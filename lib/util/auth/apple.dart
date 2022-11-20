import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/util/auth/hash.dart';
import 'package:pilll/util/auth/link_value_container.dart';
import 'package:pilll/provider/auth.dart';
import 'package:pilll/util/environment.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

const appleProviderID = "apple.com";

enum SignInWithAppleState { determined, cancel }

Future<LinkValueContainer?> linkWithApple(User user) async {
  try {
    final rawNonce = generateNonce();
    final state = generateNonce();
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [AppleIDAuthorizationScopes.email],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: Environment.siwaServiceIdentifier,
        redirectUri: Uri.parse(Environment.androidSiwaRedirectURL),
      ),
      nonce: sha256ofString(rawNonce).toString(),
      state: state,
    );
    debugPrint("appleCredential: $appleCredential");
    if (state != appleCredential.state) {
      throw AssertionError('state not matched!');
    }
    final email = appleCredential.email;
    final credential = OAuthProvider(appleProviderID).credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
      rawNonce: rawNonce,
    );
    final linkedCredential = await user.linkWithCredential(credential);
    return Future.value(LinkValueContainer(linkedCredential, email));
  } on SignInWithAppleAuthorizationException catch (e) {
    if (e.code == AuthorizationErrorCode.canceled) {
      return Future.value(null);
    }
    rethrow;
  }
}

Future<UserCredential?> signInWithApple() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw const FormatException("Anonymous User not found");
  }
  try {
    final rawNonce = generateNonce();
    final state = generateNonce();
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [AppleIDAuthorizationScopes.email],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: Environment.siwaServiceIdentifier,
        redirectUri: Uri.parse(Environment.androidSiwaRedirectURL),
      ),
      nonce: sha256ofString(rawNonce).toString(),
      state: state,
    );
    debugPrint("appleCredential: $appleCredential");
    if (state != appleCredential.state) {
      throw AssertionError('state not matched!');
    }
    final credential = OAuthProvider(appleProviderID).credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
      rawNonce: rawNonce,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  } on SignInWithAppleAuthorizationException catch (e) {
    if (e.code == AuthorizationErrorCode.canceled) {
      return Future.value(null);
    }
    rethrow;
  }
}

final isAppleLinkedProvider = Provider((ref) {
  final user = ref.watch(authStateStreamProvider);
  final userValue = user.valueOrNull;
  if (userValue == null) {
    return false;
  }
  return isLinkedAppleFor(userValue);
});
// bool isLinkedApple() {
//   final user = FirebaseAuth.instance.currentUser;
//   if (user == null) {
//     return false;
//   }
//   return isLinkedAppleFor(user);
// }

bool isLinkedAppleFor(User user) {
  return user.providerData.where((element) => element.providerId == appleProviderID).isNotEmpty;
}

Future<bool> appleReauthentification() async {
  final rawNonce = generateNonce();
  final state = generateNonce();
  final appleCredential = await SignInWithApple.getAppleIDCredential(
    scopes: [AppleIDAuthorizationScopes.email],
    webAuthenticationOptions: WebAuthenticationOptions(
      clientId: Environment.siwaServiceIdentifier,
      redirectUri: Uri.parse(Environment.androidSiwaRedirectURL),
    ),
    nonce: sha256ofString(rawNonce).toString(),
    state: state,
  );
  debugPrint("appleCredential: $appleCredential");
  if (state != appleCredential.state) {
    throw AssertionError('state not matched!');
  }
  final credential = OAuthProvider(appleProviderID).credential(
    idToken: appleCredential.identityToken,
    accessToken: appleCredential.authorizationCode,
    rawNonce: rawNonce,
  );

  await FirebaseAuth.instance.currentUser?.reauthenticateWithCredential(credential);
  return true;
}
