import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/calendar/calendar.dart';
import 'package:pilll/domain/calendar/calendar_date_header.dart';
import 'package:pilll/domain/calendar/monthly_calendar_state.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/store/menstruation_edit.dart';

class MenstruationEditPage extends HookWidget {
  final Menstruation? menstruation;
  MenstruationEditPage({
    required this.menstruation,
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
                    Text("生理期間を選択・編集",
                        style: FontType.sBigTitle.merge(TextColorStyle.main)),
                    Spacer(),
                    SecondaryButton(
                      onPressed: menstruation != null
                          ? () {
                              store
                                  .save()
                                  .then((value) => Navigator.of(context).pop());
                            }
                          : null,
                      text: "保存",
                    )
                  ],
                ),
              ),
              ...state
                  .dates()
                  .map((e) => _calendar(e))
                  .expand((element) => element)
                  .toList(),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _calendar(DateTime date) {
    return [
      CalendarDateHeader(date: date),
      Calendar(
        calendarState: MenstruationEditCalendarState(date),
        bandModels: [],
        horizontalPadding: 0,
      ),
    ];
  }
}
