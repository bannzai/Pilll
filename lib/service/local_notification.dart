import 'dart:async';
import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pilll/domain/record/util/take.dart';
import 'package:pilll/entity/local_notification_schedule.codegen.dart';
import 'package:pilll/native/pill.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/shared_preference/shared_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

// General purpose
const _sharedPreferenceKeyLocalNotificationScheduleIDs =
    'local_notification_schedule_ids';

// NOTE: Unixtime is 10 digits
const millisecondsMaxUnixtime = 9999999999999;
const maxUnixtimePlusOne = millisecondsMaxUnixtime + 1;

// Concrete identifier offsets
const reminderNotificationIdentifierOffset = 1 * maxUnixtimePlusOne;

// iOS specific
const iOSRecordPillActionIdentifier = "RECORD_PILL_LOCAL";
const iOSQuickRecordPillCategoryIdentifier = "PILL_REMINDER_LOCAL";

callback(NotificationActionDetails details) {
  print("[DEBUG] ${details.actionId}");
  if (details.actionId == iOSRecordPillActionIdentifier) {
    recordPill();
  }
}

class LocalNotification {
  final plugin = FlutterLocalNotificationsPlugin();

  static Future<void> setupTimeZone() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(
        tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()));
  }

  Future<void> initialize() async {
    await plugin.initialize(
      InitializationSettings(
        iOS: DarwinInitializationSettings(
          notificationCategories: [
            DarwinNotificationCategory(
              iOSQuickRecordPillCategoryIdentifier,
              actions: [
                DarwinNotificationAction.plain(
                    iOSRecordPillActionIdentifier, "飲んだ？ from local"),
              ],
            ),
          ],
        ),
      ),
      onSelectNotificationAction: callback,
    );
  }

  Future<void> scheduleRemiderNotification({
    required int hour,
    required int minute,
    required int totalPillNumberOfPillSheetGroup,
    required bool isTrialOrPremium,
    required tz.TZDateTime tzFrom,
  }) async {
    for (var index = 0; index < 10; index++) {
      final date = tzFrom.tzDate();
      final reminderDate = date
          .add(Duration(hours: tzFrom.hour))
          .add(Duration(minutes: tzFrom.minute + index + 1));
      print("$reminderDate");

      final id = await _createScheduleID(
        functionName: 'scheduleRemiderNotification',
        scheduleDateTime: reminderDate,
      );

      await plugin.zonedSchedule(
        id.localNotificationID,
        'scheduled title',
        'scheduled body',
        reminderDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'your channel id',
            'your channel name',
            channelDescription: 'your channel description',
          ),
          iOS: DarwinNotificationDetails(
            categoryIdentifier: iOSQuickRecordPillCategoryIdentifier,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }
}

final localNotification = LocalNotification();
