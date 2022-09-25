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
  const factory Schedule(
      {String? id,
      required String title,
      @JsonKey(
        fromJson: NonNullTimestampConverter.timestampToDateTime,
        toJson: NonNullTimestampConverter.dateTimeToTimestamp,
      )
          required DateTime date,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
          required DateTime? remindDateTime,
      @JsonKey(
        fromJson: NonNullTimestampConverter.timestampToDateTime,
        toJson: NonNullTimestampConverter.dateTimeToTimestamp,
      )
          required DateTime createdDateTime}) = _Schedule;
  const Schedule._();

  factory Schedule.fromJson(Map<String, dynamic> json) => _$ScheduleFromJson(json);
}
