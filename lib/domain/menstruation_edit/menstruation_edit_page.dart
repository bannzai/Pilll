import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/menstruation_edit/components/calendar/calendar_date_header.dart';
import 'package:pilll/domain/menstruation_edit/components/calendar/month_calendar.dart';
import 'package:pilll/domain/menstruation_edit/components/header/menstruation_edit_page_header.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/domain/menstruation_edit/menstruation_edit_page_state_notifier.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

class MenstruationEditPage extends HookConsumerWidget {
  final Menstruation? menstruation;
  final Function(Menstruation) onSaved;
  final VoidCallback onDeleted;
  const MenstruationEditPage({
    Key? key,
    required this.menstruation,
    required this.onSaved,
    required this.onDeleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(
        menstruationEditPageStateNotifierProvider(menstruation).notifier);
    final state =
        ref.watch(menstruationEditPageStateNotifierProvider(menstruation));
    final invalidMessage = state.invalidMessage;

    final scrollController = useScrollController();
    Future.microtask(() {
      if (state.isAlreadyAdjsutScrollOffset) {
        return;
      }
      store.adjustedScrollOffset();
      const double estimatedSectionTitleHeight = 95;
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
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 21.0, left: 16, right: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MenstruationEditPageHeader(
                        title: menstruation == null ? "生理開始日を選択" : "生理期間の編集",
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
                                dateForMonth: dateForMonth,
                                state: state,
                                store: store,
                                monthCalendarState:
                                    state.monthCalendarStatuses(dateForMonth),
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
}

void showMenstruationEditPage(
  BuildContext context, {
  required Menstruation? menstruation,
}) {
  analytics.setCurrentScreen(screenName: "MenstruationEditPage");
  showModalBottomSheet(
    context: context,
    builder: (context) => MenstruationEditPage(
      menstruation: menstruation,
      onSaved: (savedMenstruation) {
        Navigator.of(context).pop();
        if (menstruation == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 2),
              content: Text(
                  "${DateTimeFormatter.monthAndDay(savedMenstruation.beginDate)}から生理開始で記録しました"),
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
