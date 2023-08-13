import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/native/legacy.dart';
import 'package:pilll/native/pill.dart';
import 'package:pilll/native/widget.dart';
import 'package:pilll/utils/local_notification.dart';

const methodChannel = MethodChannel("method.channel.MizukiOhashi.Pilll");
void definedChannel() {
  methodChannel.setMethodCallHandler((MethodCall call) async {
    switch (call.method) {
      case 'recordPill':
        // 通知からの起動の時に、FirebaseAuth.instanceを参照すると、まだinitializeされてないよ．的なエラーが出る
        if (Firebase.apps.isEmpty) {
          await Firebase.initializeApp();
        }
        final firebaseUser = FirebaseAuth.instance.currentUser;
        if (firebaseUser == null) {
          return;
        }

        final database = DatabaseConnection(firebaseUser.uid);

        final pillSheetGroup = await quickRecordTakePill(database);
        syncActivePillSheetValue(pillSheetGroup: pillSheetGroup);

        final activePillSheet = pillSheetGroup?.activedPillSheet;
        final user = (await database.userReference().get()).data();
        final setting = user?.setting;
        if (pillSheetGroup != null && activePillSheet != null && user != null && setting != null) {
          if (user.useLocalNotificationForReminder) {
            await RegisterReminderLocalNotification.run(
              pillSheetGroup: pillSheetGroup,
              activePillSheet: activePillSheet,
              premiumOrTrial: user.isPremium || user.isTrial,
              setting: setting,
            );
          }
        }
        return;
      case "salvagedOldStartTakenDate":
        return salvagedOldStartTakenDate(call.arguments);
      case "analytics":
        final name = call.arguments["name"] as String;
        final parameters = Map<String, dynamic>.from(call.arguments["parameters"]);
        analytics.logEvent(name: name, parameters: parameters);
        break;
      default:
        break;
    }
  });
}
