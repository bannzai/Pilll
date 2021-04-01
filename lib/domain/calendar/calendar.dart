import 'package:pilll/domain/calendar/calculator.dart';
import 'package:pilll/domain/calendar/calendar_band_model.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/domain/calendar/calendar_day_tile.dart';
import 'package:pilll/domain/calendar/utility.dart';
import 'package:pilll/domain/diary/post_diary_page.dart';
import 'package:pilll/domain/record/weekday_badge.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/entity/diary.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/service/diary.dart';
import 'package:pilll/domain/diary/confirm_diary_sheet.dart';
import 'package:pilll/store/diaries.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/util/datetime/day.dart' as utility;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class CalendarConstants {
  static final double tileHeight = 60;
}

final AutoDisposeFutureProviderFamily<List<Diary>, DateTime>?
    calendarDiariesProvider = FutureProvider.autoDispose
        .family<List<Diary>, DateTime>((ref, DateTime dateTimeOfMonth) {
  final state = ref.watch(diariesStoreProvider.state);
  if (state.entities.isNotEmpty) {
    return Future.value(state.entities);
  }
  final diaries = ref.watch(diaryServiceProvider);
  return diaries.fetchListForMonth(dateTimeOfMonth);
});

class Calendar extends HookWidget {
  final Calculator calculator;
  final List<CalendarBandModel> bandModels;
  final double horizontalPadding;

  const Calendar({
    Key? key,
    required this.calculator,
    required this.bandModels,
    required this.horizontalPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final futureCalendarDiaries =
        useProvider(calendarDiariesProvider!(calculator.date));
    return futureCalendarDiaries.when(
      data: (value) {
        return _body(context, value);
      },
      loading: () => Indicator(),
      error: (error, trace) => Indicator(),
    );
  }

  DateTime date() => calculator.date;
  double height() =>
      calculator.lineCount().toDouble() * CalendarConstants.tileHeight;

  Column _body(BuildContext context, List<Diary> diaries) {
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
        ...List.generate(calculator.lineCount(), (_line) {
          var line = _line + 1;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Stack(
                children: [
                  Row(
                    children: Weekday.values.map((weekday) {
                      bool isPreviousMonth =
                          weekday.index < calculator.weekdayOffset() &&
                              line == 1;
                      if (isPreviousMonth) {
                        return CalendarDayTile(
                            isToday: false,
                            onTap: null,
                            weekday: weekday,
                            day: calculator
                                .dateTimeForPreviousMonthTile(weekday.index)
                                .day);
                      }
                      int day = (line - 1) * Weekday.values.length +
                          weekday.index -
                          calculator.weekdayOffset() +
                          1;
                      bool isNextMonth = day > calculator.lastDay();
                      if (isNextMonth) {
                        return Expanded(child: Container());
                      }
                      bool isExistDiary = diaries
                          .where((element) => isSameDay(
                              element.date,
                              DateTime(calculator.date.year,
                                  calculator.date.month, day)))
                          .isNotEmpty;
                      final targetMonth = calculator.date;
                      return CalendarDayTile(
                        isToday: isSameDay(utility.today(),
                            DateTime(targetMonth.year, targetMonth.month, day)),
                        weekday: weekday,
                        day: day,
                        upperWidget: isExistDiary ? _diaryMarkWidget() : null,
                        onTap: () {
                          final date = calculator
                              .dateTimeForFirstDayOfMonth()
                              .add(Duration(days: day - 1));
                          if (date.isAfter(utility.today())) {
                            return;
                          }
                          if (!isExistDiary) {
                            Navigator.of(context)
                                .push(PostDiaryPageRoute.route(date));
                          } else {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => ConfirmDiarySheet(date),
                              backgroundColor: Colors.transparent,
                            );
                          }
                        },
                      );
                    }).toList(),
                  ),
                  ...bands(
                      context, bandModels, calculator, horizontalPadding, line)
                ],
              ),
              Divider(height: 1),
            ],
          );
        }),
      ],
    );
  }

  Widget _diaryMarkWidget() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
          color: PilllColors.gray, borderRadius: BorderRadius.circular(4)),
    );
  }
}
