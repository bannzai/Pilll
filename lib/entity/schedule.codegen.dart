import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'schedule.codegen.g.dart';
part 'schedule.codegen.freezed.dart';

class ScheduleFirestoreKey {
  static const String date = "date";
}

@freezed
class Schedule with _$Schedule {
  @JsonSerializable(explicitToJson: true)
  const factory Schedule({
    String? id,
    required String title,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime date,
    LocalNotification? localNotification,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime createdDateTime,
  }) = _Schedule;
  const Schedule._();

  factory Schedule.fromJson(Map<String, dynamic> json) => _$ScheduleFromJson(json);
}

@freezed
class LocalNotification with _$LocalNotification {
  @JsonSerializable(explicitToJson: true)
  const factory LocalNotification({
    required int localNotificationID,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime remindDateTime,
  }) = _LocalNotification;
  const LocalNotification._();

  factory LocalNotification.fromJson(Map<String, dynamic> json) => _$LocalNotificationFromJson(json);
}
