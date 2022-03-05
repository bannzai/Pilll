import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/page/ok_dialog.dart';
import 'package:pilll/domain/initial_setting/pill_sheet_group/initial_setting_pill_sheet_group_pill_sheet_type_select_row.dart';
import 'package:pilll/entity/config.dart';
import 'package:pilll/performance.dart';
import 'package:pilll/service/auth.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/domain/home/home_page.dart';
import 'package:pilll/entity/user_error.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/error/template.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/service/purchase.dart';
import 'package:pilll/service/user.dart';
import 'package:pilll/util/platform/platform.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pilll/util/version/version.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

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
      child: () {
        switch (screenType) {
          case ScreenType.home:
            return HomePage(key: homeKey);
          case ScreenType.initialSetting:
            return InitialSettingPillSheetCountPageRoute.screen();
          default:
            return ScaffoldIndicator();
        }
      }(),
    );
  }

  String _traceUUID() {
    final uuid = const Uuid();
    return uuid.v4();
  }

  Trace _trace({required String name, required String uuid}) {
    final trace = performance.newTrace(
      name,
    );
    trace.putAttribute("uuid", uuid);
    return trace;
  }

  _decideScreenType() async {
    final uuid = _traceUUID();

    final launchTrace = _trace(name: "appLaunch", uuid: uuid);
    await launchTrace.start();

    try {
      final forceUpdateTrace = _trace(name: "forceUpdate", uuid: uuid);
      await forceUpdateTrace.start();

      final doc = await FirebaseFirestore.instance.doc("/globals/config").get();
      final config = Config.fromJson(doc.data() as Map<String, dynamic>);
      final packageVersion = await Version.fromPackage();

      await forceUpdateTrace.stop();

      if (packageVersion
          .isLessThan(Version.parse(config.minimumSupportedAppVersion))) {
        setState(() {
          screenType = ScreenType.forceUpdate;
        });

        launchTrace.putAttribute("end_reason", "forceUpdate");
        await launchTrace.stop();
        return;
      }

      final signInTrace = _trace(name: "signInTrace", uuid: uuid);
      await signInTrace.start();
      cachedUserOrSignInAnonymously().then((firebaseUser) async {
        await signInTrace.stop();

        unawaited(
            FirebaseCrashlytics.instance.setUserIdentifier(firebaseUser.uid));
        unawaited(firebaseAnalytics.setUserId(id: firebaseUser.uid));
        unawaited(initializePurchase(firebaseUser.uid));

        final userService = UserService(DatabaseConnection(firebaseUser.uid));

        final userFetchTrace = _trace(name: "userFetchTrace", uuid: uuid);
        await userFetchTrace.start();
        return userService.prepare(firebaseUser.uid).then((user) async {
          await userFetchTrace.stop();
          await launchTrace.stop();

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
    } catch (error, stackTrace) {
      errorLogger.recordError(error, stackTrace);

      setState(() {
        this._error = UserDisplayedError(
            ErrorMessages.connection + "\n" + "起動処理でエラーが発生しました");
      });
    }
  }
}
