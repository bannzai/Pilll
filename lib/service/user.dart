import 'package:Pilll/analytics.dart';
import 'package:Pilll/database/database.dart';
import 'package:Pilll/entity/user.dart';
import 'package:Pilll/error_log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:riverpod/all.dart';

abstract class UserServiceInterface {
  Future<User> prepare();
  Future<User> fetch();
  Future<User> subscribe();
  Future<void> deleteSettings();
  Future<void> setFlutterMigrationFlag();
  Future<void> registerRemoteNotificationToken(String token);
}

final userServiceProvider =
    Provider((ref) => UserService(ref.watch(databaseProvider)));
final initialUserProvider =
    FutureProvider((ref) => ref.watch(userServiceProvider).prepare());

class UserService extends UserServiceInterface {
  final DatabaseConnection _database;
  UserService(this._database);

  Future<User> prepare() {
    return fetch().catchError((error) {
      if (error is UserNotFound) {
        return _create().then((_) => fetch());
      }
      throw FormatException(
          "cause exception when failed fetch and create user for $error");
    });
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
    return _database
        .userReference()
        .set(
          {
            UserFirestoreFieldKeys.anonymouseUserID:
                auth.FirebaseAuth.instance.currentUser.uid,
          },
          SetOptions(merge: true),
        )
        .then((_) => errorLogger
            .setUserIdentifier(auth.FirebaseAuth.instance.currentUser.uid))
        .then((_) =>
            analytics.setUserId(auth.FirebaseAuth.instance.currentUser.uid));
  }

  Future<void> registerRemoteNotificationToken(String token) {
    print("token: $token");
    return _database.userPrivateReference().set(
      {UserPrivateFirestoreFieldKeys.fcmToken: token},
      SetOptions(merge: true),
    );
  }
}
