import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:pilll/database/database.dart';
import 'package:pilll/entity/demographic.dart';
import 'package:pilll/entity/package.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/entity/user.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info/package_info.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userServiceProvider =
    Provider((ref) => UserService(ref.watch(databaseProvider)));

final premiumStateStreamProvider = StreamProvider(
    (ref) => UserService(ref.watch(databaseProvider)).subscribe());

class UserService {
  final DatabaseConnection _database;
  UserService(this._database);

  Future<User> prepare(String uid) async {
    print("call prepare for $uid");
    final user = await fetch().catchError((error) {
      if (error is UserNotFound) {
        return _create(uid).then((_) => fetch());
      }
      throw FormatException(
          "cause exception when failed fetch and create user for $error, stackTrace: ${StackTrace.current.toString()}");
    });
    return user;
  }

  Future<User> fetch() {
    print("call fetch");
    return _database.userReference().get().then((document) {
      if (!document.exists) {
        throw UserNotFound();
      }
      print("fetched user ${document.data()}");
      return User.fromJson(document.data() as Map<String, dynamic>);
    });
  }

  Future<DocumentSnapshot> _fetchRawDocumentSnapshot() {
    return _database.userReference().get();
  }

  recordUserIDs() {
    Future(() async {
      try {
        final document = await _fetchRawDocumentSnapshot();
        final user = User.fromJson(document.data() as Map<String, dynamic>);
        final documentID = document.id;
        if (!user.userDocumentIDSets.contains(documentID)) {
          user.userDocumentIDSets.add(documentID);
        }

        final sharedPreferences = await SharedPreferences.getInstance();
        final lastSigninAnonymousUID =
            sharedPreferences.getString(StringKey.lastSigninAnonymousUID);
        if (lastSigninAnonymousUID != null &&
            !user.anonymousUserIDSets.contains(lastSigninAnonymousUID)) {
          user.anonymousUserIDSets.add(lastSigninAnonymousUID);
        }
        final firebaseCurrentUserID =
            firebaseAuth.FirebaseAuth.instance.currentUser?.uid;
        if (firebaseCurrentUserID != null &&
            !user.firebaseCurrentUserIDSets.contains(firebaseCurrentUserID)) {
          user.firebaseCurrentUserIDSets.add(firebaseCurrentUserID);
        }

        await _database.userReference().set(
              user.toJson(),
              SetOptions(merge: true),
            );
      } catch (error) {
        print(error);
      }
    });
  }

  Stream<User> subscribe() {
    return _database
        .userReference()
        .snapshots(includeMetadataChanges: true)
        .map((event) => User.fromJson(event.data() as Map<String, dynamic>));
  }

  Future<void> updatePurchaseInfo({
    required bool? isActivated,
    required String? entitlementIdentifier,
    required String? premiumPlanIdentifier,
    required String purchaseAppID,
    required List<String> activeSubscriptions,
    required String? originalPurchaseDate,
  }) async {
    await _database.userReference().set({
      if (isActivated != null) UserFirestoreFieldKeys.isPremium: isActivated,
      UserFirestoreFieldKeys.purchaseAppID: purchaseAppID
    }, SetOptions(merge: true));
    final privates = {
      if (premiumPlanIdentifier != null)
        UserPrivateFirestoreFieldKeys.latestPremiumPlanIdentifier:
            premiumPlanIdentifier,
      if (originalPurchaseDate != null)
        UserPrivateFirestoreFieldKeys.originalPurchaseDate:
            originalPurchaseDate,
      if (activeSubscriptions.isNotEmpty)
        UserPrivateFirestoreFieldKeys.activeSubscriptions: activeSubscriptions,
      if (entitlementIdentifier != null)
        UserPrivateFirestoreFieldKeys.entitlementIdentifier:
            entitlementIdentifier,
    };
    if (privates.isNotEmpty) {
      await _database
          .userPrivateReference()
          .set({...privates}, SetOptions(merge: true));
    }
  }

