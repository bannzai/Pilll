import 'package:Pilll/components/molecules/indicator.dart';
import 'package:Pilll/entity/setting.dart';
import 'package:Pilll/state/setting.dart';
import 'package:Pilll/store/setting.dart';
import 'package:Pilll/components/atoms/color.dart';
import 'package:Pilll/components/atoms/font.dart';
import 'package:Pilll/components/atoms/text_color.dart';
import 'package:Pilll/util/formatter/date_time_formatter.dart';
import 'package:Pilll/util/toolbar/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReminderTimesPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final state = useProvider(settingStoreProvider.state);
    if (state.entity == null) {
      return Indicator();
    }
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
      body: SafeArea(
        child: Container(
          child: ListView(
            children: [
              ..._components(context, state).map((e) {
                return [e, _separator()];
              }).expand((element) => element),
              _footer(context),
              _separator(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _components(BuildContext context, SettingState state) {
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

    Widget body = GestureDetector(
      onTap: () {
        _showPicker(context, store, state, number - 1);
      },
      child: ListTile(
        title: Text("通知$number"),
        subtitle: Text(DateTimeFormatter.militaryTime(reminderTime.dateTime())),
      ),
    );
    if (state.entity.reminderTimes.length == 1) {
      return body;
    }
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: state.entity.reminderTimes.length == 1
          ? null
          : (direction) {
              store.deleteReminderTimes(number - 1);
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
              store.editReminderTime(index,
                  ReminderTime(hour: dateTime.hour, minute: dateTime.minute));
            } else {
              store.addReminderTimes(
                  ReminderTime(hour: dateTime.hour, minute: dateTime.minute));
            }
          },
        );
      },
    );
  }
}

extension ReminderTimesPageRoute on ReminderTimesPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: "ReminderTimesPage"),
      builder: (_) => ReminderTimesPage(),
    );
  }
}
