import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/features/menstruation_edit/components/edit/menstruation_date_time_range_picker.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/features/menstruation/menstruation_select_modify_type_sheet.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/provider/menstruation.dart';
import 'package:pilll/utils/datetime/date_add.dart';
import 'package:pilll/utils/datetime/day.dart';

class MenstruationRecordButton extends HookConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final beginMenstruation = ref.watch(beginMenstruationProvider);
    return SizedBox(
      width: 180,
      child: PrimaryButton(
        onPressed: () async {
          analytics.logEvent(name: "pressed_menstruation_record");

          final latestMenstruation = this.latestMenstruation;
          if (latestMenstruation != null && latestMenstruation.dateRange.inRange(today())) {
            // 生理期間中は、生理期間を編集する
            return showMenstruationDateRangePicker(context, ref, initialMenstruation: latestMenstruation);
          }
          if (setting.durationMenstruation == 0) {
            // 生理期間を設定していないユーザーは、直接日付入力させる
            return showMenstruationDateRangePicker(context, ref, initialMenstruation: latestMenstruation);
          }

          showModalBottomSheet(
            context: context,
            builder: (_) => MenstruationSelectModifyTypeSheet(onTap: (type) async {
              switch (type) {
                case MenstruationSelectModifyType.today:
                  analytics.logEvent(name: "tapped_menstruation_record_today");
                  final navigator = Navigator.of(context);
                  try {
                    final begin = today();
                    final created = await beginMenstruation(
                      begin,
                      begin.addDays(setting.durationMenstruation - 1),
                    );
                    onRecord(created);
                    navigator.pop();
                    return;
                  } catch (error) {
                    if (context.mounted) showErrorAlert(context, error);
                  }
                  return;
                case MenstruationSelectModifyType.yesterday:
                  analytics.logEvent(name: "tapped_menstruation_record_yesterday");
                  try {
                    final begin = yesterday();
                    final created = await beginMenstruation(
                      begin,
                      begin.addDays(setting.durationMenstruation - 1),
                    );
                    onRecord(created);
                    if (context.mounted) Navigator.of(context).pop();
                  } catch (error) {
                    if (context.mounted) showErrorAlert(context, error);
                  }
                  return;
                case MenstruationSelectModifyType.begin:
                  analytics.logEvent(name: "tapped_menstruation_record_begin");
                  if (context.mounted) {
                    Navigator.of(context).pop();

                    final dateTimeRange = await showModalBottomSheet<DateTimeRange?>(
                        context: context,
                        builder: (context) {
                          return DateRangePickerDialog(
                            initialDateRange: DateTimeRange(start: today(), end: today().addDays(setting.durationMenstruation - 1)),
                            firstDate: DateTime.parse("2020-01-01"),
                            lastDate: today().addDays(30),
                            fieldStartLabelText: "生理開始日",
                            fieldEndLabelText: "生理終了予定日",
                            confirmText: "記録する",
                            saveText: "OK",
                          );
                        });

                    if (dateTimeRange == null) {
                      return;
                    }
                    try {
                      final created = await beginMenstruation(dateTimeRange.start, dateTimeRange.end);
                      onRecord(created);
                      if (context.mounted) Navigator.of(context).pop();
                    } catch (error) {
                      if (context.mounted) showErrorAlert(context, error);
                    }
                  }
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
