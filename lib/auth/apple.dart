import 'package:firebase_auth/firebase_auth.dart';
import 'package:pilll/auth/util.dart';
import 'package:pilll/util/environment.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

Future<UserCredential?> linkWithApple(User user) async {
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
    print("appleCredential: $appleCredential");
    if (state != appleCredential.state) {
      throw AssertionError('state not matched!');
    }
    final credential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
      rawNonce: rawNonce,
    );
    return await user.linkWithCredential(credential);
  } on SignInWithAppleAuthorizationException catch (e) {
    if (e.code == AuthorizationErrorCode.canceled) {
      return Future.value(null);
    }
    rethrow;
  }
}
