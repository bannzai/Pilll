import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:cloud_firestore/cloud_firestore.dart';

part 'local_notification_schedule.codegen.freezed.dart';
part 'local_notification_schedule.codegen.g.dart';

enum LocalNotificationScheduleKind { reminderNotification }

extension LocalNotificationScheduleKindExtension
    on LocalNotificationScheduleKind {
  String get collectionID {
    switch (this) {
      case LocalNotificationScheduleKind.reminderNotification:
        return 'reminder_notification';
    }
  }
}

abstract class LocalNotificationScheduleFirestoreField {
  static const String kind = 'kind';
}

// Concrete identifier offsets
const reminderNotificationIdentifierOffset = 1 * 10000000;

@freezed
class LocalNotificationSchedule with _$LocalNotificationSchedule {
  @JsonSerializable(explicitToJson: true)
  factory LocalNotificationSchedule({
    required LocalNotificationScheduleKind kind,
    required String title,
    required String message,
    // NOTE: localNotificationID set  to count of all local notification schedules
    required int localNotificationID,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime scheduleDateTime,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime createdDate,
  }) = _LocalNotificationSchedule;
  LocalNotificationSchedule._();

  factory LocalNotificationSchedule.fromJson(Map<String, dynamic> json) =>
      _$LocalNotificationScheduleFromJson(json);
}

@freezed
class LocalNotificationScheduleCollection
    with _$LocalNotificationScheduleCollection {
  @JsonSerializable(explicitToJson: true)
  factory LocalNotificationScheduleCollection({
    required LocalNotificationScheduleKind kind,
    required List<LocalNotificationSchedule> schedules,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime createdDate,
  }) = _LocalNotificationScheduleCollection;
  LocalNotificationScheduleCollection._();

  factory LocalNotificationScheduleCollection.reminderNotification({
    required int hour,
    required int minute,
    required List<LocalNotificationSchedule>
        reminderNotificationLocalNotificationScheduleCollection,
    required PillSheetGroup pillSheetGroup,
    required PillSheet activedPillSheet,
    required bool isTrialOrPremium,
    required Setting setting,
    required tz.TZDateTime tzFrom,
  }) {
    final lastID = reminderNotificationLocalNotificationScheduleCollection
        .where((element) =>
            element.kind == LocalNotificationScheduleKind.reminderNotification)
        .sorted(
            (a, b) => a.localNotificationID.compareTo(b.localNotificationID))
        .lastOrNull
        ?.localNotificationID;
    final localNotificationIDOffset =
        reminderNotificationIdentifierOffset + (lastID ?? 0);

    final schedules = <LocalNotificationSchedule>[];
    for (final pillSheet in pillSheetGroup.pillSheets) {
      if (pillSheet.groupIndex < activedPillSheet.groupIndex) {
        continue;
      }

      for (var pillIndex = 0;
          pillIndex < pillSheet.typeInfo.totalCount;
          pillIndex++) {
        if (activedPillSheet.groupIndex == pillSheet.groupIndex &&
            activedPillSheet.todayPillNumber <= pillIndex) {
          continue;
        }

        final reminderDate = tzFrom
            .tzDate()
            .add(Duration(days: pillIndex))
            .add(Duration(hours: hour))
            .add(Duration(minutes: minute));
        final beforePillCount = summarizedPillCountWithPillSheetsToEndIndex(
          pillSheets: pillSheetGroup.pillSheets,
          endIndex: pillSheet.groupIndex,
        );
        final title = () {
          if (isTrialOrPremium) {
            var result = setting.reminderNotificationCustomization.word;
            if (!setting
                .reminderNotificationCustomization.isInVisibleReminderDate) {
              result += " ";
              result +=
                  "${reminderDate.month}/${reminderDate.day} (${WeekdayFunctions.weekdayFromDate(reminderDate).weekdayString()})";
            }
            if (!setting
                .reminderNotificationCustomization.isInVisiblePillNumber) {
              result += " ";
              result +=
                  "${pillSheetPillNumber(pillSheet: pillSheet, targetDate: reminderDate)}番";
            }
            return result;
          } else {
            return "💊の時間です";
          }
        }();
        final message = '';

        final localNotificationSchedule = LocalNotificationSchedule(
          kind: LocalNotificationScheduleKind.reminderNotification,
          scheduleDateTime: reminderDate,
          title: title,
          message: message,
          localNotificationID:
              localNotificationIDOffset + beforePillCount + pillIndex,
          createdDate: now(),
        );
        schedules.add(localNotificationSchedule);
      }
    }

    return LocalNotificationScheduleCollection(
      kind: LocalNotificationScheduleKind.reminderNotification,
      schedules: schedules,
      createdDate: now(),
    );
  }

  factory LocalNotificationScheduleCollection.fromJson(
          Map<String, dynamic> json) =>
      _$LocalNotificationScheduleCollectionFromJson(json);
}
