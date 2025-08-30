import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:pilll/entity/remote_config_parameter.codegen.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/entity/package.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/utils/datetime/date_add.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userProvider = StreamProvider((ref) => ref.watch(databaseProvider).userReference().snapshots().map((event) => event.data()!));

class UpdatePurchaseInfo {
  final DatabaseConnection databaseConnection;
  UpdatePurchaseInfo(this.databaseConnection);

  Future<void> call({
    required bool? isActivated,
    required String? entitlementIdentifier,
    required String? premiumPlanIdentifier,
    required String purchaseAppID,
    required List<String> activeSubscriptions,
    required String? originalPurchaseDate,
  }) async {
    await databaseConnection.userRawReference().set(
        {if (isActivated != null) UserFirestoreFieldKeys.isPremium: isActivated, UserFirestoreFieldKeys.purchaseAppID: purchaseAppID},
        SetOptions(merge: true));
    final privates = {
      if (premiumPlanIdentifier != null) UserPrivateFirestoreFieldKeys.latestPremiumPlanIdentifier: premiumPlanIdentifier,
      if (originalPurchaseDate != null) UserPrivateFirestoreFieldKeys.originalPurchaseDate: originalPurchaseDate,
      if (activeSubscriptions.isNotEmpty) UserPrivateFirestoreFieldKeys.activeSubscriptions: activeSubscriptions,
      if (entitlementIdentifier != null) UserPrivateFirestoreFieldKeys.entitlementIdentifier: entitlementIdentifier,
    };
    if (privates.isNotEmpty) {
      await databaseConnection.userPrivateRawReference().set({...privates}, SetOptions(merge: true));
    }
  }
}

class SyncPurchaseInfo {
  final DatabaseConnection databaseConnection;
  SyncPurchaseInfo(this.databaseConnection);

  Future<void> call({
    required bool isActivated,
  }) async {
    await databaseConnection.userRawReference().set({
      UserFirestoreFieldKeys.isPremium: isActivated,
    }, SetOptions(merge: true));
  }
}

final fetchOrCreateUserProvider = Provider((ref) => FetchOrCreateUser(ref.watch(databaseProvider)));

class FetchOrCreateUser {
  final DatabaseConnection databaseConnection;
  FetchOrCreateUser(this.databaseConnection);

  Future<User> call(String uid) async {
    debugPrint('call fetchOrCreate for $uid');
    final user = await _fetch(uid).catchError((error) {
      if (error is UserNotFound) {
        return _create(uid).then((_) => _fetch(uid));
      }
      throw FormatException('Create user error: $error, stackTrace: ${StackTrace.current.toString()}');
    });
    return user;
  }

  Future<User> _fetch(String uid) async {
    debugPrint('#fetch $uid');
    try {
      final document = await databaseConnection.userReference().get();
      if (!document.exists) {
        debugPrint('user does not exists $uid');
        throw UserNotFound();
      }
      return document.data()!;
    } catch (e, st) {
      debugPrint('error: $e, stackTrace: $st');
      rethrow;
    }
  }

  Future<void> _create(String uid) async {
    debugPrint('#create $uid');
    final sharedPreferences = await SharedPreferences.getInstance();
    final anonymousUserID = sharedPreferences.getString(StringKey.lastSignInAnonymousUID);
    return databaseConnection.userRawReference().set(
      {
        if (anonymousUserID != null) UserFirestoreFieldKeys.anonymousUserID: anonymousUserID,
        UserFirestoreFieldKeys.userIDWhenCreateUser: uid,
      },
      SetOptions(merge: true),
    );
  }
}

final linkAppleProvider = Provider((ref) => LinkApple(ref.watch(databaseProvider)));

class LinkApple {
  final DatabaseConnection databaseConnection;
  LinkApple(this.databaseConnection);

  Future<void> call() async {
    await databaseConnection.userRawReference().set({
      UserFirestoreFieldKeys.isAnonymous: false,
    }, SetOptions(merge: true));

    await databaseConnection.userPrivateRawReference().set({
      UserPrivateFirestoreFieldKeys.isLinkedApple: true,
    }, SetOptions(merge: true));
  }
}

final linkGoogleProvider = Provider((ref) => LinkGoogle(ref.watch(databaseProvider)));

class LinkGoogle {
  final DatabaseConnection databaseConnection;
  LinkGoogle(this.databaseConnection);

  Future<void> call() async {
    await databaseConnection.userRawReference().set({
      UserFirestoreFieldKeys.isAnonymous: false,
    }, SetOptions(merge: true));

    await databaseConnection.userPrivateRawReference().set({
      UserPrivateFirestoreFieldKeys.isLinkedGoogle: true,
    }, SetOptions(merge: true));
  }
}

final registerRemotePushNotificationTokenProvider = Provider((ref) => RegisterRemotePushNotificationToken(ref.watch(databaseProvider)));

class RegisterRemotePushNotificationToken {
  final DatabaseConnection databaseConnection;
  RegisterRemotePushNotificationToken(this.databaseConnection);

