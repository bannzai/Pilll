import 'package:pilll/entity/firestore_document_id_escaping_to_json.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pill_sheet_group.g.dart';
part 'pill_sheet_group.freezed.dart';

class PillSheetGroupFirestoreKeys {
  static final createdAt = "createdAt";
}

@freezed
@JsonSerializable(explicitToJson: true)
class PillSheetGroup implements _$PillSheetGroup {
  PillSheetGroup._();
  factory PillSheetGroup({
    @JsonKey(includeIfNull: false, toJson: toNull)
        String? id,
    List<String> pillSheetIDs,
    List<PillSheet> pillSheets,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        DateTime createdAt,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
        DateTime? deletedAt,
  }) = _PillSheetGroup;

  factory PillSheetGroup.fromJson(Map<String, dynamic> json) =>
      _$PillSheetGroupFromJson(json);
  Map<String, dynamic> toJson() =>
      _$_$_PillSheetGroupToJson(this as _$_PillSheetGroup);

  PillSheet? get activedPillSheet {
    final filtered = pillSheets.where((element) => element.isActive);
    return filtered.isEmpty ? null : filtered.first;
  }

  PillSheetGroup replaced(PillSheet pillSheet) {
    if (pillSheet.id == null) {
      throw FormatException("ピルシートの置き換えによる更新できませんでした");
    }
    final index =
        pillSheets.indexWhere((element) => element.id == pillSheet.id);
    if (index == -1) {
      throw FormatException("ピルシートの置き換えによる更新できませんでした。id: ${pillSheet.id}");
    }
    final copied = [...pillSheets];
    copied[index] = pillSheet;
    return copyWith(pillSheets: copied);
  }

  bool get _isDeleted => deletedAt != null;
  bool get isDeactived => activedPillSheet == null || _isDeleted;
  bool get hasPillSheetRestDuration =>
      pillSheets.map((e) => e.pillSheetType.hasRestDurationType).contains(true);

  int get sequentialTodayPillNumber {
    if (pillSheets.isEmpty) {
      return 0;
    }
    final activedPillSheet = this.activedPillSheet;
    if (activedPillSheet == null) {
      return 0;
    }
    if (activedPillSheet.groupIndex == 0) {
      return activedPillSheet.todayPillNumber;
    }
    final passedPillSheets = pillSheets.sublist(0, activedPillSheet.groupIndex);
    if (passedPillSheets.isEmpty) {
      return activedPillSheet.todayPillNumber;
    }

    final passedPillCountForPillSheetTypes =
        summarizedPillSheetTypeTotalCountToPageIndex(
            pillSheetTypes:
                passedPillSheets.map((e) => e.pillSheetType).toList(),
            pageIndex: activedPillSheet.groupIndex);
    return passedPillCountForPillSheetTypes + activedPillSheet.todayPillNumber;
  }
}
