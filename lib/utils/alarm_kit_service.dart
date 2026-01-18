import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pilll/utils/analytics.dart';

/// AlarmKitの認証状態
enum AlarmKitAuthorizationStatus {
  authorized, // 許可済み
  denied, // 拒否
  notDetermined, // 未決定
  notAvailable; // iOS 26未満

  static AlarmKitAuthorizationStatus fromString(String value) {
    switch (value) {
      case 'authorized':
        return AlarmKitAuthorizationStatus.authorized;
      case 'denied':
        return AlarmKitAuthorizationStatus.denied;
      case 'notDetermined':
        return AlarmKitAuthorizationStatus.notDetermined;
      case 'notAvailable':
        return AlarmKitAuthorizationStatus.notAvailable;
      default:
        return AlarmKitAuthorizationStatus.notAvailable;
    }
  }
}

/// AlarmKit機能へのアクセスを提供するサービスクラス
///
/// iOS 26+でのみ利用可能なAlarmKitの機能をFlutterから使用するためのラッパーです。
/// Method Channelを通してiOSネイティブのAlarmKitManagerと通信します。
class AlarmKitService {
  static const MethodChannel _channel = MethodChannel('method.channel.MizukiOhashi.Pilll');

  /// AlarmKitが利用可能かどうかを確認する
  ///
  /// iOS 26+でのみtrueを返します。Android端末では常にfalseです。
  /// 設定画面での表示制御やアラーム登録前の判定に使用します。
  static Future<bool> isAvailable() async {
    if (!Platform.isIOS) {
      return false;
    }

    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>('isAlarmKitAvailable');
      if (result?['result'] == 'success') {
        return result?['isAlarmKitAvailable'] ?? false;
      }
      return false;
    } catch (e) {
      analytics.debug(name: 'alarm_kit_availability_check_error', parameters: {'error': e.toString()});
      return false;
    }
  }

  /// AlarmKitの認証状態を取得する
  ///
  /// 現在のAlarmKitの認証状態を確認します。
  /// UI表示に応じて適切な状態を返します。
  /// iOS 26未満の場合はnotAvailableを返します。
  ///
  /// Returns: 現在の認証状態
  static Future<AlarmKitAuthorizationStatus> getAuthorizationStatus() async {
    if (!Platform.isIOS) {
      return AlarmKitAuthorizationStatus.notAvailable;
    }

    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>('getAlarmKitAuthorizationStatus');
      if (result?['result'] == 'success') {
        final statusString = result?['authorizationStatus'] as String? ?? 'notAvailable';
        return AlarmKitAuthorizationStatus.fromString(statusString);
      }
      return AlarmKitAuthorizationStatus.notAvailable;
    } catch (e) {
      analytics.debug(name: 'alarm_kit_authorization_status_check_error', parameters: {'error': e.toString()});
      return AlarmKitAuthorizationStatus.notAvailable;
    }
  }

  /// AlarmKitの権限をリクエストする
  ///
  /// iOS 26+でAlarmKitの使用許可をユーザーに求めます。
  /// アラーム機能を初めて使用する際に呼び出す必要があります。
  ///
  /// Returns: 権限が許可された場合true、拒否された場合false
  static Future<bool> requestPermission() async {
    if (!Platform.isIOS) {
      return false;
    }

    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>('requestAlarmKitPermission');
      if (result?['result'] == 'success') {
        return result?['authorized'] ?? false;
      }
      return false;
    } catch (e) {
      analytics.debug(name: 'alarm_kit_permission_request_error', parameters: {'error': e.toString()});
      return false;
    }
  }

  /// 服薬リマインダーアラームを登録する
  ///
  /// AlarmKitを使用して指定時刻に服薬リマインダーを表示します。
  /// サイレントモード・フォーカスモード時でも確実に表示されます。
  ///
  /// [id]: アラームの一意識別子（通知IDと同じ形式）
  /// [title]: アラームに表示するタイトル
  /// [scheduledTimeMs]: アラームを表示する日時
  ///
  /// Throws: アラーム登録に失敗した場合Exception
  static Future<void> scheduleMedicationReminder({
    required String localNotificationID,
    required String title,
    required DateTime reminderDateTime,
  }) async {
    if (!Platform.isIOS) {
      throw Exception('AlarmKit is only available on iOS 26+');
    }

    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>('scheduleAlarmKitReminder', {
        'localNotificationID': localNotificationID,
        'title': title,
        'scheduledTimeMs': reminderDateTime.millisecondsSinceEpoch,
      });

      if (result?['result'] != 'success') {
        throw Exception(result?['message'] ?? 'Failed to schedule alarm');
      }

      analytics.debug(
        name: 'alarm_kit_reminder_scheduled',
        parameters: {'localNotificationID': localNotificationID, 'title': title, 'scheduledTimeMs': reminderDateTime.millisecondsSinceEpoch},
      );
    } catch (e) {
      analytics.debug(
        name: 'alarm_kit_schedule_error',
        parameters: {
          'error': e.toString(),
          'localNotificationID': localNotificationID,
          'title': title,
          'scheduledTimeMs': reminderDateTime.millisecondsSinceEpoch,
        },
      );
      rethrow;
    }
  }

  /// すべての服薬リマインダーアラームを解除する
  ///
  /// 現在登録されているすべてのAlarmKitアラームを解除します。
  /// LocalNotificationと同様に全解除してから新規登録する方式で使用します。
  ///
  /// Throws: アラーム解除に失敗した場合Exception
  static Future<void> cancelAllMedicationReminders() async {
    if (!Platform.isIOS) {
      return; // Android端末では何もしない
    }

    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>('cancelAllAlarmKitReminders');

      if (result?['result'] != 'success') {
        throw Exception(result?['message'] ?? 'Failed to cancel all alarms');
      }

      analytics.debug(name: 'alarm_kit_all_reminders_cancelled');
    } catch (e) {
      analytics.debug(name: 'alarm_kit_cancel_all_error', parameters: {'error': e.toString()});
      rethrow;
    }
  }

  /// すべてのアラームを停止する
  ///
  /// 現在鳴っているすべてのAlarmKitアラームを停止します。
  /// アラーム音を止めたい場合に使用します。
  ///
  /// Throws: アラーム停止に失敗した場合Exception
  static Future<void> stopAllAlarms() async {
    if (!Platform.isIOS) {
      return; // Android端末では何もしない
    }

    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>('stopAllAlarmKitAlarms');

      if (result?['result'] != 'success') {
        throw Exception(result?['message'] ?? 'Failed to stop all alarms');
      }

      analytics.debug(name: 'alarm_kit_all_alarms_stopped');
    } catch (e) {
      analytics.debug(name: 'alarm_kit_stop_all_error', parameters: {'error': e.toString()});
      rethrow;
    }
  }
}
