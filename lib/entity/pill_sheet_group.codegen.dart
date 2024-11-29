import 'package:collection/collection.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/datetime/date_add.dart';
import 'package:pilll/utils/datetime/date_compare.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/datetime/date_range.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

part 'pill_sheet_group.codegen.g.dart';
part 'pill_sheet_group.codegen.freezed.dart';

class PillSheetGroupFirestoreKeys {
  static const createdAt = 'createdAt';
  static const deletedAt = 'deletedAt';
}

@freezed
class PillSheetGroup with _$PillSheetGroup {
  @JsonSerializable(explicitToJson: true)
  factory PillSheetGroup({
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
    // NOTE: [SyncData:Widget] このプロパティはWidgetに同期されてる
    PillSheetGroupDisplayNumberSetting? displayNumberSetting,
    @Default(PillSheetAppearanceMode.number) PillSheetAppearanceMode pillSheetAppearanceMode,
  }) = _PillSheetGroup;
  PillSheetGroup._();

  factory PillSheetGroup.fromJson(Map<String, dynamic> json) => _$PillSheetGroupFromJson(json);

  PillSheet? get activePillSheet => activePillSheetWhen(now());

  PillSheet? activePillSheetWhen(DateTime date) {
    final filtered = pillSheets.where((element) => element.isActiveFor(date));
    return filtered.isEmpty ? null : filtered.first;
  }

  PillSheetGroup replaced(PillSheet pillSheet) {
    if (pillSheet.id == null) {
      throw FormatException(L.cannotUpdateToReplacePillSheet('null'));
    }
    final index = pillSheets.indexWhere((element) => element.id == pillSheet.id);
    if (index == -1) {
      throw FormatException(L.cannotUpdateToReplacePillSheet(pillSheet.id ?? ''));
    }
    final copied = [...pillSheets];
    copied[index] = pillSheet;
    return copyWith(pillSheets: copied);
  }

  bool get _isDeleted => deletedAt != null;
  bool get isDeactived => activePillSheet == null || _isDeleted;

  // NOTE: 0が返却される時は、過去のピルシートグループを参照しているときなど
  // NOTE: [SyncData:Widget] このプロパティはWidgetに同期されてる
  int get sequentialTodayPillNumber {
    switch (pillSheetAppearanceMode) {
      case PillSheetAppearanceMode.number:
      case PillSheetAppearanceMode.date:
        return 0;
      case PillSheetAppearanceMode.sequential:
        return pillNumbersForSequential.firstWhereOrNull((element) => isSameDay(element.date, today()))?.number ?? 0;
      case PillSheetAppearanceMode.cyclicSequential:
        return pillNumbersForCyclicSequential.firstWhereOrNull((element) => isSameDay(element.date, today()))?.number ?? 0;
    }
  }

  // NOTE: 0が返却される時は、過去のピルシートグループを参照しているときなど
  int get sequentialLastTakenPillNumber {
    final activePillSheetLastTakenDate = activePillSheet?.lastTakenDate;
    if (activePillSheetLastTakenDate == null) {
      return 0;
    }
    switch (pillSheetAppearanceMode) {
      case PillSheetAppearanceMode.number:
      case PillSheetAppearanceMode.date:
        return 0;
      case PillSheetAppearanceMode.sequential:
        return pillNumbersForSequential.firstWhereOrNull((element) => isSameDay(element.date, activePillSheetLastTakenDate))?.number ?? 0;
      case PillSheetAppearanceMode.cyclicSequential:
        return pillNumbersForCyclicSequential.firstWhereOrNull((element) => isSameDay(element.date, activePillSheetLastTakenDate))?.number ?? 0;
    }
  }

  int get sequentialEstimatedEndPillNumber {
    switch (pillSheetAppearanceMode) {
      case PillSheetAppearanceMode.number:
      case PillSheetAppearanceMode.date:
        return 0;
      case PillSheetAppearanceMode.sequential:
        return pillNumbersForSequential.last.number;
      case PillSheetAppearanceMode.cyclicSequential:
        return pillNumbersForCyclicSequential.last.number;
    }
  }

  List<PillSheetType> get pillSheetTypes => pillSheets.map((e) => e.pillSheetType).toList();

  List<RestDuration> get restDurations {
    return pillSheets.fold<List<RestDuration>>(
      [],
      (previousValue, element) => previousValue + element.restDurations,
    );
  }

