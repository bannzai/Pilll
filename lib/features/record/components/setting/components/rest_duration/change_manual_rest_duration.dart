import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:pilll/components/theme/date_range_picker.dart';
import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/features/error/alert_error.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/record/components/setting/components/rest_duration/provider.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';
import 'package:pilll/utils/local_notification.dart';

/// 服用お休み期間の開始日・終了日を変更する行。
///
/// 服用お休み期間の「削除」はあえて提供しない (https://github.com/bannzai/Pilll/issues/2035 )。
/// 前のピルシートの服用お休みを取り除くと、後続のピルシートの開始日が服用お休みの日数分だけ前にずれ、
/// 今飲んでいるシートの今日の番号が変わる。その時に服用記録を残すと飲んでいないピルが服用済みの表示になり、
/// 消すと服用記録そのものが失われるため、どちらに倒しても当人の記録と食い違う。
/// 一方、服用お休み期間が 1 つも無い状態に戻したいケースは稀で、ピルシートの変更 (開始日の変更・削除) でも代替できる。
/// ユーザーから問い合わせがあり、どうしても取り除きたい時は、この行の変更で開始日と終了日を同じ日にして
/// 期間を 0 日にする操作を案内する (DateRangePicker は同じ日を開始日と終了日に選べる)。
/// 0 日にした時も後続のピルシートの開始日は同じ理由でずれるので、その点も合わせて伝える。
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
    final changeRestDurationBeginDate = ref.watch(
      changeRestDurationBeginDateProvider,
    );
    final changeRestDuration = ref.watch(changeRestDurationProvider);
    final registerReminderLocalNotification = ref.watch(
      registerReminderLocalNotificationProvider,
    );

    String format(DateTime dateTime) {
      return '${DateTimeFormatter.monthAndDay(dateTime)}(${DateTimeFormatter.shortWeekday(dateTime)})';
    }

    final begin = format(restDuration.beginDate);
    final end = restDuration.endDate != null ? format(restDuration.endDate!) : null;

    void onChanged() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Text(L.editPausePeriod),
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
        leading: const Icon(Icons.date_range_outlined),
        title: Text(L.editPausePeriod),
        subtitle: Text(begin),
        onTap: () async {
          analytics.logEvent(
            name: 'change_manual_rest_duration_day',
            parameters: {'rest_duration_id': restDuration.id},
          );

          // NOTE: DatePickerの表示制御により、最後に服用記録をつけた日付+1以上の日付は選択できない
          // よって、lastTakenDateが変動することがない前提になる
          final dateTime = await showDatePicker(
            context: context,
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            initialDate: pillSheetGroup.lastActiveRestDuration?.beginDate ?? today(),
            firstDate: pillSheetGroup.pillSheets.first.beginDate,
            lastDate: pillSheetGroup.availableRestDurationBeginDate,
            helpText: pillSheetGroup.availableRestDurationBeginDateHelpText,
            fieldLabelText: L.pauseStartDate,
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
        leading: const Icon(Icons.date_range_outlined),
        title: Text(L.changePausePeriod),
        subtitle: Text('$begin - $end'),
        onTap: () async {
          analytics.logEvent(
            name: 'change_manual_rest_duration_range',
            parameters: {'rest_duration_id': restDuration.id},
          );

          // NOTE: 選択できる日付の上限の考え方はavailableRestDurationEndDateのドキュメントコメントを参照
          final dateTimeRange = await showDateRangePicker(
            context: context,
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            initialDateRange: restDuration.dateTimeRange,
            firstDate: pillSheetGroup.pillSheets.first.beginDate,
            lastDate: pillSheetGroup.availableRestDurationEndDate(restDuration: restDuration),
            helpText: pillSheetGroup.availableRestDurationEndDateHelpText(restDuration: restDuration),
            fieldStartHintText: L.pauseStartDate,
            fieldEndLabelText: L.pauseEndDate,
            builder: (context, child) {
              return DateRangePickerTheme(child: child!);
            },
          );

          if (dateTimeRange == null) {
            return;
          }

          // DateRangePickerでは開始日と終了日で別々の上限を設定できず、終了日のために広げたlastDateが開始日にも適用される
          // 開始日は従来通り「最終服用日の翌日」までしか選べないように、選択後に検証する
          if (dateTimeRange.start.isAfter(pillSheetGroup.availableRestDurationBeginDate.date())) {
            analytics.logEvent(
              name: 'change_rest_duration_invalid_begin',
              parameters: {'rest_duration_id': restDuration.id},
            );
            onError(AlertError(L.pauseStartDateMustBeOnOrBefore(format(pillSheetGroup.availableRestDurationBeginDate))));
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
            // 服用再開予定日が変わると、服用再開予定日以降のリマインドを登録する日が変わるため、更新後の状態で登録しなおす
            await registerReminderLocalNotification();
          } catch (e) {
            onError(e);
          }

          onChanged();
        },
      );
    }
  }
}
