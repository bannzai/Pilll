import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';

final authServiceProvider = Provider(
  (ref) => AuthService(),
);

class AuthService {
  Stream<User?> subscribe() {
    return StreamGroup.merge([FirebaseAuth.instance.userChanges()]);
  }
}
