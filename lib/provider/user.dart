import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/features/premium_function_survey/premium_function_survey_element_type.dart';
import 'package:pilll/entity/package.codegen.dart';
import 'package:pilll/entity/premium_function_survey.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info/package_info.dart';
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
    debugPrint("call fetchOrCreate for $uid");
    final user = await _fetch(uid).catchError((error) {
      if (error is UserNotFound) {
        return _create(uid).then((_) => _fetch(uid));
      }
      throw FormatException("Create user error: $error, stackTrace: ${StackTrace.current.toString()}");
    });
    return user;
  }

  Future<User> _fetch(String uid) async {
    debugPrint("#fetch $uid");
    final document = await databaseConnection.userReference().get();
    if (!document.exists) {
      debugPrint("user does not exists $uid");
      throw UserNotFound();
    }

    return document.data()!;
  }

  Future<void> _create(String uid) async {
    debugPrint("#create $uid");
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

final sendPremiumFunctionSurveyProvider = Provider((ref) => SendPremiumFunctionSurvey(ref.watch(databaseProvider)));

class SendPremiumFunctionSurvey {
  final DatabaseConnection databaseConnection;
  SendPremiumFunctionSurvey(this.databaseConnection);

  Future<void> call(List<PremiumFunctionSurveyElementType> elements, String message) async {
    final PremiumFunctionSurvey premiumFunctionSurvey = PremiumFunctionSurvey(
      elements: elements,
      message: message,
    );
    return databaseConnection
        .userPrivateRawReference()
        .set({UserPrivateFirestoreFieldKeys.premiumFunctionSurvey: premiumFunctionSurvey.toJson()}, SetOptions(merge: true));
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

  Future<void> call(String? token) {
    debugPrint("token: $token");
    return databaseConnection.userPrivateRawReference().set(
      {UserPrivateFirestoreFieldKeys.fcmToken: token},
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
    unawaited(_temporarySyncronizeDiscountEntitlement(user));
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
    final timeZoneDatabaseName = await FlutterNativeTimezone.getLocalTimezone();

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
      "lastLoginAt": now,
      // Stats
      "stats": {
        "lastLoginAt": now,
        "beginVersion": beginVersion,
        "lastLoginVersion": lastLoginVersion,
      },
      "timezone": {
        "name": timeZoneName,
        "databaseName": timeZoneDatabaseName,
        "offsetInHours": timeZoneOffset.inHours,
        "offsetIsNegative": timeZoneOffset.isNegative,
      },
      // Package
      UserFirestoreFieldKeys.packageInfo: package.toJson(),

      // UserIDs
      UserFirestoreFieldKeys.userDocumentIDSets: userDocumentIDSets,
      UserFirestoreFieldKeys.firebaseCurrentUserIDSets: firebaseCurrentUserIDSets,
      UserFirestoreFieldKeys.anonymousUserIDSets: anonymousUserIDSets,
    }, SetOptions(merge: true));
  }

  // NOTE: 下位互換のために一時的にhasDiscountEntitlementをtrueにしていくスクリプト。
  // サーバー側での制御が無駄になるけど、理屈ではこれで生合成が取れる
  Future<void> _temporarySyncronizeDiscountEntitlement(User user) async {
    final discountEntitlementDeadlineDate = user.discountEntitlementDeadlineDate;
    final bool hasDiscountEntitlement;
    if (discountEntitlementDeadlineDate == null) {
      hasDiscountEntitlement = true;
    } else {
      hasDiscountEntitlement = !now().isAfter(discountEntitlementDeadlineDate);
    }
    return databaseConnection.userRawReference().set({
      UserFirestoreFieldKeys.hasDiscountEntitlement: hasDiscountEntitlement,
    }, SetOptions(merge: true));
  }
}

final endInitialSettingProvider = Provider((ref) => EndInitialSetting(ref.watch(databaseProvider)));

class EndInitialSetting {
  final DatabaseConnection databaseConnection;
  EndInitialSetting(this.databaseConnection);

  Future<void> call(Setting setting) {
    final settingForTrial = setting.copyWith(
      pillSheetAppearanceMode: PillSheetAppearanceMode.date,
      isAutomaticallyCreatePillSheet: true,
    );

    return databaseConnection.userRawReference().set({
      UserFirestoreFieldKeys.isTrial: true,
      UserFirestoreFieldKeys.beginTrialDate: now(),
      UserFirestoreFieldKeys.trialDeadlineDate: now().add(const Duration(days: 30)),
      UserFirestoreFieldKeys.settings: settingForTrial.toJson(),
      UserFirestoreFieldKeys.hasDiscountEntitlement: true,
      UserFirestoreFieldKeys.useLocalNotificationForReminder: true,
    }, SetOptions(merge: true));
  }
}

// TODO: [UseLocalNotification-Beta] 2023-11 不要になったら削除
final updateUseLocalNotificationProvider = Provider((ref) => UpdateUseLocalNotification(databaseConnection: ref.watch(databaseProvider)));

class UpdateUseLocalNotification {
  final DatabaseConnection databaseConnection;
  UpdateUseLocalNotification({required this.databaseConnection});

  Future<void> call(User user, bool value) async {
    final updated = user.copyWith(useLocalNotificationForReminder: value);
    await databaseConnection.userReference().update(updated.toJson());
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
