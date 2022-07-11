import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pilll/auth/link_value_container.dart';

const googleProviderID = 'google.com';

enum SignInWithGoogleState { determined, cancel }

Future<LinkValueContainer?> linkWithGoogle(User user) async {
  // NOTE: workaround https://github.com/flutter/flutter/issues/44564#issuecomment-655884103
  final googleUser = await GoogleSignIn(
    scopes: [
      'email',
    ],
    hostedDomain: "",
  ).signIn();

  // NOTE: aborted
  if (googleUser == null) {
    return Future.value(null);
  }
  final email = googleUser.email;
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  final linkedCredential = await user.linkWithCredential(credential);
  return Future.value(LinkValueContainer(linkedCredential, email));
}

Future<UserCredential?> signInWithGoogle() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw const FormatException("Anonymous User not found");
  }
  // NOTE: workaround https://github.com/flutter/flutter/issues/44564#issuecomment-655884103
  final googleUser = await GoogleSignIn(
    scopes: [
      'email',
    ],
    hostedDomain: "",
  ).signIn();

  // NOTE: aborted
  if (googleUser == null) {
    return Future.value(null);
  }
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  return await FirebaseAuth.instance.signInWithCredential(credential);
}

bool isLinkedGoogle() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return false;
  }
  return isLinkedGoogleFor(user);
}

bool isLinkedGoogleFor(User user) {
  return user.providerData
      .where((element) => element.providerId == googleProviderID)
      .isNotEmpty;
}

Future<bool> googleReauthentification() async {
  // NOTE: workaround https://github.com/flutter/flutter/issues/44564#issuecomment-655884103
  final googleUser = await GoogleSignIn(
    scopes: [
      'email',
    ],
    hostedDomain: "",
  ).signIn();
  // NOTE: aborted
  if (googleUser == null) {
    return false;
  }

  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  await FirebaseAuth.instance.currentUser
      ?.reauthenticateWithCredential(credential);
  return true;
}
