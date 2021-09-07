import 'dart:math';

import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/template/setting_menstruation/setting_menstruation_pill_sheet_list.dart';
import 'package:pilll/components/organisms/pill_sheet/setting_pill_sheet_view.dart';
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
  final int pillSheetPageCount;
  final bool isOnSequenceAppearance;
  final SettingMenstruationPillSheetList pillSheetList;
  final SettingPillSheetView pillSheetView;
  final SettingMenstruationDynamicDescription dynamicDescription;
  final PrimaryButton? doneButton;

  const SettingMenstruationPage({
    Key? key,
    required this.title,
    required this.pillSheetPageCount,
    required this.isOnSequenceAppearance,
    required this.pillSheetList,
    required this.pillSheetView,
    required this.dynamicDescription,
    required this.doneButton,
  }) : super(key: key);

  @override
  _SettingMenstruationPageState createState() =>
      _SettingMenstruationPageState();
}

class _SettingMenstruationPageState extends State<SettingMenstruationPage> {
  @override
  Scaffold build(BuildContext context) {
    final doneButton = this.widget.doneButton;
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
                    () {
                      if (widget.isOnSequenceAppearance)
                        return widget.pillSheetList;
                      else
                        return widget.pillSheetView;
                    }(),
                    SizedBox(height: 24),
                    widget.dynamicDescription,
                    if (doneButton != null) ...[
                      Expanded(
                        child: Container(
                          constraints: BoxConstraints(minHeight: 32),
                        ),
                      ),
                      doneButton,
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

class SettingMenstruationDynamicDescription extends StatelessWidget {
  final int fromMenstruation;
  final int durationMenstruation;
  final PillSheetType pillSheetType;
  final void Function(int from) fromMenstructionDidDecide;
  final void Function(int duration) durationMenstructionDidDecide;

  const SettingMenstruationDynamicDescription({
    Key? key,
    required this.fromMenstruation,
    required this.durationMenstruation,
    required this.pillSheetType,
    required this.fromMenstructionDidDecide,
    required this.durationMenstructionDidDecide,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 156,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("ピル番号 ",
                  style: FontType.assisting.merge(TextColorStyle.main)),
              GestureDetector(
                onTap: () => _showFromModalSheet(context),
                child: _from(),
              ),
              Text(" 番目ぐらいから",
                  style: FontType.assisting.merge(TextColorStyle.main)),
            ],
          ),
          Text("何日間生理が続く？",
              style: FontType.assistingBold.merge(TextColorStyle.main)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () => _showDurationModalSheet(context),
                child: _duration(),
              ),
              Text(" 日間生理が続く",
                  style: FontType.assisting.merge(TextColorStyle.main)),
            ],
          )
        ],
      ),
    );
  }

  Widget _from() {
    final String fromString;
    if (fromMenstruation == 0) {
      fromString = "-";
    } else {
      fromString = fromMenstruation.toString();
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
    final String durationString;
    if (durationMenstruation == 0) {
      durationString = "-";
    } else {
      durationString = durationMenstruation.toString();
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
    int keepSelectedFromMenstruation =
        min(fromMenstruation, pillSheetType.totalCount);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PickerToolbar(
              done: (() {
                fromMenstructionDidDecide(keepSelectedFromMenstruation);
                Navigator.pop(context);
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
                  children:
                      List.generate(pillSheetType.totalCount + 1, (index) {
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
    var keepSelectedDurationMenstruation = durationMenstruation;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PickerToolbar(
              done: (() {
                durationMenstructionDidDecide(keepSelectedDurationMenstruation);
                Navigator.pop(context);
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
