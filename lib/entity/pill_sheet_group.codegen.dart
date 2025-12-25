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

/// Firestoreのピルシートグループドキュメントで使用されるフィールドキーの定数を管理するクラス
/// データベースアクセス時のタイポを防ぎ、フィールド名の一元管理を行う
class PillSheetGroupFirestoreKeys {
  /// 作成日時フィールドキー
  static const createdAt = 'createdAt';

  /// 削除日時フィールドキー
  static const deletedAt = 'deletedAt';
}

/// 複数のピルシートをグループ化して管理するメインエンティティクラス
/// ユーザーが連続してピルを服用する際の複数シートの状態、表示形式、
/// 服用履歴を統合的に管理する。Firestoreドキュメントとして保存される。
/// 生理予測、服用お休み期間、表示番号のカスタマイズなどの
/// 高度な機能を提供し、ピル服用管理の中核を担う
@freezed
abstract class PillSheetGroup with _$PillSheetGroup {
  @JsonSerializable(explicitToJson: true)
  factory PillSheetGroup({
    /// FirestoreドキュメントID（自動生成される場合はnull）
    @JsonKey(includeIfNull: false) String? id,

    /// このグループに含まれるピルシートのIDリスト
    /// pillSheetsプロパティと対応関係を持つ
    required List<String> pillSheetIDs,

    /// このグループに含まれる実際のピルシートデータ
    /// 服用状況や日程計算の基準となる
    required List<PillSheet> pillSheets,

    /// グループ作成日時（必須項目）
    /// Firestoreのタイムスタンプとして保存される
    @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
    required DateTime createdAt,

    /// 削除日時（論理削除で使用）
    /// nullの場合は削除されていない状態を表す
    @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? deletedAt,
    // NOTE: [SyncData:Widget] このプロパティはWidgetに同期されてる
    /// ピル番号の表示設定（カスタマイズ用）
    /// 開始番号・終了番号のユーザーカスタマイズを管理
    PillSheetGroupDisplayNumberSetting? displayNumberSetting,

    /// ピルシートの表示モード設定
    /// 番号表示、日付表示、連続番号表示の切り替えを制御
    @Default(PillSheetAppearanceMode.number) PillSheetAppearanceMode pillSheetAppearanceMode,
  }) = _PillSheetGroup;
  PillSheetGroup._();

  factory PillSheetGroup.fromJson(Map<String, dynamic> json) => _$PillSheetGroupFromJson(json);

  /// 現在日時でアクティブなピルシートを取得
  /// 今日の日付に対応する有効なピルシートを返す
  PillSheet? get activePillSheet => activePillSheetWhen(now());

  /// 指定日時でアクティブなピルシートを取得
  /// 特定の日付に対応する有効なピルシートを返す
  /// 履歴表示や過去データの参照で使用される
  PillSheet? activePillSheetWhen(DateTime date) {
    final filtered = pillSheets.where((element) => element.isActiveFor(date));
    return filtered.isEmpty ? null : filtered.first;
  }

  /// 指定されたピルシートでグループ内容を更新
  /// 同一IDのピルシートを新しいデータで置き換える
  /// 服用記録の更新時に使用される
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

  /// 論理削除されているかどうかを判定
  /// deletedAtが設定されている場合はtrue
  bool get _isDeleted => deletedAt != null;

  /// グループが非アクティブ状態かどうかを判定
  /// アクティブなピルシートがないか削除済みの場合はtrue
  bool get isDeactived => activePillSheet == null || _isDeleted;

