import 'package:firebase_auth/firebase_auth.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/auth/auth.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/domain/home/home_page.dart';
import 'package:pilll/domain/initial_setting/initial_setting_1_page.dart';
import 'package:pilll/entity/user_error.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/service/user.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

GlobalKey<RootState> rootKey = GlobalKey();

class Root extends StatefulWidget {
  Root({Key? key}) : super(key: key);

  @override
  RootState createState() => RootState();
}

enum ScreenType { home, initialSetting }
enum IndicatorType { shown, hidden }

class RootState extends State<Root> {
  Error? error;
  onError(Error error) {
    setState(() {
      this.error = error;
    });
  }

  ScreenType? screenType;
  showHome() {
    setState(() {
      screenType = ScreenType.home;
    });
  }

  showInitialSetting() {
    setState(() {
      screenType = ScreenType.initialSetting;
    });
  }

  reloadRoot() {
    setState(() {
      screenType = null;
      error = null;
      _auth();
    });
  }

  List<IndicatorType> _indicatorTypes = [];
  showIndicator() {
    _indicatorTypes.add(IndicatorType.shown);
    Future.delayed(Duration(milliseconds: 200)).then((value) {
      if (_indicatorTypes.isEmpty) {
        return;
      }
      if (_indicatorTypes.last == IndicatorType.hidden) {
        return;
      }
      showDialog(
          barrierColor: Colors.transparent,
          context: context,
          builder: (BuildContext context) {
            return DialogIndicator();
          });
    });
  }

  hideIndicator() {
    if (_indicatorTypes.isEmpty) {
      return;
    }
    if (_indicatorTypes.last != IndicatorType.shown) {
      return;
    }
    _indicatorTypes.add(IndicatorType.hidden);
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    _auth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return UniversalErrorPage(error: error);
    }
    if (screenType == null) {
      return ScaffoldIndicator();
    }
    return Consumer(builder: (context, watch, child) {
      return watch(authStateProvider).when(data: (snapshot) {
        switch (screenType) {
          case ScreenType.home:
            return HomePage(key: homeKey);
          case ScreenType.initialSetting:
            return InitialSetting1Page();
          default:
            return ScaffoldIndicator();
        }
      }, loading: () {
        return ScaffoldIndicator();
      }, error: (error, stacktrace) {
        print(error);
        print(stacktrace);
        final displayedError = UserDisplayedError(
            displayedMessage: "2: -- error: " +
                error.toString() +
                "stacktrace: " +
                stacktrace.toString());
        errorLogger.recordError(error, stacktrace);
        return UniversalErrorPage(error: displayedError);
      });
    });
  }

  _auth() {
    var info = "";
    auth().then((authInfo) {
      info += "DEUBG: - 1;";
      final userService = UserService(DatabaseConnection(authInfo.uid));
      info += "DEUBG: - 2; authInfo.uid: ${authInfo.uid}";
      return userService.prepare().then((_) async {
        userService.saveLaunchInfo();
        userService.saveStats();
        final user = await userService.fetch();
        if (!user.migratedFlutter) {
          analytics.logEvent(name: "DEBUG", parameters: {"index": 1});
          info = "DEUBG: - 3;";
          await userService.deleteSettings();
          await userService.setFlutterMigrationFlag();
          return ScreenType.initialSetting;
        }
        info += "DEUBG: - 3; user: ${user.toJson()}";
        if (user.setting == null) {
          analytics.logEvent(name: "DEBUG", parameters: {"index": 2});
          return ScreenType.initialSetting;
        }
        info += "DEUBG: - 4;";
        final storage = await SharedPreferences.getInstance();
        info += "DEUBG: - 5;${storage.getKeys()}";
        if (!storage.getKeys().contains(StringKey.firebaseAnonymousUserID)) {
          analytics.logEvent(name: "DEBUG", parameters: {"index": 3});
          storage.setString(
              StringKey.firebaseAnonymousUserID, user.anonymouseUserID);
        }
        bool? didEndInitialSetting =
            storage.getBool(BoolKey.didEndInitialSetting);
        info += "DEUBG: - 6;$didEndInitialSetting";
        analytics.logEvent(name: "DEBUG", parameters: {"index": 4});
        if (didEndInitialSetting == null) {
          return ScreenType.initialSetting;
        }
        info += "DEUBG: - 7;$didEndInitialSetting";
        analytics.logEvent(name: "DEBUG", parameters: {"index": 4});
        if (!didEndInitialSetting) {
          return ScreenType.initialSetting;
        }
        info += "DEUBG: - 8;$didEndInitialSetting";
        return ScreenType.home;
      });
    }).then((screenType) {
      info += "DEUBG: - 9;$screenType";
      setState(() {
        info += "DEUBG: - 10;$screenType";
        this.screenType = screenType;
      });
    }).catchError((error) {
      if (error is FirebaseAuthException) {
        final e = UserDisplayedError(
            displayedMessage:
                "Firebase auth exception message: ${error.message}");
        errorLogger.recordError(e, StackTrace.current);
        onError(UserDisplayedError(
            displayedMessage: "1: -- " +
                e.toString() +
                "2: -- $info" +
                "3: -- " +
                e.stackTrace.toString()));
        return;
      }
      if (error is FirebaseException) {
        final e = UserDisplayedError(
            displayedMessage:
                "Firebase exception service: ${error.plugin} / message: ${error.message}");
        errorLogger.recordError(e, StackTrace.current);
        onError(UserDisplayedError(
            displayedMessage: "1: -- " +
                e.toString() +
                "2: -- $info" +
                "3: -- " +
                e.stackTrace.toString()));
        return;
      }
      if (error == null) {
        final e = UserDisplayedError(displayedMessage: "error is null");
        errorLogger.recordError(e, StackTrace.current);
        onError(UserDisplayedError(
            displayedMessage: "1: -- " +
                e.toString() +
                "2: -- $info" +
                "3: -- " +
                StackTrace.current.toString()));
        return;
      }
      errorLogger.recordError(error, StackTrace.current);
      onError(UserDisplayedError(
          displayedMessage: "1: -- " +
              error.toString() +
              "2: -- $info" +
              "3: -- " +
              StackTrace.current.toString()));
    });
  }
}
