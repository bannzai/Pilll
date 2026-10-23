import 'dart:math';

import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/link_account_type.dart';
import 'package:pilll/entity/pill.codegen.dart';
import 'package:pilll/utils/datetime/date_add.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';

part 'initial_setting_state.codegen.freezed.dart';

@freezed
class InitialSettingTodayPillNumber with _$InitialSettingTodayPillNumber {
  const factory InitialSettingTodayPillNumber({
    @Default(0) int pageIndex,
    @Default(0) int pillNumberInPillSheet,
  }) = _InitialSettingTodayPillNumber;
}

@freezed
class InitialSettingState with _$InitialSettingState {
  const InitialSettingState._();
  const factory InitialSettingState({
    @Default([]) List<PillSheetType> pillSheetTypes,
    InitialSettingTodayPillNumber? todayPillNumber,
    required List<ReminderTime> reminderTimes,
    @Default(true) bool isOnReminder,
    @Default(false) bool isLoading,
    @Default(false) bool settingIsExist,
    LinkAccountType? accountType,
    @Default(1) int pillTakenCount,

    /// 初期設定の最初のページで「ヤーズフレックスの方ですか？」に「はい」と答えたか
    /// true の時はヤーズフレックス向けの導線 (28錠タイプ固定・前回の休薬・開始番号の入力) で登録する
    @Default(false) bool isYazFlex,

    /// ヤーズフレックス向けの導線で前回の休薬の入力をスキップしたか (休薬はまだしていない、または後でホームから入力する)
    /// true の時は休薬のピルを選んでいても休薬を登録しない
    @Default(false) bool yazFlexHasNotRestedYet,

    /// ヤーズフレックス向けの導線でタップした、休薬に入る直前に飲んだピルの位置 (今のピルシートグループの中のピル)
    /// このピルの翌日から [yazFlexRestDurationDays] 日休み、次のピルで服用を再開したとみなす。未選択なら null
    InitialSettingTodayPillNumber? yazFlexLastTakenPillNumberBeforeRest,

    /// ヤーズフレックス向けの導線で入力した前回の休薬の日数
    /// 既定の 4 は、ヤーズフレックス配合錠の添付文書で休薬期間が 4 日間と定められているため
    @Default(4) int yazFlexRestDurationDays,

    /// ヤーズフレックス向けの導線で入力した開始番号 (1枚目の1番は休薬明けから何日目か)
    /// 既定の 1 は、休薬明けの初日にシートの1番から飲み始めた (休薬明けとシートの切り替わりが一致している) 想定
    @Default(1) int yazFlexBeginPillNumber,
  }) = _InitialSettingState;

  /// ヤーズフレックス向けの導線で、前回の休薬が終わった日 (服用を再開した日)。休薬のピルの次のピルを飲んだ日
  /// 休薬のピルが未選択・今日の番号が未選択の時は null
  DateTime? get yazFlexLastRestDurationEndDate {
    final todayPillNumber = this.todayPillNumber;
    final lastTakenPillNumberBeforeRest = yazFlexLastTakenPillNumberBeforeRest;
    if (todayPillNumber == null || lastTakenPillNumberBeforeRest == null) {
      return null;
    }
    return today().addDays(
      -(_todayPillIndexInPillSheetGroup(todayPillNumber: todayPillNumber, pillSheetTypes: pillSheetTypes) -
          _todayPillIndexInPillSheetGroup(todayPillNumber: lastTakenPillNumberBeforeRest, pillSheetTypes: pillSheetTypes) -
          1),
    );
  }

  /// ヤーズフレックス向けの導線で、前回の休薬が始まった日 (休薬のピルを飲んだ翌日)。[yazFlexLastRestDurationEndDate] が null なら null
  DateTime? get yazFlexLastRestDurationBeginDate => yazFlexLastRestDurationEndDate?.addDays(-yazFlexRestDurationDays);

  DateTime? reminderTimeOrNull(int index) {
    if (index < reminderTimes.length) {
      return reminderDateTime(index);
    }
    final n = now();
    if (index == 0) {
      return DateTime(n.year, n.month, n.day, n.hour, 0, 0);
    }
    if (index == 1) {
      return DateTime(n.year, n.month, n.day, n.hour + 1, 0, 0);
    }
    return null;
  }

  Future<Setting> buildSetting() async {
    const menstruationDuration = 4;
    final maxPillCount = pillSheetTypes.map((e) => e.totalCount).fold(0, (previousValue, element) => previousValue + element);
    final pillNumberForFromMenstruation = max(
      0,
      maxPillCount - menstruationDuration,
    );

    final setting = Setting(
      pillNumberForFromMenstruation: pillNumberForFromMenstruation,
      durationMenstruation: menstruationDuration,
      pillSheetTypes: pillSheetTypes,
      reminderTimes: reminderTimes,
      isOnReminder: isOnReminder,
      timezoneDatabaseName: await FlutterTimezone.getLocalTimezone(),
      // BEGIN: Release function for trial user
      isAutomaticallyCreatePillSheet: true,
      // END: Release function for trial user
    );
    return setting;
  }

