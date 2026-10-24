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
import 'package:pilll/features/initial_setting/yaz_flex_begin_pill_number/page.dart';
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
          home: InitialSettingYazFlexBeginPillNumberPage(),
        ),
      ),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 500));
  }

  group("#InitialSettingYazFlexBeginPillNumberPage", () {
    testWidgets("今日の番号を選んでいる場合は、1枚目の1番に印の付いたプレビューが表示され次へ進める",
        (WidgetTester tester) async {
      await pumpPage(
        tester,
        input: (store) {
          store.selectYazFlex();
          store.setTodayPillNumber(pageIndex: 0, pillNumberInPillSheet: 10);
        },
      );

      final preview = tester.widget<YazFlexPillSheetGroupPreview>(
          find.byType(YazFlexPillSheetGroupPreview));
      expect(preview.markedPill, (pageIndex: 0, pillNumberInPillSheet: 1));
      expect(preview.initialPageIndex, 0);
      expect(find.byType(SelectedPillMark), findsOneWidget);
      expect(
        tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
        isNotNull,
      );
    });

    testWidgets("開始番号を4にした場合は、プレビューの1枚目の1番が4、今日の10番が13と表示される",
        (WidgetTester tester) async {
      await pumpPage(
        tester,
        input: (store) {
          store.selectYazFlex();
          store.setTodayPillNumber(pageIndex: 0, pillNumberInPillSheet: 10);
          store.setYazFlexBeginPillNumber(yazFlexBeginPillNumber: 4);
        },
      );

      final preview = tester.widget<YazFlexPillSheetGroupPreview>(
          find.byType(YazFlexPillSheetGroupPreview));
      expect(
        preview.pillSheetGroup.displayPillNumberWithoutDate(
            pageIndex: 0, pillNumberInPillSheet: 1),
        "4",
      );
      expect(
        preview.pillSheetGroup.displayPillNumberWithoutDate(
            pageIndex: 0, pillNumberInPillSheet: 10),
        "13",
      );
      // 1枚目のプレビューに「13」の番号が出ている
      expect(find.text("13"), findsOneWidget);
    });

    testWidgets("今日の番号が未選択の場合は、プレビューが表示されず次へ進めない", (WidgetTester tester) async {
      await pumpPage(
        tester,
        input: (store) {
          store.selectYazFlex();
        },
      );

      expect(find.byType(YazFlexPillSheetGroupPreview), findsNothing);
      expect(
        tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
        isNull,
      );
    });
  });
}
