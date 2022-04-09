import 'package:flutter/material.dart';
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
    required int localNotificationIDWithoutOffset,
    required int localNotificationIDOffset,
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

  int get actualLocalNotificationID =>
      localNotificationIDWithoutOffset + localNotificationIDOffset;
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
    required List<LocalNotificationSchedule>
        reminderNotificationLocalNotificationScheduleCollection,
    required PillSheetGroup pillSheetGroup,
    required PillSheet activedPillSheet,
    required bool isTrialOrPremium,
    required Setting setting,
    required tz.TZDateTime tzFrom,
  }) {
    final lastScheduleLocalNotificationIDWithoutOffset =
        reminderNotificationLocalNotificationScheduleCollection
                .where((element) =>
                    element.kind ==
                    LocalNotificationScheduleKind.reminderNotification)
                .sorted((a, b) => a.localNotificationIDWithoutOffset
                    .compareTo(b.localNotificationIDWithoutOffset))
                .lastOrNull
                ?.localNotificationIDWithoutOffset ??
            0;
    debugPrint(
        'lastScheduleLocalNotificationIDWithoutOffset: $lastScheduleLocalNotificationIDWithoutOffset');

    final schedules = <LocalNotificationSchedule>[];
    for (final reminderTime in setting.reminderTimes) {
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
              .add(Duration(hours: reminderTime.hour))
              .add(Duration(minutes: reminderTime.minute));

          // NOTE: LocalNotification must be scheduled at least 3 minutes after the current time (in iOS, Android not confirm).
          // Delay five minutes just to be sure.
          if (!reminderDate
              .add(const Duration(minutes: 5))
              .isAfter(tzFrom.tzDate())) {
            continue;
          }

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
            localNotificationIDWithoutOffset:
                lastScheduleLocalNotificationIDWithoutOffset +
                    beforePillCount +
                    pillIndex,
            localNotificationIDOffset: reminderNotificationIdentifierOffset,
            createdDate: now(),
          );
          schedules.add(localNotificationSchedule);
        }
      }
    }

    debugPrint('schedules: $schedules');
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
