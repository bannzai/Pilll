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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pilll/util/version/version.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

// TODO: Replace to HookConsumerWidget
// TODO: Instantiate and cache SharedPreferences with Provider on RootPage(this file)

enum ScreenType { loading, home, initialSetting, forceUpdate }

class Root extends HookConsumerWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenType = useState<ScreenType>(ScreenType.loading);
    void setScreenType(ScreenType _screenType) {
      if (screenType.value != ScreenType.forceUpdate) {
        screenType.value = _screenType;
      }
    }

    final error = useState<LaunchException?>(null);
    final firebaseUserAsyncValue = ref.watch(authStateStreamProvider);

    // For force update
    if (screenType.value == ScreenType.forceUpdate) {
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
          final shouldForceUpdate = await _checkForceUpdate();

          if (shouldForceUpdate) {
            setScreenType(ScreenType.forceUpdate);
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
            // SignIn first. Keep in mind that this method is called first.
            final firebaseUser = await ref.read(signInProvider.future);

            unawaited(FirebaseCrashlytics.instance.setUserIdentifier(firebaseUser.uid));
            unawaited(firebaseAnalytics.setUserId(id: firebaseUser.uid));
            unawaited(initializePurchase(firebaseUser.uid));
          } catch (e, st) {
            errorLogger.recordError(e, st);
            error.value = LaunchException("認証時にエラーが発生しました\n${ErrorMessages.connection}\n詳細:", e);
          }
        } else {
          // **** BEGIN: Do not break the sequence. ****
          await Future(() async {
            try {
              // Decide screen type. Keep in mind that this method is called when user is logged in.
              setScreenType(await _screenType());

              // Retrieve user from app DB.
              final user = await _mutateUserWithLaunchInfo(firebaseUser);

              // Rescue for old users
              final screenTypeForLegacyUser = await _screenTypeForOldUser(firebaseUser, user);
              if (screenTypeForLegacyUser != null) {
                setScreenType(screenTypeForLegacyUser);
              }
            } catch (e, st) {
              errorLogger.recordError(e, st);
              error.value = LaunchException("起動時にエラーが発生しました\n${ErrorMessages.connection}\n詳細:", e);
            }
          });
          // **** END: Do not break the sequence. ****
        }
      }

      f();
      return null;
    }, [firebaseUserAsyncValue.asData?.value?.uid]);

    return UniversalErrorPage(
      error: error.value,
      reload: () => ref.refresh(refreshAppProvider),
      child: () {
        switch (screenType.value) {
          case ScreenType.loading:
            return const ScaffoldIndicator();
          case ScreenType.initialSetting:
            return InitialSettingPillSheetGroupPageRoute.screen();
          case ScreenType.home:
            return HomePage(key: homeKey);
          case ScreenType.forceUpdate:
            return const ScaffoldIndicator();
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

  Future<ScreenType> _screenType() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    bool? didEndInitialSetting = sharedPreferences.getBool(BoolKey.didEndInitialSetting);
    if (didEndInitialSetting == null) {
      analytics.logEvent(name: "did_end_i_s_is_null");
      return ScreenType.initialSetting;
    }
    if (!didEndInitialSetting) {
      analytics.logEvent(name: "did_end_i_s_is_false");
      return ScreenType.initialSetting;
    }

    analytics.logEvent(name: "screen_type_is_home");
    return ScreenType.home;
  }

  Future<User> _mutateUserWithLaunchInfo(firebase_auth.User firebaseUser) async {
    final userDatastore = UserDatastore(DatabaseConnection(firebaseUser.uid));
    final user = await userDatastore.fetchOrCreate(firebaseUser.uid);

    userDatastore.saveUserLaunchInfo(user);
    userDatastore.temporarySyncronizeDiscountEntitlement(user);

    return user;
  }

  Future<ScreenType?> _screenTypeForOldUser(firebase_auth.User firebaseUser, User user) async {
    if (!user.migratedFlutter) {
      final userDatastore = UserDatastore(DatabaseConnection(firebaseUser.uid));
      await userDatastore.deleteSettings();
      await userDatastore.setFlutterMigrationFlag();
      analytics.logEvent(name: "user_is_not_migrated_flutter", parameters: {"uid": firebaseUser.uid});
      return ScreenType.initialSetting;
    } else if (user.setting == null) {
      analytics.logEvent(name: "uset_setting_is_null", parameters: {"uid": firebaseUser.uid});
      return ScreenType.initialSetting;
    }
    return null;
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
