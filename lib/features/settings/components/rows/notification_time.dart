import 'package:flutter/material.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/features/reminder_times/page.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

class NotificationTimeRow extends StatelessWidget {
  final Setting setting;
  const NotificationTimeRow({super.key, required this.setting});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        L.notificationTime,
        style: const TextStyle(
          fontFamily: FontFamily.roboto,
          fontWeight: FontWeight.w300,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        setting.reminderTimes.map((e) => DateTimeFormatter.militaryTime(e.dateTime())).join(', '),
      ),
      onTap: () {
        analytics.logEvent(name: 'did_select_changing_reminder_times');
        Navigator.of(context).push(ReminderTimesPageRoute.route());
      },
    );
  }
}
