import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:Pilll/util/shared_preference/toolbar/picker_toolbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class SettingMenstruationPageConstants {
  static final List<String> fromList =
      List<String>.generate(8, (index) => index.toString());
  static final List<String> durationList =
      List<String>.generate(7, (index) => (index + 1).toString());
}

class SettingMenstruationPage extends StatelessWidget {
  final String doneText;
  final VoidCallback done;
  // NOTE: If skip is null, SkipButton is hidden
  final VoidCallback skip;
  final int selectedFromMenstruation;
  final void Function(int from) fromMenstructionDidDecide;
  final int selectedDurationMenstruation;
  final void Function(int duration) durationMenstructionDidDecide;

  const SettingMenstruationPage(
      {Key key,
      this.doneText,
      this.done,
      this.skip,
      this.fromMenstructionDidDecide,
      this.durationMenstructionDidDecide,
      this.selectedFromMenstruation,
      this.selectedDurationMenstruation})
      : super(key: key);

  @override
  Scaffold build(BuildContext context) {
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
                          onTap: () => _showFromModalSheet(context),
                          child: _from(),
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
                          onTap: () => _showDurationModalSheet(context),
                          child: _duration(),
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
                        doneText,
                      ),
                      onPressed: !canNext(context) ? null : done),
                  if (skip != null)
                    FlatButton(
                      child: Text("スキップ"),
                      textColor: TextColor.gray,
                      onPressed: skip,
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

  Widget _from() {
    bool isNotYetSetValue = selectedFromMenstruation == null;
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
        selectedFromMenstruation.toString(),
        style: FontType.inputNumber.merge(
          TextStyle(decoration: TextDecoration.underline),
        ),
      );
    }
  }

  Widget _duration() {
    bool isNotYetSetValue = selectedDurationMenstruation == null;
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
        selectedDurationMenstruation.toString(),
        style: FontType.inputNumber.merge(
          TextStyle(decoration: TextDecoration.underline),
        ),
      );
    }
  }

  void _showFromModalSheet(BuildContext context) {
    int keepSelectedDurationMenstruation = this.selectedFromMenstruation ?? 0;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PickerToolbar(
              done: (() =>
                  fromMenstructionDidDecide(keepSelectedDurationMenstruation)),
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
                  children: SettingMenstruationPageConstants.fromList
                      .map(_pickerItem)
                      .toList(),
                  onSelectedItemChanged: (index) {
                    keepSelectedDurationMenstruation = index;
                  },
                  scrollController: FixedExtentScrollController(
                      initialItem: keepSelectedDurationMenstruation),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDurationModalSheet(BuildContext context) {
    var keepSelectedDurationMenstruation =
        this.selectedDurationMenstruation ?? 1;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PickerToolbar(
              done: (() => durationMenstructionDidDecide(
                  keepSelectedDurationMenstruation)),
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
                  children: SettingMenstruationPageConstants.durationList
                      .map(_pickerItem)
                      .toList(),
                  onSelectedItemChanged: (index) {
                    keepSelectedDurationMenstruation = index + 1;
                  },
                  scrollController: FixedExtentScrollController(
                      initialItem: keepSelectedDurationMenstruation - 1),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool canNext(BuildContext context) {
    return !(selectedFromMenstruation == null ||
        selectedDurationMenstruation == null);
  }

  String _blank() {
    return "    ";
  }

  Widget _pickerItem(String str) {
    return Text(str);
  }
}
