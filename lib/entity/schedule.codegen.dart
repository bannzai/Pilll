import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
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
    required String title,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime date,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime createdDateTime,
  }) = _Schedule;
  const Schedule._();
}
