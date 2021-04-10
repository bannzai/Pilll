import 'package:pilll/domain/calendar/monthly_calendar_state.dart';
import 'package:pilll/domain/calendar/calendar_band_model.dart';
import 'package:pilll/domain/calendar/calendar_weekday_line.dart';
import 'package:pilll/domain/record/weekday_badge.dart';
import 'package:pilll/entity/diary.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/store/diaries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class CalendarConstants {
  static final double tileHeight = 66;
}

class Calendar extends HookWidget {
  final MonthlyCalendarState calendarState;
  final List<CalendarBandModel> bandModels;
  final Function(DateTime, List<Diary>) onTap;
  final double horizontalPadding;

  const Calendar({
    Key? key,
    required this.calendarState,
    required this.bandModels,
    required this.onTap,
    required this.horizontalPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useProvider(
        monthlyDiariesStoreProvider(calendarState.dateForMonth).state);
// NOTE: hooks を使ってwidgetテストをした場合に store.state じゃないと mockができなかった。しかしこれを使用してdiariesのデータを取ると今度はstateが更新されたときに画面が再描画されない。なので簡易的にコンポーネントを切り出してhooksの影響を受けないようにする
    return CalendarBody(
        diaries: state.entities,
        calendarState: calendarState,
        bandModels: bandModels,
        onTap: onTap,
        horizontalPadding: horizontalPadding);
  }

  DateTime date() => calendarState.dateForMonth;
  double height() =>
      calendarState.lineCount().toDouble() * CalendarConstants.tileHeight;
}

class CalendarBody extends StatelessWidget {
  final List<Diary> diaries;
  final MonthlyCalendarState calendarState;
  final List<CalendarBandModel> bandModels;
  final Function(DateTime, List<Diary>) onTap;
  final double horizontalPadding;

  const CalendarBody({
    Key? key,
    required this.diaries,
    required this.calendarState,
    required this.bandModels,
    required this.onTap,
    required this.horizontalPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(
              Weekday.values.length,
              (index) => Expanded(
                    child: WeekdayBadge(
                      weekday: Weekday.values[index],
                    ),
                  )),
        ),
        Divider(height: 1),
        ...List.generate(calendarState.lineCount(), (_line) {
          final line = _line + 1;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CalendarWeekdayLine(
                  diaries: diaries,
                  calendarState: calendarState.weeklyCalendarState(line),
                  bandModels: bandModels,
                  horizontalPadding: horizontalPadding,
                  onTap: (weeklyCalendarState, date) => onTap(date, diaries)),
              Divider(height: 1),
            ],
          );
        }),
      ],
    );
  }
}
