import 'dart:math';

import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/link_account_type.dart';
import 'package:pilll/entity/pill.codegen.dart';
import 'package:pilll/utils/datetime/date_add.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
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

    /// ヤーズフレックス向けの導線で「休薬はまだしていない」を選んだか
    @Default(false) bool yazFlexHasNotRestedYet,

    /// ヤーズフレックス向けの導線で入力した、前回の休薬が始まった日
    DateTime? yazFlexLastRestDurationBeginDate,

    /// ヤーズフレックス向けの導線で入力した、前回の休薬が終わった日 (服用を再開した日)
    DateTime? yazFlexLastRestDurationEndDate,

    /// ヤーズフレックス向けの導線で入力した開始番号 (1枚目の1番は休薬明けから何日目か)
    /// null の時は [yazFlexDefaultBeginPillNumber] を使う。今日の位置・前回の休薬の入力が変わったら null に戻す
    int? yazFlexBeginPillNumber,
  }) = _InitialSettingState;

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

  /// ヤーズフレックス向けの導線で入力した開始番号の初期値
  /// 前回の休薬の再開日が1枚目の1番の日より前の時は「再開日から1枚目の1番の日までの日数 + 1」を返す
  /// それ以外 (休薬が1枚目の1番以降・休薬していない・未入力) は、1枚目の1番か休薬明けの日から1日目と数えるので 1 を返す
  int get yazFlexDefaultBeginPillNumber {
    final todayPillNumber = this.todayPillNumber;
    final restDurationEndDate = yazFlexLastRestDurationEndDate;
    if (todayPillNumber == null || restDurationEndDate == null) {
      return 1;
    }
    return max(
      1,
      1 -
          _restDurationEndPillIndexInPillSheetGroup(
            todayPillNumber: todayPillNumber,
            pillSheetTypes: pillSheetTypes,
            restDurationEndDate: restDurationEndDate,
          ),
    );
  }

  /// ヤーズフレックス向けの導線で入力した前回の休薬のうち、ピルシートグループの範囲 (1枚目の1番の日より後に服用を再開した) に入るものを返す
  /// 範囲に入らない・休薬していない・未入力の時は null。null の時の休薬明けからの日数は [yazFlexBeginPillNumber] だけで表す
  /// 呼び出すたびに新しい id の RestDuration を返すため冪等ではない。登録時に1回だけ呼ぶ
  RestDuration? buildYazFlexRestDurationInPillSheetGroup() {
    final todayPillNumber = this.todayPillNumber;
    final restDurationBeginDate = yazFlexLastRestDurationBeginDate;
    final restDurationEndDate = yazFlexLastRestDurationEndDate;
    if (!isYazFlex || yazFlexHasNotRestedYet || todayPillNumber == null || restDurationBeginDate == null || restDurationEndDate == null) {
      return null;
    }
    if (_restDurationEndPillIndexInPillSheetGroup(
          todayPillNumber: todayPillNumber,
          pillSheetTypes: pillSheetTypes,
          restDurationEndDate: restDurationEndDate,
        ) <
        1) {
      return null;
    }
    return RestDuration(
      id: firestoreIDGenerator(),
      beginDate: restDurationBeginDate,
      endDate: restDurationEndDate,
      createdDate: now(),
    );
  }

  /// 初期設定の入力からピルシートグループの [pageIndex] 枚目のピルシートを組み立てる
  /// [restDuration] はピルシートグループの範囲 (1枚目の1番の日以降) に入る、今日までに終わった服用お休み期間。無ければ null
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
  static int? _restDurationPageIndex({
    required InitialSettingTodayPillNumber todayPillNumber,
    required List<PillSheetType> pillSheetTypes,
    required RestDuration? restDuration,
  }) {
    final restDurationEndDate = restDuration?.endDate;
    if (restDurationEndDate == null) {
      return null;
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
