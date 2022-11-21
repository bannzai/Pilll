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
import 'package:mockito/mockito.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../../../helper/factory.dart';
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
        var pillSheets = Factory.pillSheets3(10);
        final pillSheetGroup = Factory.pillSheetGroup(pillSheets);
        // Reason for subtract seconds: 1, pass condition of if (restDurations.last.beginDate.isBefore(now()))
        final activePillSheet = pillSheetGroup.activedPillSheet!.copyWith(
          restDurations: [
            Factory.notYetEndRestDuration().copyWith(
              beginDate: now().subtract(const Duration(seconds: 1)),
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
      testWidgets('activePillSheet.todayPillIsAlreadyTaken', (WidgetTester tester) async {
        var pillSheets = Factory.pillSheets3(10);
        final pillSheetGroup = Factory.pillSheetGroup(pillSheets);
        final activePillSheet = pillSheetGroup.activedPillSheet!.copyWith(
          restDurations: [
            Factory.endedRestDuration(),
          ],
          lastTakenDate: now(),
        );
        pillSheets.replaceRange(0, 1, [activePillSheet]);
        expect(activePillSheet.activeRestDuration, isNull);
        expect(activePillSheet.todayPillIsAlreadyTaken, true);
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
        var pillSheets = Factory.pillSheets3(10);
        final pillSheetGroup = Factory.pillSheetGroup(pillSheets);
        // Reason for subtract seconds: 1, pass condition of if (restDurations.last.endDate.isBefore(now()))
        final activePillSheet = pillSheetGroup.activedPillSheet!.copyWith(
          restDurations: [
            Factory.endedRestDuration().copyWith(endDate: now().subtract(const Duration(seconds: 1))),
          ],
          lastTakenDate: yesterday(),
        );
        pillSheets.replaceRange(0, 1, [activePillSheet]);
        expect(activePillSheet.activeRestDuration, isNull);
        expect(activePillSheet.todayPillIsAlreadyTaken, false);
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