  Future<void> call({required String? fcmToken, required String? apnsToken}) {
    debugPrint('fcmToken: $fcmToken');
    debugPrint('apnsToken: $apnsToken');
    return databaseConnection.userPrivateRawReference().set(
      {
        UserPrivateFirestoreFieldKeys.fcmToken: fcmToken,
        UserPrivateFirestoreFieldKeys.apnsToken: apnsToken,
      },
      SetOptions(merge: true),
    );
  }
}

final saveUserLaunchInfoProvider = Provider((ref) => SaveUserLaunchInfo(ref.watch(databaseProvider)));

class SaveUserLaunchInfo {
  final DatabaseConnection databaseConnection;
  SaveUserLaunchInfo(this.databaseConnection);

  void call(User user) {
    unawaited(_saveStats(user));
  }

  Future<void> _saveStats(User user) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    // Stats
    final lastLoginVersion = await PackageInfo.fromPlatform().then((value) => value.version);
    String? beginVersion = sharedPreferences.getString(StringKey.beginVersion);
    if (beginVersion == null) {
      final v = lastLoginVersion;
      await sharedPreferences.setString(StringKey.beginVersion, v);
      beginVersion = v;
    }

    // timezone
    final now = DateTime.now().toLocal();
    final timeZoneName = now.timeZoneName;
    final timeZoneOffset = now.timeZoneOffset;
    final timeZoneDatabaseName = await FlutterTimezone.getLocalTimezone();

    // Package
    final packageInfo = await PackageInfo.fromPlatform();
    final os = Platform.operatingSystem;
    final package = Package(latestOS: os, appName: packageInfo.appName, buildNumber: packageInfo.buildNumber, appVersion: packageInfo.version);

    // UserIDs
    final userID = user.id!;
    List<String> userDocumentIDSets = [...user.userDocumentIDSets];
    if (!userDocumentIDSets.contains(userID)) {
      userDocumentIDSets.add(userID);
    }
    final lastSignInAnonymousUID = sharedPreferences.getString(StringKey.lastSignInAnonymousUID);
    List<String> anonymousUserIDSets = [...user.anonymousUserIDSets];
    if (lastSignInAnonymousUID != null && !anonymousUserIDSets.contains(lastSignInAnonymousUID)) {
      anonymousUserIDSets.add(lastSignInAnonymousUID);
    }
    final firebaseCurrentUserID = firebase_auth.FirebaseAuth.instance.currentUser?.uid;
    List<String> firebaseCurrentUserIDSets = [...user.firebaseCurrentUserIDSets];
    if (firebaseCurrentUserID != null && !firebaseCurrentUserIDSets.contains(firebaseCurrentUserID)) {
      firebaseCurrentUserIDSets.add(firebaseCurrentUserID);
    }

    return databaseConnection.userRawReference().set({
      // Shortcut property for backend
      'lastLoginAt': now,
      // Stats
      'stats': {
        'lastLoginAt': now,
        'beginVersion': beginVersion,
        'lastLoginVersion': lastLoginVersion,
      },
      'timezone': {
        'name': timeZoneName,
        'databaseName': timeZoneDatabaseName,
        'offsetInHours': timeZoneOffset.inHours,
        'offsetIsNegative': timeZoneOffset.isNegative,
      },
      // Package
      UserFirestoreFieldKeys.packageInfo: package.toJson(),

      // UserIDs
      UserFirestoreFieldKeys.userDocumentIDSets: userDocumentIDSets,
      UserFirestoreFieldKeys.firebaseCurrentUserIDSets: firebaseCurrentUserIDSets,
      UserFirestoreFieldKeys.anonymousUserIDSets: anonymousUserIDSets,

      UserFirestoreFieldKeys.isTrial: user.isTrial,
    }, SetOptions(merge: true));
  }
}

final endInitialSettingProvider = Provider((ref) => EndInitialSetting(ref.watch(databaseProvider)));

class EndInitialSetting {
  final DatabaseConnection databaseConnection;
  EndInitialSetting(this.databaseConnection);

  Future<void> call(RemoteConfigParameter remoteConfigParameter) {
    final Map<String, dynamic> data = {
      UserFirestoreFieldKeys.isTrial: true,
      UserFirestoreFieldKeys.beginTrialDate: now(),
      UserFirestoreFieldKeys.trialDeadlineDate: now().addDays(remoteConfigParameter.trialDeadlineDateOffsetDay).endOfDay(),
    };

    // ABテストが有効でない場合のみ割引期間を設定
    if (remoteConfigParameter.discountPeriodABTestDisabled) {
      data[UserFirestoreFieldKeys.discountEntitlementDeadlineDate] =
          now().addDays(remoteConfigParameter.trialDeadlineDateOffsetDay + remoteConfigParameter.discountEntitlementOffsetDay).endOfDay();
    }

    return databaseConnection.userRawReference().set(data, SetOptions(merge: true));
  }
}

final disableShouldAskCancelReasonProvider = Provider((ref) => DisableShouldAskCancelReason(ref.watch(databaseProvider)));

class DisableShouldAskCancelReason {
  final DatabaseConnection databaseConnection;
  DisableShouldAskCancelReason(this.databaseConnection);

  Future<void> call() async {
    await databaseConnection.userRawReference().set({
      UserFirestoreFieldKeys.shouldAskCancelReason: false,
    }, SetOptions(merge: true));
  }
}
