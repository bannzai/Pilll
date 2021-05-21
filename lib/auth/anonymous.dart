import 'package:firebase_auth/firebase_auth.dart';
import 'package:pilll/analytics.dart';
import 'package:riverpod/riverpod.dart';
import 'package:pilll/auth/google.dart';
import 'package:pilll/auth/apple.dart';

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

Map<String, dynamic> _logginParameters(User? currentUser) {
  return {
    "uid": currentUser?.uid,
    "isAnonymous": currentUser?.isAnonymous,
    "hasGoogleProviderData": currentUser?.providerData
        .where((element) => element.providerId == googleProviderID)
        .isNotEmpty,
    "hasAppleProviderData": currentUser?.providerData
        .where((element) => element.providerId == appleProviderID)
        .isNotEmpty,
  };
}

Future<AuthInfo> auth() {
  final currentUser = FirebaseAuth.instance.currentUser;
  analytics.logEvent(
    name: "current_user_fetched",
    parameters: _logginParameters(currentUser),
  );
  print("current user ${_logginParameters(currentUser)}");
  if (currentUser != null) {
    analytics.logEvent(
        name: "current_user_exists",
        parameters: _logginParameters(currentUser));
    _authInfoCache = AuthInfo(currentUser.uid);
    return Future.value(_authInfoCache!);
  }
  return FirebaseAuth.instance.signInAnonymously().then((value) {
    analytics.logEvent(
        name: "signin_anonymously", parameters: _logginParameters(value.user));
    print("signed in anonymous uid: ${_logginParameters(value.user)}");
    _authInfoCache = AuthInfo(value.user!.uid);
    return _authInfoCache!;
  });
}
