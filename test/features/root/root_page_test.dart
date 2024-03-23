import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/rendering.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/root/resolver/force_update.dart';
import 'package:pilll/features/root/resolver/initial_setting_or_app_page.dart';
import 'package:pilll/features/root/root_page.dart';
import 'package:pilll/provider/auth.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/provider/force_update.dart';
import 'package:pilll/provider/set_user_id.dart';
import 'package:pilll/provider/typed_shared_preferences.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/fake.dart';
import '../../helper/mock.mocks.dart';

class _FakeFirebaseUser extends Fake implements firebase_auth.User {
  @override
  String get uid => "abcdefg";
}

class _FakeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _FakeUser extends Fake implements User {
  final Setting? fakeSetting;

  // ignore: avoid_init_to_null
  _FakeUser([this.fakeSetting = null]);

  @override
  Setting? get setting => fakeSetting;
}

class _FakeSetting extends Fake implements Setting {}

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    initializeDateFormatting('ja_JP');
    Environment.isTest = true;
    analytics = FakeAnalytics();
    errorLogger = FakeErrorLogger();
    for (var element in RendererBinding.instance.renderViews) {
      element.configuration = TestViewConfiguration.fromView(
        view: WidgetsBinding.instance.platformDispatcher.views.single,
        size: const Size(375.0, 667.0),
      );
    }
  });

  group('#RootPage', () {
    testWidgets('no need force update', (WidgetTester tester) async {
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

      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            checkForceUpdateProvider.overrideWith((_) => checkForceUpdate),
            setUserIDProvider.overrideWith((ref) => setUserID),
            databaseProvider.overrideWith((ref) => MockDatabaseConnection()),
            fetchOrCreateUserProvider.overrideWith((_) => fetchOrCreateUser),
            saveUserLaunchInfoProvider.overrideWith((ref) => saveUserLaunchInfo),
            firebaseSignInProvider.overrideWith((ref) => Future.value(fakeFirebaseUser)),
            didEndInitialSettingProvider.overrideWithValue(const SharedPreferencesState(BoolKey.didEndInitialSetting, null)),
          ],
          child: MaterialApp(
            home: Material(
              child: RootPage(builder: (_) => _FakeWidget()),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(
        find.byWidgetPredicate((widget) => widget is _FakeWidget),
        findsOneWidget,
      );
    });
    testWidgets('needs force update', (WidgetTester tester) async {
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

      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            checkForceUpdateProvider.overrideWith((_) => checkForceUpdate),
            setUserIDProvider.overrideWith((ref) => setUserID),
            databaseProvider.overrideWith((ref) => MockDatabaseConnection()),
            fetchOrCreateUserProvider.overrideWith((_) => fetchOrCreateUser),
            saveUserLaunchInfoProvider.overrideWith((ref) => saveUserLaunchInfo),
            firebaseSignInProvider.overrideWith((ref) => Future.value(fakeFirebaseUser)),
            didEndInitialSettingProvider.overrideWithValue(const SharedPreferencesState(BoolKey.didEndInitialSetting, null)),
          ],
          child: MaterialApp(
            home: Material(
              child: ForceUpdate(builder: (_) => _FakeWidget()),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(
        find.byWidgetPredicate((widget) => widget is ScaffoldIndicator),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate((widget) => widget is _FakeWidget),
        findsNothing,
      );
// FIXME: Cann't check of did showDialog Widget
//      expect(
//        find.byWidgetPredicate((widget) => widget is OKDialog),
//        findsOneWidget,
//      );
    });
  });

  group('#retrieveScreenType', () {
    testWidgets('didEndInitialSetting is not exist', (WidgetTester tester) async {
      final fakeUser = _FakeUser(_FakeSetting());
      final screenType = retrieveScreenType(user: fakeUser, didEndInitialSetting: null);
      expect(screenType, InitialSettingOrAppPageScreenType.initialSetting);
    });
    testWidgets('tidEndInitialSetting is false', (WidgetTester tester) async {
      final fakeUser = _FakeUser(_FakeSetting());
      final screenType = retrieveScreenType(user: fakeUser, didEndInitialSetting: false);
      expect(screenType, InitialSettingOrAppPageScreenType.initialSetting);
    });
    testWidgets('didEndInitialSetting is true', (WidgetTester tester) async {
      final fakeUser = _FakeUser(_FakeSetting());
      final screenType = retrieveScreenType(user: fakeUser, didEndInitialSetting: true);
      expect(screenType, InitialSettingOrAppPageScreenType.app);
    });
    testWidgets('didEndInitialSetting is true and user.migratedFlutter is true but setting is null', (WidgetTester tester) async {
      final fakeUser = _FakeUser(null);
      final screenType = retrieveScreenType(user: fakeUser, didEndInitialSetting: true);
      expect(screenType, InitialSettingOrAppPageScreenType.initialSetting);
    });
  });
}
