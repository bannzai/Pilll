import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_notification_schedule_id.codegen.freezed.dart';
part 'local_notification_schedule_id.codegen.g.dart';

@freezed
class LocalNotificationScheduleID with _$LocalNotificationScheduleID {
  @JsonSerializable(explicitToJson: true)
  factory LocalNotificationScheduleID({
    required int key,
    required int localNotificaationID,
  }) = _LocalNotificationScheduleID;
  LocalNotificationScheduleID._();

  factory LocalNotificationScheduleID.fromJson(Map<String, dynamic> json) =>
      _$LocalNotificationScheduleIDFromJson(json);
}