  /// ヤーズフレックス向けの導線で入力した前回の休薬 (休薬のピルの翌日から [yazFlexRestDurationDays] 日) を返す
  /// 休薬のピルは今のピルシートグループの中のピルなので、再開したピルは常に 1枚目の1番より後にあり、範囲の判定は要らない
  /// 休薬の入力をスキップした・休薬のピルが未選択の時は null。null の時の休薬明けからの日数は [yazFlexBeginPillNumber] だけで表す
  /// 呼び出すたびに新しい id の RestDuration を返すため冪等ではない。登録時に1回だけ呼ぶ
  RestDuration? buildYazFlexRestDurationInPillSheetGroup() {
    final restDurationBeginDate = yazFlexLastRestDurationBeginDate;
    if (!isYazFlex || yazFlexHasNotRestedYet || restDurationBeginDate == null) {
      return null;
    }
    return RestDuration(
      id: firestoreIDGenerator(),
      beginDate: restDurationBeginDate,
      endDate: yazFlexLastRestDurationEndDate,
      createdDate: now(),
    );
  }

  /// 初期設定の入力からピルシートグループを組み立てる。今日飲む番号が未選択の時は null
  /// ヤーズフレックス向けの導線では、休薬明けに1に戻る服用日数の表示 (cyclicSequential) と開始番号・前回の休薬を入れる
  /// 登録の前のプレビュー表示にも使う。ピルシート・RestDuration に新しい id を振るため冪等ではなく、保存する時は1回だけ呼ぶ
  PillSheetGroup? buildPillSheetGroup() {
    final todayPillNumber = this.todayPillNumber;
    if (todayPillNumber == null) {
      return null;
    }
    final restDuration = buildYazFlexRestDurationInPillSheetGroup();
    final createdPillSheets = pillSheetTypes.asMap().keys.map((pageIndex) {
      return buildPillSheet(
        pageIndex: pageIndex,
        todayPillNumber: todayPillNumber,
        pillSheetTypes: pillSheetTypes,
        pillTakenCount: pillTakenCount,
        restDuration: restDuration,
      );
    }).toList();
    return PillSheetGroup(
      pillTakenCount: pillTakenCount,
      pillSheetIDs: createdPillSheets.map((e) => e.id!).toList(),
      pillSheets: createdPillSheets,
      createdAt: now(),
      // ヤーズフレックスは休薬明けから何日目かで服用を管理するため、休薬明けに1に戻る「服用日数」の表示にする
      displayNumberSetting: isYazFlex ? PillSheetGroupDisplayNumberSetting(beginPillNumber: yazFlexBeginPillNumber) : null,
      pillSheetAppearanceMode: isYazFlex
          ? PillSheetAppearanceMode.cyclicSequential
          // BEGIN: Release function for trial user
          : PillSheetAppearanceMode.date,
      // END: Release function for trial user
    );
  }

  /// ヤーズフレックス向けの導線で、服用を再開したピル (休薬のピルの次のピル) の位置。休薬のピルが未選択・休薬の入力をスキップした時は null
  ({int pageIndex, int pillNumberInPillSheet})? get yazFlexResumedPillPosition {
    final lastTakenPillNumberBeforeRest = yazFlexLastTakenPillNumberBeforeRest;
    if (!isYazFlex || yazFlexHasNotRestedYet || lastTakenPillNumberBeforeRest == null) {
      return null;
    }
    final resumedPillIndex = _todayPillIndexInPillSheetGroup(todayPillNumber: lastTakenPillNumberBeforeRest, pillSheetTypes: pillSheetTypes) + 1;
    for (final (pageIndex, pillSheetType) in pillSheetTypes.indexed) {
      final offset = summarizedPillCountWithPillSheetTypesToIndex(pillSheetTypes: pillSheetTypes, toIndex: pageIndex);
      if (resumedPillIndex < offset + pillSheetType.totalCount) {
        return (pageIndex: pageIndex, pillNumberInPillSheet: resumedPillIndex - offset + 1);
      }
    }
    return null;
  }

  /// ヤーズフレックス向けの導線で、休薬のピルとして選べるピルか (今日飲む番号のピルより前のピルだけ。それ以降はまだ飲んでいないので休薬の前に飲めない)
  bool yazFlexCanSelectAsLastTakenPillBeforeRest({required int pageIndex, required int pillNumberInPillSheet}) {
    final todayPillNumber = this.todayPillNumber;
    if (todayPillNumber == null) {
      return false;
    }
    return _todayPillIndexInPillSheetGroup(
          todayPillNumber: InitialSettingTodayPillNumber(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet),
          pillSheetTypes: pillSheetTypes,
        ) <
        _todayPillIndexInPillSheetGroup(todayPillNumber: todayPillNumber, pillSheetTypes: pillSheetTypes);
  }

