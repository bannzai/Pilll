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
        final mockTodayRepository = MockTodayService();
        final today = DateTime(2021, 04, 29);
        when(mockTodayRepository.now()).thenReturn(today);
        todayRepository = mockTodayRepository;

        var pillSheets = Factory.pillSheets3();
        final activePillSheet = pillSheets[0].copyWith(restDurations: [Factory.notYetEndRestDuration()]);
        pillSheets.replaceRange(0, 1, [activePillSheet]);
        expect(activePillSheet.activeRestDuration, isNotNull);

        final pillSheetGroup = Factory.pillSheetGroup(pillSheets);
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
        final mockTodayRepository = MockTodayService();
        final today = DateTime(2021, 04, 29);
        when(mockTodayRepository.now()).thenReturn(today);
        todayRepository = mockTodayRepository;

        var pillSheets = Factory.pillSheets3();
        final activePillSheet = pillSheets[0].copyWith(restDurations: [Factory.endedRestDuration()], lastTakenDate: now());
        pillSheets.replaceRange(0, 1, [activePillSheet]);
        expect(activePillSheet.activeRestDuration, isNull);
        expect(activePillSheet.todayPillIsAlreadyTaken, true);

        final pillSheetGroup = Factory.pillSheetGroup(pillSheets);
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
        final mockTodayRepository = MockTodayService();
        final today = DateTime(2021, 04, 29);
        when(mockTodayRepository.now()).thenReturn(today);
        todayRepository = mockTodayRepository;

        var pillSheets = Factory.pillSheets3();
        final activePillSheet = pillSheets[0].copyWith(restDurations: [Factory.endedRestDuration()], lastTakenDate: yesterday());
        pillSheets.replaceRange(0, 1, [activePillSheet]);
        expect(activePillSheet.activeRestDuration, isNull);
        expect(activePillSheet.todayPillIsAlreadyTaken, false);

        final pillSheetGroup = Factory.pillSheetGroup(pillSheets);
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
