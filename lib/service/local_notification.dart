import 'dart:async';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pilll/entity/local_notification_schedule.codegen.dart';
import 'package:pilll/native/pill.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

// Reminder Notification
const iOSRecordPillActionIdentifier = "RECORD_PILL_LOCAL";
const iOSQuickRecordPillCategoryIdentifier = "PILL_REMINDER_LOCAL";
const AndroidReminderNotificationChannelID =
    "AndroidReminderNotificationChannelID";
const AndroidReminderNotificationActionIdentifier =
    "AndroidReminderNotificationActionIdentifier";
const AndroidReminderNotificationGroupKey =
    "AndroidReminderNotificationGroupKey";

// General Android Notification Setting
// Doc: https://developer.android.com/reference/androidx/core/app/NotificationCompat#CATEGORY_REMINDER()
const AndroidNotificationCategory = "CATEGORY_REMINDER";

// NOTE: It can not be use Future.wait(processes) when register notification.
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
        android: const AndroidInitializationSettings(
          "@mipmap/ic_launcher",
        ),
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

  Future<void> fireCreateNewPillSheetNotification({
    required String title,
    required String body,
  }) async {
    await plugin.show(
      createNewPillSheetNotificationIdentifierOffset,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "AndroidCreateNewPillSheetChannelID",
          "新しいシート作成の通知",
          setAsGroupSummary: true,
          groupKey: AndroidReminderNotificationGroupKey,
          category: AndroidNotificationCategory,
        ),
        iOS: DarwinNotificationDetails(
          sound: "becho.caf",
          presentSound: true,
        ),
      ),
    );
  }

  Future<void> scheduleRemiderNotification({
    required LocalNotificationScheduleCollection
        localNotificationScheduleCollection,
    required bool isTrialOrPremium,
  }) async {
    assert(localNotificationScheduleCollection.kind ==
        LocalNotificationScheduleKind.reminderNotification);

    if (isTrialOrPremium) {
      for (final schedule in localNotificationScheduleCollection.schedules) {
        await plugin.cancel(schedule.actualLocalNotificationID);
        await plugin.zonedSchedule(
          schedule.actualLocalNotificationID,
          schedule.title,
          schedule.message,
          _mappedTZDateTime(schedule.scheduleDateTime),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              AndroidReminderNotificationChannelID,
              "服用通知",
              channelShowBadge: true,
              setAsGroupSummary: true,
              groupKey: AndroidReminderNotificationGroupKey,
              category: AndroidNotificationCategory,
              actions: [
                AndroidNotificationAction(
                  AndroidReminderNotificationActionIdentifier,
                  "飲んだ",
                )
              ],
            ),
            iOS: DarwinNotificationDetails(
              categoryIdentifier: iOSQuickRecordPillCategoryIdentifier,
              presentBadge: true,
              sound: "becho.caf",
              presentSound: true,
            ),
          ),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    } else {
      for (final schedule in localNotificationScheduleCollection.schedules) {
        await plugin.cancel(schedule.actualLocalNotificationID);
        await plugin.zonedSchedule(
          schedule.actualLocalNotificationID,
          schedule.title,
          schedule.message,
          _mappedTZDateTime(schedule.scheduleDateTime),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              AndroidReminderNotificationChannelID,
              "服用通知",
              channelShowBadge: true,
              setAsGroupSummary: true,
              groupKey: AndroidReminderNotificationGroupKey,
              category: AndroidNotificationCategory,
            ),
            iOS: DarwinNotificationDetails(
              categoryIdentifier: iOSQuickRecordPillCategoryIdentifier,
              presentBadge: true,
              sound: "becho.caf",
              presentSound: true,
            ),
          ),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }
  }

  Future<void> cancelScheduledRemiderNotification({
    required LocalNotificationScheduleCollection
        localNotificationScheduleCollection,
  }) async {
    for (final schedule in localNotificationScheduleCollection.schedules) {
      await plugin.cancel(schedule.actualLocalNotificationID);
    }
  }

  Future<void> test() async {
    await plugin.zonedSchedule(
      Random().nextInt(1000000),
      'test title',
      'test body',
      tz.TZDateTime.from(now().add(const Duration(minutes: 1)), tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          AndroidReminderNotificationChannelID,
          "服用通知",
          channelShowBadge: true,
          setAsGroupSummary: true,
          groupKey: AndroidReminderNotificationGroupKey,
          category: AndroidNotificationCategory,
        ),
        iOS: DarwinNotificationDetails(
          categoryIdentifier: iOSQuickRecordPillCategoryIdentifier,
          presentBadge: true,
          sound: "becho.caf",
          presentSound: true,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // NOTE: tz.TZDateTime.from に渡す値がtz.TZDateTimeだとエラーになる
  // DateTimeにダウンキャストするとtimezoneが失われてしまうためこの方法は取らない
  // ここでは、scheduleDateTimeに正しいtz.TZDateTimeが入る想定、もしくはFirsetoreから変換されたDateTimeが入ることを想定している
  tz.TZDateTime _mappedTZDateTime(DateTime scheduleDateTime) {
    if (scheduleDateTime is tz.TZDateTime) {
      return scheduleDateTime;
    } else {
      return tz.TZDateTime.from(scheduleDateTime, tz.local);
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
