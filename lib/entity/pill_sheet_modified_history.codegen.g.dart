// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_sheet_modified_history.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PillSheetModifiedHistory _$$_PillSheetModifiedHistoryFromJson(
        Map<String, dynamic> json) =>
    _$_PillSheetModifiedHistory(
      version: json['version'] ?? "v1",
      id: json['id'] as String?,
      actionType: json['actionType'] as String,
      estimatedEventCausingDate: NonNullTimestampConverter.timestampToDateTime(
          json['estimatedEventCausingDate'] as Timestamp),
      createdAt: NonNullTimestampConverter.timestampToDateTime(
          json['createdAt'] as Timestamp),
      beforePillSheetGroup: json['beforePillSheetGroup'] == null
          ? null
          : PillSheetGroup.fromJson(
              json['beforePillSheetGroup'] as Map<String, dynamic>),
      afterPillSheetGroup: json['afterPillSheetGroup'] == null
          ? null
          : PillSheetGroup.fromJson(
              json['afterPillSheetGroup'] as Map<String, dynamic>),
      timeToLive: TimestampConverter.timestampToDateTime(
          json['timeToLive'] as Timestamp?),
      value: PillSheetModifiedHistoryValue.fromJson(
          json['value'] as Map<String, dynamic>),
      pillSheetID: json['pillSheetID'] as String?,
      pillSheetGroupID: json['pillSheetGroupID'] as String?,
      beforePillSheetID: json['beforePillSheetID'] as String?,
      afterPillSheetID: json['afterPillSheetID'] as String?,
      before: json['before'] == null
          ? null
          : PillSheet.fromJson(json['before'] as Map<String, dynamic>),
      after: json['after'] == null
          ? null
          : PillSheet.fromJson(json['after'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_PillSheetModifiedHistoryToJson(
    _$_PillSheetModifiedHistory instance) {
  final val = <String, dynamic>{
    'version': instance.version,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', toNull(instance.id));
  val['actionType'] = instance.actionType;
  val['estimatedEventCausingDate'] =
      NonNullTimestampConverter.dateTimeToTimestamp(
          instance.estimatedEventCausingDate);
  val['createdAt'] =
      NonNullTimestampConverter.dateTimeToTimestamp(instance.createdAt);
  val['beforePillSheetGroup'] = instance.beforePillSheetGroup?.toJson();
  val['afterPillSheetGroup'] = instance.afterPillSheetGroup?.toJson();
  val['timeToLive'] =
      TimestampConverter.dateTimeToTimestamp(instance.timeToLive);
  val['value'] = instance.value.toJson();
  val['pillSheetID'] = instance.pillSheetID;
  val['pillSheetGroupID'] = instance.pillSheetGroupID;
  val['beforePillSheetID'] = instance.beforePillSheetID;
  val['afterPillSheetID'] = instance.afterPillSheetID;
  val['before'] = instance.before?.toJson();
  val['after'] = instance.after?.toJson();
  return val;
}
