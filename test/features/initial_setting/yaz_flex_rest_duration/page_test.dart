import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/organisms/pill_mark/pill_marks.dart';
import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/remote_config_parameter.codegen.dart';
import 'package:pilll/features/initial_setting/initial_setting_state_notifier.dart';
import 'package:pilll/features/initial_setting/yaz_flex/pill_sheet_group_preview.dart';
import 'package:pilll/features/initial_setting/yaz_flex_rest_duration/page.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/environment.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/mock.mocks.dart';
import '../../../helper/supported_device.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    initializeDateFormatting('ja_JP');
    Environment.isTest = true;

    final mockTodayRepository = MockTodayService();
    todayRepository = mockTodayRepository;
    when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-03-02"));

    final mockIDGenerator = MockFirestoreIDGenerator();
    when(mockIDGenerator.call()).thenReturn("id");
    firestoreIDGenerator = mockIDGenerator;
  });

  // 初期設定の状態を [input] で用意した InitialSettingStateNotifier を返す
  InitialSettingStateNotifier initialSettingStateNotifier({
    required void Function(InitialSettingStateNotifier store) input,
  }) {
    final store = InitialSettingStateNotifier(
      MockEndInitialSetting(),
      MockBatchFactory(),
      MockBatchSetSetting(),
      MockBatchSetPillSheetModifiedHistory(),
      MockBatchSetPillSheetGroup(),
      RemoteConfigParameter(),
      MockRegisterReminderLocalNotificationRunner(),
      DateTime.parse("2022-03-02"),
    );
    input(store);
    return store;
  }

  Future<void> pumpPage(
    WidgetTester tester, {
    required void Function(InitialSettingStateNotifier store) input,
  }) async {
    SupportedDeviceType.iPhone5SE2nd.binding(tester.view);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          initialSettingStateNotifierProvider.overrideWith(
            (ref) => initialSettingStateNotifier(input: input),
          ),
        ],
        child: const MaterialApp(
          home: InitialSettingYazFlexRestDurationPage(),
        ),
      ),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 500));
  }

  group("#InitialSettingYazFlexRestDurationPage", () {
    testWidgets("未入力の場合は開始日と再開日の入力欄とスキップのボタンが表示され、次へは押せない",
        (WidgetTester tester) async {
      await pumpPage(
        tester,
        input: (store) {
          store.selectYazFlex();
          store.setTodayPillNumber(pageIndex: 1, pillNumberInPillSheet: 2);
        },
      );

      expect(find.byType(YazFlexPillSheetGroupPreview), findsOneWidget);
      expect(find.byType(YazFlexRestDurationDateField), findsNWidgets(2));
      expect(find.byType(InconspicuousButton), findsOneWidget);
      // 開始日が未入力の間は再開日を選べず、どちらにも × が無い
      final dateFields = tester
          .widgetList<YazFlexRestDurationDateField>(
              find.byType(YazFlexRestDurationDateField))
          .toList();
      expect(dateFields[0].onTap, isNotNull);
      expect(dateFields[0].onClear, isNull);
      expect(dateFields[1].onTap, isNull);
      expect(dateFields[1].onClear, isNull);
      expect(find.byIcon(Icons.close), findsNothing);
      // 開始日が未入力の間は次へ進めない
      expect(
        tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
        isNull,
      );
      // 再開したピルが無いのでプレビューに印が無い
      expect(find.byType(SelectedPillMark), findsNothing);
    });

    testWidgets("開始日と再開日を入力済みの場合は次へ進め、両方に × が付き、再開したピルに印が付く",
        (WidgetTester tester) async {
      await pumpPage(
        tester,
        input: (store) {
          store.selectYazFlex();
          store.setTodayPillNumber(pageIndex: 1, pillNumberInPillSheet: 2);
          store.setYazFlexLastRestDurationBeginDate(
            yazFlexLastRestDurationBeginDate: DateTime.parse("2022-02-13"),
          );
          store.setYazFlexLastRestDurationEndDate(
            yazFlexLastRestDurationEndDate: DateTime.parse("2022-02-17"),
          );
        },
      );

      final dateFields = tester
          .widgetList<YazFlexRestDurationDateField>(
              find.byType(YazFlexRestDurationDateField))
          .toList();
      expect(dateFields[1].onTap, isNotNull);
      expect(dateFields[0].onClear, isNotNull);
      expect(dateFields[1].onClear, isNotNull);
      expect(find.byIcon(Icons.close), findsNWidgets(2));
      expect(
        tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
        isNotNull,
      );
      // 再開日の2022-02-17は1枚目の17番。プレビューは再開したピルのピルシート (1枚目) を開いて印を付ける
      final preview = tester.widget<YazFlexPillSheetGroupPreview>(
          find.byType(YazFlexPillSheetGroupPreview));
      expect(preview.markedPill, (pageIndex: 0, pillNumberInPillSheet: 17));
      expect(preview.initialPageIndex, 0);
      expect(find.byType(SelectedPillMark), findsOneWidget);
    });

    testWidgets("開始日だけ入力した場合 (休薬中) は次へ進め、再開日は空のままで印が無い",
        (WidgetTester tester) async {
      await pumpPage(
        tester,
        input: (store) {
          store.selectYazFlex();
          store.setTodayPillNumber(pageIndex: 1, pillNumberInPillSheet: 2);
          store.setYazFlexLastRestDurationBeginDate(
            yazFlexLastRestDurationBeginDate: DateTime.parse("2022-02-26"),
          );
        },
      );

      final dateFields = tester
          .widgetList<YazFlexRestDurationDateField>(
              find.byType(YazFlexRestDurationDateField))
          .toList();
      expect(dateFields[0].onClear, isNotNull);
      expect(dateFields[1].onTap, isNotNull);
      expect(dateFields[1].onClear, isNull);
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(
        tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
        isNotNull,
      );
      // 休薬中は再開したピルが無いので印が無く、今日飲むピルのピルシート (2枚目) を開く
      final preview = tester.widget<YazFlexPillSheetGroupPreview>(
          find.byType(YazFlexPillSheetGroupPreview));
      expect(preview.markedPill, isNull);
      expect(preview.initialPageIndex, 1);
    });

    testWidgets("開始日が今日の場合は再開日を選べない", (WidgetTester tester) async {
      await pumpPage(
        tester,
        input: (store) {
          store.selectYazFlex();
          store.setTodayPillNumber(pageIndex: 1, pillNumberInPillSheet: 2);
          store.setYazFlexLastRestDurationBeginDate(
            yazFlexLastRestDurationBeginDate: DateTime.parse("2022-03-02"),
          );
        },
      );

      final dateFields = tester
          .widgetList<YazFlexRestDurationDateField>(
              find.byType(YazFlexRestDurationDateField))
          .toList();
      expect(dateFields[1].onTap, isNull);
      expect(
        tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
        isNotNull,
      );
    });
  });
}
