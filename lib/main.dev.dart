import 'package:firebase_auth/firebase_auth.dart';
import 'package:pilll/entrypoint.dart';
import 'package:pilll/util/environment.dart';

Future<void> main() async {
  Environment.flavor = Flavor.DEVELOP;
  Environment.deleteUser = () async {
    if (!Environment.isDevelopment) {
      throw AssertionError("This method should not call out of development");
    }
    final currentUser = FirebaseAuth.instance.currentUser;
    await FirebaseAuth.instance.signOut();
    await currentUser?.delete();
  };
  await entrypoint();
}
