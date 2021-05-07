import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<UserCredential?> signInWithGoogle(User user) async {
  final googleUser = await GoogleSignIn().signIn();

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
