import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/utils/datetime/date_add.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/datetime/date_range.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

part 'pill_sheet_group.codegen.g.dart';
part 'pill_sheet_group.codegen.freezed.dart';

class PillSheetGroupFirestoreKeys {
  static const createdAt = "createdAt";
  static const deletedAt = "deletedAt";
}

@freezed
class PillSheetGroup with _$PillSheetGroup {
  const PillSheetGroup._();
  @JsonSerializable(explicitToJson: true)
  const factory PillSheetGroup({
    @JsonKey(includeIfNull: false) String? id,
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

  PillSheet? get activePillSheet => activePillSheetWhen(now());

  PillSheet? activePillSheetWhen(DateTime date) {
    final filtered = pillSheets.where((element) => element.isActiveFor(date));
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
  bool get isDeactived => activePillSheet == null || _isDeleted;

  int get sequentialTodayPillNumber {
    if (pillSheets.isEmpty) {
      return 0;
    }
    final activePillSheet = this.activePillSheet;
    if (activePillSheet == null) {
      return 0;
    }

    final passedPillCountForPillSheetTypes = summarizedPillCountWithPillSheetTypesToIndex(
        pillSheetTypes: pillSheets.map((e) => e.pillSheetType).toList(), toIndex: activePillSheet.groupIndex);

    var sequentialTodayPillNumber = passedPillCountForPillSheetTypes + activePillSheet.todayPillNumber;

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
    final activePillSheet = this.activePillSheet;
    if (activePillSheet == null) {
      return 0;
    }

    final passedPillCountForPillSheetTypes = summarizedPillCountWithPillSheetTypesToIndex(
        pillSheetTypes: pillSheets.map((e) => e.pillSheetType).toList(), toIndex: activePillSheet.groupIndex);

    var sequentialLastTakenPillNumber = passedPillCountForPillSheetTypes + activePillSheet.lastTakenPillNumber;

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

  PillSheet get lastTakenPillSheetOrFirstPillSheet {
    for (final pillSheet in pillSheets.reversed) {
      if (pillSheet.lastTakenDate != null) {
        return pillSheet;
      }
    }

    return pillSheets[0];
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

    a は28錠タイプのピルシートが3枚設定されている場合に設定では22番に生理期間が始まると設定した場合
      1枚目: 22番から
      2枚目: 22番から
      3枚目: 22番から

    bは後者の計算式で下のようになっても許容をすることにする
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

    final summarizedPillCount = pillSheets.fold<int>(
      0,
      (previousValue, element) => previousValue + element.typeInfo.totalCount,
    );
    // ピルシートグループの中に何度pillNumberForFromMenstruation が出てくるか算出
    final numberOfMenstruationSettingInPillSheetGroup = summarizedPillCount ~/ setting.pillNumberForFromMenstruation;
    // 28番ごとなら28,56,84番目開始の番号とマッチさせるために各始まりの番号を配列にする
    List<int> fromMenstruations = [];
    for (var i = 0; i < numberOfMenstruationSettingInPillSheetGroup; i++) {
      fromMenstruations.add(setting.pillNumberForFromMenstruation + (setting.pillNumberForFromMenstruation * i));
    }

    final menstruationDateRanges = <DateRange>[];
    for (final pillSheet in pillSheets) {
      if (setting.pillNumberForFromMenstruation < pillSheet.typeInfo.totalCount) {
        final left = pillSheet.displayPillTakeDate(setting.pillNumberForFromMenstruation);
        final right = left.addDays(setting.durationMenstruation - 1);
        menstruationDateRanges.add(DateRange(left, right));
      } else {
        final offset = summarizedPillCountWithPillSheetTypesToIndex(pillSheetTypes: pillSheetTypes, toIndex: pillSheet.groupIndex);
        final begin = offset + 1;
        final end = begin + (pillSheet.typeInfo.totalCount - 1);

        for (final fromMenstruation in fromMenstruations) {
          if (begin <= fromMenstruation && fromMenstruation <= end) {
            final left = pillSheet.displayPillTakeDate(fromMenstruation - offset);
            final right = left.addDays(setting.durationMenstruation - 1);
            menstruationDateRanges.add(DateRange(left, right));
          }
        }
      }
    }

    return menstruationDateRanges;
  }

  List<RestDuration> get restDurations {
    return pillSheets.fold<List<RestDuration>>(
      [],
      (previousValue, element) => previousValue + element.restDurations,
    );
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