  /// 初期設定の入力からピルシートグループの [pageIndex] 枚目のピルシートを組み立てる
  /// [restDuration] はピルシートグループの範囲 (1枚目の1番の日以降) に入る服用お休み期間。無ければ null
  /// 終了日の無い (服用お休み中の) [restDuration] は、今日飲む番号のピルを含むピルシートに入れる
  /// [restDuration] は服用を再開したピルを含むピルシートの restDurations に入れ、その日数ぶん当該ピルシート以前の beginDate を前にずらす
  static PillSheet buildPillSheet({
    required int pageIndex,
    required InitialSettingTodayPillNumber todayPillNumber,
    required List<PillSheetType> pillSheetTypes,
    required int pillTakenCount,
    required RestDuration? restDuration,
  }) {
    final pillSheetType = pillSheetTypes[pageIndex];
    final restDurationPageIndex = _restDurationPageIndex(
      todayPillNumber: todayPillNumber,
      pillSheetTypes: pillSheetTypes,
      restDuration: restDuration,
    );
    final beginDate = _beginDate(
      pageIndex: pageIndex,
      todayPillNumber: todayPillNumber,
      pillSheetTypes: pillSheetTypes,
      restDuration: restDuration,
      restDurationPageIndex: restDurationPageIndex,
    );
    final restDurations = [
      if (restDuration != null && pageIndex == restDurationPageIndex) restDuration,
    ];
    final lastTakenDate = _lastTakenDate(
      pageIndex: pageIndex,
      todayPillNumber: todayPillNumber,
      pillSheetTypes: pillSheetTypes,
      beginDate: beginDate,
      restDurations: restDurations,
    );

    if (pillTakenCount > 1) {
      return PillSheet.v2(
        id: firestoreIDGenerator(),
        groupIndex: pageIndex,
        beginDate: beginDate,
        typeInfo: pillSheetType.typeInfo,
        createdAt: now(),
        restDurations: restDurations,
        pills: Pill.generateAndFillTo(
          pillSheetType: pillSheetType,
          fromDate: beginDate,
          lastTakenDate: lastTakenDate,
          pillTakenCount: pillTakenCount,
        ),
      );
    }

    return PillSheet.v1(
      id: firestoreIDGenerator(),
      groupIndex: pageIndex,
      beginDate: beginDate,
      lastTakenDate: lastTakenDate,
      typeInfo: pillSheetType.typeInfo,
      createdAt: now(),
      restDurations: restDurations,
    );
  }

  /// 今日飲むピルが、ピルシートグループの1枚目の1番から数えて何番目 (0始まり) かを返す
  static int _todayPillIndexInPillSheetGroup({
    required InitialSettingTodayPillNumber todayPillNumber,
    required List<PillSheetType> pillSheetTypes,
  }) {
    return summarizedPillCountWithPillSheetTypesToIndex(
          pillSheetTypes: pillSheetTypes,
          toIndex: todayPillNumber.pageIndex,
        ) +
        todayPillNumber.pillNumberInPillSheet -
        1;
  }

  /// [restDurationEndDate] (服用を再開した日) に飲んだピルが、ピルシートグループの1枚目の1番から数えて何番目 (0始まり) かを返す
  /// 再開日から今日までは毎日服用している前提で、今日のピルの位置から逆算する。0以下の時は再開日が1枚目の1番の日以前であることを表す
  static int _restDurationEndPillIndexInPillSheetGroup({
    required InitialSettingTodayPillNumber todayPillNumber,
    required List<PillSheetType> pillSheetTypes,
    required DateTime restDurationEndDate,
  }) {
    return _todayPillIndexInPillSheetGroup(
          todayPillNumber: todayPillNumber,
          pillSheetTypes: pillSheetTypes,
        ) -
        daysBetween(restDurationEndDate, today());
  }

  /// [restDuration] を入れるピルシート (服用を再開したピルを含むピルシート) の pageIndex を返す。[restDuration] が無ければ null
  /// 服用お休み中 (終了日が無い) の時は、再開後の最初のピルになる今日飲む番号のピルを含むピルシート
  static int? _restDurationPageIndex({
    required InitialSettingTodayPillNumber todayPillNumber,
    required List<PillSheetType> pillSheetTypes,
    required RestDuration? restDuration,
  }) {
    if (restDuration == null) {
      return null;
    }
    final restDurationEndDate = restDuration.endDate;
    if (restDurationEndDate == null) {
      return todayPillNumber.pageIndex;
    }
    final restDurationEndPillIndex = _restDurationEndPillIndexInPillSheetGroup(
      todayPillNumber: todayPillNumber,
      pillSheetTypes: pillSheetTypes,
      restDurationEndDate: restDurationEndDate,
    );
    return pillSheetTypes.indexed
        .firstWhere(
          (e) =>
              restDurationEndPillIndex <
              summarizedPillCountWithPillSheetTypesToIndex(
                    pillSheetTypes: pillSheetTypes,
                    toIndex: e.$1,
                  ) +
                  e.$2.totalCount,
        )
        .$1;
  }

