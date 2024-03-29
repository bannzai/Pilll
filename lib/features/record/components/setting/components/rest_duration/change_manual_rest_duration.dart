import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:pilll/components/theme/date_range_picker.dart';
import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/features/record/components/pill_sheet/components/record_page_rest_duration_dialog.dart';
import 'package:pilll/features/record/components/setting/components/rest_duration/invalid_already_taken_pill_dialog.dart';
import 'package:pilll/features/record/components/setting/components/rest_duration/provider.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/datetime/date_add.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';
import 'package:pilll/utils/local_notification.dart';

class ChangeManualRestDuration extends HookConsumerWidget {
  final RestDuration restDuration;
  final PillSheetGroup pillSheetGroup;

  const ChangeManualRestDuration({
    super.key,
    required this.restDuration,
    required this.pillSheetGroup,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final changeRestDurationBeginDate = ref.watch(changeRestDurationBeginDateProvider);
    final changeRestDuration = ref.watch(changeRestDurationProvider);
    final begin = DateTimeFormatter.monthAndDay(restDuration.beginDate);
    final end = restDuration.endDate != null ? DateTimeFormatter.monthAndDay(restDuration.endDate!) : null;

    void onChanged() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(
            seconds: 2,
          ),
          content: Text("服用お休みを変更しました"),
        ),
      );

      Navigator.of(context).pop();
    }

    void onError(Object e) {
      debugPrint(e.toString());
      showErrorAlert(context, e);
    }

    if (end == null) {
      return ListTile(
        leading: const Icon(Icons.date_range),
        title: const Text("服用お休み開始日を編集"),
        subtitle: Text(begin),
        onTap: () async {
          analytics.logEvent(name: "change_manual_rest_duration_day", parameters: {
            "rest_duration_id": restDuration.id,
          });

          final dateTime = await showDatePicker(
            context: context,
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            initialDate: today(),
            firstDate: pillSheetGroup.pillSheets.first.beginingDate,
            lastDate: today(),
            helpText: "服用お休み開始日を選択",
            fieldLabelText: "服用お休み開始日",
            builder: (context, child) {
              return DateRangePickerTheme(child: child!);
            },
          );

          if (dateTime == null) {
            return;
          }

          final toRestDuration = RestDuration(
            id: firestoreIDGenerator(),
            beginDate: dateTime,
            endDate: null,
            createdDate: now(),
          );

          try {
            await changeRestDurationBeginDate(
              fromRestDuration: restDuration,
              toRestDuration: toRestDuration,
              pillSheetGroup: pillSheetGroup,
            );
          } catch (e) {
            onError(e);
          }

          onChanged();
        },
      );
    } else {
      return ListTile(
        leading: const Icon(Icons.date_range),
        title: const Text("服用お休み期間を編集"),
        subtitle: Text("$begin - $end"),
        onTap: () async {
          analytics.logEvent(name: "change_manual_rest_duration_range", parameters: {
            "rest_duration_id": restDuration.id,
          });

          final dateTimeRange = await showDateRangePicker(
            context: context,
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            initialDateRange: restDuration.dateTimeRange,
            firstDate: DateTime.parse("2020-01-01"),
            lastDate: today(),
            helpText: "服用お休み期間を選択",
            fieldStartHintText: "服用お休み開始日",
            fieldEndLabelText: "服用お休み終了日",
            builder: (context, child) {
              return DateRangePickerTheme(child: child!);
            },
          );

          if (dateTimeRange == null) {
            return;
          }

          final toRestDuration = RestDuration(
            id: firestoreIDGenerator(),
            beginDate: dateTimeRange.start,
            endDate: dateTimeRange.end,
            createdDate: now(),
          );

          try {
            await changeRestDuration(
              fromRestDuration: restDuration,
              toRestDuration: toRestDuration,
              pillSheetGroup: pillSheetGroup,
            );
          } catch (e) {
            onError(e);
          }

          onChanged();
        },
      );
    }
  }
}
