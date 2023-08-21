import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/provider/auth.dart';

const googleProviderID = 'google.com';

enum SignInWithGoogleState { determined, cancel }

Future<UserCredential?> linkWithGoogle(User user) async {
  try {
    final provider = GoogleAuthProvider();
    return await user.linkWithProvider(provider);
  } on FirebaseAuthException catch (e) {
    // sign-in-failed という code で返ってくるが、コードを読んでると該当するエラーが多かったので実際にdumpしてみたメッセージでマッチしている
    // Appleのcodeとは違うので注意
    if (e.toString().contains('The interaction was cancelled by the user')) {
      return Future.value(null);
    }
    rethrow;
  }
}

Future<UserCredential?> signInWithGoogle() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw const FormatException("Anonymous User not found");
    }
    final provider = GoogleAuthProvider().addScope('email');
    return await FirebaseAuth.instance.signInWithProvider(provider);
  } on FirebaseAuthException catch (e) {
    // sign-in-failed という code で返ってくるが、コードを読んでると該当するエラーが多かったので実際にdumpしてみたメッセージでマッチしている
    // Appleのcodeとは違うので注意
    if (e.toString().contains('The interaction was cancelled by the user')) {
      return Future.value(null);
    }
    rethrow;
  }
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

Future<void> googleReauthentification() async {
  try {
    final provider = GoogleAuthProvider();
    await FirebaseAuth.instance.currentUser?.reauthenticateWithProvider(provider);
  } on FirebaseAuthException catch (e) {
    // sign-in-failed という code で返ってくるが、コードを読んでると該当するエラーが多かったので実際にdumpしてみたメッセージでマッチしている
    // Appleのcodeとは違うので注意
    if (e.toString().contains('The interaction was cancelled by the user')) {
      return;
    }
    rethrow;
  }
}
