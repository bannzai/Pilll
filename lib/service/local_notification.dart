import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pilll/domain/record/util/take.dart';
import 'package:pilll/emoji/emoji.dart';
import 'package:pilll/entity/local_notification_schedule.codegen.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/native/pill.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/shared_preference/shared_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

// Concrete identifier offsets
const reminderNotificationIdentifierOffset = 1 * 10000000;

// iOS specific
const iOSRecordPillActionIdentifier = "RECORD_PILL_LOCAL";
const iOSQuickRecordPillCategoryIdentifier = "PILL_REMINDER_LOCAL";

onSelectNotificationAction(NotificationActionDetails details) {
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
      onSelectNotificationAction: onSelectNotificationAction,
    );
  }

  Future<void> scheduleRemiderNotification({
    required int hour,
    required int minute,
    required List<LocalNotificationSchedule>
        reminderNotificationLocalNotificationSchedules,
    required PillSheetGroup pillSheetGroup,
    required bool isTrialOrPremium,
    required Setting setting,
    required tz.TZDateTime tzFrom,
  }) async {
    final lastID = reminderNotificationLocalNotificationSchedules
        .where((element) =>
            element.kind == LocalNotificationScheduleKind.reminderNotification)
        .sorted(
            (a, b) => a.localNotificationID.compareTo(b.localNotificationID))
        .lastOrNull
        ?.localNotificationID;
    final localNotificationIDOffset =
        reminderNotificationIdentifierOffset + (lastID ?? 0);

    for (var index = 0; index < pillSheetGroup.pillSheets.length; index++) {
      final pillSheet = pillSheetGroup.pillSheets[index];

      final reminderDate = tzFrom
          .tzDate()
          .add(Duration(days: index))
          .add(Duration(hours: hour))
          .add(Duration(minutes: minute));

      final localNotificationSchedule = LocalNotificationSchedule(
        kind: LocalNotificationScheduleKind.reminderNotification,
        scheduleDateTime: reminderDate,
        localNotificationID: localNotificationIDOffset + index,
      );

      final title = () {
        if (isTrialOrPremium) {
          var result = setting.reminderNotificationCustomization.word;
          if (!setting
              .reminderNotificationCustomization.isInVisibleReminderDate) {
            result += " ";
            result +=
                "${reminderDate.month}/${reminderDate.day} (${WeekdayFunctions.weekdayFromDate(reminderDate).weekdayString()})";
          }
          if (!setting
              .reminderNotificationCustomization.isInVisiblePillNumber) {
            result += " ";
            result +=
                "${pillSheetPillNumber(pillSheet: pillSheet, targetDate: reminderDate)}番";
          }
          return result;
        } else {
          return "💊の時間です";
        }
      }();
      final body = '';

      await plugin.zonedSchedule(
        localNotificationSchedule.localNotificationID,
        title,
        body,
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
