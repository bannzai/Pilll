import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/provider/force_update.dart';
import 'package:pilll/provider/set_user_id.dart';
import 'package:pilll/provider/shared_preferences.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/page/ok_dialog.dart';
import 'package:pilll/features/initial_setting/pill_sheet_group/initial_setting_pill_sheet_group_page.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/provider/root.dart';
import 'package:pilll/provider/auth.dart';
import 'package:pilll/features/home/home_page.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/features/error/template.dart';
import 'package:pilll/features/error/universal_error_page.dart';
import 'package:pilll/utils/environment.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/platform/platform.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// FIXME: test 時にboolSharedPreferencesProviderをそのまま使うとフリーズする
final didEndInitialSettingProvider = Provider((ref) => ref.watch(boolSharedPreferencesProvider(BoolKey.didEndInitialSetting)));

class Root extends HookConsumerWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInFirebaseUser = ref.watch(firebaseSignInProvider.future);
    final checkForceUpdate = ref.watch(checkForceUpdateProvider);
    final setUserID = ref.watch(setUserIDProvider);

    final userID = useState<String?>(null);
    final shouldForceUpdate = useState(false);
    final error = useState<LaunchException?>(null);

    // Setup for application
    useEffect(() {
      if (!Environment.isTest) {
        // Set global error page
        ErrorWidget.builder = (FlutterErrorDetails details) {
          return UniversalErrorPage(
            error: details.exception.toString(),
            child: null,
            reload: () => ref.refresh(refreshAppProvider),
          );
        };
      }

      f() async {
        try {
          if (await checkForceUpdate()) {
            shouldForceUpdate.value = true;
          }
        } catch (e, st) {
          errorLogger.recordError(e, st);
          error.value = LaunchException("起動処理でエラーが発生しました\n${ErrorMessages.connection}\n詳細:", e);
        }
      }

      f();
      return null;
    }, [true]);

    // For app screen state
    useEffect(() {
      f() async {
        // SignIn first. Keep in mind that this method is called first.
        try {
          final firebaseUser = await signInFirebaseUser;
          userID.value = firebaseUser.uid;
        } catch (e, st) {
          errorLogger.recordError(e, st);
          error.value = LaunchException("認証時にエラーが発生しました\n${ErrorMessages.connection}\n詳細:", e);
        }
      }

      f();
      return null;
    }, [signInFirebaseUser]);

    useEffect(() {
      final userIDValue = userID.value;
      if (userIDValue != null) {
        setUserID(userID: userIDValue);
      }

      return null;
    }, [userID.value]);

    // For force update
    if (shouldForceUpdate.value) {
      Future.microtask(() async {
        await showOKDialog(context, title: "アプリをアップデートしてください", message: "お使いのアプリのバージョンのアップデートをお願いしております。$storeNameから最新バージョンにアップデートしてください",
            ok: () async {
          await launchUrl(
            Uri.parse(storeURL),
            mode: LaunchMode.externalApplication,
          );
        });
      });
      return const ScaffoldIndicator();
    }

    // Main stream
    return UniversalErrorPage(
      error: error.value,
      reload: () {
        error.value = null;
        return ref.refresh(refreshAppProvider);
      },
      child: () {
        final uid = userID.value;
        if (uid == null) {
          return const ScaffoldIndicator();
        } else {
          return InitialSettingOrAppPage(firebaseUserID: uid);
        }
      }(),
    );
  }
}

class LaunchException {
  final String message;
  final Object underlyingException;

  LaunchException(
    this.message,
    this.underlyingException,
  );

  @override
  String toString() => message + underlyingException.toString();
}

enum _InitialSettingOrAppPageScreenType { loading, initialSetting, app }

class InitialSettingOrAppPage extends HookConsumerWidget {
  final String firebaseUserID;
  const InitialSettingOrAppPage({Key? key, required this.firebaseUserID}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchOrCreateUser = ref.watch(fetchOrCreateUserProvider);
    final saveUserLaunchInfo = ref.watch(saveUserLaunchInfoProvider);
    final markAsMigratedToFlutter = ref.watch(markAsMigratedToFlutterProvider);

    final screenType = useState(_InitialSettingOrAppPageScreenType.loading);
    final appUser = useState<User?>(null);
    final error = useState<LaunchException?>(null);

    final didEndInitialSetting = ref.watch(didEndInitialSettingProvider);

    useEffect(() {
      f() async {
        // **** BEGIN: Do not break the sequence. ****
        try {
          // Decide screen type. Keep in mind that this method is called when user is logged in.
          screenType.value = _screenType(didEndInitialSetting: didEndInitialSetting.value);

          final appUserValue = appUser.value;
          if (appUserValue == null) {
            // Retrieve user from app DB.
            final user = await fetchOrCreateUser(firebaseUserID);
            saveUserLaunchInfo(user);
            appUser.value = user;

            // Rescue for old users
            if (!user.migratedFlutter) {
              markAsMigratedToFlutter();
              analytics.logEvent(name: "user_is_not_migrated_flutter", parameters: {"uid": firebaseUserID});
              screenType.value = _InitialSettingOrAppPageScreenType.initialSetting;
            } else if (user.setting == null) {
              analytics.logEvent(name: "uset_setting_is_null", parameters: {"uid": firebaseUserID});
              screenType.value = _InitialSettingOrAppPageScreenType.initialSetting;
            }
          } else {
            saveUserLaunchInfo(appUserValue);
          }
        } catch (e, st) {
          errorLogger.recordError(e, st);
          error.value = LaunchException("起動時にエラーが発生しました\n${ErrorMessages.connection}\n詳細:", e);
        }
        // **** END: Do not break the sequence. ****
      }

      f();
      return null;
    }, [error.value, didEndInitialSetting.value]);

    return UniversalErrorPage(
      error: error.value,
      reload: () => ref.refresh(refreshAppProvider),
      child: () {
        switch (screenType.value) {
          case _InitialSettingOrAppPageScreenType.loading:
            return const ScaffoldIndicator();
          case _InitialSettingOrAppPageScreenType.initialSetting:
            return InitialSettingPillSheetGroupPageRoute.screen();
          case _InitialSettingOrAppPageScreenType.app:
            return const HomePage();
        }
      }(),
    );
  }

  _InitialSettingOrAppPageScreenType _screenType({required bool? didEndInitialSetting}) {
    if (didEndInitialSetting == null) {
      analytics.logEvent(name: "did_end_i_s_is_null");
      return _InitialSettingOrAppPageScreenType.initialSetting;
    }
    if (!didEndInitialSetting) {
      analytics.logEvent(name: "did_end_i_s_is_false");
      return _InitialSettingOrAppPageScreenType.initialSetting;
    }

    analytics.logEvent(name: "screen_type_is_home");
    return _InitialSettingOrAppPageScreenType.app;
  }
}
