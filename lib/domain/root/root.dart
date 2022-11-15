import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/page/ok_dialog.dart';
import 'package:pilll/domain/initial_setting/pill_sheet_group/initial_setting_pill_sheet_group_page.dart';
import 'package:pilll/entity/config.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/provider/root.dart';
import 'package:pilll/service/auth.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/domain/home/home_page.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/error/template.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/service/purchase.dart';
import 'package:pilll/database/user.dart';
import 'package:pilll/util/platform/platform.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pilll/util/version/version.dart';
import 'package:url_launcher/url_launcher.dart';

// TODO: Replace to HookConsumerWidget
// TODO: Instantiate and cache SharedPreferences with Provider on RootPage(this file)

class Root extends HookConsumerWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shouldForceUpdate = useState(false);
    final firebaseUserID = useState<String?>(null);
    final error = useState<LaunchException?>(null);
    final firebaseUserAsyncValue = ref.watch(authStateStreamProvider);

    // Set global error page
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return UniversalErrorPage(
        error: details.exception.toString(),
        child: null,
        reload: () => ref.read(refreshAppProvider),
      );
    };

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
    useEffect(() {
      f() async {
        try {
          if (await _checkForceUpdate()) {
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
        final firebaseUser = firebaseUserAsyncValue.asData?.value;
        if (firebaseUser == null) {
          try {
            firebaseUserID.value = null;
            // SignIn first. Keep in mind that this method is called first.
            final firebaseUser = await ref.read(firebaseSignInProvider.future);
            firebaseUserID.value = firebaseUser.uid;

            unawaited(FirebaseCrashlytics.instance.setUserIdentifier(firebaseUser.uid));
            unawaited(firebaseAnalytics.setUserId(id: firebaseUser.uid));
            unawaited(Purchases.logIn(firebaseUser.uid));
            unawaited(initializePurchase(firebaseUser.uid));
          } catch (e, st) {
            errorLogger.recordError(e, st);
            error.value = LaunchException("認証時にエラーが発生しました\n${ErrorMessages.connection}\n詳細:", e);
          }
        }
      }

      f();
      return null;
    }, [firebaseUserAsyncValue.asData?.value?.uid]);

    return UniversalErrorPage(
      error: error.value,
      reload: () => ref.refresh(refreshAppProvider),
      child: () {
        final uid = firebaseUserID.value;
        if (uid == null) {
          return const ScaffoldIndicator();
        } else {
          return _InitialSettingOrAppPage(firebaseUserID: uid);
        }
      }(),
    );
  }

// Return false: should not force update
// Return true: should force update
  Future<bool> _checkForceUpdate() async {
    final doc = await FirebaseFirestore.instance.doc("/globals/config").get();
    final config = Config.fromJson(doc.data() as Map<String, dynamic>);
    final packageVersion = await Version.fromPackage();

    final forceUpdate = packageVersion.isLessThan(Version.parse(config.minimumSupportedAppVersion));
    if (forceUpdate) {
      analytics.logEvent(
        name: "screen_type_force_update",
        parameters: {
          "package_version": packageVersion.toString(),
          "minimum_app_version": config.minimumSupportedAppVersion,
        },
      );
    }
    return forceUpdate;
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

class _InitialSettingOrAppPage extends HookConsumerWidget {
  final String firebaseUserID;
  const _InitialSettingOrAppPage({Key? key, required this.firebaseUserID}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenType = useState(_InitialSettingOrAppPageScreenType.loading);
    final appUser = useState<User?>(null);
    final fetchOrCreateUser = ref.watch(fetchOrCreateUserProvider);
    final saveUserLaunchInfo = ref.watch(saveUserLaunchInfoProvider);
    final markAsMigratedToFlutter = ref.watch(markAsMigratedToFlutterProvider);
    final error = useState<LaunchException?>(null);

    useEffect(() {
      f() async {
        // **** BEGIN: Do not break the sequence. ****
        try {
          // Decide screen type. Keep in mind that this method is called when user is logged in.
          screenType.value = await _screenType();

          if (appUser.value == null) {
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
          }
        } catch (e, st) {
          errorLogger.recordError(e, st);
          error.value = LaunchException("起動時にエラーが発生しました\n${ErrorMessages.connection}\n詳細:", e);
        }
        // **** END: Do not break the sequence. ****
      }

      f();
      return null;
    }, [error.value]);

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

  Future<_InitialSettingOrAppPageScreenType> _screenType() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    bool? didEndInitialSetting = sharedPreferences.getBool(BoolKey.didEndInitialSetting);
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
