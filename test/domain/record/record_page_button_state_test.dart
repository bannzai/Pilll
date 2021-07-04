import 'package:pilll/analytics.dart';
import 'package:pilll/domain/record/components/button/cancel_button.dart';
import 'package:pilll/domain/record/components/button/record_page_button.dart';
import 'package:pilll/domain/record/components/button/taken_button.dart';
import 'package:pilll/domain/record/components/notification_bar/notification_bar_store.dart';
import 'package:pilll/domain/record/record_page.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/entity/user.dart';
import 'package:pilll/service/day.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/mock.mocks.dart';

class _FakeUser extends Fake implements User {
  _FakeUser({
    this.fakeIsPremium = false,
    this.fakeIsTrial = false,
    this.fakeTrialDeadlineDate,
  });
  final bool fakeIsPremium;
  final bool fakeIsTrial;
  final DateTime? fakeTrialDeadlineDate;
  @override
  bool get isPremium => fakeIsPremium;
  @override
  bool get isTrial => fakeIsTrial;
  @override
  DateTime? get trialDeadlineDate => fakeTrialDeadlineDate;
}

void main() {
  Setting _anySetting() => Setting(
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 2,
        isOnReminder: false,
        pillSheetTypeRawPath: PillSheetType.pillsheet_21.rawPath,
        reminderTimes: [],
      );

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
  group('appearance taken button type', () {
    testWidgets('today pill not taken', (WidgetTester tester) async {
      final yesterday = today().subtract(Duration(days: 1));
      final pillSheet = PillSheet(
        typeInfo: PillSheetType.pillsheet_21.typeInfo,
        beginingDate: yesterday,
        lastTakenDate: yesterday,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            recordPageStoreProvider
                .overrideWithProvider(Provider((ref) => MockRecordPageStore())),
          ],
          child: MaterialApp(
            home: RecordPageButton(
              currentPillSheet: pillSheet,
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byWidgetPredicate((widget) => widget is TakenButton),
          findsOneWidget);
    });
  });
  testWidgets('today pill is already taken', (WidgetTester tester) async {
    final pillSheet = PillSheet(
      typeInfo: PillSheetType.pillsheet_21.typeInfo,
      beginingDate: today(),
      lastTakenDate: today(),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          recordPageStoreProvider
              .overrideWithProvider(Provider((ref) => MockRecordPageStore())),
        ],
        child: MaterialApp(
          home: RecordPageButton(
            currentPillSheet: pillSheet,
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.byWidgetPredicate((widget) => widget is CancelButton),
        findsOneWidget);
  });
}