  static DateTime _beginDate({
    required int pageIndex,
    required InitialSettingTodayPillNumber todayPillNumber,
    required List<PillSheetType> pillSheetTypes,
    required RestDuration? restDuration,
    required int? restDurationPageIndex,
  }) {
    if (pageIndex <= todayPillNumber.pageIndex) {
      // Left side from todayPillNumber.pageIndex
      // Or current pageIndex == todayPillNumber.pageIndex
      final passedTotalCountElement = pillSheetTypes.sublist(0, todayPillNumber.pageIndex - pageIndex).map((e) => e.totalCount);
      final int passedTotalCount;
      if (passedTotalCountElement.isEmpty) {
        passedTotalCount = 0;
      } else {
        passedTotalCount = passedTotalCountElement.reduce(
          (value, element) => value + element,
        );
      }

      // 服用お休み期間を含むピルシートとそれより前のピルシートは、服用お休みの日数ぶん開始日が前になる
      final restDurationDays = restDuration != null && restDurationPageIndex != null && pageIndex <= restDurationPageIndex
          ? summarizedRestDuration(restDurations: [restDuration], upperDate: today())
          : 0;

      return today().subtract(
        Duration(
          days: passedTotalCount + (todayPillNumber.pillNumberInPillSheet - 1) + restDurationDays,
        ),
      );
    } else {
      // Right Side from todayPillNumber.pageIndex
      final beforePillSheetBeginDate = _beginDate(
        pageIndex: pageIndex - 1,
        todayPillNumber: todayPillNumber,
        pillSheetTypes: pillSheetTypes,
        restDuration: restDuration,
        restDurationPageIndex: restDurationPageIndex,
      );
      final beforePillSheetType = pillSheetTypes[pageIndex - 1];
      // 1つ前のピルシートが服用お休み期間を含む場合は、その日数ぶん開始日が後ろになる
      final beforePillSheetRestDurationDays = restDuration != null && pageIndex - 1 == restDurationPageIndex
          ? summarizedRestDuration(restDurations: [restDuration], upperDate: today())
          : 0;
      return beforePillSheetBeginDate.addDays(beforePillSheetType.totalCount + beforePillSheetRestDurationDays);
    }
  }

  static DateTime? _lastTakenDate({
    required int pageIndex,
    required InitialSettingTodayPillNumber todayPillNumber,
    required List<PillSheetType> pillSheetTypes,
    required DateTime beginDate,
    required List<RestDuration> restDurations,
  }) {
    if (pageIndex == 0 && todayPillNumber.pageIndex == 0 && todayPillNumber.pillNumberInPillSheet == 1) {
      return null;
    }
    final pillSheetType = pillSheetTypes[pageIndex];
    if (todayPillNumber.pageIndex < pageIndex) {
      // Right side PillSheet
      return null;
    } else if (todayPillNumber.pageIndex > pageIndex) {
      // Left side PillSheet
      return beginDate.addDays(pillSheetType.totalCount - 1 + summarizedRestDuration(restDurations: restDurations, upperDate: today()));
    } else if (todayPillNumber.pillNumberInPillSheet == 1) {
      // Current PillSheet で今日が1番の時は、前のピルシートの最後のピルを飲んだ日 (beginDateの前日) になる
      return beginDate.addDays(-1);
    } else {
      // Current PillSheet
      // 服用お休み期間を考慮した、今日飲むピルの1つ前のピルの服用予定日
      return PillSheet.v1(
        id: null,
        typeInfo: pillSheetType.typeInfo,
        beginDate: beginDate,
        lastTakenDate: null,
        createdAt: null,
        restDurations: restDurations,
      ).buildDates()[todayPillNumber.pillNumberInPillSheet - 2];
    }
  }

  DateTime reminderDateTime(int index) {
    var t = DateTime.now();
    final reminderTime = reminderTimes[index];
    return DateTime(
      t.year,
      t.month,
      t.day,
      reminderTime.hour,
      reminderTime.minute,
      t.second,
      t.millisecond,
      t.microsecond,
    );
  }

  int? selectedTodayPillNumberIntoPillSheet({required int pageIndex}) {
    if (todayPillNumber?.pageIndex != pageIndex) {
      return null;
    }
    return todayPillNumber?.pillNumberInPillSheet;
  }
}
