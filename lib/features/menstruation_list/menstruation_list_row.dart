import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/menstruation_edit/menstruation_edit_page.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:pilll/utils/datetime/date_add.dart';

class MenstruationListRow extends StatelessWidget {
  final Menstruation menstruation;
  final Menstruation? previousMenstruation;

  const MenstruationListRow({
    Key? key,
    required this.menstruation,
    required this.previousMenstruation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final dateTimeRange = await showModalBottomSheet<DateTimeRange?>(
            context: context,
            builder: (context) {
              return DateRangePickerDialog(
                initialDateRange: DateTimeRange(start: today(), end: today().addDays(3)),
                firstDate: DateTime.parse("2020-01-01"),
                lastDate: today().addDays(30),
                fieldStartLabelText: "生理開始日",
                fieldEndLabelText: "生理終了予定日",
                confirmText: "記録する",
                saveText: "OK",
              );
            });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(_dateRange,
                  style: const TextStyle(fontFamily: FontFamily.japanese, fontWeight: FontWeight.w400, fontSize: 12, color: TextColor.main)),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            width: _dotLineWidth,
            decoration: BoxDecoration(
              color: PilllColors.tinBackground,
              borderRadius: BorderRadius.circular(26),
            ),
            height: 20,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  ...List.generate(
                    menstruation.dateRange.days + 1,
                    (index) {
                      return [_circle(), const SizedBox(width: 4)];
                    },
                  ).expand((element) => element).toList(),
                  const Spacer(),
                  Text(
                    _duration,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      color: TextColor.main,
                      fontFamily: FontFamily.number,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circle() {
    return Container(
      decoration: BoxDecoration(
        color: PilllColors.menstruation,
        borderRadius: BorderRadius.circular(6),
      ),
      width: 12,
      height: 12,
    );
  }

  String get _dateRange {
    return "${DateTimeFormatter.monthAndDay(menstruation.beginDate)} - ${DateTimeFormatter.monthAndDay(menstruation.endDate)}";
  }

  String get _duration {
    final menstruationDuration = _menstruationDuration;
    if (menstruationDuration == null) {
      return "-";
    }
    return "$menstruationDuration日周期";
  }

  double get _dotLineWidth {
    const double widthForDay = 10;
    final menstruationDuration = _menstruationDuration;
    if (menstruationDuration == null) {
      return widthForDay * 28;
    }
    return widthForDay * menstruationDuration;
  }

  int? get _menstruationDuration => menstruationsDiff(menstruation, previousMenstruation);
}
