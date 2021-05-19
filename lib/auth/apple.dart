import 'package:firebase_auth/firebase_auth.dart';
import 'package:pilll/auth/hash.dart';
import 'package:pilll/util/environment.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final _providerID = "apple.com";

enum SigninWithAppleState { determined, cancel }

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
    final credential = OAuthProvider(_providerID).credential(
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

Future<User?> unlinkApple() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw FormatException("firebase user is not found when unlink apple");
  }
  return user.unlink(_providerID);
}

Future<UserCredential?> signInWithApple() async {
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
    final credential = OAuthProvider(_providerID).credential(
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

bool isLinkedApple() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return false;
  }
  return isLinkedAppleFor(user);
}

bool isLinkedAppleFor(User user) {
  return user.providerData
      .where((element) => element.providerId == _providerID)
      .isNotEmpty;
}
