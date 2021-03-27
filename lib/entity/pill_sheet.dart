import 'package:pilll/entity/firestore_document_id_escaping_to_json.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'pill_sheet.g.dart';
part 'pill_sheet.freezed.dart';

abstract class PillSheetFirestoreKey {
  static final String typeInfo = "typeInfo";
  static final String createdAt = "createdAt";
  static final String deletedAt = "deletedAt";
  static final String lastTakenDate = "lastTakenDate";
  static final String beginingDate = "beginingDate";
}

@freezed
abstract class PillSheetTypeInfo with _$PillSheetTypeInfo {
  @JsonSerializable(explicitToJson: true)
  factory PillSheetTypeInfo({
    required String pillSheetTypeReferencePath,
    required String name,
    required int totalCount,
    required int dosingPeriod,
  }) = _PillSheetTypeInfo;

  factory PillSheetTypeInfo.fromJson(Map<String, dynamic> json) =>
      _$PillSheetTypeInfoFromJson(json);
  Map<String, dynamic> toJson() =>
      _$_$_PillSheetTypeInfoToJson(this as _$_PillSheetTypeInfo);
}

@freezed
abstract class PillSheetModel implements _$PillSheetModel {
  String? get documentID => id;

  PillSheetType get sheetType =>
      PillSheetTypeFunctions.fromRawPath(typeInfo.pillSheetTypeReferencePath);

  PillSheetModel._();
  @JsonSerializable(explicitToJson: true)
  factory PillSheetModel({
    @JsonKey(includeIfNull: false, toJson: toNull)
        String? id,
    @JsonKey()
        required PillSheetTypeInfo typeInfo,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime beginingDate,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
        DateTime? lastTakenDate,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
        DateTime? createdAt,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
        DateTime? deletedAt,
  }) = _PillSheetModel;
  factory PillSheetModel.create(PillSheetType type) => PillSheetModel(
        typeInfo: type.typeInfo,
        beginingDate: today(),
        lastTakenDate: null,
      );

  factory PillSheetModel.fromJson(Map<String, dynamic> json) =>
      _$PillSheetModelFromJson(json);
  Map<String, dynamic> toJson() =>
      _$_$_PillSheetModelToJson(this as _$_PillSheetModel);

  PillSheetType get pillSheetType =>
      PillSheetTypeFunctions.fromRawPath(typeInfo.pillSheetTypeReferencePath);

  int get todayPillNumber {
    var diff = today().difference(beginingDate.date()).inDays;
    return diff % pillSheetType.totalCount + 1;
  }

  int get lastTakenPillNumber => lastTakenDate == null
      ? 0
      : lastTakenDate!.date().difference(beginingDate.date()).inDays + 1;

  bool get allTaken => todayPillNumber == lastTakenPillNumber;
  bool get isEnded =>
      today().difference(beginingDate.date()).inDays + 1 >
      pillSheetType.totalCount;
  bool get isDeleted => deletedAt != null;
  bool get inNotTakenDuration => todayPillNumber > typeInfo.dosingPeriod;
}
