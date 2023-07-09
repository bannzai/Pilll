import 'package:pilll/entity/pill.codegen.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/features/record/components/button/cancel_button.dart';
import 'package:pilll/features/record/components/button/record_page_button.dart';
import 'package:pilll/features/record/components/button/rest_duration_button.dart';
import 'package:pilll/features/record/components/button/taken_button.dart';
import 'package:pilll/provider/revert_take_pill.dart';
import 'package:pilll/provider/take_pill.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../../../helper/mock.mocks.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    initializeDateFormatting('ja_JP');
    Environment.isTest = true;
    analytics = MockAnalytics();
    WidgetsBinding.instance.renderView.configuration = TestViewConfiguration(size: const Size(375.0, 667.0));
  });

  group('#RecordPageButton', () {
    group('#RestDurationButton', () {
      testWidgets('pill sheet has activeRestDuration', (WidgetTester tester) async {
        final firstPillSheetBeginDate = now().subtract(const Duration(days: 10));
        var pillSheets = [
          PillSheet(
            id: "pill_sheet_id_1",
            typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
            beginingDate: firstPillSheetBeginDate,
            lastTakenDate: null,
            createdAt: now(),
            pills: Pill.generateAndFillTo(
                pillSheetType: PillSheetType.pillsheet_28_0, fromDate: firstPillSheetBeginDate, lastTakenDate: null, pillTakenCount: 1),
          ),
          PillSheet(
            id: "pill_sheet_id_2",
            typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
            beginingDate: firstPillSheetBeginDate.add(const Duration(days: 28)),
            lastTakenDate: null,
            createdAt: now(),
            pills: Pill.generateAndFillTo(
                pillSheetType: PillSheetType.pillsheet_28_0,
                fromDate: firstPillSheetBeginDate.add(const Duration(days: 28)),
                lastTakenDate: null,
                pillTakenCount: 1),
          ),
          PillSheet(
            id: "pill_sheet_id_3",
            typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
            beginingDate: firstPillSheetBeginDate.add(const Duration(days: 56)),
            lastTakenDate: null,
            createdAt: now(),
            pills: Pill.generateAndFillTo(
                pillSheetType: PillSheetType.pillsheet_28_0,
                fromDate: firstPillSheetBeginDate.add(const Duration(days: 56)),
                lastTakenDate: null,
                pillTakenCount: 1),
          )
        ];
        final pillSheetGroup = PillSheetGroup(pillSheetIDs: pillSheets.map((e) => e.id!).toList(), pillSheets: pillSheets, createdAt: now());
        // Reason for subtract seconds: 1, pass condition of if (restDurations.last.beginDate.isBefore(now()))
        final activePillSheet = pillSheetGroup.activedPillSheet!.copyWith(
          restDurations: [
            RestDuration(
              beginDate: now().subtract(const Duration(seconds: 1)),
              createdDate: now(),
              endDate: null,
            ),
          ],
        );
        pillSheets.replaceRange(0, 1, [activePillSheet]);
        expect(activePillSheet.activeRestDuration, isNotNull);
        expect(pillSheetGroup.activedPillSheet, activePillSheet);

        await tester.pumpWidget(
          ProviderScope(
            overrides: const [],
            child: MaterialApp(
              home: Material(
                child: RecordPageButton(
                  pillSheetGroup: pillSheetGroup,
                  currentPillSheet: activePillSheet,
                  userIsPremiumOtTrial: false,
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byWidgetPredicate((widget) => widget is RestDurationButton),
          findsOneWidget,
        );
      });
    });
    group('#CancelButton', () {
      testWidgets('activePillSheet.todayPillsAreAlreadyTaken', (WidgetTester tester) async {
        final firstPillSheetBeginDate = now().subtract(const Duration(days: 10));
        var pillSheets = [
          PillSheet(
            id: "pill_sheet_id_1",
            typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
            beginingDate: firstPillSheetBeginDate,
            lastTakenDate: null,
            createdAt: now(),
            pills: Pill.generateAndFillTo(
                pillSheetType: PillSheetType.pillsheet_28_0, fromDate: firstPillSheetBeginDate, lastTakenDate: null, pillTakenCount: 1),
          ),
          PillSheet(
            id: "pill_sheet_id_2",
            typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
            beginingDate: firstPillSheetBeginDate.add(const Duration(days: 28)),
            lastTakenDate: null,
            createdAt: now(),
            pills: Pill.generateAndFillTo(
                pillSheetType: PillSheetType.pillsheet_28_0,
                fromDate: firstPillSheetBeginDate.add(const Duration(days: 28)),
                lastTakenDate: null,
                pillTakenCount: 1),
          ),
          PillSheet(
            id: "pill_sheet_id_3",
            typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
            beginingDate: firstPillSheetBeginDate.add(const Duration(days: 56)),
            lastTakenDate: null,
            createdAt: now(),
            pills: Pill.generateAndFillTo(
                pillSheetType: PillSheetType.pillsheet_28_0,
                fromDate: firstPillSheetBeginDate.add(const Duration(days: 56)),
                lastTakenDate: null,
                pillTakenCount: 1),
          )
        ];
        final pillSheetGroup = PillSheetGroup(pillSheetIDs: pillSheets.map((e) => e.id!).toList(), pillSheets: pillSheets, createdAt: now());
        final activePillSheet = pillSheetGroup.activedPillSheet!.copyWith(
          restDurations: [
            RestDuration(
              beginDate: now().subtract(const Duration(days: 1)),
              createdDate: now().subtract(const Duration(days: 1)),
              endDate: now(),
            ),
          ],
          lastTakenDate: now(),
          pills: Pill.generateAndFillTo(
              pillSheetType: PillSheetType.pillsheet_28_0,
              fromDate: pillSheetGroup.activedPillSheet!.beginingDate,
              lastTakenDate: now(),
              pillTakenCount: 1),
        );
        pillSheets.replaceRange(0, 1, [activePillSheet]);
        expect(activePillSheet.activeRestDuration, isNull);
        expect(activePillSheet.todayPillsAreAlreadyTaken, true);
        expect(pillSheetGroup.activedPillSheet, activePillSheet);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [revertTakePillProvider.overrideWith((ref) => MockRevertTakePill())],
            child: MaterialApp(
              home: Material(
                child: RecordPageButton(
                  pillSheetGroup: pillSheetGroup,
                  currentPillSheet: activePillSheet,
                  userIsPremiumOtTrial: false,
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byWidgetPredicate((widget) => widget is CancelButton),
          findsOneWidget,
        );
      });
    });
    group('#TakenButton', () {
      testWidgets('show TakenButton', (WidgetTester tester) async {
        final firstPillSheetBeginDate = now().subtract(const Duration(days: 10));
        var pillSheets = [
          PillSheet(
            id: "pill_sheet_id_1",
            typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
            beginingDate: firstPillSheetBeginDate,
            lastTakenDate: null,
            createdAt: now(),
            pills: Pill.generateAndFillTo(
                pillSheetType: PillSheetType.pillsheet_28_0, fromDate: firstPillSheetBeginDate, lastTakenDate: null, pillTakenCount: 1),
          ),
          PillSheet(
            id: "pill_sheet_id_2",
            typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
            beginingDate: firstPillSheetBeginDate.add(const Duration(days: 28)),
            lastTakenDate: null,
            createdAt: now(),
            pills: Pill.generateAndFillTo(
                pillSheetType: PillSheetType.pillsheet_28_0,
                fromDate: firstPillSheetBeginDate.add(const Duration(days: 28)),
                lastTakenDate: null,
                pillTakenCount: 1),
          ),
          PillSheet(
            id: "pill_sheet_id_3",
            typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
            beginingDate: firstPillSheetBeginDate.add(const Duration(days: 56)),
            lastTakenDate: null,
            createdAt: now(),
            pills: Pill.generateAndFillTo(
                pillSheetType: PillSheetType.pillsheet_28_0,
                fromDate: firstPillSheetBeginDate.add(const Duration(days: 56)),
                lastTakenDate: null,
                pillTakenCount: 1),
          )
        ];
        final pillSheetGroup = PillSheetGroup(pillSheetIDs: pillSheets.map((e) => e.id!).toList(), pillSheets: pillSheets, createdAt: now());

        // Reason for subtract seconds: 1, pass condition of if (restDurations.last.endDate.isBefore(now()))
        final activePillSheet = pillSheetGroup.activedPillSheet!.copyWith(
          restDurations: [
            RestDuration(
                beginDate: now().subtract(const Duration(days: 1)),
                createdDate: now().subtract(const Duration(days: 1)),
                endDate: now().subtract(const Duration(seconds: 1))),
          ],
          lastTakenDate: yesterday(),
        );
        pillSheets.replaceRange(0, 1, [activePillSheet]);
        expect(activePillSheet.activeRestDuration, isNull);
        expect(activePillSheet.todayPillsAreAlreadyTaken, false);
        expect(pillSheetGroup.activedPillSheet, activePillSheet);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [takePillProvider.overrideWith((ref) => MockTakePill())],
            child: MaterialApp(
              home: Material(
                child: RecordPageButton(
                  pillSheetGroup: pillSheetGroup,
                  currentPillSheet: activePillSheet,
                  userIsPremiumOtTrial: false,
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byWidgetPredicate((widget) => widget is TakenButton),
          findsOneWidget,
        );
      });
    });
  });
}
