import 'dart:math';

import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/util/toolbar/picker_toolbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class SettingMenstruationDynamicDescriptionConstants {
  static final List<String> durationList = ["-", ...List<String>.generate(7, (index) => (index + 1).toString())];
}

class SettingMenstruationDynamicDescription extends StatelessWidget {
  final List<PillSheetType> pillSheetTypes;
  final int fromMenstruation;
  final int durationMenstruation;
  final void Function(int from) fromMenstructionDidDecide;
  final void Function(int duration) durationMenstructionDidDecide;

  const SettingMenstruationDynamicDescription({
    Key? key,
    required this.pillSheetTypes,
    required this.fromMenstruation,
    required this.durationMenstruation,
    required this.fromMenstructionDidDecide,
    required this.durationMenstructionDidDecide,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("ピル番号 ", style: FontType.assisting.merge(TextColorStyle.main)),
            GestureDetector(
              onTap: () => _showFromModalSheet(context),
              child: _from(),
            ),
            Text(" 番ごとに", style: FontType.assisting.merge(TextColorStyle.main)),
          ],
        ),
        Text("何日間生理が続く？",
            style: const TextStyle(
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ).merge(TextColorStyle.main)),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () => _showDurationModalSheet(context),
              child: _duration(),
            ),
            Text(" 日間生理が続く", style: FontType.assisting.merge(TextColorStyle.main)),
          ],
        )
      ],
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
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(
          width: 1,
          color: PilllColors.border,
        ),
      ),
      child: Center(
        child: Text(fromString, style: FontType.inputNumber.merge(TextColorStyle.gray)),
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
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(
          width: 1,
          color: PilllColors.border,
        ),
      ),
      child: Center(
        child: Text(durationString, style: FontType.inputNumber.merge(TextColorStyle.gray)),
      ),
    );
  }

  void _showFromModalSheet(BuildContext context) {
    final maximumCount = pillSheetTypes.map((e) => e.totalCount).reduce((value, element) => value + element);
    int keepSelectedFromMenstruation = min(fromMenstruation, maximumCount);
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
            SizedBox(
              height: 200,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: CupertinoPicker(
                  itemExtent: 40,
                  children: List.generate(maximumCount + 1, (index) {
                    if (index == 0) {
                      return "-";
                    }
                    return "$index";
                  }).map(_pickerItem).toList(),
                  onSelectedItemChanged: (index) {
                    keepSelectedFromMenstruation = index;
                  },
                  scrollController: FixedExtentScrollController(initialItem: keepSelectedFromMenstruation),
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
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: CupertinoPicker(
                  itemExtent: 40,
                  children: SettingMenstruationDynamicDescriptionConstants.durationList.map(_pickerItem).toList(),
                  onSelectedItemChanged: (index) {
                    keepSelectedDurationMenstruation = index;
                  },
                  scrollController: FixedExtentScrollController(initialItem: keepSelectedDurationMenstruation),
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
