import 'package:firebase_auth/firebase_auth.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/auth/apple.dart';
import 'package:pilll/auth/google.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pilll/auth/apple.dart' as apple;
import 'package:pilll/auth/google.dart' as google;

final authServiceProvider = Provider(
  (ref) => AuthService(),
);

final authStateStreamProvider = StreamProvider<User>(
  (ref) => _subscribe().where((event) => event != null).cast(),
);

class AuthService {
  // 退会時は一時的にnullになる。なのでOptional型のこのstreamを使う
  Stream<User?> optionalStream() {
    return _subscribe();
  }

  Stream<User> stream() {
    return optionalStream().where((event) => event != null).cast();
  }

  bool isLinkedApple() {
    return apple.isLinkedApple();
  }

  bool isLinkedGoogle() {
    return google.isLinkedGoogle();
  }
}

class AuthInfo {
  final String uid;

  AuthInfo(this.uid);
}

Stream<User?> _subscribe() {
  return FirebaseAuth.instance.userChanges();
}

Future<User?> signIn() async {
  return _cacheOrAuth();
}

Future<AuthInfo> cacheOrAuth() async {
  return _cacheOrAuth().then((value) => AuthInfo(value!.uid));
}

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

Future<User?> _cacheOrAuth() async {
  final currentUser = await FirebaseAuth.instance.userChanges().last;

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

    return currentUser;
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
      await sharedPreferences.setString(
          StringKey.lastSigninAnonymousUID, user.uid);
    }
  }

  return value.user;
}
