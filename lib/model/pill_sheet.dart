import 'package:Pilll/model/firestore_timestamp_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';
part 'pill_sheet.freezed.dart';
part 'pill_sheet.g.dart';

abstract class PillSheetFirestoreFieldKeys {
  static final String beginingDate = "beginingDate";
  static final String pillSheetTypeInfo = "pillSheetTypeInfo";
  static final String pillSheetTypeInfoRef = "reference";
  static final String pillSheetTypeInfoPillCount = "pillCount";
  static final String pillSheetTypeInfoDosingPeriod = "dosingPeriod";
  static final String lastTakenDate = "lastTakenDate";
}

@freezed
abstract class PillSheetTypeInfo with _$PillSheetTypeInfo {
  factory PillSheetTypeInfo({
    @required String pillSheetTypeReferencePath,
    @required int totalCount,
    @required int dosingPeriod,
  }) = _PillSheetTypeInfo;

  factory PillSheetTypeInfo.fromJson(Map<String, dynamic> json) =>
      _$PillSheetTypeInfoFromJson(json);
  Map<String, dynamic> toJson() => _$_$_PillSheetTypeInfoToJson(this);
}

@freezed
abstract class PillSheetModel with _$PillSheetModel {
  factory PillSheetModel({
    @required
        PillSheetTypeInfo typeInfo,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    @required
        DateTime beginingDate,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    @required
        DateTime lastTakenDate,
  }) = _PillSheetModel;

  factory PillSheetModel.fromJson(Map<String, dynamic> json) =>
      _$PillSheetModelFromJson(json);
  Map<String, dynamic> toJson() => _$_$_PillSheetModelToJson(this);
}
