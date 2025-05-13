import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
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
        return pillNumbersForCyclicSequential.firstWhereOrNull((element) => isSameDay(element.date, today()))?.number ?? 0;
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
        return pillNumbersForCyclicSequential.firstWhereOrNull((element) => isSameDay(element.date, activePillSheetLastTakenDate))?.number ?? 0;
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
        return pillNumbersForCyclicSequential.last.number;
      case PillSheetAppearanceMode.cyclicSequential:
        return pillNumbersForCyclicSequential.last.number;
    }
  }

  PillSheet get lastTakenPillSheetOrFirstPillSheet {
    for (final pillSheet in pillSheets.reversed) {
      if (pillSheet.lastTakenDate != null) {
        return pillSheet;
      }
    }
    return pillSheets[0];
  }

  // テストまで作ったが、プロダクションではまだ使ってない。とはいえ普通に使うメソッドなので visibleForTestingにしておく
  @visibleForTesting
  int? get lastTakenPillNumberWithoutDate {
    for (final pillSheet in pillSheets.reversed) {
      final lastTakenPillNumber = pillSheet.lastTakenPillNumber;
      if (lastTakenPillNumber != null) {
        switch (pillSheetAppearanceMode) {
          case PillSheetAppearanceMode.number:
          case PillSheetAppearanceMode.date:
            return _pillNumberInPillSheet(pillNumberInPillSheet: lastTakenPillNumber);
          case PillSheetAppearanceMode.sequential:
          case PillSheetAppearanceMode.cyclicSequential:
            return _cycleSequentialPillSheetNumber(pageIndex: pillSheet.groupIndex, pillNumberInPillSheet: lastTakenPillNumber);
        }
      }
    }
    return null;
  }

  List<PillSheetType> get pillSheetTypes => pillSheets.map((e) => e.pillSheetType).toList();

  List<RestDuration> get restDurations {
    return pillSheets.fold<List<RestDuration>>(
      [],
      (previousValue, element) => previousValue + element.restDurations,
    );
  }

  late final List<PillSheetGroupPillNumberDomainPillMarkValue> pillNumbersInPillSheet = _pillNumbersInPillSheet();
  late final List<PillSheetGroupPillNumberDomainPillMarkValue> pillNumbersForCyclicSequential = _pillNumbersForCyclicSequential();
}

// PillSheetGroupの表示用の番号を取得する際にnow(),today()が使われ計算するが、PillSheetModifiedHistoryは、イベントが起きた日に応じた番号が必要になる
// なのでメソッドの引数にestimatedEventCausingDateを追加して、その日に応じた番号を返すようにする
// _pillNumbersInPillSheet,_pillNumbersForCyclicSequential を直接呼び出し、引数に estimatedEventCausingDate を渡す
extension PillSheetGroupPillSheetModifiedHistoryDomain on PillSheetGroup {
  int pillNumberWithoutDateOrZero({
    // 例えば履歴の表示の際にbeforePillSheetGroupとafterPillSheetGroupのpillSheetAppearanceModeが違う場合があるので、pillSheetAppearanceModeを引数にする
    required PillSheetAppearanceMode pillSheetAppearanceMode,
    required int pageIndex,
    required int pillNumberInPillSheet,
    required DateTime estimatedEventCausingDate,
  }) {
    // pillNumberInPillSheet: lastTakenOrZeroPillNumberが0の場合に0を返す
    // PillSheetModifiedHistoryPillNumberOrDate.taken で beforeLastTakenPillNumber にプラス1しており、整合性を保つため
    if (pillNumberInPillSheet == 0) {
      return 0;
    }

    switch (pillSheetAppearanceMode) {
      case PillSheetAppearanceMode.number:
        return _pillNumberInPillSheet(pillNumberInPillSheet: pillNumberInPillSheet);
      case PillSheetAppearanceMode.date:
        return _pillNumberInPillSheet(pillNumberInPillSheet: pillNumberInPillSheet);
      case PillSheetAppearanceMode.sequential:
      case PillSheetAppearanceMode.cyclicSequential:
        return _cycleSequentialPillSheetNumber(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet);
    }
  }

  int pillNumberWithoutDateOrZeroFromDate({
    // 例えば履歴の表示の際にbeforePillSheetGroupとafterPillSheetGroupのpillSheetAppearanceModeが違う場合があるので、pillSheetAppearanceModeを引数にする
    required PillSheetAppearanceMode pillSheetAppearanceMode,
    required DateTime targetDate,
    required DateTime estimatedEventCausingDate,
  }) {
    switch (pillSheetAppearanceMode) {
      case PillSheetAppearanceMode.number:
        return pillNumbersInPillSheet.firstWhere((e) => isSameDay(e.date, targetDate)).number;
      case PillSheetAppearanceMode.date:
        return pillNumbersInPillSheet.firstWhere((e) => isSameDay(e.date, targetDate)).number;
      case PillSheetAppearanceMode.sequential:
      case PillSheetAppearanceMode.cyclicSequential:
        return pillNumbersForCyclicSequential.firstWhere((e) => isSameDay(e.date, targetDate)).number;
    }
  }
}

extension PillSheetGroupDisplayDomain on PillSheetGroup {
  // 日付以外を返す
  String displayPillNumberWithoutDate({
    required int pageIndex,
    required int pillNumberInPillSheet,
  }) {
    // NOTE: 内容が同じ処理を呼び出すので、特別にestimatedEventCausingDateにnowを渡して処理をしている
    return pillNumberWithoutDateOrZero(
      pillSheetAppearanceMode: pillSheetAppearanceMode,
      pageIndex: pageIndex,
      pillNumberInPillSheet: pillNumberInPillSheet,
      estimatedEventCausingDate: today(),
    ).toString();
  }

