import 'dart:async';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/weekday.dart';
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

// Notification ID offset
const notificationIdentifierOffsetBase = 10000;
const createNewPillSheetNotificationIdentifierOffset =
    1 * notificationIdentifierOffsetBase;
const reminderNotificationIdentifierOffset =
    10 * notificationIdentifierOffsetBase;

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
    await plugin.cancel(createNewPillSheetNotificationIdentifierOffset);
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
    required PillSheetGroup pillSheetGroup,
    required PillSheet activedPillSheet,
    required bool isTrialOrPremium,
    required Setting setting,
  }) async {
    final tzNow = tz.TZDateTime.now(tz.local);
    for (final reminderTime in setting.reminderTimes) {
      // 新規ピルシートグループの作成後に通知のスケジュールができないため、多めに通知をスケジュールする
      // ユーザーの何かしらのアクションでどこかでスケジュールされるだろう
      for (final loopIndex in List.generate(6, (index) => index)) {
        for (final pillSheet in pillSheetGroup.pillSheets) {
          for (var pillIndex = 0;
              pillIndex < pillSheet.typeInfo.totalCount;
              pillIndex++) {
            final groupPillCount = pillSheetGroup.pillSheets
                .map((e) => e.typeInfo.totalCount)
                .reduce((a, b) => a + b);
            final groupOffset = groupPillCount * loopIndex;
            final beforePillCount = summarizedPillCountWithPillSheetsToEndIndex(
              pillSheets: pillSheetGroup.pillSheets,
              endIndex: pillSheet.groupIndex,
            );
            final daysOffset = groupOffset + beforePillCount + pillIndex;

            final reminderDate = tzNow
                .add(Duration(days: daysOffset))
                .add(Duration(hours: reminderTime.hour))
                .add(Duration(minutes: reminderTime.minute));
            // NOTE: LocalNotification must be scheduled at least 3 minutes after the current time (in iOS, Android not confirm).
            // Delay five minutes just to be sure.
            if (!reminderDate.add(const Duration(minutes: 5)).isAfter(tzNow)) {
              continue;
            }

            final notificationID = () {
              return daysOffset + reminderNotificationIdentifierOffset;
            }();
            final message = '';

            if (isTrialOrPremium) {
              final title = () {
                var result = setting.reminderNotificationCustomization.word;
                if (!setting.reminderNotificationCustomization
                    .isInVisibleReminderDate) {
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
              }();

              await plugin.cancel(notificationID);
              await plugin.zonedSchedule(
                notificationID,
                title,
                message,
                reminderDate,
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
            } else {
              final title = "💊の時間です";
              await plugin.cancel(notificationID);
              await plugin.zonedSchedule(
                notificationID,
                title,
                message,
                reminderDate,
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
      }
    }
  }

  Future<void> cancelAllScheduledRemiderNotification() async {
    for (final pendingNotificationRequest
        in await plugin.pendingNotificationRequests()) {
      if (pendingNotificationRequest.id - reminderNotificationIdentifierOffset >
          0) {
        await plugin.cancel(pendingNotificationRequest.id);
      }
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
}

final localNotification = LocalNotification();

// onSelectNotificationAction must be static method or global method
void onSelectNotificationAction(NotificationActionDetails details) {
  if (details.actionId == iOSRecordPillActionIdentifier) {
    recordPill();
  }
}
