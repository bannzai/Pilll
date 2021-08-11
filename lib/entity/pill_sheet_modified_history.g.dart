// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_sheet_modified_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PillSheetModifiedHistory _$_$_PillSheetModifiedHistoryFromJson(
    Map<String, dynamic> json) {
  return _$_PillSheetModifiedHistory(
    id: json['id'] as String,
    actionType: json['actionType'] as String,
    userID: json['userID'] as String,
    value: PillSheetModifiedHistoryValue.fromJson(
        json['value'] as Map<String, dynamic>),
    after: PillSheet.fromJson(json['after'] as Map<String, dynamic>),
    estimatedEventCausingDate: NonNullTimestampConverter.timestampToDateTime(
        json['estimatedEventCausingDate'] as Timestamp),
  );
}

Map<String, dynamic> _$_$_PillSheetModifiedHistoryToJson(
    _$_PillSheetModifiedHistory instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', toNull(instance.id));
  val['actionType'] = instance.actionType;
  val['userID'] = instance.userID;
  val['value'] = instance.value.toJson();
  val['after'] = instance.after.toJson();
  val['estimatedEventCausingDate'] =
      NonNullTimestampConverter.dateTimeToTimestamp(
          instance.estimatedEventCausingDate);
  return val;
}
