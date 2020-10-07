import 'package:Pilll/model/app_state.dart';
import 'package:Pilll/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

abstract class UserRepositoryInterface {
  Future<User> fetchOrCreateUser();
  Future<User> fetch();
  Future<User> subscribe();
}

class UserRepository extends UserRepositoryInterface {
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
    return FirebaseFirestore.instance
        .collection(User.path)
        .doc(auth.FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((document) {
      if (!document.exists) {
        throw UserNotFound();
      }
      var user = User.map(document.data());
      AppState.shared.user = user;
      return user;
    });
  }

  Future<User> subscribe() {
    return FirebaseFirestore.instance
        .collection(User.path)
        .doc(auth.FirebaseAuth.instance.currentUser.uid)
        .snapshots(includeMetadataChanges: true)
        .listen((event) {
      return User.map(event.data());
    }).asFuture();
  }

  Future<void> _create() {
    assert(!AppState.shared.userIsExists,
        "user already exists on process. maybe you will call fetch before create");
    if (AppState.shared.userIsExists) throw UserAlreadyExists();
    return FirebaseFirestore.instance
        .collection(User.path)
        .doc(auth.FirebaseAuth.instance.currentUser.uid)
        .set(
      {
        UserFirestoreFieldKeys.anonymouseUserID:
            auth.FirebaseAuth.instance.currentUser.uid,
      },
    );
  }
}

final UserRepositoryInterface userRepository = UserRepository();
