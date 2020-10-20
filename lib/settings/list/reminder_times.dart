import 'package:Pilll/model/setting.dart';
import 'package:Pilll/store/setting.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:Pilll/util/formatter/date_time_formatter.dart';
import 'package:Pilll/util/shared_preference/toolbar/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';

class ReminderTimes extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "通知時間",
          style: TextStyle(color: TextColor.black),
        ),
        backgroundColor: PilllColors.background,
      ),
      body: Container(
        child: ListView(
          children: _components(context),
        ),
      ),
    );
  }

  List<Widget> _components(BuildContext context) {
    final state = useProvider(settingStoreProvider.state);
    return [
      _component(state.entity, 1),
    ];
  }

  Widget _component(Setting setting, int number) {
    return ListTile(
      title: Text("通知$number"),
      subtitle:
          Text(DateTimeFormatter.militaryTime(setting.reminderDateTime())),
    );
  }

  void _showPicker(BuildContext context) {
    final state = useProvider(settingStoreProvider.state);
    final store = useProvider(settingStoreProvider);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return DateTimePicker(
          initialDateTime: state.entity.reminderDateTime(),
          done: (dateTime) {
            Navigator.pop(context);
            store.modifyReminderTime(
              ReminderTime(hour: dateTime.hour, minute: dateTime.minute),
            );
          },
        );
      },
    );
  }
}
