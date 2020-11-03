import 'package:Pilll/database/database.dart';
import 'package:Pilll/entity/user.dart';
import 'package:Pilll/auth/auth.dart/';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:riverpod/all.dart';

abstract class UserServiceInterface {
  Future<User> fetch();
  Future<User> subscribe();
}

final userServiceProvider =
    Provider((ref) => UserService(ref.watch(databaseProvider)));
final initialUserProvider =
    FutureProvider((ref) => ref.watch(userServiceProvider)._prepare());
// ignore: top_level_function_literal_block
final userProvider = Provider((ref) async {
  final user = await ref.watch(initialUserProvider.future);
  return user;
});

class UserService extends UserServiceInterface {
  final DatabaseConnection _database;
  UserService(this._database);

  Future<User> _prepare() {
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
    );
  }
}
