import 'package:freezed_annotation/freezed_annotation.dart';

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
    // NOTE: localNotificationID set  to count of all local notification schedules
    required int localNotificationID,
  }) = _LocalNotificationSchedule;
  LocalNotificationSchedule._();

  factory LocalNotificationSchedule.fromJson(Map<String, dynamic> json) =>
      _$LocalNotificationScheduleFromJson(json);
}
