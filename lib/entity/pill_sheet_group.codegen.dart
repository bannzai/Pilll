import 'package:collection/collection.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/entity/number_range.codegen.dart';
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

  List<RestDuration> get restDurations {
    return pillSheets.fold<List<RestDuration>>(
      [],
      (previousValue, element) => previousValue + element.restDurations,
    );
  }
}

extension PillSheetGroupDisplayDomain on PillSheetGroup {
  // 日付以外を返す
  String displayPillNumberOnlyNumber({
    required PillSheetAppearanceMode pillSheetAppearanceMode,
    required int pageIndex,
    required int pillNumberInPillSheet,
  }) {
    switch (pillSheetAppearanceMode) {
      case PillSheetAppearanceMode.sequential:
        return _displaySequentialPillSheetNumber(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet);
      case PillSheetAppearanceMode.number:
        return _displayPillNumberInPillSheet(pillNumberInPillSheet: pillNumberInPillSheet);
      case PillSheetAppearanceMode.date:
        return _displayPillNumberInPillSheet(pillNumberInPillSheet: pillNumberInPillSheet);
      case PillSheetAppearanceMode.sequentialWithCycle:
        return _displayCycleSequentialPillSheetNumber(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet);
    }
  }

  String displayPillNumber({
    required bool premiumOrTrial,
    required PillSheetAppearanceMode pillSheetAppearanceMode,
    required int pageIndex,
    required int pillNumberInPillSheet,
  }) {
    return switch (pillSheetAppearanceMode) {
      PillSheetAppearanceMode.number => _displayPillNumberInPillSheet(pillNumberInPillSheet: pillNumberInPillSheet),
      PillSheetAppearanceMode.date => premiumOrTrial
          ? _displayPillSheetDate(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet)
          : _displayPillNumberInPillSheet(pillNumberInPillSheet: pillNumberInPillSheet),
      PillSheetAppearanceMode.sequential => _displaySequentialPillSheetNumber(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet),
      PillSheetAppearanceMode.sequentialWithCycle =>
        _displayCycleSequentialPillSheetNumber(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet),
    };
  }

  String _displayPillNumberInPillSheet({
    required int pillNumberInPillSheet,
  }) {
    return "$pillNumberInPillSheet";
  }

  @visibleForTesting
  String displayPillSheetDate({
    required int pageIndex,
    required int pillNumberInPillSheet,
  }) {
    return _displayPillSheetDate(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet);
  }

  String _displayPillSheetDate({
    required int pageIndex,
    required int pillNumberInPillSheet,
  }) {
    return DateTimeFormatter.monthAndDay(pillSheets[pageIndex].displayPillTakeDate(pillNumberInPillSheet));
  }

  @visibleForTesting
  String displaySequentialPillSheetNumber({
    required int pageIndex,
    required int pillNumberInPillSheet,
  }) {
    return _displaySequentialPillSheetNumber(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet);
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

  @visibleForTesting
  String displayCycleSequentialPillSheetNumber({
    required int pageIndex,
    required int pillNumberInPillSheet,
  }) {
    return _displayCycleSequentialPillSheetNumber(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet);
  }

  String _displayCycleSequentialPillSheetNumber({
    required int pageIndex,
    required int pillNumberInPillSheet,
  }) {
    return pillNumbersForSequentialWithCycle()[pageIndex].numbers[pillNumberInPillSheet - 1].toString();
  }
}

@freezed
class PillSheetGroupPillNumberDomainPillMarkValue with _$PillSheetGroupPillNumberDomainPillMarkValue {
  const factory PillSheetGroupPillNumberDomainPillMarkValue({
    required PillSheet pillSheet,
    required DateTime date,
    required int number,
  }) = _PillSheetGroupPillNumberDomainPillMarkValue;
}

extension PillSheetGroupPillNumberDomain on PillSheetGroup {
  PillSheetGroupPillNumberDomainPillMarkValue pillMark({
    required PillSheet pillSheet,
    required PillSheetAppearanceMode pillSheetAppearanceMode,
  }) {
    return pillMarks(pillSheetAppearanceMode: pillSheetAppearanceMode).firstWhere((e) => e.pillSheet.id == pillSheet.id);
  }

