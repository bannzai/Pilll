import 'package:firebase_auth/firebase_auth.dart';
import 'package:pilll/auth/util.dart';
import 'package:pilll/service/user.dart';
import 'package:pilll/auth/apple.dart' as apple;
import 'package:pilll/auth/google.dart' as google;

Future<SigninWithAppleState> linkWithApple(UserService service) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw AssertionError("Required Firebase user");
  }
  try {
    final credential = await apple.linkWithApple(user);
    if (credential == null) {
      return Future.value(SigninWithAppleState.cancel);
    }
    final email = credential.user?.email;
    assert(email != null);

    service.linkApple(email ?? "");

    return Future.value(SigninWithAppleState.determined);
  } catch (error) {
    print("$error, ${StackTrace.current.toString()}");
    rethrow;
  }
}

Future<SigninWithGoogleState> linkWithGoogle(UserService service) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw AssertionError("Required Firebase user");
  }
  try {
    final credential = await google.linkWithGoogle(user);
    if (credential == null) {
      return Future.value(SigninWithGoogleState.cancel);
    }
    final email = credential.user?.email;
    assert(email != null);

    service.linkGoogle(email ?? "");

    return Future.value(SigninWithGoogleState.determined);
  } catch (error) {
    print("$error, ${StackTrace.current.toString()}");
    rethrow;
  }
}
