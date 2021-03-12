import 'dart:io';

import 'package:pilll/analytics.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/entity/package.dart';
import 'package:pilll/entity/user.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:package_info/package_info.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserServiceInterface {
  Future<User> prepare();
  Future<User> fetch();
  Future<User> subscribe();
  Future<void> deleteSettings();
  Future<void> setFlutterMigrationFlag();
  Future<void> registerRemoteNotificationToken(String token);
  Future<void> saveLaunchInfo();
  Future<void> saveStats();
}

final userServiceProvider =
    Provider((ref) => UserService(ref.watch(databaseProvider)));
final initialUserProvider =
    FutureProvider((ref) => ref.watch(userServiceProvider).prepare());

class UserService extends UserServiceInterface {
  final DatabaseConnection _database;
  UserService(this._database);

  Future<User> prepare() async {
    final user = await fetch().catchError((error) {
      if (error is UserNotFound) {
        return _create().then((_) => fetch());
      }
      throw FormatException(
          "cause exception when failed fetch and create user for $error");
    });
    errorLogger.setUserIdentifier(auth.FirebaseAuth.instance.currentUser.uid);
    firebaseAnalytics.setUserId(auth.FirebaseAuth.instance.currentUser.uid);
    return user;
  }

  Future<User> fetch() {
    return _database.userReference().get().then((document) {
      if (!document.exists) {
        throw UserNotFound();
      }
      return User.fromJson(document.data());
    });
  }

  Future<User> subscribe() {
    return _database
        .userReference()
        .snapshots(includeMetadataChanges: true)
        .listen((event) {
      return User.fromJson(event.data());
    }).asFuture();
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

  Future<void> _create() {
    return _database.userReference().set(
      {
        UserFirestoreFieldKeys.anonymouseUserID:
            auth.FirebaseAuth.instance.currentUser.uid,
      },
      SetOptions(merge: true),
    );
  }

  Future<void> registerRemoteNotificationToken(String token) {
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

  Future<void> saveStats() {
    return SharedPreferences.getInstance().then((store) async {
      String beginingVersion = store.getString(StringKey.beginingVersionKey);
      if (beginingVersion == null) {
        final v =
            await PackageInfo.fromPlatform().then((value) => value.version);
        await store.setString(StringKey.beginingVersionKey, v);
        return v;
      }
      return beginingVersion;
    }).then((version) {
      return _database.userReference().set({
        "stats": {
          "lastLoginAt": DateTime.now(),
          "beginingVersion": version,
        }
      }, SetOptions(merge: true));
    });
  }
}
