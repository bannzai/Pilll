import 'package:Pilll/model/initial_setting.dart';
import 'package:Pilll/store/initial_setting.dart';
import 'package:Pilll/store/setting.dart';
import 'package:Pilll/style/button.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:Pilll/util/formatter/date_time_formatter.dart';
import 'package:Pilll/util/shared_preference/toolbar/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';

class InitialSetting4 extends HookWidget {
  bool _notYetSetTime(InitialSettingModel model) {
    return model.reminderMinute == null || model.reminderHour == null;
  }

  Widget _time(BuildContext context, InitialSettingModel entity) {
    return Text(
      DateTimeFormatter.militaryTime(entity.reminderDateTime()),
      style: FontType.largeNumber.merge(
        TextStyle(
          decoration: TextDecoration.underline,
          color: TextColor.black,
        ),
      ),
    );
  }

  void _showDurationModalSheet(
    BuildContext context,
    InitialSettingModel entity,
    InitialSettingStateStore store,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return DateTimePicker(
          initialDateTime: entity.reminderDateTime(),
          done: (dateTime) {
            store.modify((model) => model
              ..copyWith(
                  reminderHour: dateTime.hour,
                  reminderMinute: dateTime.minute));
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = useProvider(initialSettingStoreProvider);
    final state = useProvider(initialSettingStoreProvider.state);
    if (_notYetSetTime(state.entity)) {
      store.modify(
          (model) => model..copyWith(reminderHour: 22, reminderMinute: 0));
    }
    final settingStore = useProvider(settingStoreProvider);
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "4/4",
          style: TextStyle(color: TextColor.black),
        ),
        backgroundColor: PilllColors.background,
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 24),
              Text(
                "ピルの飲み忘れ通知",
                style: FontType.title.merge(TextColorStyle.standard),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              Container(
                height: 77,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("通知時刻"),
                    GestureDetector(
                      onTap: () {
                        _showDurationModalSheet(context, state.entity, store);
                      },
                      child: _time(context, state.entity),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Wrap(
                direction: Axis.vertical,
                spacing: 8,
                children: <Widget>[
                  PrimaryButton(
                    text: "設定",
                    onPressed: () {
                      settingStore
                          .register(state.entity..copyWith(isOnReminder: true));
                    },
                  ),
                  TertiaryButton(
                    text: "スキップ",
                    onPressed: () {
                      settingStore.register(
                          state.entity..copyWith(isOnReminder: false));
                    },
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
