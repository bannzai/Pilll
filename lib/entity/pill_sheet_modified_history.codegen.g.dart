// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_sheet_modified_history.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PillSheetModifiedHistory _$PillSheetModifiedHistoryFromJson(Map<String, dynamic> json) => _PillSheetModifiedHistory(
  version: json['version'] ?? 'v1',
  id: json['id'] as String?,
  actionType: json['actionType'] as String,
  estimatedEventCausingDate: NonNullTimestampConverter.timestampToDateTime(json['estimatedEventCausingDate'] as Timestamp),
  createdAt: NonNullTimestampConverter.timestampToDateTime(json['createdAt'] as Timestamp),
  beforePillSheetGroup: json['beforePillSheetGroup'] == null ? null : PillSheetGroup.fromJson(json['beforePillSheetGroup'] as Map<String, dynamic>),
  afterPillSheetGroup: json['afterPillSheetGroup'] == null ? null : PillSheetGroup.fromJson(json['afterPillSheetGroup'] as Map<String, dynamic>),
  ttlExpiresDateTime: TimestampConverter.timestampToDateTime(json['ttlExpiresDateTime'] as Timestamp?),
  archivedDateTime: TimestampConverter.timestampToDateTime(json['archivedDateTime'] as Timestamp?),
  isArchived: json['isArchived'] as bool? ?? false,
  value: PillSheetModifiedHistoryValue.fromJson(json['value'] as Map<String, dynamic>),
  pillSheetID: json['pillSheetID'] as String?,
  pillSheetGroupID: json['pillSheetGroupID'] as String?,
  beforePillSheetID: json['beforePillSheetID'] as String?,
  afterPillSheetID: json['afterPillSheetID'] as String?,
  before: json['before'] == null ? null : PillSheet.fromJson(json['before'] as Map<String, dynamic>),
  after: json['after'] == null ? null : PillSheet.fromJson(json['after'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PillSheetModifiedHistoryToJson(_PillSheetModifiedHistory instance) => <String, dynamic>{
  'version': instance.version,
  'id': ?instance.id,
  'actionType': instance.actionType,
  'estimatedEventCausingDate': NonNullTimestampConverter.dateTimeToTimestamp(instance.estimatedEventCausingDate),
  'createdAt': NonNullTimestampConverter.dateTimeToTimestamp(instance.createdAt),
  'beforePillSheetGroup': instance.beforePillSheetGroup?.toJson(),
  'afterPillSheetGroup': instance.afterPillSheetGroup?.toJson(),
  'ttlExpiresDateTime': TimestampConverter.dateTimeToTimestamp(instance.ttlExpiresDateTime),
  'archivedDateTime': TimestampConverter.dateTimeToTimestamp(instance.archivedDateTime),
  'isArchived': instance.isArchived,
  'value': instance.value.toJson(),
  'pillSheetID': instance.pillSheetID,
  'pillSheetGroupID': instance.pillSheetGroupID,
  'beforePillSheetID': instance.beforePillSheetID,
  'afterPillSheetID': instance.afterPillSheetID,
  'before': instance.before?.toJson(),
  'after': instance.after?.toJson(),
};
