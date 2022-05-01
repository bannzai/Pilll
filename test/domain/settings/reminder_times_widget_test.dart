import 'package:pilll/domain/settings/setting_page_state.codegen.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/domain/settings/reminder_times_page.dart';
import 'package:pilll/domain/settings/setting_page_store.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/mock.mocks.dart';
import '../../helper/supported_device.dart';

class _FakeUser extends Fake implements User {
  _FakeUser({
// ignore: unused_element
    this.fakeIsPremium = false,
// ignore: unused_element
    this.fakeIsTrial = false,
// ignore: unused_element
    this.fakeIsExpiredDiscountEntitlements = false,
// ignore: unused_element
    this.fakeIsTrialDeadlineDate,
  });
  final bool fakeIsPremium;
  final bool fakeIsTrial;
  final bool fakeIsExpiredDiscountEntitlements;
  final DateTime? fakeIsTrialDeadlineDate;
  @override
  bool get isPremium => fakeIsPremium;
  @override
  bool get isTrial => fakeIsTrial;
  @override
  bool get hasDiscountEntitlement => fakeIsExpiredDiscountEntitlements;
  @override
  DateTime? get trialDeadlineDate => fakeIsTrialDeadlineDate;
}

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    initializeDateFormatting('ja_JP');
    Environment.isTest = true;
  });
  group("appearance widgets dependend on reminderTimes", () {
    testWidgets(
        'when setting has one reminder times. one reminder times mean requires minimum count',
        (WidgetTester tester) async {
      SupportedDeviceType.iPhone5SE2nd.binding(tester.binding.window);

      final settingDatastore = MockSettingDatastore();
      final entity = const Setting(
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 2,
        isOnReminder: false,
        pillSheetTypes: [PillSheetType.pillsheet_21],
        reminderTimes: [
          ReminderTime(hour: 10, minute: 0),
        ],
      );
      when(settingDatastore.fetch())
          .thenAnswer((realInvocation) => Future.value(entity));
      when(settingDatastore.stream())
          .thenAnswer((realInvocation) => Stream.fromIterable([entity]));

      final pillSheetDatastore = MockPillSheetDatastore();
      final userDatastore = MockUserDatastore();
      when(userDatastore.fetch())
          .thenAnswer((realInvocation) => Future.value(_FakeUser()));
      when(userDatastore.stream())
          .thenAnswer((realInvocation) => Stream.fromIterable([_FakeUser()]));

      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
      final pillSheet = PillSheet.create(PillSheetType.pillsheet_21);
      final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());
      when(pillSheetGroupDatastore.fetchLatest())
          .thenAnswer((realInvocation) => Future.value(pillSheetGroup));
      when(pillSheetGroupDatastore.latestPillSheetGroupStream()).thenAnswer(
          (realInvocation) => Stream.fromIterable([pillSheetGroup]));

      final batchFactory = MockBatchFactory();
      final pillSheetModifiedService = MockPillSheetModifiedHistoryDatastore();

      final store = SettingStateStore(
        batchFactory,
        settingDatastore,
        pillSheetDatastore,
        userDatastore,
        pillSheetModifiedService,
        pillSheetGroupDatastore,
      );
      store.setup();

      final fakeUser = _FakeUser();
      final state = SettingState(
        setting: entity,
        isPremium: fakeUser.isPremium,
        isTrial: fakeUser.isTrial,
        latestPillSheetGroup: pillSheetGroup,
        trialDeadlineDate: fakeUser.trialDeadlineDate,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingStateProvider.overrideWithValue(state),
            settingStoreProvider.overrideWithProvider(
              StateNotifierProvider(
                (ref) => store,
              ),
            )
          ],
          child: MaterialApp(home: ReminderTimesPage()),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.text("通知時間の追加"), findsOneWidget);
      expect(find.byWidgetPredicate((widget) => widget is Dismissible),
          findsNothing);
    });
    testWidgets('when setting has maximum count reminder times︎',
        (WidgetTester tester) async {
      SupportedDeviceType.iPhone5SE2nd.binding(tester.binding.window);

      final settingDatastore = MockSettingDatastore();
      final entity = const Setting(
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 2,
        isOnReminder: false,
        pillSheetTypes: [PillSheetType.pillsheet_21],
        reminderTimes: [
          ReminderTime(hour: 10, minute: 0),
          ReminderTime(hour: 11, minute: 0),
          ReminderTime(hour: 12, minute: 0)
        ],
      );
      when(settingDatastore.fetch())
          .thenAnswer((realInvocation) => Future.value(entity));
      when(settingDatastore.stream())
          .thenAnswer((realInvocation) => Stream.value(entity));

      final userDatastore = MockUserDatastore();
      when(userDatastore.fetch())
          .thenAnswer((realInvocation) => Future.value(_FakeUser()));
      when(userDatastore.stream())
          .thenAnswer((realInvocation) => Stream.value(_FakeUser()));

      final pillSheet = PillSheet.create(PillSheetType.pillsheet_21);
      final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());
      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
      when(pillSheetGroupDatastore.fetchLatest())
          .thenAnswer((realInvocation) => Future.value(pillSheetGroup));
      when(pillSheetGroupDatastore.latestPillSheetGroupStream())
          .thenAnswer((realInvocation) => Stream.value(pillSheetGroup));

      final batchFactory = MockBatchFactory();
      final pillSheetDatastore = MockPillSheetDatastore();
      final pillSheetModifiedService = MockPillSheetModifiedHistoryDatastore();

      final store = SettingStateStore(
        batchFactory,
        settingDatastore,
        pillSheetDatastore,
        userDatastore,
        pillSheetModifiedService,
        pillSheetGroupDatastore,
      );
      store.setup();

      final fakeUser = _FakeUser();
      final state = SettingState(
        setting: entity,
        isPremium: fakeUser.isPremium,
        isTrial: fakeUser.isTrial,
        latestPillSheetGroup: pillSheetGroup,
        trialDeadlineDate: fakeUser.trialDeadlineDate,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingStateProvider.overrideWithValue(state),
            settingStoreProvider.overrideWithProvider(
              StateNotifierProvider(
                (ref) => store,
              ),
            )
          ],
          child: MaterialApp(home: ReminderTimesPage()),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.text("通知時間の追加"), findsNothing);
      expect(find.byWidgetPredicate((widget) => widget is Dismissible),
          findsNWidgets(3));
    });
  });
}
