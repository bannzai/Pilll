import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

// NOTE: Unixtime is 13 digits
const millisecondsMaxUnixtime = 9999999999999;
const maxUnixtimePlusOne = millisecondsMaxUnixtime + 1;

// Concrete identifier offsets
const reminderNotificationIdentifierOffset = 1 * maxUnixtimePlusOne;

class LocalNotification {
  final plugin = FlutterLocalNotificationsPlugin();

  static Future<void> setupTimeZone() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(
        tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()));
  }

  Future<void> scheduleRemiderNotification({
    required int hour,
    required int minute,
    required int totalPillNumberOfPillSheetGroup,
    required bool isTrialOrPremium,
    required tz.TZDateTime tzFrom,
  }) async {
    final processes = List.generate(totalPillNumberOfPillSheetGroup, (index) {
      final date = tzFrom.add(Duration(days: index)).tzDate();
      final reminderDate =
          date.add(Duration(hours: hour)).add(Duration(minutes: minute));

      return plugin.zonedSchedule(
        reminderNotificationIdentifierOffset +
            reminderDate.millisecondsSinceEpoch,
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
            categoryIdentifier: "PILL_REMINDER",
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    });

    await Future.wait(processes);
  }
}

final localNotification = LocalNotification();
