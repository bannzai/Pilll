import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/domain/calendar/calendar.dart';
import 'package:pilll/domain/calendar/calendar_date_header.dart';
import 'package:pilll/domain/calendar/monthly_calendar_state.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/store/menstruation_edit.dart';

class MenstruationEditPage extends HookWidget {
  final Menstruation? menstruation;
  final Function(Menstruation) didEndSave;
  final VoidCallback didEndDelete;
  MenstruationEditPage({
    required this.menstruation,
    required this.didEndSave,
    required this.didEndDelete,
  });

  @override
  Widget build(BuildContext context) {
    final store = useProvider(menstruationEditProvider(menstruation));
    final state = useProvider(menstruationEditProvider(menstruation).state);
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
              color: PilllColors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0),
              )),
          child: ListView(
            controller: scrollController,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 21.0, left: 16, right: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("生理期間の編集",
                        style: FontType.sBigTitle.merge(TextColorStyle.main)),
                    Spacer(),
                    SecondaryButton(
                      onPressed: () {
                        analytics.logEvent(
                            name: "pressed_saving_menstruation_edit");
                        if (store.shouldShowDiscardDialog()) {
                          showDialog(
                            context: context,
                            builder: (context) => DiscardDialog(
                              title: "生理期間を削除しますか？",
                              message: "",
                              doneButtonText: "削除する",
                              done: () => store
                                  .delete()
                                  .then((_) => didEndDelete())
                                  .then((_) => analytics.logEvent(
                                      name: "pressed_delete_menstruation")),
                              cancel: () {
                                analytics.logEvent(
                                    name: "cancelled_delete_menstruation");
                                Navigator.of(context).pop();
                              },
                            ),
                          );
                        } else {
                          store.save().then((value) => didEndSave(value));
                        }
                      },
                      text: "保存",
                    )
                  ],
                ),
              ),
              ...state
                  .dates()
                  .map((dateForMonth) {
                    return [
                      CalendarDateHeader(date: dateForMonth),
                      Calendar(
                        calendarState: MenstruationEditCalendarState(
                            dateForMonth, state.menstruation),
                        bandModels: [],
                        onTap: (date, diaries) => store.tappedDate(date),
                        horizontalPadding: 0,
                      ),
                    ];
                  })
                  .expand((element) => element)
                  .toList(),
            ],
          ),
        );
      },
    );
  }
}
