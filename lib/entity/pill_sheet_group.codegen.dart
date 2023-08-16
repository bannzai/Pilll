import 'package:pilll/entity/firestore_document_id_escaping_to_json.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/utils/datetime/date_range.dart';
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

  List<PillSheetType> get pillSheetTypes => pillSheets.map((e) => e.pillSheetType).toList();

  // 日付以外を返す
  String displayPillNumberOnlyNumber({
    required PillSheetAppearanceMode pillSheetAppearanceMode,
    required int pageIndex,
    required int pillNumberInPillSheet,
  }) {
    switch (pillSheetAppearanceMode) {
      case PillSheetAppearanceMode.sequential:
        return _displaySequentialPillSheetNumber(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet);
      default:
        return _displayPillNumberInPillSheet(pillNumberInPillSheet: pillNumberInPillSheet);
    }
  }

  String displayPillNumber({
    required bool premiumOrTrial,
    required PillSheetAppearanceMode pillSheetAppearanceMode,
    required int pageIndex,
    required int pillNumberInPillSheet,
  }) {
    if (premiumOrTrial && pillSheetAppearanceMode == PillSheetAppearanceMode.date) {
      return _displayPillSheetDate(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet);
    } else if (pillSheetAppearanceMode == PillSheetAppearanceMode.sequential) {
      return _displaySequentialPillSheetNumber(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet);
    } else {
      return _displayPillNumberInPillSheet(pillNumberInPillSheet: pillNumberInPillSheet);
    }
  }

  String _displayPillNumberInPillSheet({
    required int pillNumberInPillSheet,
  }) {
    return "$pillNumberInPillSheet";
  }

  String _displaySequentialPillSheetNumber({
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

  String _displayPillSheetDate({
    required int pageIndex,
    required int pillNumberInPillSheet,
  }) {
    return DateTimeFormatter.monthAndDay(pillSheets[pageIndex].displayPillTakeDate(pillNumberInPillSheet));
  }

  /*
    1. setting.pillNumberForFromMenstruation < pillSheet.typeInfo.totalCount の場合は単純にこの式の結果を用いる
    2. setting.pillNumberForFromMenstruation > pillSheet.typeInfo.totalCount の場合はページ数も考慮して
      pillSheet.begin < pillNumberForFromMenstruation < pillSheet.typeInfo.totalCount の場合の結果を用いる

    a. 想定される使い方は各ピルシートごとに同じ生理の期間開始を設定したい(1.の仕様)
    b. ヤーズフレックスのようにどこか1枚だけ生理の開始期間を設定したい(2.の仕様)

    なので後者の計算式で下のようになっても許容をすることにする

    28錠タイプが4枚ある場合で46番ごとに生理期間がくる設定をしていると生理期間の始まりが
      1枚目: なし
      2枚目: 18番から
      3枚目: なし
      4枚目: 8番から
  */
  List<DateRange> menstruationDateRanges({required Setting setting}) {
    // 0が設定できる。その場合は生理設定をあえて無視したいと考えて0を返す
    if (setting.pillNumberForFromMenstruation == 0 || setting.durationMenstruation == 0) {
      return [];
    }

    final menstruationDateRanges = <DateRange>[];
    for (final pillSheet in pillSheets) {
      if (setting.pillNumberForFromMenstruation < pillSheet.typeInfo.totalCount) {
        // a. 想定される使い方は各ピルシートごとに同じ生理の期間開始を設定したい(1.の仕様)
        final left = pillSheet.displayPillTakeDate(setting.pillNumberForFromMenstruation);
        final right = left.add(Duration(days: setting.durationMenstruation - 1));
        menstruationDateRanges.add(DateRange(left, right));
      } else {
        // b. ヤーズフレックスのようにどこか1枚だけ生理の開始期間を設定したい(2.の仕様)
        final offset = summarizedPillCountWithPillSheetTypesToIndex(pillSheetTypes: pillSheetTypes, toIndex: pillSheet.groupIndex);
        final begin = offset + 1;
        final end = begin + (pillSheet.typeInfo.totalCount - 1);
        if (begin <= setting.pillNumberForFromMenstruation && setting.pillNumberForFromMenstruation <= end) {
          final left = pillSheet.displayPillTakeDate(setting.pillNumberForFromMenstruation - offset);
          final right = left.add(Duration(days: setting.durationMenstruation - 1));
          menstruationDateRanges.add(DateRange(left, right));
        }
      }
    }

    return menstruationDateRanges;
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
