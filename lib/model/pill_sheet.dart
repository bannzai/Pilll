import 'package:Pilll/model/firestore_timestamp_converter.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/util/today.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
part 'pill_sheet.g.dart';

abstract class PillSheetFirestoreFieldKeys {
  static final String beginingDate = "beginingDate";
  static final String pillSheetTypeInfo = "pillSheetTypeInfo";
  static final String pillSheetTypeInfoRef = "reference";
  static final String pillSheetTypeInfoPillCount = "pillCount";
  static final String pillSheetTypeInfoDosingPeriod = "dosingPeriod";
  static final String lastTakenDate = "lastTakenDate";
}

@JsonSerializable(nullable: false)
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

@JsonSerializable(nullable: false)
class PillSheetModel {
  final PillSheetTypeInfo typeInfo;
  @JsonKey(
    fromJson: TimestampConverter.timestampToDateTime,
    toJson: TimestampConverter.dateTimeToTimestamp,
  )
  DateTime _beginingDate;
  DateTime get beginingDate => _beginingDate;
  @JsonKey(
    fromJson: TimestampConverter.timestampToDateTime,
    toJson: TimestampConverter.dateTimeToTimestamp,
  )
  final DateTime lastTakenDate;

  DateTime Function() _today;
  PillSheetModel({
    @required this.typeInfo,
    @required DateTime beginingDate,
    @required this.lastTakenDate,
    DateTime Function() todayBuilder = today,
  })  : assert(typeInfo != null),
        assert(beginingDate != null),
        assert(lastTakenDate != null) {
    _beginingDate = beginingDate;
    _today = todayBuilder;
  }

  factory PillSheetModel.fromJson(Map<String, dynamic> json) =>
      _$PillSheetModelFromJson(json);
  Map<String, dynamic> toJson() => _$PillSheetModelToJson(this);

  PillSheetType get pillSheetType =>
      PillSheetTypeFunctions.fromRawPath(typeInfo.pillSheetTypeReferencePath);
  int get todayPillNumber {
    return _today().difference(beginingDate).inDays + 1;
  }

  void resetTodayTakenPillNumber(int pillNumber) {
    if (pillNumber == todayPillNumber) return;
    var betweenToday = pillNumber - todayPillNumber;
    _beginingDate.add(Duration(days: betweenToday));
  }
}
