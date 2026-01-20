import 'package:firebase_auth/firebase_auth.dart';
import 'package:pilll/entrypoint.dart';
import 'package:pilll/utils/environment.dart';
import 'package:pilll/utils/local_notification.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  Environment.flavor = Flavor.DEVELOP;
  Environment.deleteUser = () async {
    if (!Environment.isDevelopment) {
      throw AssertionError('This method should not call out of development');
    }
    (await SharedPreferences.getInstance()).setBool(
      BoolKey.didEndInitialSetting,
      false,
    );
    await FirebaseAuth.instance.currentUser?.delete();
  };
  Environment.signOutUser = () async {
    if (!Environment.isDevelopment) {
      throw AssertionError('This method should not call out of development');
    }
    (await SharedPreferences.getInstance()).setBool(
      BoolKey.didEndInitialSetting,
      false,
    );
    // local notificationのみ解除（AlarmKit解除はRiverpodコンテナ内でのみ実行可能）
    final pendingNotifications = await localNotificationService.pendingReminderNotifications();
    await Future.wait(
      pendingNotifications.map(
        (p) => localNotificationService.cancelNotification(
          localNotificationID: p.id,
        ),
      ),
    );
    await FirebaseAuth.instance.signOut();
  };
  await entrypoint();
}
