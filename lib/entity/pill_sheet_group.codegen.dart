import 'package:pilll/entity/firestore_document_id_escaping_to_json.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/utils/datetime/date_compare.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/emoji/emoji.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

part 'pill_sheet_group.codegen.g.dart';
part 'pill_sheet_group.codegen.freezed.dart';

class PillSheetGroupFirestoreKeys {
  static const createdAt = "createdAt";
}

@freezed
class PillSheetGroup with _$PillSheetGroup {
  const PillSheetGroup._();
  @JsonSerializable(explicitToJson: true)
  const factory PillSheetGroup({
    @JsonKey(includeIfNull: false, toJson: toNull) String? id,
    required List<String> pillSheetIDs,
    required List<PillSheet> pillSheets,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime createdAt,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    DateTime? deletedAt,
    PillSheetGroupDisplayNumberSetting? displayNumberSetting,
  }) = _PillSheetGroup;

  factory PillSheetGroup.fromJson(Map<String, dynamic> json) => _$PillSheetGroupFromJson(json);

  PillSheet? get activedPillSheet {
    final filtered = pillSheets.where((element) => element.isActive);
    return filtered.isEmpty ? null : filtered.first;
  }

  PillSheetGroup replaced(PillSheet pillSheet) {
    if (pillSheet.id == null) {
      throw const FormatException("ピルシートの置き換えによる更新できませんでした");
    }
    final index = pillSheets.indexWhere((element) => element.id == pillSheet.id);
    if (index == -1) {
      throw FormatException("ピルシートの置き換えによる更新できませんでした。id: ${pillSheet.id}");
    }
    final copied = [...pillSheets];
    copied[index] = pillSheet;
    return copyWith(pillSheets: copied);
  }

  bool get _isDeleted => deletedAt != null;
  bool get isDeactived => activedPillSheet == null || _isDeleted;

  int get sequentialTodayPillNumber {
    if (pillSheets.isEmpty) {
      return 0;
    }
    final activedPillSheet = this.activedPillSheet;
    if (activedPillSheet == null) {
      return 0;
    }

    final passedPillCountForPillSheetTypes = summarizedPillCountWithPillSheetTypesToIndex(
        pillSheetTypes: pillSheets.map((e) => e.pillSheetType).toList(), toIndex: activedPillSheet.groupIndex);

    var sequentialTodayPillNumber = passedPillCountForPillSheetTypes + activedPillSheet.todayPillNumber;

    final displayNumberSetting = this.displayNumberSetting;
    if (displayNumberSetting != null) {
      final beginPillNumberOffset = displayNumberSetting.beginPillNumber;
      if (beginPillNumberOffset != null && beginPillNumberOffset > 0) {
        sequentialTodayPillNumber += (beginPillNumberOffset - 1);
      }

      final endPillNumberOffset = displayNumberSetting.endPillNumber;
      if (endPillNumberOffset != null && endPillNumberOffset > 0) {
        sequentialTodayPillNumber %= endPillNumberOffset;
        if (sequentialTodayPillNumber == 0) {
          sequentialTodayPillNumber = endPillNumberOffset;
        }
      }
    }

    return sequentialTodayPillNumber;
  }

  int get sequentialLastTakenPillNumber {
    if (pillSheets.isEmpty) {
      return 0;
    }
    final activedPillSheet = this.activedPillSheet;
    if (activedPillSheet == null) {
      return 0;
    }

    final passedPillCountForPillSheetTypes = summarizedPillCountWithPillSheetTypesToIndex(
        pillSheetTypes: pillSheets.map((e) => e.pillSheetType).toList(), toIndex: activedPillSheet.groupIndex);

    var sequentialLastTakenPillNumber = passedPillCountForPillSheetTypes + activedPillSheet.lastTakenPillNumber;

    final displayNumberSetting = this.displayNumberSetting;
    if (displayNumberSetting != null) {
      final beginPillNumberOffset = displayNumberSetting.beginPillNumber;
      if (beginPillNumberOffset != null && beginPillNumberOffset > 0) {
        sequentialLastTakenPillNumber += (beginPillNumberOffset - 1);
      }

      final endPillNumberOffset = displayNumberSetting.endPillNumber;
      if (endPillNumberOffset != null && endPillNumberOffset > 0) {
        sequentialLastTakenPillNumber %= endPillNumberOffset;
        if (sequentialTodayPillNumber == 0) {
          sequentialLastTakenPillNumber = endPillNumberOffset;
        }
      }
    }

    return sequentialLastTakenPillNumber;
  }

