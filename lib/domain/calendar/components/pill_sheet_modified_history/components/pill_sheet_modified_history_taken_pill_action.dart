import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_taken_action_layout.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

class PillSheetModifiedHistoryTakenPillAction extends StatelessWidget {
  final DateTime estimatedEventCausingDate;
  final TakenPillValue? value;
  final PillSheet afterPillSheet;

  const PillSheetModifiedHistoryTakenPillAction({
    Key? key,
    required this.estimatedEventCausingDate,
    required this.value,
    required this.afterPillSheet,
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
        analytics.logEvent(name: "tapped_history_taken_action");
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PillSheetModifiedHistoryDate(
                estimatedEventCausingDate: estimatedEventCausingDate,
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
                  final inRestDuration = _inRestDuration(
                      afterPillSheet, value.afterLastTakenPillNumber, index);
                  if (index == 0) {
                    return _centerWidget(inRestDuration
                        ? SvgPicture.asset(
                            "images/dash_o.svg",
                          )
                        : SvgPicture.asset(
                            "images/o.svg",
                          ));
                  } else {
                    return _shiftWidget(
                        inRestDuration
                            ? SvgPicture.asset("images/dash_half_o.svg")
                            : SvgPicture.asset(
                                "images/half_o.svg",
                              ),
                        index);
                  }
                }).reversed.toList()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _centerWidget(Widget picture) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        child: picture,
      ),
    );
  }

  Widget _shiftWidget(Widget picture, int index) {
    return Align(
      alignment: Alignment(0.6 * index, 0),
      child: Container(
        child: picture,
      ),
    );
  }

  bool _inRestDuration(
      PillSheet afterPillSheet, int afterLastTakenPillNumber, int index) {
    final pillNumber = afterLastTakenPillNumber - index;
    return afterPillSheet.pillSheetType.dosingPeriod < pillNumber;
  }
}
