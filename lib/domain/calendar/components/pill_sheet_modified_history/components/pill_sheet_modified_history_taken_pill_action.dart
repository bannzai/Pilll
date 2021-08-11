import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_taken_action_layout.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:pilll/util/toolbar/date_time_picker.dart';

class PillSheetModifiedHistoryTakenPillAction extends StatelessWidget {
  final DateTime estimatedEventCausingDate;
  final TakenPillValue? value;
  final PillSheet afterPillSheet;
  final Function(DateTime) onPickerItemSelect;

  const PillSheetModifiedHistoryTakenPillAction({
    Key? key,
    required this.estimatedEventCausingDate,
    required this.value,
    required this.afterPillSheet,
    required this.onPickerItemSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value = this.value;
    if (value == null) {
      return Container();
    }
    final time = DateTimeFormatter.hourAndMinute(value.afterLastTakenDate);
    return GestureDetector(
      onTap: () {
        _showPicker(context);
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PillSheetModifiedHistoryDate(
                createdAt: estimatedEventCausingDate,
                beforePillNumber: value.beforeLastTakenPillNumber,
                afterPillNumber: value.afterLastTakenPillNumber,
              ),
              Container(
                width:
                    PillSheetModifiedHistoryTakenActionLayoutWidths.takenTime,
                child: Text(
                  time,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: TextColor.main,
                    fontSize: 15,
                    fontFamily: FontFamily.number,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Container(
                width:
                    PillSheetModifiedHistoryTakenActionLayoutWidths.takenMark,
                padding: EdgeInsets.only(left: 8),
                child: Stack(
                    children: List.generate(
                        value.afterLastTakenPillNumber -
                            (value.beforeLastTakenPillNumber ?? 1), (index) {
                  final child = _inRestDuration(afterPillSheet,
                          value.afterLastTakenPillNumber - index)
                      ? SvgPicture.asset("images/dot_o.svg")
                      : SvgPicture.asset("images/o.svg");

                  final alignment = index == 0
                      ? Alignment.center
                      : Alignment(-0.3 * index, 0);
                  return Align(
                      alignment: alignment,
                      child: Container(
                        color: Colors.white,
                        child: child,
                      ));
                }).reversed.toList()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _inRestDuration(PillSheet pillSheet, int pillNumber) {
    return pillSheet.pillSheetType.dosingPeriod < pillNumber;
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return DateTimePicker(
          initialDateTime: estimatedEventCausingDate,
          done: (dateTime) {
            Navigator.pop(context);
            onPickerItemSelect(dateTime);
          },
          mode: CupertinoDatePickerMode.dateAndTime,
        );
      },
    );
  }
}
