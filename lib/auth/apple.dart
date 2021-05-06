import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nonce/nonce.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

Future<UserCredential?> siwa(User user) async {
  try {
    final rawNonce = Nonce.generate();
    final state = Nonce.generate();
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: String.fromEnvironment("SIWA_SERVICE_IDENTIFIIER"),
        redirectUri: Uri.parse(
          String.fromEnvironment('ANDROID_SIWA_REDIRECT_URL'),
        ),
      ),
      nonce: sha256.convert(utf8.encode(rawNonce)).toString(),
      state: state,
    );
    print(appleCredential);
    if (state != appleCredential.state) {
      throw AssertionError('state not matched!');
    }
    final credential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
      rawNonce: rawNonce,
    );
    final userCredential = await user.linkWithCredential(credential);
    return Future.value(userCredential);
  } on SignInWithAppleAuthorizationException catch (e) {
    if (e.code == AuthorizationErrorCode.canceled) {
      return Future.value(null);
    }
    rethrow;
  }
}
