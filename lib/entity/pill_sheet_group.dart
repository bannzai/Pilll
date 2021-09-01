import 'package:pilll/entity/firestore_document_id_escaping_to_json.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pill_sheet_group.g.dart';
part 'pill_sheet_group.freezed.dart';

abstract class PillSheetGroupFirestoreKeys {
  static final createdAt = "createdAt";
}

@freezed
abstract class PillSheetGroup implements _$PillSheetGroup {
  PillSheetGroup._();
  @JsonSerializable(explicitToJson: true)
  factory PillSheetGroup({
    @JsonKey(includeIfNull: false, toJson: toNull)
        String? id,
    required List<String> pillSheetIDs,
    required List<PillSheet> pillSheets,
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

  bool get isDeactived => activedPillSheet == null;
  bool get isDeleted => deletedAt != null;
}
