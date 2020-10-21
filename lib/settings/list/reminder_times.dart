import 'package:Pilll/main/components/setting_menstruation_page.dart';
import 'package:Pilll/model/setting.dart';
import 'package:Pilll/model/user_error.dart';
import 'package:Pilll/state/setting.dart';
import 'package:Pilll/store/setting.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:Pilll/util/formatter/date_time_formatter.dart';
import 'package:Pilll/util/shared_preference/toolbar/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
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
          children: [..._components(context), _footer(context)],
        ),
      ),
    );
  }

  List<Widget> _components(BuildContext context) {
    final state = useProvider(settingStoreProvider.state);
    return state.entity.reminderTimes
        .asMap()
        .map((offset, reminderTime) =>
            MapEntry(offset, _component(context, reminderTime, offset + 1)))
        .values
        .toList();
  }

  Widget _component(
    BuildContext context,
    ReminderTime reminderTime,
    int number,
  ) {
    final state = useProvider(settingStoreProvider.state);
    final store = useProvider(settingStoreProvider);
    return GestureDetector(
      onTap: () {
        _showPicker(context, store, state, number - 1);
      },
      child: Dismissible(
        key: Key("$number"),
        onDismissed: (direction) {
          print("delete action");
        },
        background: Container(color: Colors.red),
        child: ListTile(
          title: Text("通知$number"),
          subtitle:
              Text(DateTimeFormatter.militaryTime(reminderTime.dateTime())),
        ),
      ),
    );
  }

  Widget _footer(BuildContext context) {
    final state = useProvider(settingStoreProvider.state);
    if (state.entity.reminderTimes.length >= ReminderTime.maximumCount) {
      return Container();
    }
    final store = useProvider(settingStoreProvider);
    return GestureDetector(
      onTap: () {
        _showPicker(context, store, state, null);
      },
      child: Container(
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

  void _showPicker(BuildContext context, SettingStateStore store,
      SettingState state, int index) {
    final isEditing = index != null;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return DateTimePicker(
          initialDateTime: isEditing
              ? state.entity.reminderTimes[index].dateTime()
              : ReminderTime(hour: 22, minute: 0).dateTime(),
          done: (dateTime) {
            Navigator.pop(context);
            if (isEditing) {
              final newReminderTime =
                  ReminderTime(hour: dateTime.hour, minute: dateTime.minute);
              store.modifyReminderTimes(
                  state.entity.reminderTimes..[index] = newReminderTime);
            } else {
              store.modifyReminderTimes(state.entity.reminderTimes
                ..add(ReminderTime(
                    hour: dateTime.hour, minute: dateTime.minute)));
            }
          },
        );
      },
    );
  }
}
