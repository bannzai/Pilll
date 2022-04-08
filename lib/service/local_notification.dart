import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pilll/entity/local_notification_schedule.codegen.dart';
import 'package:pilll/native/pill.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

// iOS specific
const iOSRecordPillActionIdentifier = "RECORD_PILL_LOCAL";
const iOSQuickRecordPillCategoryIdentifier = "PILL_REMINDER_LOCAL";

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
                    iOSRecordPillActionIdentifier, "飲んだ"),
              ],
            ),
          ],
        ),
      ),
      onSelectNotificationAction: onSelectNotificationAction,
    );
  }

  Future<void> scheduleRemiderNotification({
    required LocalNotificationScheduleCollection
        localNotificationScheduleCollection,
  }) async {
    assert(localNotificationScheduleCollection.kind ==
        LocalNotificationScheduleKind.reminderNotification);

    for (final schedule in localNotificationScheduleCollection.schedules) {
      await plugin.zonedSchedule(
        schedule.localNotificationID,
        schedule.title,
        schedule.message,
        tz.TZDateTime.from(schedule.scheduleDateTime, tz.local),
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

// onSelectNotificationAction must be static method or global method
void onSelectNotificationAction(NotificationActionDetails details) {
  if (details.actionId == iOSRecordPillActionIdentifier) {
    recordPill();
  }
}
