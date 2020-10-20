import 'package:Pilll/model/setting.dart';
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
          children: [..._components(context), _footer()],
        ),
      ),
    );
  }

  List<Widget> _components(BuildContext context) {
    final state = useProvider(settingStoreProvider.state);
    return state.entity.reminderTimes
        .asMap()
        .map((offset, reminderTime) =>
            MapEntry(offset, _component(reminderTime, offset + 1)))
        .values
        .toList();
  }

  Widget _component(ReminderTime reminderTime, int number) {
    return Dismissible(
      key: Key("$number"),
      onDismissed: (direction) {
        print("delete action");
      },
      background: Container(color: Colors.red),
      child: ListTile(
        title: Text("通知$number"),
        subtitle: Text(DateTimeFormatter.militaryTime(reminderTime.dateTime())),
      ),
    );
  }

  Widget _footer() {
    return GestureDetector(
      onTap: () {},
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

  void _showPicker(BuildContext context, int index) {
    final state = useProvider(settingStoreProvider.state);
    final store = useProvider(settingStoreProvider);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return DateTimePicker(
          initialDateTime: state.entity.reminderTimes[index].dateTime(),
          done: (dateTime) {
            Navigator.pop(context);
            final newReminderTime =
                ReminderTime(hour: dateTime.hour, minute: dateTime.minute);
            store.modifyReminderTimes(
                state.entity.reminderTimes..[index] = newReminderTime);
          },
        );
      },
    );
  }
}
