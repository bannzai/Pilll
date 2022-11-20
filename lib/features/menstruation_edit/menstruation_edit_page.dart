import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/calendar/date_range.dart';
import 'package:pilll/features/menstruation_edit/components/calendar/calendar_date_header.dart';
import 'package:pilll/features/menstruation_edit/components/calendar/month_calendar.dart';
import 'package:pilll/features/menstruation_edit/components/header/menstruation_edit_page_header.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

class MenstruationEditPage extends HookConsumerWidget {
  final Menstruation? initialMenstruation;
  final Function(Menstruation) onSaved;

  final VoidCallback onDeleted;

  const MenstruationEditPage({
    Key? key,
    required this.initialMenstruation,
    required this.onSaved,
    required this.onDeleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialMenstruation = this.initialMenstruation;
    final setting = ref.watch(settingProvider).requireValue;
    final invalidMessage = useState("");
    final editingDateRange =
        useState<DateRange?>(initialMenstruation == null ? null : DateRange(initialMenstruation.beginDate, initialMenstruation.endDate));

    final adjustedInitialScrollOffset = useState(false);
    final scrollController = useScrollController();
    Future.microtask(() {
      if (adjustedInitialScrollOffset.value) {
        return;
      }
      adjustedInitialScrollOffset.value = true;
      const double estimatedSectionTitleHeight = 95;
      scrollController.jumpTo(CalendarConstants.tileHeight * CalendarConstants.maxLineCount + estimatedSectionTitleHeight);
    });

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.7,
      builder: (context, _) {
        return SizedBox.expand(
          child: Container(
            decoration: const BoxDecoration(
                color: PilllColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                )),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 21.0, left: 16, right: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MenstruationEditPageHeader(
                        initialMenstruation: initialMenstruation,
                        editingDateRange: editingDateRange,
                        onDeleted: onDeleted,
                        onSaved: onSaved,
                      ),
                      if (invalidMessage.value.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(invalidMessage.value,
                            style: const TextStyle(
                              fontFamily: FontFamily.japanese,
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              color: TextColor.danger,
                            )),
                      ],
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: [
                      ..._displayedDates()
                          .map((dateForMonth) {
                            return [
                              CalendarDateHeader(date: dateForMonth),
                              MonthCalendar(
                                dateForMonth: dateForMonth,
                                editingDateRange: editingDateRange.value,
                                onTap: (date) {
                                  final menstruation = this.initialMenstruation;
                                  if (date.isAfter(today()) && menstruation == null) {
                                    invalidMessage.value = "未来の日付は選択できません";
                                  } else {
                                    _tappedDate(date: date, setting: setting, dateRange: editingDateRange);
                                  }
                                },
                              )
                            ];
                          })
                          .expand((element) => element)
                          .toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _tappedDate({
    required DateTime date,
    required Setting setting,
    required ValueNotifier<DateRange?> dateRange,
  }) async {
    final dateRangeValue = dateRange.value;
    if (dateRangeValue == null) {
      final begin = date;
      final end = date.add(Duration(days: max(setting.durationMenstruation - 1, 0)));
      dateRange.value = DateRange(begin, end);
    } else {
      if (isSameDay(dateRangeValue.begin, date) && isSameDay(dateRangeValue.end, date)) {
        dateRange.value = null;
        return;
      }

      if (date.isBefore(dateRangeValue.begin)) {
        dateRange.value = DateRange(date, dateRangeValue.end);
        return;
      }
      if (date.isAfter(dateRangeValue.end)) {
        dateRange.value = DateRange(dateRangeValue.begin, date);
        return;
      }

      if ((isSameDay(dateRangeValue.begin, date) || date.isAfter(dateRangeValue.begin)) && date.isBefore(dateRangeValue.end)) {
        dateRange.value = DateRange(dateRangeValue.begin, date);
        return;
      }

      if (isSameDay(dateRangeValue.end, date)) {
        dateRange.value = DateRange(dateRangeValue.begin, date.subtract(const Duration(days: 1)));
        return;
      }
    }
  }

  List<DateTime> _displayedDates() {
    final baseMenstruation = initialMenstruation;
    if (baseMenstruation != null) {
      return [
        DateTime(baseMenstruation.beginDate.year, baseMenstruation.beginDate.month - 1, 1),
        baseMenstruation.beginDate,
        DateTime(baseMenstruation.beginDate.year, baseMenstruation.beginDate.month + 1, 1),
      ];
    } else {
      final t = today();
      return [
        DateTime(t.year, t.month - 1, 1),
        t,
        DateTime(t.year, t.month + 1, 1),
      ];
    }
  }
}

void showMenstruationEditPage(
  BuildContext context, {
  required Menstruation? initialMenstruation,
}) {
  analytics.setCurrentScreen(screenName: "MenstruationEditPage");
  showModalBottomSheet(
    context: context,
    builder: (context) => MenstruationEditPage(
      initialMenstruation: initialMenstruation,
      onSaved: (savedMenstruation) {
        if (initialMenstruation == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 2),
              content: Text("${DateTimeFormatter.monthAndDay(savedMenstruation.beginDate)}から生理開始で記録しました"),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 2),
              content: Text("生理期間を編集しました"),
            ),
          );
        }
        Navigator.of(context).pop();
      },
      onDeleted: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            content: Text("生理期間を削除しました"),
          ),
        );
        Navigator.of(context).pop();
      },
    ),
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
  );
}
