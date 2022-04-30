import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/domain/menstruation_edit/menstruation_edit_page.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';

class MenstruationListRowState {
  final Menstruation menstruation;
  final String? prefix;
  int? menstruationDuration;

  MenstruationListRowState(this.menstruation, this.prefix);

  static int diff(MenstruationListRowState lhs, MenstruationListRowState rhs) {
    final range =
        DateRange(lhs.menstruation.beginDate, rhs.menstruation.beginDate);
    return range.days.abs() - 1;
  }

  static List<MenstruationListRowState> rows(List<Menstruation> menstruations) {
    return [...menstruations]
        .asMap()
        .map((index, element) =>
            MapEntry(index, MenstruationListRowState(element, _prefix(index))))
        .values
        .toList()
        .fold<List<MenstruationListRowState>>([], (value, element) {
      if (value.isEmpty) {
        return [element];
      }
      return value
        ..last.menstruationDuration =
            MenstruationListRowState.diff(value.last, element)
        ..add(element);
    }).toList();
  }

  static String? _prefix(int i) {
    if (i == 0) {
      return "前回";
    }
    if (i == 1) {
      return "前々回";
    }
    return null;
  }

  String get dateRange {
    return "(${DateTimeFormatter.monthAndDay(menstruation.beginDate)} - ${DateTimeFormatter.monthAndDay(menstruation.endDate)})";
  }

  String get duration {
    final menstruationDuration = this.menstruationDuration;
    if (menstruationDuration == null) {
      return "-";
    }
    return "$menstruationDuration日周期";
  }

  double get width {
    final double widthForDay = 10;
    final menstruationDuration = this.menstruationDuration;
    if (menstruationDuration == null) {
      return widthForDay * 28;
    }
    return widthForDay * menstruationDuration;
  }
}

class MenstruationListRow extends StatelessWidget {
  final MenstruationListRowState state;

  const MenstruationListRow({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showMenstruationEditPage(context, state.menstruation);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (state.prefix != null)
                Text(state.prefix ?? "",
                    style: FontType.descriptionBold.merge(TextColorStyle.main)),
              Text(state.dateRange,
                  style: FontType.description.merge(TextColorStyle.main)),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            width: state.width,
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
                    state.menstruation.dateRange.days + 1,
                    (index) {
                      return [_circle(), const SizedBox(width: 4)];
                    },
                  ).expand((element) => element).toList(),
                  const Spacer(),
                  Text(
                    state.duration,
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
}
