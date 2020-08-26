import 'package:Pilll/main/application/router.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/initial_setting/initial_setting.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:Pilll/util/shared_preference/keys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialSetting4 extends StatefulWidget {
  @override
  _InitialSetting4State createState() => _InitialSetting4State();
}

class _InitialSetting4State extends State<InitialSetting4> {
  bool _canNext(BuildContext context) {
    var model = Provider.of<InitialSettingModel>(context, listen: false);
    return !(model.hour == null || model.minute == null);
  }

  String timeString(BuildContext context) {
    int minute = 0;
    int hour = 22;
    var model = Provider.of<InitialSettingModel>(context, listen: false);
    if (model.minute != null) {
      minute = model.minute;
    }
    if (model.hour != null) {
      hour = model.hour;
    }
    var formatter = NumberFormat("00");
    return formatter.format(hour) + ":" + formatter.format(minute);
  }

  DateTime defaultDateTime() {
    var t = DateTime.now().toLocal();
    return DateTime(
        t.year, t.month, t.day, 22, 0, t.second, t.millisecond, t.microsecond);
  }

  void _done() {
    Navigator.popAndPushNamed(context, Routes.main);
  }

  void _showDurationModalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: CupertinoDatePicker(
                use24hFormat: true,
                minuteInterval: 10,
                initialDateTime: defaultDateTime(),
                mode: CupertinoDatePickerMode.time,
                onDateTimeChanged: (DateTime value) {
                  setState(() {
                    var model = Provider.of<InitialSettingModel>(context,
                        listen: false);
                    model.hour = value.hour;
                    model.minute = value.minute;
                  });
                },
              )),
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
                      child: Text(
                        timeString(context),
                        style: FontType.largeNumber
                            .merge(TextColorStyle.black)
                            .merge(
                              TextStyle(
                                decoration: TextDecoration.underline,
                                color: PilllColors.lightGray,
                              ),
                            ),
                      ),
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
                    onPressed: !_canNext(context) ? null : _done,
                  ),
                  FlatButton(
                    child: Text("スキップ"),
                    textColor: TextColor.gray,
                    onPressed: _done,
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
