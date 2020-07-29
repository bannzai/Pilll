import 'package:Pilll/theme/color.dart';
import 'package:Pilll/initial_setting/initial_setting.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
                    print(value);
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
                style: FontType.title.merge(TextColorStyle.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 132),
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
              SizedBox(height: 178),
              FlatButton(
                disabledColor: PilllColors.disable,
                color: PilllColors.enable,
                child: Container(
                  width: 180,
                  height: 44,
                  child: Center(
                      child: Text(
                    "設定",
                    style: FontType.done.merge(TextColorStyle.white),
                  )),
                ),
                onPressed: !_canNext(context)
                    ? null
                    : context.watch<InitialSettingModel>().done,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
