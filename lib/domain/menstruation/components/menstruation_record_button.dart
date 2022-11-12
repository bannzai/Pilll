import 'package:flutter/material.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/domain/menstruation/menstruation_state.codegen.dart';
import 'package:pilll/domain/menstruation_edit/menstruation_edit_page.dart';
import 'package:pilll/domain/menstruation/menstruation_select_modify_type_sheet.dart';
import 'package:pilll/domain/menstruation/menstruation_page_state_notifier.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/util/datetime/day.dart';

class MenstruationRecordButton extends StatelessWidget {
  final Menstruation? latestMenstruation;
  final Setting setting;
  final Function(Menstruation) onRecord;

  const MenstruationRecordButton({
    Key? key,
    required this.latestMenstruation,
    required this.setting,
    required this.onRecord,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: PrimaryButton(
        onPressed: () async {
          analytics.logEvent(name: "pressed_menstruation_record");
          final latestMenstruation = this.latestMenstruation;
          if (latestMenstruation != null && latestMenstruation.dateRange.inRange(today())) {
            showMenstruationEditPage(context, menstruation: latestMenstruation);
            return;
          }

          if (setting.durationMenstruation == 0) {
            return showMenstruationEditPage(context, menstruation: null);
          }
          showModalBottomSheet(
            context: context,
            builder: (_) => MenstruationSelectModifyTypeSheet(onTap: (type) async {
              switch (type) {
                case MenstruationSelectModifyType.today:
                  analytics.logEvent(name: "tapped_menstruation_record_today");
                  final created = await store.asyncAction.recordFromToday(setting: setting);
                  onRecord(created);
                  Navigator.of(context).pop();
                  return;
                case MenstruationSelectModifyType.yesterday:
                  analytics.logEvent(name: "tapped_menstruation_record_yesterday");
                  final created = await store.asyncAction.recordFromYesterday(setting: setting);
                  onRecord(created);
                  Navigator.of(context).pop();
                  return;
                case MenstruationSelectModifyType.begin:
                  analytics.logEvent(name: "tapped_menstruation_record_begin");
                  Navigator.of(context).pop();
                  return showMenstruationEditPage(context, menstruation: null);
              }
            }),
          );
        },
        text: _buttonString,
      ),
    );
  }

  String get _buttonString {
    final latestMenstruation = this.latestMenstruation;
    if (latestMenstruation == null) {
      return "生理を記録";
    }
    if (latestMenstruation.dateRange.inRange(today())) {
      return "生理期間を編集";
    }
    return "生理を記録";
  }
}
