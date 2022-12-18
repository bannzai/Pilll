import 'dart:async';

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/schedule.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/native/pill.dart';
import 'package:pilll/provider/batch.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/provider/take_pill.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

// Reminder Notification
const iOSRecordPillActionIdentifier = "RECORD_PILL_LOCAL";
const iOSQuickRecordPillCategoryIdentifier = "PILL_REMINDER_LOCAL";
const androidReminderNotificationChannelID = "androidReminderNotificationChannelID";
const androidCalendarScheduleNotificationChannelID = "androidCalendarScheduleNotificationChannelID";
const androidReminderNotificationActionIdentifier = "androidReminderNotificationActionIdentifier";
const androidReminderNotificationGroupKey = "androidReminderNotificationGroupKey";

// General Android Notification Setting
// Doc: https://developer.android.com/reference/androidx/core/app/NotificationCompat#CATEGORY_REMINDER()
const androidNotificationCategoryCalendarSchedule = "androidNotificationCategoryCalendarSchedule";
const androidNotificationCategoryRemindNotification = "androidNotificationCategoryRemindNotification";

// Notification ID offset
const scheduleNotificationIdentifierOffset = 100000;
const reminderNotificationIdentifierOffset = 1000000000;

// NOTE: It can not be use Future.wait(processes) when register notification.
class LocalNotificationService {
  final plugin = FlutterLocalNotificationsPlugin();

