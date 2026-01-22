// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_sheet_modified_history.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PillSheetModifiedHistoryImpl _$$PillSheetModifiedHistoryImplFromJson(
        Map<String, dynamic> json) =>
    _$PillSheetModifiedHistoryImpl(
      version: json['version'] ?? 'v2',
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
      ttlExpiresDateTime: TimestampConverter.timestampToDateTime(
          json['ttlExpiresDateTime'] as Timestamp?),
      archivedDateTime: TimestampConverter.timestampToDateTime(
          json['archivedDateTime'] as Timestamp?),
      isArchived: json['isArchived'] as bool? ?? false,
      value: PillSheetModifiedHistoryValue.fromJson(
          json['value'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PillSheetModifiedHistoryImplToJson(
    _$PillSheetModifiedHistoryImpl instance) {
  final val = <String, dynamic>{
    'version': instance.version,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['actionType'] = instance.actionType;
  val['estimatedEventCausingDate'] =
      NonNullTimestampConverter.dateTimeToTimestamp(
          instance.estimatedEventCausingDate);
  val['createdAt'] =
      NonNullTimestampConverter.dateTimeToTimestamp(instance.createdAt);
  val['beforePillSheetGroup'] = instance.beforePillSheetGroup?.toJson();
  val['afterPillSheetGroup'] = instance.afterPillSheetGroup?.toJson();
  val['ttlExpiresDateTime'] =
      TimestampConverter.dateTimeToTimestamp(instance.ttlExpiresDateTime);
  val['archivedDateTime'] =
      TimestampConverter.dateTimeToTimestamp(instance.archivedDateTime);
  val['isArchived'] = instance.isArchived;
  val['value'] = instance.value.toJson();
  return val;
}
