import 'package:flutter/services.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/native/legacy.dart';
import 'package:pilll/utils/environment.dart';
import 'package:pilll/native/pill.dart';
import 'package:pilll/native/widget.dart';
import 'package:pilll/utils/local_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pilll/provider/database.dart';

const methodChannel = MethodChannel("method.channel.MizukiOhashi.Pilll");
void definedChannel() {
  methodChannel.setMethodCallHandler((MethodCall call) async {
    switch (call.method) {
      case 'recordPill':
        // TODO: [UseLocalNotification-Beta] 2023-11 不要になったら処理を削除
        // ネイティブ側のFirebaseの処理も削除
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

        final cancelReminderLocalNotification = CancelReminderLocalNotification();
        // エンティティの変更があった場合にdatabaseの読み込みで最新の状態を取得するために、Future.microtaskで更新を待ってから処理を始める
        // hour,minute,番号を基準にIDを決定しているので、時間変更や番号変更時にそれまで登録されていたIDを特定するのが不可能なので全てキャンセルする
        await (Future.microtask(() => null), cancelReminderLocalNotification()).wait;

        final activePillSheet = pillSheetGroup?.activePillSheet;
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
