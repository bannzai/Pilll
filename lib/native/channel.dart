import 'package:flutter/services.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/native/pill.dart';
import 'package:pilll/native/widget.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:pilll/utils/local_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pilll/provider/customer_info.dart';
import 'package:pilll/provider/database.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

const methodChannel = MethodChannel('method.channel.MizukiOhashi.Pilll');
void definedChannel() {
  methodChannel.setMethodCallHandler((MethodCall call) async {
    switch (call.method) {
      case 'recordPill':
        await LocalNotificationService.setupTimeZone();

        // 通知からの起動の時に、FirebaseAuth.instanceを参照すると、まだinitializeされてないよ．的なエラーが出る
        if (Firebase.apps.isEmpty) {
          await Firebase.initializeApp();
        }
        final firebaseUser = FirebaseAuth.instance.currentUser;
        if (firebaseUser == null) {
          return;
        }

        try {
          analytics.logEvent(name: 'handle_recordPill_method_channel');

          final database = DatabaseConnection(firebaseUser.uid);

          final pillSheetGroup = await quickRecordTakePill(database);
          syncActivePillSheetValue(pillSheetGroup: pillSheetGroup);

          // リマインダーを登録し直す時の課金状態。取り消した後に取得が失敗するとリマインダーが全て消えるため、取り消しより先に取得する。
          // 取得できない時 (オフラインで SDK のキャッシュが無い等) は、服用の記録は済んでいるので失敗の通知を出さず、登録済みのリマインダーを残して終える
          final CustomerInfo customerInfo;
          try {
            customerInfo = await fetchCustomerInfoOutsideUI(uid: firebaseUser.uid);
          } catch (e, st) {
            errorLogger.recordError(e, st);
            return;
          }

          final cancelReminderLocalNotification = CancelReminderLocalNotification();
          // エンティティの変更があった場合にdatabaseの読み込みで最新の状態を取得するために、Future.microtaskで更新を待ってから処理を始める
          // hour,minute,番号を基準にIDを決定しているので、時間変更や番号変更時にそれまで登録されていたIDを特定するのが不可能なので全てキャンセルする
          await (
            Future.microtask(() => null),
            cancelReminderLocalNotification(),
          ).wait;

          final activePillSheet = pillSheetGroup?.activePillSheet;
          final user = (await database.userReference().get()).data();
          final setting = user?.setting;
          if (pillSheetGroup != null && activePillSheet != null && user != null && setting != null) {
            await RegisterReminderLocalNotification.run(
              pillSheetGroup: pillSheetGroup,
              activePillSheet: activePillSheet,
              premiumOrTrial: customerInfo.premiumOrTrial(user: user),
              setting: setting,
            );
          }
        } catch (e, st) {
          errorLogger.recordError(e, st);

          // errorLoggerに記録した後に実行する。これも失敗する可能性がある
          await localNotificationService.plugin.show(
            fallbackNotificationIdentifier,
            L.quickRecordTakePillFailed,
            L.quickRecordTakePillFailedMessage,
            null,
          );
        }
        return;
      case 'analytics':
        final name = call.arguments['name'] as String;
        final parameters = Map<String, dynamic>.from(
          call.arguments['parameters'],
        );
        analytics.logEvent(name: name, parameters: parameters);
        break;
      default:
        break;
    }
  });
}