  int get estimatedEndPillNumber {
    var estimatedEndPillNumber =
        summarizedPillCountWithPillSheetTypesToIndex(pillSheetTypes: pillSheets.map((e) => e.pillSheetType).toList(), toIndex: pillSheets.length);

    final displayNumberSetting = this.displayNumberSetting;
    if (displayNumberSetting != null) {
      final beginPillNumberOffset = displayNumberSetting.beginPillNumber;
      if (beginPillNumberOffset != null && beginPillNumberOffset > 0) {
        estimatedEndPillNumber += (beginPillNumberOffset - 1);
      }

      final endPillNumberOffset = displayNumberSetting.endPillNumber;
      if (endPillNumberOffset != null && endPillNumberOffset > 0) {
        estimatedEndPillNumber %= endPillNumberOffset;
        if (sequentialTodayPillNumber == 0) {
          estimatedEndPillNumber = endPillNumberOffset;
        }
      }
    }

    return estimatedEndPillNumber;
  }

  int pillSheetDisplayNumber({required int pillSheetGroupIndex, required int sourcePillNumberInPillSheet}) {
    final pageOffset =
        summarizedPillCountWithPillSheetTypesToIndex(pillSheetTypes: pillSheets.map((e) => e.pillSheetType).toList(), toIndex: pillSheetGroupIndex);
    var result = pageOffset + sourcePillNumberInPillSheet;

    final displayNumberSetting = this.displayNumberSetting;
    final beginDisplayNumberSetting = displayNumberSetting?.beginPillNumber;
    final endDisplayNumberSetting = displayNumberSetting?.endPillNumber;
    if (displayNumberSetting != null) {
      if (beginDisplayNumberSetting != null && beginDisplayNumberSetting > 0) {
        result += beginDisplayNumberSetting - 1;
      }

      if (endDisplayNumberSetting != null && endDisplayNumberSetting > 0) {
        result = result % endDisplayNumberSetting;

        if (result == 0) {
          result = endDisplayNumberSetting;
        }
      }
    }

    return result;
  }

  List<PillSheetType> get pillSheetTypes => pillSheets.map((e) => e.pillSheetType).toList();

  String displayPillSheetNumber({
    required bool premiumOrTrial,
    required PillSheetAppearanceMode pillSheetAppearanceMode,
    required int pageIndex,
    required int pillNumberInPillSheet,
  }) {
    if (premiumOrTrial && pillSheetAppearanceMode == PillSheetAppearanceMode.date) {
      return displayPillSheetDate(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet);
    } else if (pillSheetAppearanceMode == PillSheetAppearanceMode.sequential) {
      return displaySequentialPillSheetNumber(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet);
    } else {
      return displayPillSheetNumberInPillSheet(pillNumberInPillSheet: pillNumberInPillSheet);
    }
  }

  String displayPillSheetNumberInPillSheet({
    required int pillNumberInPillSheet,
  }) {
    return "$pillNumberInPillSheet";
  }

  String displaySequentialPillSheetNumber({
    required int pageIndex,
    required int pillNumberInPillSheet,
  }) {
    final offset = summarizedPillCountWithPillSheetTypesToIndex(
      pillSheetTypes: pillSheetTypes,
      toIndex: pageIndex,
    );
    var number = offset + pillNumberInPillSheet;

    final displayNumberSetting = this.displayNumberSetting;
    if (displayNumberSetting != null) {
      final beginPillNumberOffset = displayNumberSetting.beginPillNumber;
      if (beginPillNumberOffset != null && beginPillNumberOffset > 0) {
        number += (beginPillNumberOffset - 1);
      }

      final endPillNumberOffset = displayNumberSetting.endPillNumber;
      if (endPillNumberOffset != null && endPillNumberOffset > 0) {
        number %= endPillNumberOffset;
        if (number == 0) {
          number = endPillNumberOffset;
        }
      }
    }
    return "$number";
  }

  String displayPillSheetDate({
    required int pageIndex,
    required int pillNumberInPillSheet,
  }) {
    return DateTimeFormatter.monthAndDay(pillSheets[pageIndex].displayPillTakeDate(pillNumberInPillSheet));
  }
}

@freezed
class PillSheetGroupDisplayNumberSetting with _$PillSheetGroupDisplayNumberSetting {
  @JsonSerializable(explicitToJson: true)
  const factory PillSheetGroupDisplayNumberSetting({
    int? beginPillNumber,
    int? endPillNumber,
  }) = _PillSheetGroupDisplayNumberSetting;

  factory PillSheetGroupDisplayNumberSetting.fromJson(Map<String, dynamic> json) => _$PillSheetGroupDisplayNumberSettingFromJson(json);
}
