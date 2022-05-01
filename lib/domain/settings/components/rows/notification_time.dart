import 'package:flutter/material.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/domain/settings/reminder_times_page.dart';
import 'package:pilll/domain/settings/setting_page_state.codegen.dart';
import 'package:pilll/domain/settings/setting_page_state_notifier.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

class NotificationTimeRow extends StatelessWidget {
  final SettingStateNotifier store;
  final SettingState state;

  const NotificationTimeRow({
    Key? key,
    required this.store,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("通知時刻", style: FontType.listRow),
      subtitle: Text(state.setting.reminderTimes
          .map((e) => DateTimeFormatter.militaryTime(e.dateTime()))
          .join(", ")),
      onTap: () {
        analytics.logEvent(
          name: "did_select_changing_reminder_times",
        );
        Navigator.of(context).push(ReminderTimesPageRoute.route(store: store));
      },
    );
  }
}
