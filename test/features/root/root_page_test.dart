import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/components/page/ok_dialog.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/home/home_page.dart';
import 'package:pilll/features/initial_setting/pill_sheet_group/initial_setting_pill_sheet_group_page.dart';
import 'package:pilll/features/root/root_page.dart';
import 'package:pilll/provider/auth.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/provider/force_update.dart';
import 'package:pilll/provider/set_user_id.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/fake.dart';
import '../../helper/mock.mocks.dart';

class _FakeFirebaseUser extends Fake implements firebase_auth.User {
  @override
  String get uid => "abcdefg";
}

class _FakeUser extends Fake implements User {}

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    initializeDateFormatting('ja_JP');
    Environment.isTest = true;
    analytics = FakeAnalytics();
    errorLogger = FakeErrorLogger();
    WidgetsBinding.instance.renderView.configuration = TestViewConfiguration(size: const Size(375.0, 667.0));
  });

  group('#RootPage', () {
    testWidgets('no need force update', (WidgetTester tester) async {
      final mockTodayRepository = MockTodayService();
      final today = DateTime(2021, 04, 29);
      when(mockTodayRepository.now()).thenReturn(today);
      todayRepository = mockTodayRepository;

      final fakeFirebaseUser = _FakeFirebaseUser();
      final fakeUser = _FakeUser();

      final checkForceUpdate = MockCheckForceUpdate();
      when(checkForceUpdate()).thenAnswer((_) => Future.value(false));

      final setUserID = MockSetUserID();
      when(setUserID(userID: fakeFirebaseUser.uid)).thenAnswer((realInvocation) => Future.value());

      final fetchOrCreateUser = MockFetchOrCreateUser();
      when(fetchOrCreateUser(fakeFirebaseUser.uid)).thenAnswer((realInvocation) => Future.value(fakeUser));

      final saveUserLaunchInfo = MockSaveUserLaunchInfo();
      when(saveUserLaunchInfo(fakeUser)).thenReturn(null);

      final markAsMigratedToFlutter = MockMarkAsMigratedToFlutter();
      when(markAsMigratedToFlutter()).thenAnswer((realInvocation) => Future.value());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            firebaseUserStateProvider.overrideWith((ref) => Stream.value(fakeFirebaseUser)),
            checkForceUpdateProvider.overrideWith((_) => checkForceUpdate),
            setUserIDProvider.overrideWith((ref) => setUserID),
            databaseProvider.overrideWith((ref) => MockDatabaseConnection()),
            fetchOrCreateUserProvider.overrideWith((_) => fetchOrCreateUser),
            saveUserLaunchInfoProvider.overrideWith((ref) => saveUserLaunchInfo),
            markAsMigratedToFlutterProvider.overrideWith((ref) => markAsMigratedToFlutter),
            firebaseSignInProvider.overrideWith((ref) => Future.value(fakeFirebaseUser)),
          ],
          child: const MaterialApp(
            home: Material(
              child: Root(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate((widget) => widget is InitialSettingOrAppPage),
        findsWidgets,
      );
    });
    testWidgets('needs force update', (WidgetTester tester) async {
      final mockTodayRepository = MockTodayService();
      final today = DateTime(2021, 04, 29);
      when(mockTodayRepository.now()).thenReturn(today);
      todayRepository = mockTodayRepository;

      final fakeFirebaseUser = _FakeFirebaseUser();
      final fakeUser = _FakeUser();

      final checkForceUpdate = MockCheckForceUpdate();
      when(checkForceUpdate()).thenAnswer((_) => Future.value(true));

      final setUserID = MockSetUserID();
      when(setUserID(userID: fakeFirebaseUser.uid)).thenAnswer((realInvocation) => Future.value());

      final fetchOrCreateUser = MockFetchOrCreateUser();
      when(fetchOrCreateUser(fakeFirebaseUser.uid)).thenAnswer((realInvocation) => Future.value(fakeUser));

      final saveUserLaunchInfo = MockSaveUserLaunchInfo();
      when(saveUserLaunchInfo(fakeUser)).thenReturn(null);

      final markAsMigratedToFlutter = MockMarkAsMigratedToFlutter();
      when(markAsMigratedToFlutter()).thenAnswer((realInvocation) => Future.value());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            firebaseUserStateProvider.overrideWith((ref) => Stream.value(fakeFirebaseUser)),
            checkForceUpdateProvider.overrideWith((_) => checkForceUpdate),
            setUserIDProvider.overrideWith((ref) => setUserID),
            databaseProvider.overrideWith((ref) => MockDatabaseConnection()),
            fetchOrCreateUserProvider.overrideWith((_) => fetchOrCreateUser),
            saveUserLaunchInfoProvider.overrideWith((ref) => saveUserLaunchInfo),
            markAsMigratedToFlutterProvider.overrideWith((ref) => markAsMigratedToFlutter),
            firebaseSignInProvider.overrideWith((ref) => Future.value(fakeFirebaseUser)),
          ],
          child: const MaterialApp(
            home: Material(
              child: Root(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(
        find.byWidgetPredicate((widget) => widget is ScaffoldIndicator),
        findsWidgets,
      );
// FIXME: Cann't check of did showDialog Widget
//      expect(
//        find.byWidgetPredicate((widget) => widget is OKDialog),
//        findsWidgets,
//      );
    });
  });
}
