import 'package:flutter/rendering.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/root/resolver/initial_setting_or_app_page.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pilll/utils/error_log.dart';

import '../../helper/fake.dart';

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
    errorLogger = FakeErrorLogger();
    for (var element in RendererBinding.instance.renderViews) {
      element.configuration = TestViewConfiguration.fromView(
        view: WidgetsBinding.instance.platformDispatcher.views.single,
        size: const Size(375.0, 667.0),
      );
    }
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
