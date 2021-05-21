import 'package:firebase_auth/firebase_auth.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:riverpod/riverpod.dart';
import 'package:pilll/auth/google.dart';
import 'package:pilll/auth/apple.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

Future<AuthInfo> auth() async {
  final currentUser = FirebaseAuth.instance.currentUser;
  analytics.logEvent(
    name: "current_user_fetched",
    parameters: _logginParameters(currentUser),
  );
  if (currentUser != null) {
    analytics.logEvent(
        name: "current_user_exists",
        parameters: _logginParameters(currentUser));
    final sharedPreferences = await SharedPreferences.getInstance();
    final existsUID = sharedPreferences.getString(StringKey.currentUserUID);
    if (existsUID == null || existsUID.isEmpty) {
      sharedPreferences.setString(StringKey.currentUserUID, currentUser.uid);
    }

    _authInfoCache = AuthInfo(currentUser.uid);
    return Future.value(_authInfoCache!);
  }
  final value = await FirebaseAuth.instance.signInAnonymously();
  analytics.logEvent(
      name: "signin_anonymously", parameters: _logginParameters(value.user));
  final sharedPreferences = await SharedPreferences.getInstance();
  final existsUID =
      sharedPreferences.getString(StringKey.lastSigninAnonymousUID);
  if (existsUID == null || existsUID.isEmpty) {
    final user = value.user;
    if (user != null) {
      sharedPreferences.setString(StringKey.lastSigninAnonymousUID, user.uid);
    }
  }

  _authInfoCache = AuthInfo(value.user!.uid);
  return _authInfoCache!;
}
