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

    final anonymousUserCredential = await FirebaseAuth.instance.signInAnonymously();
    analytics.logEvent(name: "signin_anonymously", parameters: _logginParameters(anonymousUserCredential.user));

    final sharedPreferences = await SharedPreferences.getInstance();
    final existsUID = sharedPreferences.getString(StringKey.lastSignInAnonymousUID);
    if (existsUID == null || existsUID.isEmpty) {
      final user = anonymousUserCredential.user;
      if (user != null) {
        await sharedPreferences.setString(StringKey.lastSignInAnonymousUID, user.uid);
      }
    }

    return anonymousUserCredential.user!;
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
