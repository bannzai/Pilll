import 'dart:math';

import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/components/picker/picker_toolbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pilll/features/localizations/l.dart';

abstract class SettingMenstruationDynamicDescriptionConstants {
  // NOTE: 30日という上限値は特に医学的根拠があるわけではなく、十分な選択肢を提供するための適当な値です
  static final List<String> durationList = [
    '-',
    ...List<String>.generate(30, (index) => (index + 1).toString()),
  ];
}

class SettingMenstruationDynamicDescription extends StatelessWidget {
  final List<PillSheetType> pillSheetTypes;
  final int fromMenstruation;
  final int durationMenstruation;
  final void Function(int from) fromMenstructionDidDecide;
  final void Function(int duration) durationMenstructionDidDecide;

  const SettingMenstruationDynamicDescription({
    super.key,
    required this.pillSheetTypes,
    required this.fromMenstruation,
    required this.durationMenstruation,
    required this.fromMenstructionDidDecide,
    required this.durationMenstructionDidDecide,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const SizedBox(height: 20),
        // TODO: [Localizations]
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${L.pillNumber} ',
              style: const TextStyle(
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: TextColor.main,
              ),
            ),
            GestureDetector(onTap: () => _showPicker(context), child: _from()),
            Text(
              ' ${L.perNumber}',
              style: const TextStyle(
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: TextColor.main,
              ),
            ),
          ],
        ),
        Text(
          L.howManyDaysDoesMenstruationLast,
          style: const TextStyle(
            fontFamily: FontFamily.japanese,
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: TextColor.main,
          ),
        ),
        const SizedBox(height: 4),
        // TODO: [Localizations]
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () => _showDurationModalSheet(context),
              child: _duration(),
            ),
            Text(
              ' ${L.daysMenstruationLasts}',
              style: const TextStyle(
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: TextColor.main,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _from() {
    final String fromString;
    if (fromMenstruation == 0) {
      fromString = '-';
    } else {
      fromString = fromMenstruation.toString();
    }
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(width: 1, color: AppColors.border),
      ),
      child: Center(
        child: Text(
          fromString,
          style: const TextStyle(
            fontFamily: FontFamily.japanese,
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: TextColor.gray,
          ),
        ),
      ),
    );
  }

  Widget _duration() {
    final String durationString;
    if (durationMenstruation == 0) {
      durationString = '-';
    } else {
      durationString = durationMenstruation.toString();
    }
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(width: 1, color: AppColors.border),
      ),
      child: Center(
        child: Text(
          durationString,
          style: const TextStyle(
            fontFamily: FontFamily.japanese,
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: TextColor.gray,
          ),
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
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
                  onSelectedItemChanged: (index) {
                    keepSelectedFromMenstruation = index;
                  },
                  scrollController: FixedExtentScrollController(
                    initialItem: keepSelectedFromMenstruation,
                  ),
                  children: List.generate(maximumCount + 1, (index) {
                    if (index == 0) {
                      return '-';
                    }
                    return '$index';
                  }).map(_pickerItem).toList(),
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
                  onSelectedItemChanged: (index) {
                    keepSelectedDurationMenstruation = index;
                  },
                  scrollController: FixedExtentScrollController(
                    initialItem: keepSelectedDurationMenstruation,
                  ),
                  children: SettingMenstruationDynamicDescriptionConstants.durationList.map(_pickerItem).toList(),
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
