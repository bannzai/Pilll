import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/auth/apple.dart';
import 'package:pilll/utils/auth/google.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final firebaseUserStateProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.userChanges(),
);

final firebaseSignInProvider = FutureProvider<User>((ref) async {
  analytics.logEvent(name: "current_user_provider");
  final currentUser = FirebaseAuth.instance.currentUser;

  analytics.logEvent(
    name: "current_user_fetched",
    parameters: _logginParameters(currentUser),
  );

  if (currentUser != null) {
    analytics.logEvent(name: "cached_current_user_exists", parameters: _logginParameters(currentUser));
    return currentUser;
  } else {
    analytics.logEvent(name: "cached_current_user_not_exists");

    // keep until FirebaseAuth.instance user state updated
    final waitLatestChangedOptionalUser = Future<User?>(() {
      final completer = Completer<User?>();

      StreamSubscription<User?>? subscription;
      subscription = FirebaseAuth.instance.userChanges().listen((firebaseUser) {
        completer.complete(firebaseUser);
        subscription?.cancel();
      });
      return completer.future;
    });

    final obtainedUser = await waitLatestChangedOptionalUser;
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
    final waitLatestChangedUser = Future<User>(() {
      final completer = Completer<User>();
      final Stream<User> nonOptionalStream = FirebaseAuth.instance.userChanges().where((event) => event != null).cast();

      StreamSubscription<User>? subscription;
      subscription = nonOptionalStream.listen((firebaseUser) {
        completer.complete(firebaseUser);
        subscription?.cancel();
      });
      return completer.future;
    });

    final User signedUser = await waitLatestChangedUser;
    assert(anonymousUser.user?.uid == signedUser.uid);
    return signedUser;
  }
});

final isLinkedProvider = Provider((ref) => ref.watch(isAppleLinkedProvider) || ref.watch(isGoogleLinkedProvider));

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
