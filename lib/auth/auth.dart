import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';

class AuthInfo {
  final String uid;

  AuthInfo(this.uid);
}

Future<AuthInfo> auth() => FirebaseAuth.instance
    .signInAnonymously()
    .then((value) => AuthInfo(value.user.uid));
final signInProvider = FutureProvider<AuthInfo>((ref) async {
  return auth();
});
