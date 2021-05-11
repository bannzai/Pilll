import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final _providerID = 'google.com';

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
  return user.providerData
      .where((element) => element.providerId == _providerID)
      .isNotEmpty;
}
