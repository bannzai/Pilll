import 'dart:math';

import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/template/setting_menstruation/setting_menstruation_pill_sheet_list.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/util/toolbar/picker_toolbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class SettingMenstruationPageConstants {
  static final List<String> durationList = [
    "-",
    ...List<String>.generate(7, (index) => (index + 1).toString())
  ];
}

class SettingMenstruationPageModel {
  int selectedFromMenstruation;
  int selectedDurationMenstruation;
  PillSheetType pillSheetType;

  SettingMenstruationPageModel({
    required this.selectedFromMenstruation,
    required this.selectedDurationMenstruation,
    required this.pillSheetType,
  });
}

class SettingMenstruationPage extends StatefulWidget {
  final String title;
  // NOTE: If done and skip is null, button is hidden
  final String? doneText;
  final VoidCallback? done;
  final int pillSheetTotalCount;
  final int pillSheetPageCount;
  final SettingMenstruationPageModel model;
  final void Function(int from) fromMenstructionDidDecide;
  final void Function(int duration) durationMenstructionDidDecide;

  const SettingMenstruationPage({
    Key? key,
    required this.title,
    required this.doneText,
    required this.done,
    required this.pillSheetTotalCount,
    required this.pillSheetPageCount,
    required this.model,
    required this.fromMenstructionDidDecide,
    required this.durationMenstructionDidDecide,
  }) : super(key: key);

  @override
  _SettingMenstruationPageState createState() =>
      _SettingMenstruationPageState();
}

class _SettingMenstruationPageState extends State<SettingMenstruationPage> {
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
          this.widget.title,
          style: TextStyle(color: TextColor.black),
        ),
        backgroundColor: PilllColors.white,
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, viewport) {
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: viewport.maxHeight),
            child: SingleChildScrollView(
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 24),
                    Text(
                      "生理がはじまるピル番号をタップ",
                      style: FontType.sBigTitle.merge(TextColorStyle.main),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),
                    SettingMenstruationPillSheetList(
                      pillSheetCount: widget.pillSheetPageCount,
                      pillSheetType: widget.model.pillSheetType,
                      selectedPillNumber: widget.model.selectedFromMenstruation,
                      markSelected: (number) {
                        widget.fromMenstructionDidDecide(number);
                        setState(() {
                          widget.model.selectedFromMenstruation = number;
                        });
                      },
                    ),
                    SizedBox(height: 24),
                    Container(
                      height: 156,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("ピル番号 ",
                                  style: FontType.assisting
                                      .merge(TextColorStyle.main)),
                              GestureDetector(
                                onTap: () => _showFromModalSheet(context),
                                child: _from(),
                              ),
                              Text(" 番目ぐらいから",
                                  style: FontType.assisting
                                      .merge(TextColorStyle.main)),
                            ],
                          ),
                          Text("何日間生理が続く？",
                              style: FontType.assistingBold
                                  .merge(TextColorStyle.main)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => _showDurationModalSheet(context),
                                child: _duration(),
                              ),
                              Text(" 日間生理が続く",
                                  style: FontType.assisting
                                      .merge(TextColorStyle.main)),
                            ],
                          )
                        ],
                      ),
                    ),
                    if (this.widget.done != null) ...[
                      Expanded(
                        child: Container(
                          constraints: BoxConstraints(minHeight: 32),
                        ),
                      ),
                      PrimaryButton(
                        text: this.widget.doneText ?? "",
                        onPressed: this.widget.done,
                      ),
                      SizedBox(height: 35),
                    ]
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _from() {
    final from = this.widget.model.selectedFromMenstruation;
    final String fromString;
    if (from == 0) {
      fromString = "-";
    } else {
      fromString = from.toString();
    }
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        border: Border.all(
          width: 1,
          color: PilllColors.border,
        ),
      ),
      child: Center(
        child: Text(fromString,
            style: FontType.inputNumber.merge(TextColorStyle.gray)),
      ),
    );
  }

  Widget _duration() {
    final duration = this.widget.model.selectedDurationMenstruation;
    final String durationString;
    if (duration == 0) {
      durationString = "-";
    } else {
      durationString = duration.toString();
    }
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        border: Border.all(
          width: 1,
          color: PilllColors.border,
        ),
      ),
      child: Center(
        child: Text(durationString,
            style: FontType.inputNumber.merge(TextColorStyle.gray)),
      ),
    );
  }

  void _showFromModalSheet(BuildContext context) {
    int keepSelectedFromMenstruation = min(
        this.widget.model.selectedFromMenstruation,
        this.widget.pillSheetTotalCount);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PickerToolbar(
              done: (() {
                this
                    .widget
                    .fromMenstructionDidDecide(keepSelectedFromMenstruation);
                Navigator.pop(context);
                setState(() {
                  this.widget.model.selectedFromMenstruation =
                      keepSelectedFromMenstruation;
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
                  children: List.generate(this.widget.pillSheetTotalCount + 1,
                      (index) {
                    if (index == 0) {
                      return "-";
                    }
                    return "$index";
                  }).map(_pickerItem).toList(),
                  onSelectedItemChanged: (index) {
                    keepSelectedFromMenstruation = index;
                  },
                  scrollController: FixedExtentScrollController(
                      initialItem: keepSelectedFromMenstruation),
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
        this.widget.model.selectedDurationMenstruation;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PickerToolbar(
              done: (() {
                this.widget.durationMenstructionDidDecide(
                    keepSelectedDurationMenstruation);
                Navigator.pop(context);
                setState(() {
                  this.widget.model.selectedDurationMenstruation =
                      keepSelectedDurationMenstruation;
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
                  children: SettingMenstruationPageConstants.durationList
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

  Widget _pickerItem(String str) {
    return Text(str);
  }
}

extension SettingMenstruationPageRoute on SettingMenstruationPage {
  static Route<dynamic> route({
    required String title,
    required String? doneText,
    required VoidCallback? done,
    required int pillSheetTotalCount,
    required int pillSheetPageCount,
    required SettingMenstruationPageModel model,
    required void Function(int from) fromMenstructionDidDecide,
    required void Function(int duration) durationMenstructionDidDecide,
  }) {
    return MaterialPageRoute(
      settings: RouteSettings(name: "SettingMenstruationPage"),
      builder: (_) => SettingMenstruationPage(
        title: title,
        doneText: doneText,
        done: done,
        pillSheetTotalCount: pillSheetTotalCount,
        pillSheetPageCount: pillSheetPageCount,
        model: model,
        fromMenstructionDidDecide: fromMenstructionDidDecide,
        durationMenstructionDidDecide: durationMenstructionDidDecide,
      ),
    );
  }
}
