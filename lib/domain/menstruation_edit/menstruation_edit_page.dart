import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/domain/calendar/components/month/month_calendar.dart';
import 'package:pilll/domain/menstruation_edit/components/calendar/calendar_date_header.dart';
import 'package:pilll/components/organisms/calendar/weekly/weekly_calendar.dart';
import 'package:pilll/domain/menstruation_edit/components/calendar/weekly_calendar_state.dart';
import 'package:pilll/domain/menstruation_edit/components/header/menstruation_edit_page_header.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/domain/menstruation_edit/menstruation_edit_page_store.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

class MenstruationEditPage extends HookConsumerWidget {
  final String title;
  final Menstruation? menstruation;
  final Function(Menstruation) onSaved;
  final VoidCallback onDeleted;
  MenstruationEditPage({
    required this.title,
    required this.menstruation,
    required this.onSaved,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(menstruationEditProvider(menstruation).notifier);
    final state = ref.watch(menstruationEditProvider(menstruation));
    final invalidMessage = state.invalidMessage;

    final scrollController = useScrollController();
    // TODO: Check
    // Future.delayed(const Duration(microseconds: 200)).then((value) {});
    Future.microtask(() {
      if (state.isAlreadyAdjsutScrollOffset) {
        return;
      }
      store.adjustedScrollOffset();
      final double estimatedSectionTitleHeight = 95;
      scrollController.jumpTo(
          CalendarConstants.tileHeight * CalendarConstants.maxLineCount +
              estimatedSectionTitleHeight);
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
            child: ListView(
              controller: scrollController,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 21.0, left: 16, right: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MenstruationEditPageHeader(
                        title: title,
                        state: state,
                        store: store,
                        onDeleted: onDeleted,
                        onSaved: onSaved,
                      ),
                      if (invalidMessage != null) ...[
                        const SizedBox(height: 12),
                        Text(invalidMessage,
                            style: FontType.assisting
                                .merge(TextColorStyle.danger)),
                      ],
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: [
                      ...state.displayedDates
                          .map((dateForMonth) {
                            return [
                              CalendarDateHeader(date: dateForMonth),
                              MonthCalendar(
                                state: MenstruationEditCalendarState(
                                    dateForMonth, state.menstruation),
                                weekCalendarBuilder:
                                    (context, weeklyCalendarState) {
                                  return CalendarWeekdayLine(
                                    state: MenstruationEditWeeklyCalendarState(
                                      weeklyCalendarState,
                                      dateForMonth,
                                      state.menstruation,
                                    ),
                                    horizontalPadding: 0,
                                    onTap: (weeklyCalendarState, date) {
                                      analytics.logEvent(
                                          name:
                                              "selected_day_tile_on_menstruation_edit");
                                      store.tappedDate(date);
                                    },
                                  );
                                },
                              ),
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
}

// TODO: Integrate
void showMenstruationEditPage(
  BuildContext context, {
  required Menstruation? menstruation,
}) {
  analytics.setCurrentScreen(screenName: "MenstruationEditPage");
  showModalBottomSheet(
    context: context,
    builder: (context) => MenstruationEditPage(
      title: "生理期間の編集",
      menstruation: menstruation,
      onSaved: (menstruation) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            content: Text("生理期間を編集しました"),
          ),
        );
      },
      onDeleted: () {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            content: Text("生理期間を削除しました"),
          ),
        );
      },
    ),
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
  );
}

void showMenstruationEditPageForCreate(
  BuildContext context,
) {
  analytics.setCurrentScreen(screenName: "MenstruationEditPage");
  showModalBottomSheet(
    context: context,
    builder: (context) => MenstruationEditPage(
      title: "生理開始日を選択",
      menstruation: null,
      onSaved: (menstruation) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            content: Text(
                "${DateTimeFormatter.monthAndDay(menstruation.beginDate)}から生理開始で記録しました"),
          ),
        );
      },
      onDeleted: () {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            content: Text("生理期間を削除しました"),
          ),
        );
      },
    ),
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
  );
}