  static Future<void> setupTimeZone() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()));
  }

  Future<void> initialize() async {
    await plugin.initialize(
        InitializationSettings(
          android: const AndroidInitializationSettings(
            "ic_notification",
          ),
          iOS: DarwinInitializationSettings(
            notificationCategories: [
              DarwinNotificationCategory(
                iOSQuickRecordPillCategoryIdentifier,
                actions: [
                  DarwinNotificationAction.plain(iOSRecordPillActionIdentifier, "飲んだ"),
                ],
              ),
            ],
          ),
        ),
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  Future<void> scheduleCalendarScheduleNotification({
    required Schedule schedule,
  }) async {
    final localNotification = schedule.localNotification;
    if (localNotification != null) {
      final remindDate = tz.TZDateTime.from(localNotification.remindDateTime, tz.local);
      debugPrint("$remindDate");
      await plugin.zonedSchedule(
        localNotification.localNotificationID,
        "本日の予定です",
        schedule.title,
        remindDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            androidCalendarScheduleNotificationChannelID,
            "カレンダーの予定",
            groupKey: null,
            category: AndroidNotificationCategory(androidNotificationCategoryCalendarSchedule),
          ),
          iOS: DarwinNotificationDetails(
            sound: "becho.caf",
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  Future<void> cancelNotification({required int localNotificationID}) async {
    await plugin.cancel(localNotificationID);
  }

  // reminder time id is 10{groupIndex:2}{hour:2}{minute:2}{pillNumberIntoPillSheet:2}
  // for example return value 1002223014 means,  `10` is prefix, gropuIndex: `02` is third pillSheet,`22` is hour, `30` is minute, `14` is pill number into pill sheet
  // 1000000000 = reminderNotificationIdentifierOffset
  // 10000000 = pillSheetGroupIndex
  // 100000 = reminderTime.hour
  // 1000 = reminderTime.minute
  // 10 = pillNumberIntoPillSheet
  int _calcLocalNotificationID({
    required int pillSheetGroupIndex,
    required ReminderTime reminderTime,
    required int pillNumberIntoPillSheet,
  }) {
    final groupIndex = pillSheetGroupIndex * 10000000;
    final hour = reminderTime.hour * 100000;
    final minute = reminderTime.minute * 1000;
    return reminderNotificationIdentifierOffset + groupIndex + hour + minute + pillNumberIntoPillSheet;
  }

  // 休薬終了や初期設定完了後に使う
  Future<void> scheduleAllRemiderNotification({
    required PillSheetGroup pillSheetGroup,
    required PillSheet activePillSheet,
    required bool isTrialOrPremium,
    required Setting setting,
  }) async {
    final tzNow = tz.TZDateTime.now(tz.local);
    final List<Future<void>> futures = [];

    for (final reminderTime in setting.reminderTimes) {
      // 新規ピルシートグループの作成後に通知のスケジュールができないため、多めに通知をスケジュールする
      // ユーザーの何かしらのアクションでどこかでスケジュールされるだろう
      for (final offset in List.generate(14, (index) => index)) {
        final reminderDate = tzNow.add(Duration(days: offset)).add(Duration(hours: reminderTime.hour)).add(Duration(minutes: reminderTime.minute));
        // NOTE: LocalNotification must be scheduled at least 3 minutes after the current time (in iOS, Android not confirm).
        // Delay five minutes just to be sure.
        if (!reminderDate.add(const Duration(minutes: 5)).isAfter(tzNow)) {
          continue;
        }

        var targetPillSheet = activePillSheet;
        var pillNumberIntoPillSheet = activePillSheet.todayPillNumber + offset;
        if (pillNumberIntoPillSheet > activePillSheet.typeInfo.totalCount) {
          targetPillSheet = pillSheetGroup.pillSheets[activePillSheet.groupIndex + 1];

          const nextPillSheetFirstNumber = 1;
          pillNumberIntoPillSheet = nextPillSheetFirstNumber + offset;
        }

        final notificationID = _calcLocalNotificationID(
            pillSheetGroupIndex: targetPillSheet.groupIndex, reminderTime: reminderTime, pillNumberIntoPillSheet: pillNumberIntoPillSheet);
        if (isTrialOrPremium) {
          final title = () {
            var result = setting.reminderNotificationCustomization.word;
            if (!setting.reminderNotificationCustomization.isInVisibleReminderDate) {
              result += " ";
              result += "${reminderDate.month}/${reminderDate.day} (${WeekdayFunctions.weekdayFromDate(reminderDate).weekdayString()})";
            }
            if (!setting.reminderNotificationCustomization.isInVisiblePillNumber) {
              result += " ";
              result += "$pillNumberIntoPillSheet番";
            }
            return result;
          }();

          futures.add(Future(() async {
            await plugin.cancel(notificationID);
            await plugin.zonedSchedule(
              notificationID,
              title,
              '',
              reminderDate,
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  androidReminderNotificationChannelID,
                  "服用通知",
                  channelShowBadge: true,
                  setAsGroupSummary: true,
                  groupKey: androidReminderNotificationGroupKey,
                  category: AndroidNotificationCategory(androidNotificationCategoryRemindNotification),
                  actions: [
                    AndroidNotificationAction(
                      androidReminderNotificationActionIdentifier,
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
              uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
            );
          }));
        } else {
          const title = "💊の時間です";
          futures.add(Future(() async {
            await plugin.cancel(notificationID);
            await plugin.zonedSchedule(
              notificationID,
              title,
              '',
              reminderDate,
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  androidReminderNotificationChannelID,
                  "服用通知",
                  channelShowBadge: true,
                  setAsGroupSummary: true,
                  groupKey: androidReminderNotificationGroupKey,
                  category: AndroidNotificationCategory(androidNotificationCategoryRemindNotification),
                ),
                iOS: DarwinNotificationDetails(
                  categoryIdentifier: iOSQuickRecordPillCategoryIdentifier,
                  presentBadge: true,
                  sound: "becho.caf",
                  presentSound: true,
                ),
              ),
              androidAllowWhileIdle: true,
              uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
            );
          }));
        }
      }
    }

    await Future.wait(futures);

    debugPrint("end scheduleRemiderNotification: ${setting.reminderTimes}");
  }
}

final localNotificationService = LocalNotificationService()..initialize();

// onDidReceiveNotificationResponse must be static method or global method
void onDidReceiveNotificationResponse(NotificationResponse details) {
  if (details.actionId == iOSRecordPillActionIdentifier) {
    quickRecordTakePill();
  }
}
