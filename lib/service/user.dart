import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:pilll/database/database.dart';
import 'package:pilll/entity/demographic.dart';
import 'package:pilll/entity/package.dart';
import 'package:pilll/entity/user.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info/package_info.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userServiceProvider =
    Provider((ref) => UserService(ref.watch(databaseProvider)));

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
      return User.fromJson(document.data()!);
    });
  }

  Future<DocumentSnapshot> _fetchRawDocumentSnapshot() {
    return _database.userReference().get();
  }

  recordUserIDs() {
    Future(() async {
      try {
        final document = await _fetchRawDocumentSnapshot();
        final user = User.fromJson(document.data()!);
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

  Future<User> subscribe() {
    return _database
        .userReference()
        .snapshots(includeMetadataChanges: true)
        .listen((event) => User.fromJson(event.data()!))
        .asFuture();
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

  Future<void> saveStats() {
    return SharedPreferences.getInstance().then((store) async {
      String? beginingVersion = store.getString(StringKey.beginingVersionKey);
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
}
