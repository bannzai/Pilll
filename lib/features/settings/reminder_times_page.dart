import 'dart:async';

import 'package:async_value_group/async_value_group.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/features/settings/provider.dart';
import 'package:pilll/features/settings/timezone_setting_dialog.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/features/error/universal_error_page.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';
import 'package:pilll/utils/local_notification.dart';
import 'package:pilll/components/picker/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class ReminderTimesPage extends HookConsumerWidget {
  const ReminderTimesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setSetting = ref.watch(setSettingProvider);
    final registerReminderLocalNotification = ref.watch(registerReminderLocalNotificationProvider);

    return AsyncValueGroup.group2(
      ref.watch(settingProvider),
      ref.watch(deviceTimezoneNameProvider),
    ).when(
      data: (data) {
        final setting = data.$1;
        final deviceTimezoneName = data.$2;
        return ReminderTimesPageBody(
          setting: setting,
          deviceTimezoneName: deviceTimezoneName,
          setSetting: setSetting,
          registerReminderLocalNotification: registerReminderLocalNotification,
        );
      },
      error: (error, _) => UniversalErrorPage(
        error: error,
        child: null,
        reload: () => ref.refresh(databaseProvider),
      ),
      loading: () => const ScaffoldIndicator(),
    );
  }
}

extension ReminderTimesPageRoute on ReminderTimesPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: "ReminderTimesPage"),
      builder: (_) => const ReminderTimesPage(),
    );
  }
}

class ReminderTimesPageBody extends StatelessWidget {
  final Setting setting;
  final String deviceTimezoneName;
  final SetSetting setSetting;
  final RegisterReminderLocalNotification registerReminderLocalNotification;

  const ReminderTimesPageBody({
    super.key,
    required this.setting,
    required this.deviceTimezoneName,
    required this.setSetting,
    required this.registerReminderLocalNotification,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "通知時間",
          style: TextStyle(color: TextColor.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              analytics.logEvent(name: "pressed_tz_setting_action");
              showDialog(
                context: context,
                builder: (_) => TimezoneSettingDialog(
                  setting: setting,
                  deviceTimezoneName: deviceTimezoneName,
                  onDone: (tz) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 2),
                        content: Text("$tzに変更しました"),
                      ),
                    );
                  },
                ),
              );
            },
            icon: const Icon(Icons.timer_sharp, color: PilllColors.primary),
          ),
        ],
        backgroundColor: PilllColors.background,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ...setting.reminderTimes
                .asMap()
                .map(
                  (offset, reminderTime) => MapEntry(
                    offset,
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Container(
                            height: 1,
                            color: PilllColors.border,
                          ),
                        ),
                        _component(context, setting: setting, reminderTime: reminderTime, setSetting: setSetting, number: offset + 1)
                      ],
                    ),
                  ),
                )
                .values,
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Container(
                height: 1,
                color: PilllColors.border,
              ),
            ),
            _add(context, setting: setting, setSetting: setSetting),
          ],
        ),
      ),
    );
  }

  Widget _component(
    BuildContext context, {
    required Setting setting,
    required ReminderTime reminderTime,
    required SetSetting setSetting,
    required int number,
  }) {
    Widget body = GestureDetector(
      onTap: () {
        analytics.logEvent(name: "show_modify_reminder_time");
        _showPicker(context, setting: setting, setSetting: setSetting, index: number - 1);
      },
      child: ListTile(
        title: Text("通知$number"),
        subtitle: Text(DateTimeFormatter.militaryTime(reminderTime.dateTime())),
      ),
    );
    if (setting.reminderTimes.length == 1) {
      return body;
    }
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: setting.reminderTimes.length == 1
          ? null
          : (direction) {
              analytics.logEvent(name: "delete_reminder_time");
              _deleteReminderTimes(
                index: number - 1,
                setting: setting,
                setSetting: setSetting,
              ).catchError((error) => showErrorAlert(context, error));
            },
      background: Container(
        color: Colors.red,
        child: const SizedBox(
          width: 40,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "削除",
                style: TextStyle(
                  fontFamily: FontFamily.japanese,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: TextColor.white,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ),
      ),
      child: body,
    );
  }

  Widget _add(BuildContext context, {required Setting setting, required SetSetting setSetting}) {
    if (setting.reminderTimes.length >= ReminderTime.maximumCount) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        analytics.logEvent(name: "pressed_add_reminder_time");
        _showPicker(context, setSetting: setSetting, setting: setting, index: null);
      },
      child: SizedBox(
        height: 64,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("images/add.svg"),
            const Text(
              "通知時間の追加",
              style: TextStyle(
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: TextColor.main,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showPicker(
    BuildContext context, {
    required Setting setting,
    required SetSetting setSetting,
    required int? index,
  }) {
    final isEditing = index != null;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return TimePicker(
          initialDateTime: isEditing ? setting.reminderTimes[index].dateTime() : const ReminderTime(hour: 20, minute: 0).dateTime(),
          done: (dateTime) {
            if (isEditing) {
              analytics.logEvent(name: "edited_reminder_time");
              unawaited(_editReminderTime(
                index: index,
                reminderTime: ReminderTime(hour: dateTime.hour, minute: dateTime.minute),
                setting: setting,
                setSetting: setSetting,
              ).catchError((error) => showErrorAlert(context, error)));
            } else {
              analytics.logEvent(name: "added_reminder_time");
              unawaited(_addReminderTimes(
                reminderTime: ReminderTime(hour: dateTime.hour, minute: dateTime.minute),
                setting: setting,
                setSetting: setSetting,
              ).catchError((error) => showErrorAlert(context, error)));
            }

            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<void> _addReminderTimes({
    required Setting setting,
    required ReminderTime reminderTime,
    required SetSetting setSetting,
  }) async {
    List<ReminderTime> copied = [...setting.reminderTimes];
    copied.add(reminderTime);
    await _modifyReminderTimes(setting: setting, reminderTimes: copied, setSetting: setSetting);
  }

  Future<void> _editReminderTime({
    required Setting setting,
    required int index,
    required ReminderTime reminderTime,
    required SetSetting setSetting,
  }) async {
    List<ReminderTime> copied = [...setting.reminderTimes];
    copied[index] = reminderTime;
    await _modifyReminderTimes(setting: setting, reminderTimes: copied, setSetting: setSetting);
  }

  Future<void> _deleteReminderTimes({
    required Setting setting,
    required int index,
    required SetSetting setSetting,
  }) async {
    List<ReminderTime> copied = [...setting.reminderTimes];
    copied.removeAt(index);
    await _modifyReminderTimes(setting: setting, reminderTimes: copied, setSetting: setSetting);
  }

  Future<void> _modifyReminderTimes({
    required Setting setting,
    required List<ReminderTime> reminderTimes,
    required SetSetting setSetting,
  }) async {
    if (reminderTimes.length > ReminderTime.maximumCount) {
      throw Exception("登録できる上限に達しました。${ReminderTime.maximumCount}件以内に収めてください");
    }
    if (reminderTimes.length < ReminderTime.minimumCount) {
      throw Exception("通知時刻は最低${ReminderTime.minimumCount}件必要です");
    }
    await setSetting(setting.copyWith(reminderTimes: reminderTimes));
    await registerReminderLocalNotification();
  }
}
