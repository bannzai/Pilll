import 'package:pilll/domain/settings/setting_page_state.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/domain/settings/setting_page_state_notifier.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/error/error_alert.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:pilll/util/toolbar/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class ReminderTimesPage extends HookConsumerWidget {
  final SettingStateNotifier store;

  ReminderTimesPage({
    required this.store,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingStateProvider).value!;
    final setting = state.setting;

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
        backgroundColor: PilllColors.background,
      ),
      body: SafeArea(
        child: Container(
          child: ListView(
            children: [
              ..._components(context, store, setting).map((e) {
                return [e, _separator()];
              }).expand((element) => element),
              _footer(context, state, store),
              _separator(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _components(
      BuildContext context, SettingStateNotifier store, Setting setting) {
    return setting.reminderTimes
        .asMap()
        .map((offset, reminderTime) => MapEntry(offset,
            _component(context, store, setting, reminderTime, offset + 1)))
        .values
        .toList();
  }

  Widget _component(
    BuildContext context,
    SettingStateNotifier store,
    Setting setting,
    ReminderTime reminderTime,
    int number,
  ) {
    Widget body = GestureDetector(
      onTap: () {
        _showPicker(context, store, setting, number - 1);
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
              store.asyncAction
                  .deleteReminderTimes(index: number - 1, setting: setting)
                  .catchError((error) => showErrorAlertFor(context, error));
            },
      background: Container(
        color: Colors.red,
        child: Container(
          width: 40,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "削除",
                style: FontType.assistingBold.merge(TextColorStyle.white),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ),
      ),
      child: body,
    );
  }

  Widget _separator() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Container(
        height: 1,
        color: PilllColors.border,
      ),
    );
  }

  Widget _footer(
      BuildContext context, SettingState state, SettingStateNotifier store) {
    final setting = state.setting;
    if (setting.reminderTimes.length >= ReminderTime.maximumCount) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        _showPicker(context, store, setting, null);
      },
      child: Container(
        height: 64,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("images/add.svg"),
            Text(
              "通知時間の追加",
              style: FontType.assisting.merge(TextColorStyle.main),
            )
          ],
        ),
      ),
    );
  }

  void _showPicker(BuildContext context, SettingStateNotifier store,
      Setting setting, int? index) {
    final isEditing = index != null;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return TimePicker(
          initialDateTime: isEditing
              ? setting.reminderTimes[index].dateTime()
              : const ReminderTime(hour: 20, minute: 0).dateTime(),
          done: (dateTime) {
            if (isEditing) {
              store.asyncAction
                  .editReminderTime(
                    index: index,
                    reminderTime: ReminderTime(
                        hour: dateTime.hour, minute: dateTime.minute),
                    setting: setting,
                  )
                  .catchError((error) => showErrorAlertFor(context, error));
            } else {
              store.asyncAction
                  .addReminderTimes(
                      reminderTime: ReminderTime(
                          hour: dateTime.hour, minute: dateTime.minute),
                      setting: setting)
                  .catchError((error) => showErrorAlertFor(context, error));
            }

            Navigator.pop(context);
          },
        );
      },
    );
  }
}

extension ReminderTimesPageRoute on ReminderTimesPage {
  static Route<dynamic> route({
    required SettingStateNotifier store,
  }) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: "ReminderTimesPage"),
      builder: (_) => ReminderTimesPage(store: store),
    );
  }
}
