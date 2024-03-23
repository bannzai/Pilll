import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/picker/date_range_picker.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/utils/datetime/date_add.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/provider/menstruation.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

void showMenstruationDateRangePicker(BuildContext context, WidgetRef ref, {required Menstruation? initialMenstruation}) async {
  void onSaved(Menstruation savedMenstruation) {
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
  }

  final dateTimeRange = await showDateRangePicker(
    context: context,
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    initialDateRange: initialMenstruation?.dateTimeRange,
    firstDate: DateTime.parse("2020-01-01"),
    lastDate: today().addDays(30),
    helpText: initialMenstruation == null ? "生理開始日を選択" : "生理期間の編集",
    fieldStartHintText: "生理開始日",
    fieldEndLabelText: "生理終了日",
    builder: (context, child) {
      return DateRangePickerTheme(child: child!);
    },
  );

  if (dateTimeRange == null) {
    return;
  }

  if (initialMenstruation == null) {
    final menstruation = Menstruation(
      beginDate: dateTimeRange.start,
      endDate: dateTimeRange.end,
      createdAt: now(),
    );
    try {
      onSaved(await ref.read(setMenstruationProvider).call(menstruation));
    } catch (e) {
      if (context.mounted) showErrorAlert(context, e);
    }
  } else {
    final menstruation = initialMenstruation.copyWith(
      beginDate: dateTimeRange.start,
      endDate: dateTimeRange.end,
    );
    try {
      onSaved(await ref.read(setMenstruationProvider).call(menstruation));
    } catch (e) {
      if (context.mounted) showErrorAlert(context, e);
    }
  }
}
