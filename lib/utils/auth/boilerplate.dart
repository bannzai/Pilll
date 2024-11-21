import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:pilll/utils/auth/exception.dart';
import 'package:pilll/entity/link_account_type.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/auth/apple.dart';
import 'package:pilll/utils/auth/google.dart';

Future<SignInWithAppleState> callLinkWithApple(LinkApple linkApple) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw AssertionError("Required Firebase user");
  }
  try {
    final credential = await linkWithApple(user);
    if (credential == null) {
      return Future.value(SignInWithAppleState.cancel);
    }
    await linkApple();

    return Future.value(SignInWithAppleState.determined);
  } on FirebaseAuthException catch (error, stackTrace) {
    errorLogger.recordError(error, stackTrace);
    debugPrint("FirebaseAuthException $error, code: ${error.code}, stack: ${stackTrace.toString()}");
    final mappedException = mapFromFirebaseAuthException(error, LinkAccountType.apple);
    if (mappedException != null) {
      throw mappedException;
    }
    rethrow;
  } catch (error, stack) {
    debugPrint("$error, ${StackTrace.current.toString()}");
    errorLogger.recordError(error, stack);
    rethrow;
  }
}

Future<SignInWithGoogleState> callLinkWithGoogle(LinkGoogle linkGoogle) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw AssertionError("Required Firebase user");
  }
  try {
    final credential = await linkWithGoogle(user);
    if (credential == null) {
      return Future.value(SignInWithGoogleState.cancel);
    }

    await linkGoogle();

    return Future.value(SignInWithGoogleState.determined);
  } on FirebaseAuthException catch (error, stackTrace) {
    errorLogger.recordError(error, stackTrace);
    debugPrint("FirebaseAuthException $error, code: ${error.code}, stack: ${stackTrace.toString()}");
    final mappedException = mapFromFirebaseAuthException(error, LinkAccountType.google);
    if (mappedException != null) {
      throw mappedException;
    }
    rethrow;
  } catch (error, stack) {
    debugPrint("$error, ${StackTrace.current.toString()}");
    errorLogger.recordError(error, stack);
    rethrow;
  }
}
