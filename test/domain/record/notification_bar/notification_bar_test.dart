import 'package:pilll/analytics.dart';
import 'package:pilll/domain/record/components/notification_bar/notification_bar.dart';
import 'package:pilll/domain/record/components/notification_bar/notification_bar_state.dart';
import 'package:pilll/domain/record/components/notification_bar/notification_bar_store.dart';
import 'package:pilll/domain/record/components/notification_bar/notification_bar_store_parameter.dart';
import 'package:pilll/domain/record/components/notification_bar/rest_duration.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/service/day.dart';
import 'package:pilll/util/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/mock.mocks.dart';

void main() {
  final totalCountOfActionForTakenPillForLongTimeUser = 14;
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues(
        {BoolKey.recommendedSignupNotificationIsAlreadyShow: true});
    initializeDateFormatting('ja_JP');
    Environment.isTest = true;
    analytics = MockAnalytics();
    WidgetsBinding.instance!.renderView.configuration =
        new TestViewConfiguration(size: const Size(375.0, 667.0));
  });
  group('notification bar appearance content type', () {
    testWidgets('today pill not taken', (WidgetTester tester) async {
      final mockTodayRepository = MockTodayService();
      final today = DateTime(2021, 04, 29);

      when(mockTodayRepository.today()).thenReturn(today);
      todayRepository = mockTodayRepository;

      var pillSheet = PillSheet.create(PillSheetType.pillsheet_21);
      pillSheet = pillSheet.copyWith(
        lastTakenDate: today,
        beginingDate: today.subtract(
// NOTE: Into rest duration and notification duration
          Duration(days: 25),
        ),
      );
      var state = NotificationBarState(
        pillSheet: pillSheet,
        totalCountOfActionForTakenPill:
            totalCountOfActionForTakenPillForLongTimeUser,
      );
      state = state.copyWith(
        isPremium: false,
        isTrial: false,
        isLinkedLoginProvider: false,
      );

      final anyParameter = NotificationBarStoreParameter(
        pillSheet: pillSheet,
        totalCountOfActionForTakenPill:
            totalCountOfActionForTakenPillForLongTimeUser,
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            notificationBarStateProvider
                .overrideWithProvider((ref, param) => state),
          ],
          child: MaterialApp(
            home: NotificationBar(anyParameter),
          ),
        ),
      );
      await tester.pump();

      expect(
        find.byWidgetPredicate(
            (widget) => widget is RestDurationNotificationBar),
        findsOneWidget,
      );
    });
  });
}
