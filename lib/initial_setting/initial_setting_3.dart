import 'package:Pilll/main/application/router.dart';
import 'package:Pilll/model/setting.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/initial_setting/initial_setting.dart';
import 'package:Pilll/initial_setting/initial_setting_4.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:Pilll/util/shared_preference/toolbar/picker_toolbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitialSetting3 extends StatefulWidget {
  @override
  _InitialSetting3State createState() => _InitialSetting3State();
}

class _InitialSetting3State extends State<InitialSetting3> {
  final List<String> _fromList =
      List<String>.generate(8, (index) => index.toString());

  final List<String> _durationList =
      List<String>.generate(7, (index) => (index + 1).toString());

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
          "3/4",
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
                "生理について教えてください",
                style: FontType.title.merge(TextColorStyle.standard),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              Container(
                height: 156,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("いつから生理がはじまる？",
                        style:
                            FontType.assistingBold.merge(TextColorStyle.black)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("偽薬期間に入って",
                            style:
                                FontType.assisting.merge(TextColorStyle.gray)),
                        GestureDetector(
                          onTap: showFromModalSheet,
                          child: _from(context),
                        ),
                        Text("日後ぐらいから",
                            style:
                                FontType.assisting.merge(TextColorStyle.gray)),
                      ],
                    ),
                    Text("何日間生理が続く？",
                        style:
                            FontType.assistingBold.merge(TextColorStyle.black)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: showDurationModalSheet,
                          child: _duration(context),
                        ),
                        Text("日間生理が続く",
                            style:
                                FontType.assisting.merge(TextColorStyle.gray)),
                      ],
                    )
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
                      "次へ",
                    ),
                    onPressed: !canNext(context)
                        ? null
                        : () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return InitialSetting4();
                                },
                              ),
                            );
                          },
                  ),
                  FlatButton(
                    child: Text("スキップ"),
                    textColor: TextColor.gray,
                    onPressed: () {
                      Provider.of<Setting>(context, listen: false)
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

  Widget _from(BuildContext context) {
    Setting model = Provider.of<Setting>(context, listen: false);
    bool isNotYetSetValue = model.fromMenstruation == null;
    if (isNotYetSetValue) {
      return Text(
        _blank(),
        style: FontType.inputNumber.merge(
          TextStyle(
              decoration: TextDecoration.underline, color: TextColor.lightGray),
        ),
      );
    } else {
      return Text(
        model.fromMenstruation.toString(),
        style: FontType.inputNumber.merge(
          TextStyle(decoration: TextDecoration.underline),
        ),
      );
    }
  }

  Widget _duration(BuildContext context) {
    Setting model = Provider.of<Setting>(context, listen: false);
    bool isNotYetSetValue = model.durationMenstruation == null;
    if (isNotYetSetValue) {
      return Text(
        _blank(),
        style: FontType.inputNumber.merge(
          TextStyle(
              decoration: TextDecoration.underline, color: TextColor.lightGray),
        ),
      );
    } else {
      return Text(
        model.durationMenstruation.toString(),
        style: FontType.inputNumber.merge(
          TextStyle(decoration: TextDecoration.underline),
        ),
      );
    }
  }

  void showFromModalSheet() {
    var model = Provider.of<Setting>(context, listen: false);
    int selectedFromMenstruction =
        model.fromMenstruation == null ? 0 : model.fromMenstruation;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PickerToolbar(
              done: (() {
                setState(() {
                  model.fromMenstruation = selectedFromMenstruction;
                  Navigator.pop(context);
                });
              }),
              cancel: (() {
                Navigator.pop(context);
              }),
            ),
            Container(
              height: 200,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: CupertinoPicker(
                  itemExtent: 40,
                  children: _fromList.map(_pickerItem).toList(),
                  onSelectedItemChanged: (index) {
                    selectedFromMenstruction = index;
                  },
                  scrollController: FixedExtentScrollController(
                      initialItem: selectedFromMenstruction),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showDurationModalSheet() {
    var model = Provider.of<Setting>(context, listen: false);
    var selectedDurationMenstruation =
        model.durationMenstruation == null ? 1 : model.durationMenstruation;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PickerToolbar(
              done: (() {
                setState(() {
                  model.durationMenstruation = selectedDurationMenstruation;
                  Navigator.pop(context);
                });
              }),
              cancel: (() {
                Navigator.pop(context);
              }),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 3,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: CupertinoPicker(
                  itemExtent: 40,
                  children: _durationList.map(_pickerItem).toList(),
                  onSelectedItemChanged: (index) {
                    selectedDurationMenstruation = index + 1;
                  },
                  scrollController: FixedExtentScrollController(
                      initialItem: selectedDurationMenstruation - 1),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool canNext(BuildContext context) {
    Setting model = Provider.of<Setting>(context, listen: false);
    return !(model.fromMenstruation == null ||
        model.durationMenstruation == null);
  }

  String _blank() {
    return "    ";
  }

  Widget _pickerItem(String str) {
    return Text(str);
  }
}
