import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';

class AuthInfo {
  final String uid;

  AuthInfo(this.uid);
}

AuthInfo? _authInfoCache;
final authStateProvider = FutureProvider<AuthInfo>((ref) {
  if (_authInfoCache != null) {
    return Future.value(_authInfoCache);
  }
  return auth();
});

Future<AuthInfo> auth() {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid != null) {
    _authInfoCache = AuthInfo(uid);
    return Future.value(_authInfoCache!);
  }
  return FirebaseAuth.instance.signInAnonymously().then((value) {
    _authInfoCache = AuthInfo(value.user!.uid);
    return _authInfoCache!;
  });
}
