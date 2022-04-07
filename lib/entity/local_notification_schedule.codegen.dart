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
    required String key,
    required LocalNotificationScheduleKind kind,
    required int localNotification,
    required DateTime scheduleDateTime,
  }) = _LocalNotificationSchedule;
  LocalNotificationSchedule._();

  factory LocalNotificationSchedule.fromJson(Map<String, dynamic> json) =>
      _$LocalNotificationScheduleFromJson(json);
}
