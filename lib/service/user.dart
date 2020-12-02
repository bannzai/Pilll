import 'package:Pilll/database/database.dart';
import 'package:Pilll/entity/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:riverpod/all.dart';

abstract class UserServiceInterface {
  Future<User> prepare();
  Future<User> fetch();
  Future<User> subscribe();
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
}
