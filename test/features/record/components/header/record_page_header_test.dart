import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/pill.codegen.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/record/components/header/record_page_header.dart';
import 'package:pilll/features/record/components/header/today_taken_pill_number.dart';
import 'package:pilll/l10n/app_localizations.dart';
import 'package:pilll/utils/datetime/day.dart';

import '../../../../helper/mock.mocks.dart';

void main() {
  setUpAll(() async {
    // ヘッダーの日付 (DateTimeFormatter.monthAndDay・shortWeekday) が表示言語の DateFormat を使うため
    await initializeDateFormatting();
  });

  group('#RecordPageInformationHeader', () {
    /// 表示言語を lang にして、QA で ng になった状態 (28 錠 + 偽薬 4 錠・1 日 2 回・服用日数の表示・今日が 1 日目) のヘッダーを pump する。
    /// 画面の幅は iPhone 13 / 14 相当 (test/snapshot/snapshot_harness.dart の snapshotLogicalSize と同じ 390) にする。
    /// L・Intl.defaultLocale・todayRepository・画面の大きさはテストの終わりに戻す
    Future<void> pumpSubject(WidgetTester tester,
        {required String lang}) async {
      final originalL = L;
      final originalDefaultLocale = Intl.defaultLocale;
      final originalTodayRepository = todayRepository;
      addTearDown(() {
        L = originalL;
        Intl.defaultLocale = originalDefaultLocale;
        todayRepository = originalTodayRepository;
      });
      L = lookupAppLocalizations(Locale(lang));
      Intl.defaultLocale = lang;

      // QA の記録で今日が 1 日目だった 2026-11-09 (月曜日)
      final today = DateTime.parse('2026-11-09');
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(today);

      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordPageInformationHeader(
              today: today,
              pillSheetGroup: PillSheetGroup(
                pillSheetIDs: ['pill_sheet_id_1'],
                pillSheets: [
                  PillSheet.v2(
                    id: 'pill_sheet_id_1',
                    groupIndex: 0,
                    typeInfo: PillSheetType.pillsheet_28_4.typeInfo,
                    beginDate: today,
                    createdAt: today,
                    restDurations: [],
                    pills: Pill.testGenerateAndIterateTo(
                      pillSheetType: PillSheetType.pillsheet_28_4,
                      fromDate: today,
                      lastTakenDate: null,
                      pillTakenCount: 2,
                    ),
                  ),
                ],
                createdAt: today,
                pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
              ),
              user: const User(),
            ),
          ),
        ),
      );
    }

    /// 日付と服用数が画面の横幅の中に収まり、日付の左端から服用数の右端までが画面の左右中央に並んでいることを確かめる
    void expectDateAndPillNumberInsideScreen(WidgetTester tester) {
      final screenWidth =
          tester.view.physicalSize.width / tester.view.devicePixelRatio;
      final dateRect = tester.getRect(find.textContaining('(').first);
      final pillNumberRect = tester.getRect(find.byType(TodayTakenPillNumber));
      expect(dateRect.left, greaterThanOrEqualTo(0));
      expect(dateRect.right, lessThanOrEqualTo(screenWidth));
      expect(pillNumberRect.left, greaterThanOrEqualTo(0));
      expect(pillNumberRect.right, lessThanOrEqualTo(screenWidth));
      expect((dateRect.left + pillNumberRect.right) / 2,
          moreOrLessEquals(screenWidth / 2, epsilon: 1));
    }

    testWidgets('fr で服用日数の表示・1 日 2 回のピルシートでも、ヘッダーが横幅からはみ出さず日付と服用数が画面に収まる',
        (tester) async {
      await pumpSubject(tester, lang: 'fr');

      expect(tester.takeException(), isNull);
      expect(find.text('09/11 (lun.)'), findsOneWidget);
      expectDateAndPillNumberInsideScreen(tester);
    });

    for (final lang in ['ja', 'en', 'de', 'es']) {
      testWidgets('$lang で服用日数の表示・1 日 2 回のピルシートでも、ヘッダーが横幅からはみ出さず日付と服用数が画面に収まる',
          (tester) async {
        await pumpSubject(tester, lang: lang);

        expect(tester.takeException(), isNull);
        expectDateAndPillNumberInsideScreen(tester);
      });
    }
  });
}
