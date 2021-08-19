// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_sheet_modified_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PillSheetModifiedHistory _$_$_PillSheetModifiedHistoryFromJson(
    Map<String, dynamic> json) {
  return _$_PillSheetModifiedHistory(
    id: json['id'] as String?,
    actionType: json['actionType'] as String,
    value: PillSheetModifiedHistoryValue.fromJson(
        json['value'] as Map<String, dynamic>),
    pillSheetID: json['pillSheetID'] as String,
    before: json['before'] == null
        ? null
        : PillSheet.fromJson(json['before'] as Map<String, dynamic>),
    after: PillSheet.fromJson(json['after'] as Map<String, dynamic>),
    estimatedEventCausingDate: NonNullTimestampConverter.timestampToDateTime(
        json['estimatedEventCausingDate'] as Timestamp),
    createdAt: NonNullTimestampConverter.timestampToDateTime(
        json['createdAt'] as Timestamp),
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
  val['value'] = instance.value.toJson();
  val['pillSheetID'] = instance.pillSheetID;
  val['before'] = instance.before?.toJson();
  val['after'] = instance.after.toJson();
  val['estimatedEventCausingDate'] =
      NonNullTimestampConverter.dateTimeToTimestamp(
          instance.estimatedEventCausingDate);
  val['createdAt'] =
      NonNullTimestampConverter.dateTimeToTimestamp(instance.createdAt);
  return val;
}
