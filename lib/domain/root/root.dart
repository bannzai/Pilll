import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/page/ok_dialog.dart';
import 'package:pilll/domain/initial_setting/pill_sheet_group/initial_setting_pill_sheet_group_pill_sheet_type_select_row.dart';
import 'package:pilll/entrypoint.dart';
import 'package:pilll/service/auth.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/domain/home/home_page.dart';
import 'package:pilll/entity/user_error.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/error/template.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/service/user.dart';
import 'package:pilll/util/platform/platform.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:pilll/util/version/version.dart';
import 'package:url_launcher/url_launcher.dart';

GlobalKey<RootState> rootKey = GlobalKey();

class Root extends StatefulWidget {
  Root({Key? key}) : super(key: key);

  @override
  RootState createState() => RootState();
}

enum ScreenType { home, initialSetting, forceUpdate }

class RootState extends State<Root> {
  dynamic _error;

  ScreenType? screenType;
  showHome() {
    setState(() {
      screenType = ScreenType.home;
    });
  }

  reload() {
    setState(() {
      screenType = null;
      _error = null;
      _decideScreenType();
    });
  }

  @override
  void initState() {
    _decideScreenType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (screenType == null && _error == null) {
      return ScaffoldIndicator();
    }
    if (screenType == ScreenType.forceUpdate) {
      Future.microtask(() async {
        await showOKDialog(context,
            title: "アプリをアップデートしてください",
            message: "お使いのアプリのバージョンが古いため$storeNameから最新バージョンにアップデートしてください",
            ok: () async {
          await launch(storeURL, forceSafariVC: false, forceWebView: false);
        });
      });
      return ScaffoldIndicator();
    }

    return UniversalErrorPage(
      error: _error,
      reload: () => reload(),
      child: Consumer(builder: (context, ref, child) {
        return ref.watch(authStateStreamProvider).when(data: (snapshot) {
          switch (screenType) {
            case ScreenType.home:
              return HomePage(key: homeKey);
            case ScreenType.initialSetting:
              return InitialSettingPillSheetCountPageRoute.screen();
            default:
              return ScaffoldIndicator();
          }
        }, loading: () {
          return ScaffoldIndicator();
        }, error: (error, stacktrace) {
          print(error);
          print(stacktrace);
          errorLogger.recordError(error, stacktrace);
          setState(() {
            final displayError = ErrorMessages.connection +
                "\n" +
                "errorType: ${error.runtimeType.toString()}\n" +
                error.toString() +
                "error: ${error.toString()}\n" +
                stacktrace.toString();
            _error = displayError;
          });

          return Indicator();
        });
      }),
    );
  }

  _decideScreenType() async {
    const minimumSupportedAppVersionKey = "minimum_supported_app_version";
    final remoteConfig = RemoteConfig.instance;
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        minimumFetchInterval: Duration(seconds: 0),
        fetchTimeout: Duration(seconds: 10),
      ),
    );
    remoteConfig.setDefaults({
      minimumSupportedAppVersionKey: "3.4.0",
    });
    await remoteConfig.fetchAndActivate();
    final minimumSupportedAppVersion =
        remoteConfig.getString(minimumSupportedAppVersionKey);
    final packageVersion = await Version.fromPackage();
    if (packageVersion.isLessThan(Version.parse(minimumSupportedAppVersion))) {
      setState(() {
        screenType = ScreenType.forceUpdate;
      });
    } else {
      final user = await callSignin();

      // No UI thread blocking
      if (user != null) {
        unawaited(FirebaseCrashlytics.instance.setUserIdentifier(user.uid));
        unawaited(firebaseAnalytics.setUserId(id: user.uid));
        unawaited(initializePurchase(user.uid));
      }
      // ignore: unawaited_futures
      cacheOrAuth().then((authInfo) {
        final userService = UserService(DatabaseConnection(authInfo.uid));
        return userService.prepare(authInfo.uid).then((user) async {
          userService.saveUserLaunchInfo();
          unawaited(userService.temporarySyncronizeDiscountEntitlement(user));

          if (!user.migratedFlutter) {
            await userService.deleteSettings();
            await userService.setFlutterMigrationFlag();
            return ScreenType.initialSetting;
          }
          if (user.setting == null) {
            return ScreenType.initialSetting;
          }

          final storage = await SharedPreferences.getInstance();
          if (!storage.getKeys().contains(StringKey.firebaseAnonymousUserID)) {
            await storage.setString(
                StringKey.firebaseAnonymousUserID, authInfo.uid);
          }

          bool? didEndInitialSetting =
              storage.getBool(BoolKey.didEndInitialSetting);
          if (didEndInitialSetting == null) {
            return ScreenType.initialSetting;
          }
          if (!didEndInitialSetting) {
            return ScreenType.initialSetting;
          }

          return ScreenType.home;
        });
      }).then((screenType) {
        setState(() {
          this.screenType = screenType;
        });
      }).catchError((error) {
        errorLogger.recordError(error, StackTrace.current);
        setState(() {
          this._error = UserDisplayedError(ErrorMessages.connection +
              "\n" +
              "errorType: ${error.runtimeType.toString()}\n" +
              "error: ${error.toString()}\n" +
              StackTrace.current.toString());
        });
      });
    }
  }
}
