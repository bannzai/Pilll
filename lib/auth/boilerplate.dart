import 'package:firebase_auth/firebase_auth.dart';
import 'package:pilll/auth/exception.dart';
import 'package:pilll/entity/link_account_type.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/database/user.dart';
import 'package:pilll/auth/apple.dart';
import 'package:pilll/auth/google.dart';

Future<SignInWithAppleState> callLinkWithApple(UserDatabase userService) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw AssertionError("Required Firebase user");
  }
  try {
    final credential = await linkWithApple(user);
    if (credential == null) {
      return Future.value(SignInWithAppleState.cancel);
    }
    final email = credential.email;
    assert(email != null);
    await userService.linkApple(email);

    return Future.value(SignInWithAppleState.determined);
  } on FirebaseAuthException catch (error, stackTrace) {
    errorLogger.recordError(error, stackTrace);
    print(
        "FirebaseAuthException $error, code: ${error.code}, stack: ${stackTrace.toString()}");
    final mappedException =
        mapFromFirebaseAuthException(error, LinkAccountType.apple);
    if (mappedException != null) {
      throw mappedException;
    }
    rethrow;
  } catch (error, stack) {
    print("$error, ${StackTrace.current.toString()}");
    errorLogger.recordError(error, stack);
    rethrow;
  }
}

Future<SignInWithGoogleState> callLinkWithGoogle(
    UserDatabase userService) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw AssertionError("Required Firebase user");
  }
  try {
    final credential = await linkWithGoogle(user);
    if (credential == null) {
      return Future.value(SignInWithGoogleState.cancel);
    }

    final email = credential.email;
    assert(email != null);
    await userService.linkGoogle(email);

    return Future.value(SignInWithGoogleState.determined);
  } on FirebaseAuthException catch (error, stackTrace) {
    errorLogger.recordError(error, stackTrace);
    print(
        "FirebaseAuthException $error, code: ${error.code}, stack: ${stackTrace.toString()}");
    final mappedException =
        mapFromFirebaseAuthException(error, LinkAccountType.google);
    if (mappedException != null) {
      throw mappedException;
    }
    rethrow;
  } catch (error, stack) {
    print("$error, ${StackTrace.current.toString()}");
    errorLogger.recordError(error, stack);
    rethrow;
  }
}
