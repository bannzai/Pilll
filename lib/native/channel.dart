import 'package:flutter/services.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/native/pill.dart';
import 'package:pilll/native/widget.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:pilll/utils/local_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';

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
          return null;
        }

        try {
          analytics.logEvent(name: 'handle_recordPill_method_channel');

          final database = DatabaseConnection(firebaseUser.uid);

          await _syncAfterQuickRecord(database: database, pillSheetGroup: await quickRecordTakePill(database));
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
        return null;
      // ios/Runner/RecordPillIntent.swift (Siri・ショートカット) から呼ばれる。AppIntentRecordPillResult の name を返す
      case 'recordPillFromAppIntent':
        await LocalNotificationService.setupTimeZone();

        // アプリを開かない起動では、FirebaseAuth.instance を参照する前に initialize が要る (recordPill と同じ)
        if (Firebase.apps.isEmpty) {
          await Firebase.initializeApp();
        }
        final firebaseUser = FirebaseAuth.instance.currentUser;
        if (firebaseUser == null) {
          return AppIntentRecordPillResult.notSignedIn.name;
        }

        try {
          analytics.logEvent(name: 'handle_recordPillFromAppIntent_channel');

          final database = DatabaseConnection(firebaseUser.uid);
          final user = (await database.userReference().get()).data();
          if (user == null) {
            return AppIntentRecordPillResult.notSignedIn.name;
          }

          final (result, pillSheetGroup) = await recordPillFromAppIntent(
            user: user,
            pillSheetGroup: await fetchLatestPillSheetGroup(database),
            takePill: quickRecordTakePillOf(database),
          );
          if (result == AppIntentRecordPillResult.recorded) {
            // 記録は済んでいるため、ウィジェットと通知の更新の失敗で「記録できなかった」と返さない
            try {
              await _syncAfterQuickRecord(database: database, pillSheetGroup: pillSheetGroup);
            } catch (e, st) {
              errorLogger.recordError(e, st);
            }
          }
          return result.name;
        } catch (e, st) {
          errorLogger.recordError(e, st);
          // 失敗は iOS 側の返答で伝えるため、recordPill のような失敗の通知は出さない
          return AppIntentRecordPillResult.failed.name;
        }
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

/// クイックレコードの後に、ウィジェットの値と服用リマインダーの通知を記録後の PillSheetGroup に合わせる
Future<void> _syncAfterQuickRecord({
  required DatabaseConnection database,
  required PillSheetGroup? pillSheetGroup,
}) async {
  syncActivePillSheetValue(pillSheetGroup: pillSheetGroup);

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
      premiumOrTrial: user.isPremium || user.isTrial,
      setting: setting,
    );
  }
}