  String displayPillNumberOrDate({
    required bool premiumOrTrial,
    required int pageIndex,
    required int pillNumberInPillSheet,
  }) {
    final pillNumber = switch (pillSheetAppearanceMode) {
      PillSheetAppearanceMode.number => _pillNumberInPillSheet(pillNumberInPillSheet: pillNumberInPillSheet),
      PillSheetAppearanceMode.date => premiumOrTrial
          ? _displayPillSheetDate(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet)
          : _pillNumberInPillSheet(pillNumberInPillSheet: pillNumberInPillSheet),
      PillSheetAppearanceMode.sequential => _cycleSequentialPillSheetNumber(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet),
      PillSheetAppearanceMode.cyclicSequential => _cycleSequentialPillSheetNumber(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet),
    };
    return pillNumber.toString();
  }

  int _pillNumberInPillSheet({
    required int pillNumberInPillSheet,
  }) {
    return pillNumberInPillSheet;
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
  int cycleSequentialPillSheetNumber({
    required int pageIndex,
    required int pillNumberInPillSheet,
  }) {
    return _cycleSequentialPillSheetNumber(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet);
  }

  int _cycleSequentialPillSheetNumber({
    required int pageIndex,
    required int pillNumberInPillSheet,
  }) {
    return pillNumbersForCyclicSequential.where((e) => e.pillSheet.groupIndex == pageIndex).toList()[pillNumberInPillSheet - 1].number;
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
        return pillNumbersInPillSheet;
      case PillSheetAppearanceMode.sequential:
      case PillSheetAppearanceMode.cyclicSequential:
        return pillNumbersForCyclicSequential;
    }
  }

  List<PillSheetGroupPillNumberDomainPillMarkValue> _pillNumbersInPillSheet({DateTime? estimatedEventCausingDate}) {
    return pillSheets
        .map((pillSheet) => pillSheet
            .buildDates(estimatedEventCausingDate: estimatedEventCausingDate)
            .indexed
            .map((e) => PillSheetGroupPillNumberDomainPillMarkValue(pillSheet: pillSheet, date: e.$2, number: e.$1 + 1))
            .toList())
        .flattened
        .toList();
  }

  List<PillSheetGroupPillNumberDomainPillMarkValue> _pillNumbersForCyclicSequential({DateTime? estimatedEventCausingDate}) {
    List<PillSheetGroupPillNumberDomainPillMarkValue> pillMarks = [];
    final beginPillNumber = displayNumberSetting?.beginPillNumber ?? 1;
    final endPillNumber = displayNumberSetting?.endPillNumber;
    for (final pillSheet in pillSheets) {
      for (final date in pillSheet.buildDates(estimatedEventCausingDate: estimatedEventCausingDate)) {
        // 1つ目はbeginNumber or 1が設定される。2つ目以降は前のピル番号+1を基本的に設定していく
        if (pillMarks.isEmpty) {
          pillMarks.add(
            PillSheetGroupPillNumberDomainPillMarkValue(
              pillSheet: pillSheet,
              date: date,
              number: beginPillNumber,
            ),
          );
        } else {
          var number = pillMarks.last.number + 1;
          for (final restDuration in restDurations) {
            final endDate = restDuration.endDate;
            if (endDate != null) {
              if (isSameDay(endDate, date)) {
                // 服用お休みと期間の終了日と一緒な場合=服用お休みが終了したので、番号は1番から始まる
                number = 1;
              }
            } else {
              // 服用お休みが終わってない
              // 特に何もしない
            }
          }

          if (endPillNumber != null && number > endPillNumber) {
            // 終了番号が設定されていて、それを超えたら1番から始まる
            // 終了番号が設定されてない場合にピルシートのピルの数をendPillNumberの代わりとして使用してはいけない。開始番号が10で、19番目のピルシートは29と表記すべきだから
            number = 1;
          }
          pillMarks.add(
            PillSheetGroupPillNumberDomainPillMarkValue(
              pillSheet: pillSheet,
              date: date,
              number: number,
            ),
          );
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
    // 開始番号はピルシートグループの開始の番号。周期ではない。終了の番号に到達・もしくは服用お休み期間あとは1番から始まる
    int? beginPillNumber,
    // 開始番号は周期の終了番号。周期の終了した数・服用お休みの有無に関わらずこの番号が最終番号となる
    int? endPillNumber,
  }) = _PillSheetGroupDisplayNumberSetting;

  factory PillSheetGroupDisplayNumberSetting.fromJson(Map<String, dynamic> json) => _$PillSheetGroupDisplayNumberSettingFromJson(json);
}

@JsonEnum(valueField: 'value')
enum PillSheetAppearanceMode {
  @JsonValue('number')
  number,
  @JsonValue('date')
  date,
  // 古い値。cyclicSequentialに変更した。一時的に両立されていた
  @JsonValue('sequential')
  sequential,
  @JsonValue('cyclicSequential')
  cyclicSequential,
}

extension PillSheetAppearanceModeExt on PillSheetAppearanceMode {
  bool get isSequential {
    switch (this) {
      case PillSheetAppearanceMode.number:
      case PillSheetAppearanceMode.date:
        return false;
      case PillSheetAppearanceMode.sequential:
      case PillSheetAppearanceMode.cyclicSequential:
        return true;
    }
  }
}
