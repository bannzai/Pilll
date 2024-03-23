import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/picker/date_range_picker.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/features/menstruation_edit/components/edit/menstruation_date_time_range_picker.dart';
import 'package:pilll/features/menstruation_edit/components/edit/menstruation_edit_selection_sheet.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/features/menstruation/menstruation_select_modify_type_sheet.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/provider/menstruation.dart';
import 'package:pilll/utils/datetime/date_add.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

class MenstruationRecordButton extends HookConsumerWidget {
  final Menstruation? latestMenstruation;
  final Setting setting;

  const MenstruationRecordButton({
    Key? key,
    required this.latestMenstruation,
    required this.setting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beginMenstruation = ref.watch(beginMenstruationProvider);

    void onRecord(Menstruation menstruation) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Text("${DateTimeFormatter.monthAndDay(menstruation.beginDate)}から生理開始で記録しました"),
        ),
      );
    }

    return SizedBox(
      width: 180,
      child: PrimaryButton(
        onPressed: () async {
          analytics.logEvent(name: "pressed_menstruation_record");

          final latestMenstruation = this.latestMenstruation;
          if (latestMenstruation != null && latestMenstruation.dateRange.inRange(today())) {
            // 生理期間中は、生理期間を編集する
            return showMenstruationEditSelectionSheet(
              context,
              MenstruationEditSelectionSheet(
                menstruation: latestMenstruation,
              ),
            );
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
                  final dateTime = await showDatePicker(
                    context: context,
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                    initialDate: today(),
                    firstDate: DateTime.parse("2020-01-01"),
                    lastDate: today().addDays(30),
                    helpText: "生理開始日を選択",
                    fieldLabelText: "生理開始日",
                    builder: (context, child) {
                      return DateRangePickerTheme(child: child!);
                    },
                  );
                  if (dateTime == null) {
                    return;
                  }

                  try {
                    final begin = dateTime;
                    final created = await beginMenstruation(
                      begin,
                      begin.addDays(setting.durationMenstruation - 1),
                    );
                    onRecord(created);
                    if (context.mounted) Navigator.of(context).pop();
                  } catch (error) {
                    if (context.mounted) showErrorAlert(context, error);
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
