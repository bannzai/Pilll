import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/utils/auth/link_value_container.dart';
import 'package:pilll/provider/auth.dart';

const googleProviderID = 'google.com';

enum SignInWithGoogleState { determined, cancel }

Future<LinkValueContainer?> linkWithGoogle(User user) async {
  final provider = GoogleAuthProvider()..addScope('email');
  final linkedCredential = await user.linkWithProvider(provider);
  return Future.value(LinkValueContainer(linkedCredential, linkedCredential.user?.email));
}

Future<UserCredential?> signInWithGoogle() async {
  final provider = GoogleAuthProvider()..addScope('email');
  return await FirebaseAuth.instance.signInWithProvider(provider);
}

final isGoogleLinkedProvider = Provider((ref) {
  final user = ref.watch(firebaseUserStateProvider);
  final userValue = user.valueOrNull;
  if (userValue == null) {
    return false;
  }
  return isLinkedGoogleFor(userValue);
});

bool isLinkedGoogleFor(User user) {
  return user.providerData.where((element) => element.providerId == GoogleAuthProvider.PROVIDER_ID).isNotEmpty;
}

Future<bool> googleReauthentification() async {
  final provider = GoogleAuthProvider();
  await FirebaseAuth.instance.currentUser?.reauthenticateWithProvider(provider);
  return true;
}
