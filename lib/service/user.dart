import 'package:Pilll/database/database.dart';
import 'package:Pilll/model/app_state.dart';
import 'package:Pilll/model/user.dart';
import 'package:Pilll/provider/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:riverpod/all.dart';

abstract class UserServiceInterface {
  Future<User> fetchOrCreateUser();
  Future<User> fetch();
  Future<User> subscribe();
}

final userServiceProvider = Provider((ref) => UserService(ref.read));

class UserService extends UserServiceInterface {
  final Reader reader;
  UserService(this.reader);

  DatabaseConnection get _database => reader(databaseProvider);

  @override
  Future<User> fetchOrCreateUser() {
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
      var user = User.map(document.data());
      AppState.shared.user = user;
      return user;
    });
  }

  Future<User> subscribe() {
    return _database
        .userReference()
        .snapshots(includeMetadataChanges: true)
        .listen((event) {
      print('user: ${event.data()})');
      return User.map(event.data());
    }).asFuture();
  }

  Future<void> _create() {
    assert(!AppState.shared.userIsExists,
        "user already exists on process. maybe you will call fetch before create");
    if (AppState.shared.userIsExists) throw UserAlreadyExists();
    return _database.userReference().set(
      {
        UserFirestoreFieldKeys.anonymouseUserID:
            auth.FirebaseAuth.instance.currentUser.uid,
      },
    );
  }
}

UserServiceInterface userRepository = UserService(null);
