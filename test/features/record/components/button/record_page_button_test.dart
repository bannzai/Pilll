import 'dart:async';

import 'package:pilll/features/record/components/button/record_page_button.dart';
import 'package:pilll/features/record/components/button/rest_duration_button.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pilll_ads.dart';
import 'package:pilll/features/premium_introduction/util/discount_deadline.dart';
import 'package:pilll/features/record/components/announcement_bar/components/discount_price_deadline.dart';
import 'package:pilll/features/record/components/announcement_bar/components/ended_pill_sheet.dart';
import 'package:pilll/features/record/components/announcement_bar/components/pilll_ads.dart';
import 'package:pilll/features/record/components/announcement_bar/notification_bar.dart';
import 'package:pilll/features/record/components/announcement_bar/components/premium_trial_limit.dart';
import 'package:pilll/features/record/components/announcement_bar/components/recommend_signup.dart';
import 'package:pilll/features/record/components/announcement_bar/components/recommend_signup_premium.dart';
import 'package:pilll/features/record/components/announcement_bar/components/rest_duration.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/pilll_ads.codegen.dart';
import 'package:pilll/provider/locale.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/provider/auth.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/emoji/emoji.dart';
import 'package:pilll/utils/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helper/factory.dart';
import '../../../../helper/mock.mocks.dart';

void main() {
  const totalCountOfActionForTakenPillForLongTimeUser = 14;
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
  });
}
