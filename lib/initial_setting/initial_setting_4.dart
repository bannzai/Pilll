import 'package:Pilll/main/application/router.dart';
import 'package:Pilll/model/app_state.dart';
import 'package:Pilll/model/initial_setting.dart';
import 'package:Pilll/style/button.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:Pilll/util/formatter/date_time_formatter.dart';
import 'package:Pilll/util/shared_preference/toolbar/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InitialSetting4 extends StatefulWidget {
  @override
  _InitialSetting4State createState() => _InitialSetting4State();
}

class _InitialSetting4State extends State<InitialSetting4> {
  @override
  void initState() {
    var model = AppState.read(context);
    if (_notYetSetTime(model.initialSetting)) {
      model.initialSetting.reminderHour = 22;
      model.initialSetting.reminderMinute = 0;
    }
    super.initState();
  }

  bool _notYetSetTime(InitialSettingModel model) {
    return model.reminderMinute == null || model.reminderHour == null;
  }

  Widget _time(BuildContext context) {
    var dateTime = AppState.watch(context).initialSetting.reminderDateTime();
    return Text(
      DateTimeFormatter.militaryTime(dateTime),
      style: FontType.largeNumber.merge(
        TextStyle(
          decoration: TextDecoration.underline,
          color: TextColor.black,
        ),
      ),
    );
  }

  void _showDurationModalSheet(BuildContext context) {
    var model = AppState.read(context);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return DateTimePicker(
          initialDateTime: model.initialSetting.reminderDateTime(),
          done: (dateTime) {
            setState(() {
              model.initialSetting.reminderHour = dateTime.hour;
              model.initialSetting.reminderMinute = dateTime.minute;
              Navigator.pop(context);
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var model = AppState.watch(context);
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
                        _showDurationModalSheet(context);
                      },
                      child: _time(context),
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
                      model.initialSetting.isOnReminder = true;
                      model.initialSetting
                          .register()
                          .then((_) => Router.endInitialSetting(context));
                    },
                  ),
                  TertiaryButton(
                    text: "スキップ",
                    onPressed: () {
                      model.initialSetting.isOnReminder = false;
                      model.initialSetting
                          .register()
                          .then((_) => Router.endInitialSetting(context));
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
