import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_notification_schedule_id.codegen.freezed.dart';
part 'local_notification_schedule_id.codegen.g.dart';

@freezed
class LocalNotificationScheduleID with _$LocalNotificationScheduleID {
  @JsonSerializable(explicitToJson: true)
  factory LocalNotificationScheduleID({
    required String key,
    required int localNotificationID,
    required DateTime scheduleDateTime,
  }) = _LocalNotificationScheduleID;
  LocalNotificationScheduleID._();

  factory LocalNotificationScheduleID.fromJson(Map<String, dynamic> json) =>
      _$LocalNotificationScheduleIDFromJson(json);
}

@freezed
class LocalNotificationScheduleIDs with _$LocalNotificationScheduleIDs {
  @JsonSerializable(explicitToJson: true)
  factory LocalNotificationScheduleIDs({
    required List<LocalNotificationScheduleID> ids,
  }) = _LocalNotificationScheduleIDs;
  LocalNotificationScheduleIDs._();

  factory LocalNotificationScheduleIDs.fromJson(Map<String, dynamic> json) =>
      _$LocalNotificationScheduleIDsFromJson(json);
}