  // NOTE: 0が返却される時は、過去のピルシートグループを参照しているときなど
  // NOTE: [SyncData:Widget] このプロパティはWidgetに同期されてる
  /// 今日の日付に対応する連続番号を取得
  /// sequential/cyclicSequentialモードでのみ有効
  /// 過去のグループ参照時は0を返す
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
  /// 最後に服用したピルの連続番号を取得
  /// sequential/cyclicSequentialモードでのみ有効
  /// 服用履歴がない場合は0を返す
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
        return pillNumbersForCyclicSequential.firstWhereOrNull((element) => isSameDay(element.date, today()))?.number ?? 0;
      case PillSheetAppearanceMode.cyclicSequential:
        return pillNumbersForCyclicSequential.firstWhereOrNull((element) => isSameDay(element.date, activePillSheetLastTakenDate))?.number ?? 0;
    }
  }

  /// 連続番号の最終番号を取得
  /// sequential/cyclicSequentialモードでのみ有効
  /// グループ全体の最後のピル番号を返す
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

  /// 最後に服用したピルシートまたは最初のピルシートを取得
  /// 服用履歴のあるピルシートを逆順で検索し、見つからない場合は最初のピルシートを返す
  /// 服用状況の表示や次回服用予定の計算で使用される
  PillSheet get lastTakenPillSheetOrFirstPillSheet {
    for (final pillSheet in pillSheets.reversed) {
      if (pillSheet.lastTakenDate != null) {
        return pillSheet;
      }
    }
    return pillSheets[0];
  }

  // テストまで作ったが、プロダクションではまだ使ってない。とはいえ普通に使うメソッドなので visibleForTestingにしておく
  /// 最後に服用したピルの番号を日付情報なしで取得
  /// テスト用に公開されているが本番では未使用
  /// 各表示モードに応じた適切なピル番号を返す
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

  /// グループに含まれる全ピルシートの種類情報のリスト
  /// 各ピルシートのタイプ情報を配列で取得
  List<PillSheetType> get pillSheetTypes => pillSheets.map((e) => e.pillSheetType).toList();

  /// グループに含まれる全ピルシートの服用お休み期間のリスト
  /// 各ピルシートの休薬期間を統合した配列を取得
  List<RestDuration> get restDurations {
    return pillSheets.fold<List<RestDuration>>([], (previousValue, element) => previousValue + element.restDurations);
  }

  /// ピルシート内番号表示用のピルマーク値リスト（遅延初期化）
  /// number/dateモードで使用される基本的なピル番号情報
  late final List<PillSheetGroupPillNumberDomainPillMarkValue> pillNumbersInPillSheet = _pillNumbersInPillSheet();

  /// 連続番号表示用のピルマーク値リスト（遅延初期化）
  /// sequential/cyclicSequentialモードで使用される連続番号情報
  late final List<PillSheetGroupPillNumberDomainPillMarkValue> pillNumbersForCyclicSequential = _pillNumbersForCyclicSequential();
}

/// ピルシート変更履歴のドメインロジックを提供するextension
/// 履歴表示時の特定日付におけるピル番号計算機能を提供
/// イベント発生日に基づいた正確な番号算出が可能
extension PillSheetGroupPillSheetModifiedHistoryDomain on PillSheetGroup {
  // NOTE: PillSheetGroupの表示用の番号を取得する際にnow(),today()が使われ計算するが、PillSheetModifiedHistoryは、イベントが起きた日に応じた番号が必要になる
  // なのでメソッドの引数にestimatedEventCausingDateを追加して、その日に応じた番号を返すようにする
  // _pillNumbersInPillSheet,_pillNumbersForCyclicSequential を直接呼び出し、引数に estimatedEventCausingDate を渡す
  /// 指定日付とイベント発生日に基づくピル番号を取得
  /// 履歴表示で過去の特定日におけるピル番号を正確に算出
  /// 表示モードが異なる履歴データでも適切な番号を返す
  int pillNumberWithoutDateOrZeroFromDate({
    // 例えば履歴の表示の際にbeforePillSheetGroupとafterPillSheetGroupのpillSheetAppearanceModeが違う場合があるので、pillSheetAppearanceModeを引数にする
    /// 履歴データの表示モード（before/afterで異なる場合があるため）
    required PillSheetAppearanceMode pillSheetAppearanceMode,

    /// 番号を取得したい対象日付
    required DateTime targetDate,

    /// イベントが発生した推定日付
    required DateTime estimatedEventCausingDate,
  }) {
    switch (pillSheetAppearanceMode) {
      case PillSheetAppearanceMode.number:
        return _pillNumbersInPillSheet(estimatedEventCausingDate: estimatedEventCausingDate).firstWhere((e) => isSameDay(e.date, targetDate)).number;
      case PillSheetAppearanceMode.date:
        return _pillNumbersInPillSheet(estimatedEventCausingDate: estimatedEventCausingDate).firstWhere((e) => isSameDay(e.date, targetDate)).number;
      case PillSheetAppearanceMode.sequential:
      case PillSheetAppearanceMode.cyclicSequential:
        return _pillNumbersForCyclicSequential(
          estimatedEventCausingDate: estimatedEventCausingDate,
        ).firstWhere((e) => isSameDay(e.date, targetDate)).number;
    }
  }

