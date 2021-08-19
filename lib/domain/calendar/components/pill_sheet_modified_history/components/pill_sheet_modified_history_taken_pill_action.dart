import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_date_component.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/taken_pill_action_o_list.dart';
import 'package:pilll/entity/pill_sheet.dart';
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
            children: [
              PillSheetModifiedHistoryDate(
                estimatedEventCausingDate: estimatedEventCausingDate,
                effectivePillNumber:
                    PillSheetModifiedHistoryDateEffectivePillNumber.taken(
                        value),
              ),
              Spacer(),
              Container(
                constraints: BoxConstraints(
                  maxWidth:
                      PillSheetModifiedHistoryTakenActionLayoutWidths.trailing,
                ),
                child: Row(
                  children: [
                    Container(
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
                    Spacer(),
                    Container(
                      width: PillSheetModifiedHistoryTakenActionLayoutWidths
                          .takenMark,
                      padding: EdgeInsets.only(left: 8),
                      child: TakenPillActionOList(
                          value: value, afterPillSheet: afterPillSheet),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
