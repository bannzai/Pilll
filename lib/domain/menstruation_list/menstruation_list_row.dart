import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/menstruation_edit/menstruation_edit_page.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';

class MenstruationListRow extends StatelessWidget {
  final Menstruation menstruation;
  final Menstruation? previousMenstruation;
  final String? prefix;

  const MenstruationListRow({
    Key? key,
    required this.menstruation,
    required this.previousMenstruation,
    required this.prefix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showMenstruationEditPage(context, menstruation: menstruation);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (prefix != null) Text(prefix ?? "", style: FontType.descriptionBold.merge(TextColorStyle.main)),
              Text(_dateRange, style: FontType.description.merge(TextColorStyle.main)),
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
    return "(${DateTimeFormatter.monthAndDay(menstruation.beginDate)} - ${DateTimeFormatter.monthAndDay(menstruation.endDate)})";
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
