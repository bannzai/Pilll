import 'package:firebase_auth/firebase_auth.dart';
import 'package:pilll/entrypoint.dart';
import 'package:pilll/utils/environment.dart';

Future<void> main() async {
  Environment.flavor = Flavor.DEVELOP;
  Environment.deleteUser = () async {
    if (!Environment.isDevelopment) {
      throw AssertionError("This method should not call out of development");
    }
    await FirebaseAuth.instance.currentUser?.delete();
  };
  Environment.signOutUser = () async {
    if (!Environment.isDevelopment) {
      throw AssertionError("This method should not call out of development");
    }
    await FirebaseAuth.instance.signOut();
  };
  await entrypoint();
}