  List<PillSheetGroupPillNumberDomainPillMarkValue> pillMarks({required PillSheetAppearanceMode pillSheetAppearanceMode}) {
    switch (pillSheetAppearanceMode) {
      // NOTE: 日付のbegin,endも.numberと一緒な扱いにする
      case PillSheetAppearanceMode.number:
      case PillSheetAppearanceMode.date:
        return pillMarksPillNumber();
      case PillSheetAppearanceMode.sequential:
        return pillNumbersForSequential();
      case PillSheetAppearanceMode.sequentialWithCycle:
        return pillNumbersForSequentialWithCycle();
    }
  }

  List<PillSheetGroupPillNumberDomainPillMarkValue> pillMarksPillNumber() {
    return pillSheets
        .map((pillSheet) => pillSheet
            .dates()
            .indexed
            .map((e) => PillSheetGroupPillNumberDomainPillMarkValue(pillSheet: pillSheet, date: e.$2, number: e.$1))
            .toList())
        .flattened
        .toList();
  }

  List<PillNumberRange> pillNumbersForSequential() {
    final List<PillNumberRange> pillNumberRanges = [];
    for (final pillSheet in pillSheets) {
      var begin = summarizedPillCountWithPillSheetTypesToIndex(
        pillSheetTypes: pillSheetTypes,
        toIndex: pillSheet.groupIndex,
      );
      var end = begin + pillSheet.pillSheetType.totalCount - 1;

      final displayNumberSetting = this.displayNumberSetting;
      if (displayNumberSetting != null) {
        final beginPillNumberOffset = displayNumberSetting.beginPillNumber;
        if (beginPillNumberOffset != null && beginPillNumberOffset > 0) {
          begin += (beginPillNumberOffset - 1);
          end += (beginPillNumberOffset - 1);
        }

        final endPillNumberOffset = displayNumberSetting.endPillNumber;
        if (endPillNumberOffset != null && endPillNumberOffset > 0) {
          begin %= endPillNumberOffset;
          if (begin == 0) {
            begin = 1;
          }
          end %= endPillNumberOffset;
          if (end == 0) {
            end = endPillNumberOffset;
          }
        }
      }

      pillNumberRanges.add(PillNumberRange(pillSheet: pillSheet, begin: begin, end: end));
    }

    return pillNumberRanges;
  }

  List<List<PillNumberRange>> pillNumbersForSequentialWithCycle() {
    final List<List<PillNumberRange>> pillNumberRanges = [];
    for (final pillSheet in pillSheets) {
      final List<PillNumberRange> list = [];
      int begin;
      int end;
      (int begin, int end) withDisplayNumberSetting(int begin, int end) {
        final displayNumberSetting = this.displayNumberSetting;
        if (displayNumberSetting != null) {
          // NOTE: beginの決め方がpillSheet.groupIndex != 0の時に前の最後の番号+1で決定されるので、beginPllNumberでは変更されない
          if (pillSheet.groupIndex == 0) {
            final beginPillNumberOffset = displayNumberSetting.beginPillNumber;
            if (beginPillNumberOffset != null && beginPillNumberOffset > 0) {
              begin += (beginPillNumberOffset - 1);
              end += (beginPillNumberOffset - 1);
            }
          }

          final endPillNumberOffset = displayNumberSetting.endPillNumber;
          if (endPillNumberOffset != null && endPillNumberOffset > 0) {
            begin %= endPillNumberOffset;
            if (begin == 0) {
              begin = 1;
            }
            end %= endPillNumberOffset;
            if (end == 0) {
              end = endPillNumberOffset;
            }
          }
        }
        return (begin, end);
      }

      if (pillSheet.groupIndex == 0) {
        begin = 1;
        end = pillSheet.pillSheetType.totalCount;
      } else {
        begin = pillNumberRanges.last.last.end + 1;
        end = begin + pillSheet.pillSheetType.totalCount - 1;
      }

      if (pillSheet.restDurations.isNotEmpty) {
        for (final restDuration in pillSheet.restDurations) {
          final diff = daysBetween(restDuration.beginDate, restDuration.endDate ?? today());
          (begin, end) = withDisplayNumberSetting(begin, end + diff);
          list.add(PillNumberRange(pillSheet: pillSheet, begin: begin, end: end));

          begin = 1;
          end = pillSheet.pillSheetType.totalCount;
        }
      } else {
        (begin, end) = withDisplayNumberSetting(begin, end);
        list.add(PillNumberRange(pillSheet: pillSheet, begin: begin, end: end));
      }

      pillNumberRanges.add(list);
    }

    return pillNumberRanges;
  }
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

typedef PillSheetGroupMenstruationDomainNumberRange = ({int begin, int end, int pillSheetGroupIndex});

extension PillSheetGroupMenstruationDomain on PillSheetGroup {
  List<PillSheetGroupMenstruationDomainNumberRange> menstruationNumberRanges({required Setting setting}) {
    // 0が設定できる。その場合は生理設定をあえて無視したいと考えて0を返す
    if (setting.pillNumberForFromMenstruation == 0 || setting.durationMenstruation == 0) {
      return [];
    }

    final menstruationRanges = <PillSheetGroupMenstruationDomainNumberRange>[];
    for (final pillSheet in pillSheets) {
      if (setting.pillNumberForFromMenstruation < pillSheet.typeInfo.totalCount) {
        menstruationRanges.add((
          begin: setting.pillNumberForFromMenstruation,
          end: setting.pillNumberForFromMenstruation + setting.durationMenstruation - 1,
          pillSheetGroupIndex: pillSheet.groupIndex,
        ));
      } else {
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

        final offset = summarizedPillCountWithPillSheetTypesToIndex(pillSheetTypes: pillSheetTypes, toIndex: pillSheet.groupIndex);
        final begin = offset + 1;
        final end = begin + (pillSheet.typeInfo.totalCount - 1);
        for (final fromMenstruation in fromMenstruations) {
          if (begin <= fromMenstruation && fromMenstruation <= end) {
            final begin = fromMenstruation - offset;
            menstruationRanges.add((
              begin: begin,
              end: begin + setting.durationMenstruation - 1,
              pillSheetGroupIndex: pillSheet.groupIndex,
            ));
          }
        }
      }
    }

    return menstruationRanges;
  }

