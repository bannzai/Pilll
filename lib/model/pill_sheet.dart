import 'package:Pilll/model/firestore_timestamp_converter.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/util/today.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';
part 'pill_sheet.g.dart';

@JsonSerializable(nullable: false, explicitToJson: true)
class PillSheetTypeInfo {
  final String pillSheetTypeReferencePath;
  final int totalCount;
  final int dosingPeriod;

  PillSheetTypeInfo({
    @required this.pillSheetTypeReferencePath,
    @required this.totalCount,
    @required this.dosingPeriod,
  })  : assert(pillSheetTypeReferencePath != null),
        assert(totalCount != null),
        assert(dosingPeriod != null);

  factory PillSheetTypeInfo.fromJson(Map<String, dynamic> json) =>
      _$PillSheetTypeInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PillSheetTypeInfoToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PillSheetModel {
  @JsonKey(ignore: true)
  final String id;
  String get documentID => id;

  @JsonKey(nullable: false)
  final PillSheetTypeInfo typeInfo;
  @JsonKey(
    nullable: false,
    fromJson: TimestampConverter.timestampToDateTime,
    toJson: TimestampConverter.dateTimeToTimestamp,
  )
  DateTime beginingDate;
  @JsonKey(
    fromJson: TimestampConverter.timestampToDateTime,
    toJson: TimestampConverter.dateTimeToTimestamp,
  )
  final DateTime lastTakenDate;
  @JsonKey(
    fromJson: TimestampConverter.timestampToDateTime,
    toJson: TimestampConverter.dateTimeToTimestamp,
  )
  DateTime createdAt;
  @JsonKey(
    fromJson: TimestampConverter.timestampToDateTime,
    toJson: TimestampConverter.dateTimeToTimestamp,
  )
  DateTime deletedAt;

  @JsonKey(ignore: true)
  DateTime Function() _today;
  PillSheetModel({
    this.id,
    @required this.typeInfo,
    @required this.beginingDate,
    @required this.lastTakenDate,
    DateTime Function() todayBuilder = today,
  })  : assert(typeInfo != null),
        assert(beginingDate != null) {
    _today = todayBuilder;
  }

  factory PillSheetModel.create(PillSheetType type) => PillSheetModel(
        typeInfo: type.typeInfo,
        beginingDate: today(),
        lastTakenDate: null,
      );

  factory PillSheetModel.fromJson(Map<String, dynamic> json) =>
      _$PillSheetModelFromJson(json);
  Map<String, dynamic> toJson() => _$PillSheetModelToJson(this);

  PillSheetType get pillSheetType =>
      PillSheetTypeFunctions.fromRawPath(typeInfo.pillSheetTypeReferencePath);
  int get todayPillNumber {
    var diff = _today().difference(beginingDate).inDays;
    return diff % pillSheetType.totalCount + 1;
  }

  int get lastTakenPillNumber => lastTakenDate == null
      ? 1
      : lastTakenDate.difference(beginingDate).inDays + 1;

  void resetTodayTakenPillNumber(int pillNumber) {
    if (pillNumber == todayPillNumber) return;
    var betweenToday = pillNumber - todayPillNumber;
    beginingDate = beginingDate.add(Duration(days: betweenToday));
  }
}