  late final List<PillSheetGroupPillNumberDomainPillMarkValue> pillMarksPillNumber = _pillMarksPillNumber();
  late final List<PillSheetGroupPillNumberDomainPillMarkValue> pillNumbersForSequential = _pillNumbersForSequential();
  late final List<PillSheetGroupPillNumberDomainPillMarkValue> pillNumbersForCyclicSequential = _pillNumbersForCyclicSequential();
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
      case PillSheetAppearanceMode.cyclicSequential:
        return _displayCycleSequentialPillSheetNumber(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet);
    }
  }

  String displayPillNumber({
    required bool premiumOrTrial,
    required int pageIndex,
    required int pillNumberInPillSheet,
  }) {
    return switch (pillSheetAppearanceMode) {
      PillSheetAppearanceMode.number => _displayPillNumberInPillSheet(pillNumberInPillSheet: pillNumberInPillSheet),
      PillSheetAppearanceMode.date => premiumOrTrial
          ? _displayPillSheetDate(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet)
          : _displayPillNumberInPillSheet(pillNumberInPillSheet: pillNumberInPillSheet),
      PillSheetAppearanceMode.sequential => _displaySequentialPillSheetNumber(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet),
      PillSheetAppearanceMode.cyclicSequential =>
        _displayCycleSequentialPillSheetNumber(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet),
    };
  }

  String _displayPillNumberInPillSheet({
    required int pillNumberInPillSheet,
  }) {
    return '$pillNumberInPillSheet';
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
    return pillNumbersForSequential.where((e) => e.pillSheet.groupIndex == pageIndex).toList()[pillNumberInPillSheet - 1].number.toString();
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
    return pillNumbersForCyclicSequential.where((e) => e.pillSheet.groupIndex == pageIndex).toList()[pillNumberInPillSheet - 1].number.toString();
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
        return pillMarksPillNumber;
      case PillSheetAppearanceMode.sequential:
        return pillNumbersForSequential;
      case PillSheetAppearanceMode.cyclicSequential:
        return pillNumbersForCyclicSequential;
    }
  }

  List<PillSheetGroupPillNumberDomainPillMarkValue> _pillMarksPillNumber() {
    return pillSheets
        .map((pillSheet) =>
            pillSheet.dates.indexed.map((e) => PillSheetGroupPillNumberDomainPillMarkValue(pillSheet: pillSheet, date: e.$2, number: e.$1)).toList())
        .flattened
        .toList();
  }

  List<PillSheetGroupPillNumberDomainPillMarkValue> _pillNumbersForSequential() {
    List<PillSheetGroupPillNumberDomainPillMarkValue> pillMarks = [];
    var offset = 0;
    for (final pillSheet in pillSheets) {
      final dates = pillSheet.dates;
      pillMarks.addAll(
        dates.indexed.map(
          (e) => PillSheetGroupPillNumberDomainPillMarkValue(
            pillSheet: pillSheet,
            date: e.$2,
            number: e.$1 + 1 + offset,
          ),
        ),
      );
      offset += dates.length;
    }

    final displayNumberSetting = this.displayNumberSetting;
    if (displayNumberSetting != null) {
      final beginPillNumberOffset = displayNumberSetting.beginPillNumber;
      if (beginPillNumberOffset != null && beginPillNumberOffset > 0) {
        pillMarks = pillMarks.map((e) => e.copyWith(number: e.number + beginPillNumberOffset - 1)).toList();
      }

      final endPillNumberOffset = displayNumberSetting.endPillNumber;
      if (endPillNumberOffset != null && endPillNumberOffset > 0) {
        final endPillNumberOffsetIndexes = pillMarks.indexed.where((e) => e.$2.number % endPillNumberOffset == 0).map((e) => e.$1);
        final beginPillNumberOffsetIndexes = endPillNumberOffsetIndexes.map((e) => e + 1).toList();
        for (int beginPillNumberOffsetIndex in beginPillNumberOffsetIndexes) {
          if (beginPillNumberOffsetIndex < pillMarks.length) {
            for (final (sublistIndex, (pillMarkIndex, pillMark)) in pillMarks.indexed.toList().sublist(beginPillNumberOffsetIndex).indexed.toList()) {
              pillMarks[pillMarkIndex] = pillMark.copyWith(number: sublistIndex + 1);
            }
          }
        }
      }
    }

    return pillMarks;
  }

  List<PillSheetGroupPillNumberDomainPillMarkValue> _pillNumbersForCyclicSequential() {
    List<PillSheetGroupPillNumberDomainPillMarkValue> pillMarks = [];
    var offset = 0;
    for (final pillSheet in pillSheets) {
      final dates = pillSheet.dates;
      pillMarks.addAll(
        dates.indexed.map(
          (e) => PillSheetGroupPillNumberDomainPillMarkValue(
            pillSheet: pillSheet,
            date: e.$2,
            number: e.$1 + 1 + offset,
          ),
        ),
      );
      offset += dates.length;
    }

    for (final restDuration in restDurations) {
      final restDurationEndDate = restDuration.endDate;
      if (restDurationEndDate != null) {
        final index = pillMarks.indexed.firstWhereOrNull((e) => isSameDay(e.$2.date, restDurationEndDate))?.$1;
        if (index != null) {
          for (final (sublistIndex, (pillMarkIndex, pillMark)) in pillMarks.indexed.toList().sublist(index).indexed.toList()) {
            pillMarks[pillMarkIndex] = pillMark.copyWith(number: sublistIndex + 1);
          }
        }
      }
    }

    final displayNumberSetting = this.displayNumberSetting;
    if (displayNumberSetting != null) {
      final beginPillNumberOffset = displayNumberSetting.beginPillNumber;
      if (beginPillNumberOffset != null && beginPillNumberOffset > 0) {
        pillMarks = pillMarks.map((e) => e.copyWith(number: e.number + beginPillNumberOffset - 1)).toList();
      }

      final endPillNumberOffset = displayNumberSetting.endPillNumber;
      if (endPillNumberOffset != null && endPillNumberOffset > 0) {
        final endPillNumberOffsetIndexes = pillMarks.indexed.where((e) => e.$2.number % endPillNumberOffset == 0).map((e) => e.$1);
        final beginPillNumberOffsetIndexes = endPillNumberOffsetIndexes.map((e) => e + 1).toList();
        for (int beginPillNumberOffsetIndex in beginPillNumberOffsetIndexes) {
          if (beginPillNumberOffsetIndex < pillMarks.length) {
            for (final (sublistIndex, (pillMarkIndex, pillMark)) in pillMarks.indexed.toList().sublist(beginPillNumberOffsetIndex).indexed.toList()) {
              pillMarks[pillMarkIndex] = pillMark.copyWith(number: sublistIndex + 1);
            }
          }
        }
      }
    }

    return pillMarks;
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

extension PillSheetGroupMenstruationDomain on PillSheetGroup {
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
