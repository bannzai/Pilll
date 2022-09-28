import 'dart:async';
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
  (ref) => _userAuthStateChanges().where((event) => event != null).cast(),
);

final isLinkedProvider = Provider((ref) => apple.isLinkedApple() || google.isLinkedGoogle());

class AuthService {
  // 退会時は一時的にnullになる。なのでOptional型のこのstreamを使う
  Stream<User?> optionalStream() {
    return _userAuthStateChanges();
  }

  Stream<User> stream() {
    return _userAuthStateChanges().where((event) => event != null).cast();
  }

  bool isLinkedApple() {
    return apple.isLinkedApple();
  }

  bool isLinkedGoogle() {
    return google.isLinkedGoogle();
  }
}

Stream<User?> _userAuthStateChanges() {
  return FirebaseAuth.instance.userChanges();
}

// Obtain the latest users form FirebaseAuth.
// If it is not exists:
//   -> wait userAuthStateChanges stream complete that firebase auth setup complete:
//     -> return result of signin anonymous;
Future<User> cachedUserOrSignInAnonymously() async {
  analytics.logEvent(name: "call_sign_in");
  final currentUser = FirebaseAuth.instance.currentUser;

  analytics.logEvent(
    name: "current_user_fetched",
    parameters: _logginParameters(currentUser),
  );

  if (currentUser != null) {
    analytics.logEvent(name: "cached_current_user_exists", parameters: _logginParameters(currentUser));

    final sharedPreferences = await SharedPreferences.getInstance();
    final existsUID = sharedPreferences.getString(StringKey.currentUserUID);
    if (existsUID == null || existsUID.isEmpty) {
      sharedPreferences.setString(StringKey.currentUserUID, currentUser.uid);
    }

    return currentUser;
  } else {
    analytics.logEvent(name: "cached_current_user_not_exists");

    // keep until FirebaseAuth.instance user state updated
    final obtainLatestChangedOptionalUserState = Future<User?>(() {
      final completer = Completer<User?>();

      StreamSubscription<User?>? subscription;
      subscription = _userAuthStateChanges().listen((firebaseUser) {
        completer.complete(firebaseUser);
        subscription?.cancel();
      });
      return completer.future;
    });

    final obtainedUser = await obtainLatestChangedOptionalUserState;
    if (obtainedUser != null) {
      analytics.logEvent(
        name: "obtained_current_user_exists",
        parameters: _logginParameters(obtainedUser),
      );
      return obtainedUser;
    }

    final anonymousUser = await FirebaseAuth.instance.signInAnonymously();
    analytics.logEvent(name: "signin_anonymously", parameters: _logginParameters(anonymousUser.user));

    final sharedPreferences = await SharedPreferences.getInstance();
    final existsUID = sharedPreferences.getString(StringKey.lastSignInAnonymousUID);
    if (existsUID == null || existsUID.isEmpty) {
      final user = anonymousUser.user;
      if (user != null) {
        await sharedPreferences.setString(StringKey.lastSignInAnonymousUID, user.uid);
      }
    }

    // keep until FirebaseAuth.instance user state updated
    final obtainLatestChangedUserState = Future<User>(() {
      final completer = Completer<User>();
      final Stream<User> nonOptionalStream = _userAuthStateChanges().where((event) => event != null).cast();

      StreamSubscription<User>? subscription;
      subscription = nonOptionalStream.listen((firebaseUser) {
        completer.complete(firebaseUser);
        subscription?.cancel();
      });
      return completer.future;
    });

    final User signedUser = await obtainLatestChangedUserState;
    assert(anonymousUser.user?.uid == signedUser.uid);
    return signedUser;
  }
}

Map<String, dynamic> _logginParameters(User? currentUser) {
  if (currentUser == null) {
    return {};
  }

  return {
    "uid": currentUser.uid,
    "isAnonymous": currentUser.isAnonymous,
    "hasGoogleProviderData": currentUser.providerData.where((element) => element.providerId == googleProviderID).isNotEmpty,
    "hasAppleProviderData": currentUser.providerData.where((element) => element.providerId == appleProviderID).isNotEmpty,
  };
}