  Future<void> syncPurchaseInfo({
    required bool isActivated,
  }) async {
    await _database.userReference().set({
      UserFirestoreFieldKeys.isPremium: isActivated,
    }, SetOptions(merge: true));
  }

  Future<void> deleteSettings() {
    return _database
        .userReference()
        .update({UserFirestoreFieldKeys.settings: FieldValue.delete()});
  }

  Future<void> setFlutterMigrationFlag() {
    return _database.userReference().set(
      {UserFirestoreFieldKeys.migratedFlutter: true},
      SetOptions(merge: true),
    );
  }

  Future<void> _create(String uid) async {
    print("call create for $uid");
    final sharedPreferences = await SharedPreferences.getInstance();
    final anonymousUserID =
        sharedPreferences.getString(StringKey.lastSigninAnonymousUID);
    return _database.userReference().set(
      {
        if (anonymousUserID != null)
          UserFirestoreFieldKeys.anonymousUserID: anonymousUserID,
        UserFirestoreFieldKeys.userIDWhenCreateUser: uid,
      },
      SetOptions(merge: true),
    );
  }

  Future<void> registerRemoteNotificationToken(String? token) {
    print("token: $token");
    return _database.userPrivateReference().set(
      {UserPrivateFirestoreFieldKeys.fcmToken: token},
      SetOptions(merge: true),
    );
  }

  Future<void> saveLaunchInfo() {
    final os = Platform.operatingSystem;
    return PackageInfo.fromPlatform().then((info) {
      final packageInfo = Package(
          latestOS: os,
          appName: info.appName,
          buildNumber: info.buildNumber,
          appVersion: info.version);
      return _database.userReference().set(
          {UserFirestoreFieldKeys.packageInfo: packageInfo.toJson()},
          SetOptions(merge: true));
    });
  }

  Future<void> saveStats() async {
    final store = await SharedPreferences.getInstance();
    String? beginingVersion = store.getString(StringKey.beginingVersionKey);
    if (beginingVersion == null) {
      final v = await PackageInfo.fromPlatform().then((value) => value.version);
      await store.setString(StringKey.beginingVersionKey, v);
      beginingVersion = v;
    }

    final now = DateTime.now();
    final timeZoneName = now.timeZoneName;
    final timeZoneOffset = now.timeZoneOffset;

    return _database.userReference().set({
      "stats": {
        "lastLoginAt": now,
        "beginingVersion": beginingVersion,
        "timeZoneName": timeZoneName,
        "timeZoneOffset":
            "${timeZoneOffset.isNegative ? "-" : "+"}${timeZoneOffset.inHours}",
      }
    }, SetOptions(merge: true));
  }

  Future<void> linkApple(String? email) async {
    await _database.userReference().set({
      UserFirestoreFieldKeys.isAnonymous: false,
    }, SetOptions(merge: true));
    return _database.userPrivateReference().set({
      if (email != null) UserPrivateFirestoreFieldKeys.appleEmail: email,
      UserPrivateFirestoreFieldKeys.isLinkedApple: true,
    }, SetOptions(merge: true));
  }

  Future<void> linkGoogle(String? email) async {
    await _database.userReference().set({
      UserFirestoreFieldKeys.isAnonymous: false,
    }, SetOptions(merge: true));
    return _database.userPrivateReference().set({
      if (email != null) UserPrivateFirestoreFieldKeys.googleEmail: email,
      UserPrivateFirestoreFieldKeys.isLinkedGoogle: true,
    }, SetOptions(merge: true));
  }

  Future<void> postDemographic(Demographic demographic) {
    return _database.userPrivateReference().set(
        {UserPrivateFirestoreFieldKeys.demographic: demographic.toJson()},
        SetOptions(merge: true));
  }

  Future<void> trial(Setting setting) {
    return _database.userReference().set({
      UserFirestoreFieldKeys.isTrial: true,
      UserFirestoreFieldKeys.beginTrialDate: now(),
      UserFirestoreFieldKeys.trialDeadlineDate: now().add(Duration(days: 30)),
      UserFirestoreFieldKeys.settings: setting.toJson(),
    }, SetOptions(merge: true));
  }
}
