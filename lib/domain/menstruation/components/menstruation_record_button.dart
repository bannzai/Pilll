import 'package:flutter/material.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/domain/menstruation/menstruation_state.codegen.dart';
import 'package:pilll/domain/menstruation_edit/menstruation_edit_page.dart';
import 'package:pilll/domain/menstruation/menstruation_select_modify_type_sheet.dart';
import 'package:pilll/domain/menstruation/menstruation_store.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

class MenstruationRecordButton extends StatelessWidget {
  const MenstruationRecordButton({
    Key? key,
    required this.state,
    required this.store,
  }) : super(key: key);

  final MenstruationState state;
  final MenstruationStore store;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      onPressed: () async {
        analytics.logEvent(name: "pressed_menstruation_record");
        final latestMenstruation = state.latestMenstruation;
        if (latestMenstruation != null &&
            latestMenstruation.dateRange.inRange(today())) {
          showMenstruationEditPageForUpdate(context, latestMenstruation);
          return;
        }

        final setting = state.setting;
        if (setting == null) {
          throw const FormatException(
              "生理記録前にデータの読み込みに失敗しました。再読み込みしてから再度お試しください");
        }

        if (setting.durationMenstruation == 0) {
          return showMenstruationEditPageForCreate(context);
        }
        showModalBottomSheet(
          context: context,
          builder: (_) =>
              MenstruationSelectModifyTypeSheet(onTap: (type) async {
            switch (type) {
              case MenstruationSelectModifyType.today:
                analytics.logEvent(name: "tapped_menstruation_record_today");
                Navigator.of(context).pop();
                final created = await store.recordFromToday();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 2),
                    content: Text(
                        "${DateTimeFormatter.monthAndDay(created.beginDate)}から生理開始で記録しました"),
                  ),
                );
                return;
              case MenstruationSelectModifyType.yesterday:
                analytics.logEvent(
                    name: "tapped_menstruation_record_yesterday");
                Navigator.of(context).pop();
                final created = await store.recordFromYesterday();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 2),
                    content: Text(
                        "${DateTimeFormatter.monthAndDay(created.beginDate)}から生理開始で記録しました"),
                  ),
                );
                return;
              case MenstruationSelectModifyType.begin:
                analytics.logEvent(name: "tapped_menstruation_record_begin");
                Navigator.of(context).pop();
                return showMenstruationEditPageForCreate(context);
            }
          }),
        );
      },
      text: state.buttonString,
    );
  }
}