  // NOTE: pillNumberWithoutDateOrZeroFromDate と違い、estimatedEventCausingDate は不要。なぜなら番号はindexから計算ができ、index自体は普遍であるため。
  // 日付が可変なので、日付から計算する pillNumberWithoutDateOrZeroFromDate には estimatedEventCausingDate が必要になる
  /// ページインデックスとピル番号から表示番号を取得
  /// インデックスベースの計算のためestimatedEventCausingDateは不要
  /// 履歴表示で確定した番号情報から表示値を算出
  int pillNumberWithoutDateOrZero({
    // 例えば履歴の表示の際にbeforePillSheetGroupとafterPillSheetGroupのpillSheetAppearanceModeが違う場合があるので、pillSheetAppearanceModeを引数にする
    /// 履歴データの表示モード
    required PillSheetAppearanceMode pillSheetAppearanceMode,

    /// ピルシートのページインデックス
    required int pageIndex,

    /// ピルシート内の番号
    required int pillNumberInPillSheet,
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
}

/// ピルシートグループの表示に関するドメインロジックを提供するextension
/// 各種表示モードに応じたピル番号や日付の表示文字列を生成
/// UI表示用のフォーマット済み文字列を提供
extension PillSheetGroupDisplayDomain on PillSheetGroup {
  // 日付以外を返す
  /// 日付以外のピル番号表示文字列を取得
  /// number/sequential/cyclicSequentialモード用
  String displayPillNumberWithoutDate({
    /// ピルシートのページインデックス
    required int pageIndex,

    /// ピルシート内の番号
    required int pillNumberInPillSheet,
  }) {
    return pillNumberWithoutDateOrZero(
      pillSheetAppearanceMode: pillSheetAppearanceMode,
      pageIndex: pageIndex,
      pillNumberInPillSheet: pillNumberInPillSheet,
    ).toString();
  }

  /// ピル番号または日付の表示文字列を取得
  /// 表示モードとプレミアム状態に応じて適切な表示を生成
  String displayPillNumberOrDate({
    /// プレミアムまたは試用状態かどうか
    required bool premiumOrTrial,

    /// ピルシートのページインデックス
    required int pageIndex,

    /// ピルシート内の番号
    required int pillNumberInPillSheet,
  }) {
    final pillNumber = switch (pillSheetAppearanceMode) {
      PillSheetAppearanceMode.number => _pillNumberInPillSheet(pillNumberInPillSheet: pillNumberInPillSheet),
      PillSheetAppearanceMode.date =>
        premiumOrTrial
            ? _displayPillSheetDate(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet)
            : _pillNumberInPillSheet(pillNumberInPillSheet: pillNumberInPillSheet),
      PillSheetAppearanceMode.sequential => _cycleSequentialPillSheetNumber(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet),
      PillSheetAppearanceMode.cyclicSequential => _cycleSequentialPillSheetNumber(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet),
    };
    return pillNumber.toString();
  }

  /// ピルシート内番号をそのまま返す
  /// number/dateモード用の基本的な番号取得
  int _pillNumberInPillSheet({required int pillNumberInPillSheet}) {
    return pillNumberInPillSheet;
  }

  /// ピルシートの日付表示文字列を取得（テスト用）
  /// dateモード用の日付フォーマット処理
  @visibleForTesting
  String displayPillSheetDate({required int pageIndex, required int pillNumberInPillSheet}) {
    return _displayPillSheetDate(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet);
  }

  /// ピルシートの日付表示文字列を内部生成
  /// 月日形式でフォーマットされた文字列を返す
  String _displayPillSheetDate({required int pageIndex, required int pillNumberInPillSheet}) {
    return DateTimeFormatter.monthAndDay(pillSheets[pageIndex].displayPillTakeDate(pillNumberInPillSheet));
  }

  /// 連続番号を取得（テスト用）
  /// sequential/cyclicSequentialモード用の番号計算
  @visibleForTesting
  int cycleSequentialPillSheetNumber({required int pageIndex, required int pillNumberInPillSheet}) {
    return _cycleSequentialPillSheetNumber(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet);
  }

  /// 連続番号を内部計算
  /// 指定されたページとピル番号に対応する連続番号を算出
  int _cycleSequentialPillSheetNumber({required int pageIndex, required int pillNumberInPillSheet}) {
    return pillNumbersForCyclicSequential.where((e) => e.pillSheet.groupIndex == pageIndex).toList()[pillNumberInPillSheet - 1].number;
  }
}

/// ピル番号ドメインのピルマーク値を表すデータクラス
/// 特定のピルシート、日付、番号の組み合わせを保持
/// 表示モード切り替えや番号計算の基礎データとして使用
@freezed
abstract class PillSheetGroupPillNumberDomainPillMarkValue with _$PillSheetGroupPillNumberDomainPillMarkValue {
  const factory PillSheetGroupPillNumberDomainPillMarkValue({
    /// 対象となるピルシート情報
    required PillSheet pillSheet,

    /// 対象となる日付
    required DateTime date,

    /// 表示番号
    required int number,
  }) = _PillSheetGroupPillNumberDomainPillMarkValue;
}

/// ピル番号計算に関するドメインロジックを提供するextension
/// 各種表示モードでのピル番号マッピングと計算処理を管理
/// number/date/sequential/cyclicSequentialの各モードに対応
extension PillSheetGroupPillNumberDomain on PillSheetGroup {
  /// 指定されたピルシートのピルマーク情報を取得
  /// 表示モードに応じた適切なマーク値を返す
  PillSheetGroupPillNumberDomainPillMarkValue pillMark({required PillSheet pillSheet, required PillSheetAppearanceMode pillSheetAppearanceMode}) {
    return pillMarks(pillSheetAppearanceMode: pillSheetAppearanceMode).firstWhere((e) => e.pillSheet.id == pillSheet.id);
  }

  /// 指定された表示モードでの全ピルマーク情報リストを取得
  /// 各モードに応じた番号計算結果の配列を返す
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

  /// ピルシート内番号計算の基礎データを生成
  /// 各ピルシートの日付と対応する番号のマッピングを作成
  /// estimatedEventCausingDateは履歴機能で使用される
  List<PillSheetGroupPillNumberDomainPillMarkValue> _pillNumbersInPillSheet({DateTime? estimatedEventCausingDate}) {
    return pillSheets
        .map(
          (pillSheet) => pillSheet
              .buildDates(estimatedEventCausingDate: estimatedEventCausingDate)
              .indexed
              .map((e) => PillSheetGroupPillNumberDomainPillMarkValue(pillSheet: pillSheet, date: e.$2, number: e.$1 + 1))
              .toList(),
        )
        .flattened
        .toList();
  }

  /// 連続番号計算の基礎データを生成
  /// グループ全体を通した連続番号と日付のマッピングを作成
  /// 開始番号、終了番号、服用お休み期間を考慮した番号付けを行う
  List<PillSheetGroupPillNumberDomainPillMarkValue> _pillNumbersForCyclicSequential({DateTime? estimatedEventCausingDate}) {
    List<PillSheetGroupPillNumberDomainPillMarkValue> pillMarks = [];
    final beginPillNumber = displayNumberSetting?.beginPillNumber ?? 1;
    final endPillNumber = displayNumberSetting?.endPillNumber;
    for (final pillSheet in pillSheets) {
      for (final date in pillSheet.buildDates(estimatedEventCausingDate: estimatedEventCausingDate)) {
        // 1つ目はbeginNumber or 1が設定される。2つ目以降は前のピル番号+1を基本的に設定していく
        if (pillMarks.isEmpty) {
          pillMarks.add(PillSheetGroupPillNumberDomainPillMarkValue(pillSheet: pillSheet, date: date, number: beginPillNumber));
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
          pillMarks.add(PillSheetGroupPillNumberDomainPillMarkValue(pillSheet: pillSheet, date: date, number: number));
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

/// 生理予測・生理期間計算に関するドメインロジックを提供するextension
/// ユーザーの設定に基づいて各ピルシートの生理期間を算出
/// 通常の定期的な生理とヤーズフレックス等の不定期な生理の両方に対応
extension PillSheetGroupMenstruationDomain on PillSheetGroup {
  /// 設定に基づいて生理期間の日付範囲リストを計算
  /// 各ピルシートでの生理開始予定日と期間を算出
  /// 設定値が0の場合は空配列を返す
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
        final summarizedPillCount = pillSheets.fold<int>(0, (previousValue, element) => previousValue + element.typeInfo.totalCount);

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

/// 服用お休み期間管理に関するドメインロジックを提供するextension
/// 休薬期間の開始・終了判定と対象ピルシートの特定機能を提供
/// ユーザーの休薬予定管理で使用される
extension PillSheetGroupRestDurationDomain on PillSheetGroup {
  /// 現在アクティブな服用お休み期間を取得
  /// 複数のピルシートから最初に見つかったアクティブな休薬期間を返す
  RestDuration? get lastActiveRestDuration {
    return pillSheets.map((e) => e.activeRestDuration).whereNotNull().firstOrNull;
  }

  /// 服用お休み開始の対象となるピルシートを取得
  /// 最後に服用したピルシートが完了済みなら次のシート、
  /// 未完了なら現在のシートを対象とする
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
  /// 最後の服用日の翌日、または服用履歴がない場合は今日を返す
  /// UI入力フィールドの初期値として使用される
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

/// ピルシートグループの表示番号設定を管理するデータクラス
/// sequential/cyclicSequentialモードでのカスタマイズ番号設定を保持
/// 開始番号と終了番号の組み合わせでピル番号の表示範囲を制御
@freezed
abstract class PillSheetGroupDisplayNumberSetting with _$PillSheetGroupDisplayNumberSetting {
  @JsonSerializable(explicitToJson: true)
  const factory PillSheetGroupDisplayNumberSetting({
    // 開始番号はピルシートグループの開始の番号。周期ではない。終了の番号に到達・もしくは服用お休み期間あとは1番から始まる
    /// グループ全体での開始番号設定
    /// nullの場合は1から開始される
    int? beginPillNumber,
    // 開始番号は周期の終了番号。周期の終了した数・服用お休みの有無に関わらずこの番号が最終番号となる
    /// 周期の終了番号設定
    /// nullの場合は終了番号制限なしで連続番号付けされる
    int? endPillNumber,
  }) = _PillSheetGroupDisplayNumberSetting;

  factory PillSheetGroupDisplayNumberSetting.fromJson(Map<String, dynamic> json) => _$PillSheetGroupDisplayNumberSettingFromJson(json);
}

/// ピルシートの表示モードを定義するenum
/// ピル番号の表示方法を4種類から選択可能
/// ユーザーの好みや使用シーンに応じた表示の切り替えが可能
@JsonEnum(valueField: 'value')
enum PillSheetAppearanceMode {
  /// 基本的な番号表示モード（1, 2, 3...）
  @JsonValue('number')
  number,

  /// 日付表示モード（月/日形式）
  /// プレミアム機能として提供される
  @JsonValue('date')
  date,
  // 古い値。cyclicSequentialに変更した。一時的に両立されていた
  /// 連続番号表示モード（旧形式、cyclicSequentialに移行）
  @JsonValue('sequential')
  sequential,

  /// 周期的連続番号表示モード
  /// 設定可能な開始・終了番号で番号をループさせる
  @JsonValue('cyclicSequential')
  cyclicSequential,
}

/// PillSheetAppearanceModeの拡張機能を提供するextension
/// 表示モードが連続番号系かどうかの判定機能を提供
extension PillSheetAppearanceModeExt on PillSheetAppearanceMode {
  /// 連続番号系の表示モードかどうかを判定
  /// sequential/cyclicSequentialの場合はtrue
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
