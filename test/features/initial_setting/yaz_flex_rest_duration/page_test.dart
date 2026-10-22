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
    testWidgets("「休薬はまだしていない」を選んでいる場合は休薬の日付の入力欄と「まだ服用を再開していない」が表示されない", (
      WidgetTester tester,
    ) async {
      await pumpPage(
        tester,
        input: (store) {
          store.selectYazFlex();
          store.setTodayPillNumber(pageIndex: 1, pillNumberInPillSheet: 2);
          store.setYazFlexHasNotRestedYet(yazFlexHasNotRestedYet: true);
        },
      );

      expect(find.byType(YazFlexPillSheetGroupPreview), findsOneWidget);
      expect(find.byType(YazFlexRestDurationDateField), findsNothing);
      expect(find.byType(YazFlexRestDurationCheckbox), findsOneWidget);
      expect(
        tester.widget<Checkbox>(find.byType(Checkbox)).value,
        true,
      );
      // 休薬の日付が無くても次へ進める
      expect(
        tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
        isNotNull,
      );
    });

    testWidgets("「休薬はまだしていない」を選んでいない場合は休薬の開始日と終了日の入力欄と「まだ服用を再開していない」が表示される", (
      WidgetTester tester,
    ) async {
      await pumpPage(
        tester,
        input: (store) {
          store.selectYazFlex();
          store.setTodayPillNumber(pageIndex: 1, pillNumberInPillSheet: 2);
        },
      );

      expect(find.byType(YazFlexRestDurationDateField), findsNWidgets(2));
      expect(find.byType(YazFlexRestDurationCheckbox), findsNWidgets(2));
      // 開始日が未入力の間は終了日を選べない
      final dateFields = tester
          .widgetList<YazFlexRestDurationDateField>(
              find.byType(YazFlexRestDurationDateField))
          .toList();
      expect(dateFields[0].onTap, isNotNull);
      expect(dateFields[1].onTap, isNull);
      // 休薬の日付が未入力の間は次へ進めない
      expect(
        tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
        isNull,
      );
      // 再開したピルが無いのでプレビューに印が無い
      expect(find.byType(SelectedPillMark), findsNothing);
    });

    testWidgets("休薬の開始日と終了日を入力済みの場合は次へ進め、再開したピルに印が付く",
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

      expect(find.byType(YazFlexRestDurationDateField), findsNWidgets(2));
      final dateFields = tester
          .widgetList<YazFlexRestDurationDateField>(
              find.byType(YazFlexRestDurationDateField))
          .toList();
      expect(dateFields[1].onTap, isNotNull);
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

    testWidgets("「まだ服用を再開していない」を選んでいる場合は終了日の入力欄が消え、開始日があれば次へ進める",
        (WidgetTester tester) async {
      await pumpPage(
        tester,
        input: (store) {
          store.selectYazFlex();
          store.setTodayPillNumber(pageIndex: 1, pillNumberInPillSheet: 2);
          store.setYazFlexLastRestDurationBeginDate(
            yazFlexLastRestDurationBeginDate: DateTime.parse("2022-02-26"),
          );
          store.setYazFlexHasNotResumedYet(yazFlexHasNotResumedYet: true);
        },
      );

      expect(find.byType(YazFlexRestDurationDateField), findsOneWidget);
      expect(find.byType(YazFlexRestDurationCheckbox), findsNWidgets(2));
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

    testWidgets("「まだ服用を再開していない」を選んでいても開始日が未入力の間は次へ進めない",
        (WidgetTester tester) async {
      await pumpPage(
        tester,
        input: (store) {
          store.selectYazFlex();
          store.setTodayPillNumber(pageIndex: 1, pillNumberInPillSheet: 2);
          store.setYazFlexHasNotResumedYet(yazFlexHasNotResumedYet: true);
        },
      );

      expect(find.byType(YazFlexRestDurationDateField), findsOneWidget);
      expect(
        tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
        isNull,
      );
    });
  });
}