  List<DateRange> menstruationDateRanges({required Setting setting}) {
    // 0が設定できる。その場合は生理設定をあえて無視したいと考えて0を返す
    if (setting.pillNumberForFromMenstruation == 0 || setting.durationMenstruation == 0) {
      return [];
    }

    final menstruationDateRanges = <DateRange>[];
    for (final pillSheet in pillSheets) {
      if (setting.pillNumberForFromMenstruation < pillSheet.typeInfo.totalCount) {
        final left = pillSheet.displayPillTakeDate(setting.pillNumberForFromMenstruation);
        final right = left.addDays(setting.durationMenstruation - 1);
        menstruationDateRanges.add(DateRange(left, right));
      } else {
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
}

extension PillSheetGroupRestDurationDomain on PillSheetGroup {
  RestDuration? get lastActiveRestDuration {
    return pillSheets.map((e) => e.activeRestDuration).whereNotNull().firstOrNull;
  }

  PillSheet get lastTakenPillSheetOrFirstPillSheet {
    for (final pillSheet in pillSheets.reversed) {
      if (pillSheet.lastTakenDate != null) {
        return pillSheet;
      }
    }

    return pillSheets[0];
  }

  PillSheet get targetBeginRestDurationPillSheet {
    final PillSheet targetPillSheet;
    if (lastTakenPillSheetOrFirstPillSheet.isTakenAll) {
      // 最後に飲んだピルシートのピルが全て服用済みの場合は、次のピルシートを対象としてrestDurationを設定する
      // すでに服用済みの場合は、次のピルの番号から服用お休みを開始する必要があるから
      targetPillSheet = pillSheets[lastTakenPillSheetOrFirstPillSheet.groupIndex + 1];
    } else {
      targetPillSheet = lastTakenPillSheetOrFirstPillSheet;
    }
    return targetPillSheet;
  }

  /// 服用お休みを開始できる日付を返す。beginRestDurationやDatePickerの初期値に利用する
  DateTime get availableRestDurationBeginDate {
    final lastTakenDate = targetBeginRestDurationPillSheet.lastTakenDate;
    if (lastTakenDate == null) {
      // 上述のtargetBeginRestDurationPillSheetを決定するifにより以下の内容が考えられる
      // if (pillSheetGroup.lastTakenPillSheetOrFirstPillSheet.isTakenAll)
      // true: 0番以外のピルシート
      // false: 0番のピルシート

      // 1番目から服用お休みする場合は、beginDateは今日になる
      return today();
    } else {
      // 服用お休みは原則最後に服用した日付の次の日付からスタートする
      return lastTakenDate.addDays(1);
    }
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
