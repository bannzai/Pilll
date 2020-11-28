import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';

class AuthInfo {
  final String uid;

  AuthInfo(this.uid);
}

final authStateChangesProvider = StreamProvider<AuthInfo>((ref) => FirebaseAuth
    .instance
    .authStateChanges()
    .map((event) => AuthInfo(event.uid)));

Future<AuthInfo> auth() => FirebaseAuth.instance
    .signInAnonymously()
    .then((value) => AuthInfo(value.user.uid));
