import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';

part 'local_notification_schedule.codegen.freezed.dart';
part 'local_notification_schedule.codegen.g.dart';

enum LocalNotificationScheduleKind { reminderNotification }

abstract class LocalNotificationScheduleFirestoreField {
  static const String kind = 'kind';
}

@freezed
class LocalNotificationSchedule with _$LocalNotificationSchedule {
  @JsonSerializable(explicitToJson: true)
  factory LocalNotificationSchedule({
    required LocalNotificationScheduleKind kind,
    required DateTime scheduleDateTime,
    required String title,
    required String message,
    // NOTE: localNotificationID set  to count of all local notification schedules
    required int localNotificationID,
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
class LocalNotificationScheduleDocument
    with _$LocalNotificationScheduleDocument {
  @JsonSerializable(explicitToJson: true)
  factory LocalNotificationScheduleDocument({
    required LocalNotificationScheduleKind kind,
    required List<LocalNotificationSchedule> schedules,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime createdDate,
  }) = _LocalNotificationScheduleDocument;
  LocalNotificationScheduleDocument._();

  factory LocalNotificationScheduleDocument.fromJson(
          Map<String, dynamic> json) =>
      _$LocalNotificationScheduleDocumentFromJson(json);
}
