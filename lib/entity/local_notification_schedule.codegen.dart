import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_notification_schedule.codegen.freezed.dart';
part 'local_notification_schedule.codegen.g.dart';

@freezed
class LocalNotificationSchedule with _$LocalNotificationSchedule {
  @JsonSerializable(explicitToJson: true)
  factory LocalNotificationSchedule({
    required String key,
    required int localNotification,
    required DateTime scheduleDateTime,
  }) = _LocalNotificationSchedule;
  LocalNotificationSchedule._();

  factory LocalNotificationSchedule.fromJson(Map<String, dynamic> json) =>
      _$LocalNotificationScheduleFromJson(json);
}
