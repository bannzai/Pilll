import 'package:flutter/material.dart';
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
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/domain/menstruation_edit/menstruation_edit_store.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

class MenstruationEditPage extends HookConsumerWidget {
  final String title;
  final Menstruation? menstruation;
  final Function(Menstruation) didEndSave;
  final VoidCallback didEndDelete;
  MenstruationEditPage({
    required this.title,
    required this.menstruation,
    required this.didEndSave,
    required this.didEndDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(menstruationEditProvider(menstruation).notifier);
    final state = ref.watch(menstruationEditProvider(menstruation));
    final invalidMessage = state.invalidMessage;
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.7,
      builder: (context, scrollController) {
        Future.delayed(const Duration(microseconds: 200)).then((value) {
          if (state.isAlreadyAdjsutScrollOffset) {
            return;
          }
          store.adjustedScrollOffset();
          final double estimatedSectionTitleHeight = 95;
          scrollController.jumpTo(
              CalendarConstants.tileHeight * CalendarConstants.maxLineCount +
                  estimatedSectionTitleHeight);
        });
        return Container(
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(title,
                            style:
                                FontType.sBigTitle.merge(TextColorStyle.main)),
                        const Spacer(),
                        AlertButton(
                          onPressed: () async {
                            analytics.logEvent(
                                name: "pressed_saving_menstruation_edit");
                            if (store.shouldShowDiscardDialog()) {
                              showDialog(
                                context: context,
                                builder: (context) => DiscardDialog(
                                  title: "生理期間を削除しますか？",
                                  message: const Text(""),
                                  actions: [
                                    AlertButton(
                                      text: "キャンセル",
                                      onPressed: () async {
                                        analytics.logEvent(
                                            name:
                                                "cancelled_delete_menstruation");
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    AlertButton(
                                      text: "削除する",
                                      onPressed: () async {
                                        await store.delete();
                                        didEndDelete();

                                        analytics.logEvent(
                                            name:
                                                "pressed_delete_menstruation");
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            } else if (store.isDismissWhenSaveButtonPressed()) {
                              Navigator.of(context).pop();
                            } else {
                              store.save().then((value) => didEndSave(value));
                            }
                          },
                          text: "保存",
                        )
                      ],
                    ),
                    if (invalidMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(invalidMessage,
                          style:
                              FontType.assisting.merge(TextColorStyle.danger)),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    ...state
                        .dates()
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
        );
      },
    );
  }
}

void showMenstruationEditPageForUpdate(
  BuildContext context,
  Menstruation menstruation,
) {
  analytics.setCurrentScreen(screenName: "MenstruationEditPage");
  showModalBottomSheet(
    context: context,
    builder: (context) => MenstruationEditPage(
      title: "生理期間の編集",
      menstruation: menstruation,
      didEndSave: (menstruation) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            content: Text("生理期間を編集しました"),
          ),
        );
      },
      didEndDelete: () {
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
      didEndSave: (menstruation) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            content: Text(
                "${DateTimeFormatter.monthAndDay(menstruation.beginDate)}から生理開始で記録しました"),
          ),
        );
      },
      didEndDelete: () {
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
