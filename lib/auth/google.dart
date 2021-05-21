import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleProviderID = 'google.com';

enum SigninWithGoogleState { determined, cancel }

Future<UserCredential?> linkWithGoogle(User user) async {
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

  return await user.linkWithCredential(credential);
}

Future<User?> unlinkGoogle() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw FormatException("firebase user is not found when unlink google");
  }
  return user.unlink(googleProviderID);
}

Future<UserCredential?> signInWithGoogle() async {
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
