import 'package:Pilll/main/application/router.dart';
import 'package:Pilll/model/auth_user.dart';
import 'package:Pilll/model/setting.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:Pilll/util/formatter/date_time_formatter.dart';
import 'package:Pilll/util/shared_preference/toolbar/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitialSetting4 extends StatefulWidget {
  @override
  _InitialSetting4State createState() => _InitialSetting4State();
}

class _InitialSetting4State extends State<InitialSetting4> {
  @override
  void initState() {
    var model = Provider.of<AuthUser>(context, listen: false).user.setting;
    if (_notYetSetTime(model)) {
      model.reminderHour = 22;
      model.reminderMinute = 0;
    }
    super.initState();
  }

  bool _notYetSetTime(Setting model) {
    return model.reminderMinute == null || model.reminderHour == null;
  }

  Widget _time(BuildContext context) {
    var dateTime = Provider.of<AuthUser>(context, listen: false)
        .user
        .setting
        .reminderDateTime();
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
    var model = Provider.of<AuthUser>(context, listen: false).user.setting;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return DateTimePicker(
          initialDateTime: model.reminderDateTime(),
          done: (dateTime) {
            setState(() {
              model.reminderHour = dateTime.hour;
              model.reminderMinute = dateTime.minute;
              Navigator.pop(context);
            });
          },
        );
      },
    );
  }

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
                  RaisedButton(
                    child: Text(
                      "設定",
                    ),
                    onPressed: () {
                      var model = Provider.of<AuthUser>(context, listen: false)
                          .user
                          .setting;
                      model.isOnReminder = true;
                      model
                          .register()
                          .then((_) => Router.endInitialSetting(context));
                    },
                  ),
                  FlatButton(
                    child: Text("スキップ"),
                    textColor: TextColor.gray,
                    onPressed: () {
                      var model = Provider.of<AuthUser>(context, listen: false)
                          .user
                          .setting;
                      model.isOnReminder = false;
                      model
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
