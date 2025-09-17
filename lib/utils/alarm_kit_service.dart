import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pilll/utils/analytics.dart';

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
  /// [scheduledTime]: アラームを表示する日時
  ///
  /// Throws: アラーム登録に失敗した場合Exception
  static Future<void> scheduleMedicationReminder({
    required String id,
    required String title,
    required DateTime scheduledTime,
  }) async {
    if (!Platform.isIOS) {
      throw Exception('AlarmKit is only available on iOS 26+');
    }

    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>('scheduleAlarmKitReminder', {
        'id': id,
        'title': title,
        'scheduledTime': scheduledTime.millisecondsSinceEpoch,
      });

      if (result?['result'] != 'success') {
        throw Exception(result?['message'] ?? 'Failed to schedule alarm');
      }

      analytics.debug(name: 'alarm_kit_reminder_scheduled', parameters: {
        'id': id,
        'title': title,
        'scheduledTime': scheduledTime.toIso8601String(),
      });
    } catch (e) {
      analytics.debug(name: 'alarm_kit_schedule_error', parameters: {
        'error': e.toString(),
        'id': id,
        'title': title,
      });
      rethrow;
    }
  }

  /// 服薬リマインダーアラームを解除する
  ///
  /// 指定したIDのAlarmKitアラームを解除します。
  ///
  /// [id]: 解除するアラームの識別子
  ///
  /// Throws: アラーム解除に失敗した場合Exception
  static Future<void> cancelMedicationReminder(String id) async {
    if (!Platform.isIOS) {
      return; // Android端末では何もしない
    }

    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>('cancelAlarmKitReminder', {
        'id': id,
      });

      if (result?['result'] != 'success') {
        throw Exception(result?['message'] ?? 'Failed to cancel alarm');
      }

      analytics.debug(name: 'alarm_kit_reminder_cancelled', parameters: {'id': id});
    } catch (e) {
      analytics.debug(name: 'alarm_kit_cancel_error', parameters: {
        'error': e.toString(),
        'id': id,
      });
      rethrow;
    }
  }

  /// アラームを停止する
  ///
  /// 現在表示されているアラームを停止します。
  /// アラーム画面の停止ボタンから呼び出される処理です。
  ///
  /// [id]: 停止するアラームの識別子
  static Future<void> stopAlarm(String id) async {
    if (!Platform.isIOS) {
      return;
    }

    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>('stopAlarmKitAlarm', {
        'id': id,
      });

      if (result?['result'] != 'success') {
        throw Exception(result?['message'] ?? 'Failed to stop alarm');
      }

      analytics.debug(name: 'alarm_kit_alarm_stopped', parameters: {'id': id});
    } catch (e) {
      analytics.debug(name: 'alarm_kit_stop_error', parameters: {
        'error': e.toString(),
        'id': id,
      });
      // 停止処理の失敗はログ記録のみで例外は再スローしない
    }
  }
}
