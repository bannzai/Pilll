import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/organisms/pill_mark/pill_marks.dart';
import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
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
    testWidgets("休薬のピルが未選択の場合は、タップできるプレビューとスキップのボタンが出て、日数の欄は無く次へは押せない",
        (WidgetTester tester) async {
      await pumpPage(
        tester,
        input: (store) {
          store.selectYazFlex();
          store.setTodayPillNumber(pageIndex: 1, pillNumberInPillSheet: 2);
        },
      );

      final preview = tester.widget<YazFlexPillSheetGroupPreview>(
          find.byType(YazFlexPillSheetGroupPreview));
      expect(preview.onPillTap, isNotNull);
      expect(preview.markedPill, isNull);
      // 今日飲むピルのピルシート (2枚目) を開く
      expect(preview.initialPageIndex, 1);
      expect(find.byType(SelectedPillMark), findsNothing);
      expect(find.byType(YazFlexRestDurationDaysField), findsNothing);
      expect(find.byType(InconspicuousButton), findsOneWidget);
      expect(
        tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
        isNull,
      );
    });

    testWidgets("休薬のピル (1枚目の16番) を選んだ場合は、そのピルに印が付いて日数の欄 (既定の4日間) が出て、次へ進める",
        (WidgetTester tester) async {
      await pumpPage(
        tester,
        input: (store) {
          store.selectYazFlex();
          store.setTodayPillNumber(pageIndex: 1, pillNumberInPillSheet: 2);
          store.setYazFlexLastTakenPillNumberBeforeRest(
              pageIndex: 0, pillNumberInPillSheet: 16);
        },
      );

      final preview = tester.widget<YazFlexPillSheetGroupPreview>(
          find.byType(YazFlexPillSheetGroupPreview));
      expect(preview.markedPill, (pageIndex: 0, pillNumberInPillSheet: 16));
      expect(preview.initialPageIndex, 0);
      expect(find.byType(SelectedPillMark), findsOneWidget);
      // 次の17番から1に戻る
      expect(
        preview.pillSheetGroup.displayPillNumberWithoutDate(
            pageIndex: 0, pillNumberInPillSheet: 17),
        "1",
      );
      expect(
        tester
            .widget<YazFlexRestDurationDaysField>(
                find.byType(YazFlexRestDurationDaysField))
            .restDurationDays,
        4,
      );
      expect(
        tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
        isNotNull,
      );
    });

    testWidgets("休薬の日数を7日にした場合は、日数の欄に7が出る", (WidgetTester tester) async {
      await pumpPage(
        tester,
        input: (store) {
          store.selectYazFlex();
          store.setTodayPillNumber(pageIndex: 1, pillNumberInPillSheet: 2);
          store.setYazFlexLastTakenPillNumberBeforeRest(
              pageIndex: 0, pillNumberInPillSheet: 16);
          store.setYazFlexRestDurationDays(yazFlexRestDurationDays: 7);
        },
      );

      expect(
        tester
            .widget<YazFlexRestDurationDaysField>(
                find.byType(YazFlexRestDurationDaysField))
            .restDurationDays,
        7,
      );
    });
  });
}
