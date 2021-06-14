import 'package:pilll/components/page/hud.dart';
import 'package:pilll/service/auth.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/domain/home/home_page.dart';
import 'package:pilll/domain/initial_setting/initial_setting_1_page.dart';
import 'package:pilll/entity/user_error.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/error/template.dart';
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

class RootState extends State<Root> {
  dynamic? error;
  onError(dynamic error) {
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

  @override
  void initState() {
    _auth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return UniversalErrorPage(
        error: error.toString(),
        child: null,
        reload: () {
          reloadRoot();
        },
      );
    }
    if (screenType == null) {
      return ScaffoldIndicator();
    }
    return HUD(
      key: hudKey,
      child: Consumer(builder: (context, watch, child) {
        return watch(authStateStreamProvider).when(data: (snapshot) {
          switch (screenType) {
            case ScreenType.home:
              return HomePage(key: homeKey);
            case ScreenType.initialSetting:
              return InitialSetting1PageRoute.screen();
            default:
              return ScaffoldIndicator();
          }
        }, loading: () {
          return ScaffoldIndicator();
        }, error: (error, stacktrace) {
          print(error);
          print(stacktrace);
          errorLogger.recordError(error, stacktrace);
          final displayedError = ErrorMessages.connection +
              "\n" +
              "errorType: ${error.runtimeType.toString()}\n" +
              error.toString() +
              "error: ${error.toString()}\n" +
              stacktrace.toString();
          return UniversalErrorPage(
            error: displayedError,
            child: null,
            reload: () {
              rootKey.currentState?.reloadRoot();
            },
          );
        });
      }),
    );
  }

  _auth() {
    cacheOrAuth().then((authInfo) {
      final userService = UserService(DatabaseConnection(authInfo.uid));
      return userService.prepare(authInfo.uid).then((_) async {
        userService.recordUserIDs();
        userService.saveLaunchInfo();
        userService.saveStats();
        final user = await userService.fetch();
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
          storage.setString(StringKey.firebaseAnonymousUserID, authInfo.uid);
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
      onError(UserDisplayedError(ErrorMessages.connection +
          "\n" +
          "errorType: ${error.runtimeType.toString()}\n" +
          "error: ${error.toString()}\n" +
          StackTrace.current.toString()));
    });
  }
}
