import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/provider/auth.dart';

enum SignInWithAppleState { determined, cancel }

Future<UserCredential?> linkWithApple(User user) async {
  try {
    final provider = AppleAuthProvider();
    return await user.linkWithProvider(provider);
  } on FirebaseAuthException catch (e) {
    // canceled という code で返ってくるが、コードを読んでると該当するエラーが多かったので実際にdumpしてみたメッセージでマッチしている
    // Googleのcodeとは違うので注意
    if (e.toString().contains('The user canceled the authorization attempt')) {
      return Future.value(null);
    }
    rethrow;
  }
}

Future<UserCredential?> signInWithApple() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw const FormatException("Anonymous User not found");
    }
    final provider = AppleAuthProvider().addScope('email');
    return await FirebaseAuth.instance.signInWithProvider(provider);
  } on FirebaseAuthException catch (e) {
    // canceled という code で返ってくるが、コードを読んでると該当するエラーが多かったので実際にdumpしてみたメッセージでマッチしている
    // Googleのcodeとは違うので注意
    if (e.toString().contains('The user canceled the authorization attempt')) {
      return Future.value(null);
    }
    rethrow;
  }
}

final isAppleLinkedProvider = Provider((ref) {
  final user = ref.watch(firebaseUserStateProvider);
  final userValue = user.valueOrNull;
  if (userValue == null) {
    return false;
  }
  return isLinkedAppleFor(userValue);
});

bool isLinkedAppleFor(User user) {
  return user.providerData.where((element) => element.providerId == AppleAuthProvider.PROVIDER_ID).isNotEmpty;
}

Future<void> appleReauthentification() async {
  try {
    final provider = AppleAuthProvider();
    await FirebaseAuth.instance.currentUser?.reauthenticateWithProvider(provider);
  } on FirebaseAuthException catch (e) {
    // canceled という code で返ってくるが、コードを読んでると該当するエラーが多かったので実際にdumpしてみたメッセージでマッチしている
    // Googleのcodeとは違うので注意
    if (e.toString().contains('The user canceled the authorization attempt')) {
      return Future.value();
    }
    rethrow;
  }
}
