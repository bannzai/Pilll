import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';

part 'pill_sheet_modified_history_value.codegen.g.dart';
part 'pill_sheet_modified_history_value.codegen.freezed.dart';

/// ピルシートに対する各種変更操作の履歴を記録するメインクラス
/// 服用記録、削除、番号変更、休薬期間設定など様々な操作を統一的に管理
/// Firestore履歴ドキュメントの値部分として使用され、監査ログや
/// データ分析、トラブルシューティングで重要な役割を果たす
/// 各変更タイプに対応するプロパティのうち、実際に発生した変更に応じて
/// 該当するプロパティのみが非nullの値を持つ構造
@freezed
class PillSheetModifiedHistoryValue with _$PillSheetModifiedHistoryValue {
  const PillSheetModifiedHistoryValue._();
  @JsonSerializable(explicitToJson: true)
  const factory PillSheetModifiedHistoryValue({
    /// ピルシート作成時の記録
    /// 新規ピルシートが作成された際の作成情報
    @Default(null) CreatedPillSheetValue? createdPillSheet,
    /// 自動記録された最終服用日の変更
    /// システムが自動的に最終服用日を更新した際の記録
    @Default(null) AutomaticallyRecordedLastTakenDateValue? automaticallyRecordedLastTakenDate,
    /// ピルシート削除時の記録
    /// ピルシートが削除された際の削除情報
    @Default(null) DeletedPillSheetValue? deletedPillSheet,
    /// ピル服用記録時の情報
    /// ユーザーがピルを服用したことを記録した際の情報
    @Default(null) TakenPillValue? takenPill,
    /// ピル服用記録の取り消し情報
    /// 誤って記録した服用を取り消した際の情報
    @Default(null) RevertTakenPillValue? revertTakenPill,
    /// ピル番号変更時の記録
    /// ピル番号の調整や修正が行われた際の変更情報
    @Default(null) ChangedPillNumberValue? changedPillNumber,
    /// ピルシート終了時の記録
    /// シートの服用完了や手動終了時の情報
    @Default(null) EndedPillSheetValue? endedPillSheet,
    /// 休薬期間開始時の記録
    /// ユーザーが服用を一時停止した際の開始情報
    @Default(null) BeganRestDurationValue? beganRestDurationValue,
    /// 休薬期間終了時の記録
    /// 休薬期間が終了し服用を再開した際の情報
    @Default(null) EndedRestDurationValue? endedRestDurationValue,
    /// 休薬期間開始日変更時の記録（v2から追加）
    /// 既存の休薬期間の開始日を変更した際の情報
    @Default(null) ChangedRestDurationBeginDateValue? changedRestDurationBeginDateValue,
    /// 休薬期間内容変更時の記録（v2から追加）
    /// 休薬期間の設定内容を変更した際の情報
    @Default(null) ChangedRestDurationValue? changedRestDurationValue,
    /// 表示開始番号変更時の記録
    /// ピルシートの表示番号の開始値を変更した際の情報
    @Default(null) ChangedBeginDisplayNumberValue? changedBeginDisplayNumber,
    /// 表示終了番号変更時の記録
    /// ピルシートの表示番号の終了値を変更した際の情報
    @Default(null) ChangedEndDisplayNumberValue? changedEndDisplayNumber,
  }) = _PillSheetModifiedHistoryValue;

  factory PillSheetModifiedHistoryValue.fromJson(Map<String, dynamic> json) => _$PillSheetModifiedHistoryValueFromJson(json);
}

/// ピルシート作成時の履歴情報を記録するクラス
/// 新規ピルシートが作成された際の作成日時と対象シートIDを保存
/// v1時代の構造で現在は非推奨プロパティとなっている
@freezed
class CreatedPillSheetValue with _$CreatedPillSheetValue {
  const CreatedPillSheetValue._();
  @JsonSerializable(explicitToJson: true)
  const factory CreatedPillSheetValue({
    // The below properties are deprecated and added since v1.
    // This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
    /// ピルシート作成日時（非推奨）
    /// Firestoreタイムスタンプから自動変換される作成日時
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime pillSheetCreatedAt,
    /// 作成されたピルシートのIDリスト（非推奨）
    /// 複数シート同時作成に対応するためのIDリスト
    @Default([]) List<String> pillSheetIDs,
  }) = _CreatedPillSheetValue;

  factory CreatedPillSheetValue.fromJson(Map<String, dynamic> json) => _$CreatedPillSheetValueFromJson(json);
}

/// 最終服用日の自動記録時の履歴情報を記録するクラス
/// システムが自動的に最終服用日を更新した際のbefore/after情報を保存
/// v1時代の構造で現在は非推奨プロパティとなっている
@freezed
class AutomaticallyRecordedLastTakenDateValue with _$AutomaticallyRecordedLastTakenDateValue {
  const AutomaticallyRecordedLastTakenDateValue._();
  @JsonSerializable(explicitToJson: true)
  const factory AutomaticallyRecordedLastTakenDateValue({
    // The below properties are deprecated and added since v1.
    // This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
    /// 変更前の最終服用日（非推奨、nullable）
    /// 初回服用の場合はnullとなる
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    DateTime? beforeLastTakenDate,
    /// 変更後の最終服用日（非推奨）
    /// 自動記録によって設定された新しい最終服用日
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime afterLastTakenDate,
    /// 変更前の最終服用ピル番号（非推奨）
    /// 自動記録前のピル番号
    required int beforeLastTakenPillNumber,
    /// 変更後の最終服用ピル番号（非推奨）
    /// 自動記録後のピル番号
    required int afterLastTakenPillNumber,
  }) = _AutomaticallyRecordedLastTakenDateValue;

  factory AutomaticallyRecordedLastTakenDateValue.fromJson(Map<String, dynamic> json) => _$AutomaticallyRecordedLastTakenDateValueFromJson(json);
}

/// ピルシート削除時の履歴情報を記録するクラス
/// ピルシートが削除された際の削除日時と対象シートIDを保存
/// v1時代の構造で現在は非推奨プロパティとなっている
@freezed
class DeletedPillSheetValue with _$DeletedPillSheetValue {
  const DeletedPillSheetValue._();
  @JsonSerializable(explicitToJson: true)
  const factory DeletedPillSheetValue({
    // The below properties are deprecated and added since v1.
    // This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
    /// ピルシート削除日時（非推奨）
    /// Firestoreタイムスタンプから自動変換される削除日時
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime pillSheetDeletedAt,
    /// 削除されたピルシートのIDリスト（非推奨）
    /// 複数シート同時削除に対応するためのIDリスト
    @Default([]) List<String> pillSheetIDs,
  }) = _DeletedPillSheetValue;

  factory DeletedPillSheetValue.fromJson(Map<String, dynamic> json) => _$DeletedPillSheetValueFromJson(json);
}

/// ピル服用記録時の履歴情報を記録するクラス
/// ユーザーがピルを服用した際の記録方法（クイック記録か手動か）、
/// 編集情報、服用日時の変更前後情報を保存する
/// v1で追加されたプロパティと非推奨プロパティが混在している
@freezed
class TakenPillValue with _$TakenPillValue {
  const TakenPillValue._();
  @JsonSerializable(explicitToJson: true)
  const factory TakenPillValue({
    // ============ BEGIN: Added since v1 ============
    /// クイック記録かどうかのフラグ（v1追加）
    /// nullは途中から追加されたプロパティのため判定不能を表す
    // null => 途中から追加したプロパティなので、どちらか不明
    bool? isQuickRecord,
    /// 服用記録の編集情報（v1追加）
    /// ユーザーが後から服用時刻を編集した場合の詳細情報
    TakenPillEditedValue? edited,
    // ============ END: Added since v1 ============

    // The below properties are deprecated and added since v1.
    // This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
    /// 変更前の最終服用日（非推奨、nullable）
    /// 初回服用の場合はnullとなる
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    DateTime? beforeLastTakenDate,
    /// 変更後の最終服用日（非推奨）
    /// 服用記録によって設定された新しい最終服用日
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime afterLastTakenDate,
    /// 変更前の最終服用ピル番号（非推奨）
    /// 服用記録前のピル番号
    required int beforeLastTakenPillNumber,
    /// 変更後の最終服用ピル番号（非推奨）
    /// 服用記録後のピル番号
    required int afterLastTakenPillNumber,
  }) = _TakenPillValue;

  factory TakenPillValue.fromJson(Map<String, dynamic> json) => _$TakenPillValueFromJson(json);
}

/// 服用記録の編集に関する詳細情報を記録するクラス
/// ユーザーが後から服用時刻を編集した際の実際の服用時刻、
/// 元の履歴記録時刻、編集操作の作成時刻を管理する
/// v1から追加された新しい構造のクラス
@freezed
class TakenPillEditedValue with _$TakenPillEditedValue {
  @JsonSerializable(explicitToJson: true)
  const factory TakenPillEditedValue({
    // ============ BEGIN: Added since v1 ============
    /// 実際の服用時刻（v1追加）
    /// ユーザーが編集した後の正確な服用時刻
    // 実際の服用時刻。ユーザーが編集した後の服用時刻
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime actualTakenDate,
    /// 元の履歴記録時刻（v1追加）
    /// 通常はユーザーが編集する前の服用時刻として記録される
    // 元々の履歴がDBに書き込まれた時刻。通常はユーザーが編集する前の服用時刻
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime historyRecordedDate,
    /// 編集操作の作成日時（v1追加）
    /// この編集レコードがデータベースに作成された日時
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime createdDate,
    // ============ END: Added since v1 ============
  }) = _TakenPillEditedValue;
  const TakenPillEditedValue._();

  factory TakenPillEditedValue.fromJson(Map<String, dynamic> json) => _$TakenPillEditedValueFromJson(json);
}

/// ピル服用記録の取り消し時の履歴情報を記録するクラス
/// 誤って記録された服用を取り消した際の変更前後情報を保存
/// v1時代の構造で現在は非推奨プロパティとなっている
@freezed
class RevertTakenPillValue with _$RevertTakenPillValue {
  const RevertTakenPillValue._();
  @JsonSerializable(explicitToJson: true)
  const factory RevertTakenPillValue({
    // The below properties are deprecated and added since v1.
    // This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
    /// 取り消し前の最終服用日（非推奨、nullable）
    /// 取り消し操作前の最終服用日
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    DateTime? beforeLastTakenDate,
    /// 取り消し後の最終服用日（非推奨、nullable）
    /// 取り消し操作後の最終服用日、服用履歴がなくなった場合はnull
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    required DateTime? afterLastTakenDate,
    /// 取り消し前の最終服用ピル番号（非推奨）
    /// 取り消し操作前のピル番号
    required int beforeLastTakenPillNumber,
    /// 取り消し後の最終服用ピル番号（非推奨）
    /// 取り消し操作後のピル番号
    required int afterLastTakenPillNumber,
  }) = _RevertTakenPillValue;

  factory RevertTakenPillValue.fromJson(Map<String, dynamic> json) => _$RevertTakenPillValueFromJson(json);
}

/// ピル番号変更時の履歴情報を記録するクラス
/// ピル服用スケジュールの調整や修正が行われた際の詳細な変更情報を保存
/// 開始日、今日のピル番号、グループインデックスの変更前後を記録
/// v1時代の構造で現在は非推奨プロパティとなっている
@freezed
class ChangedPillNumberValue with _$ChangedPillNumberValue {
  const ChangedPillNumberValue._();
  @JsonSerializable(explicitToJson: true)
  const factory ChangedPillNumberValue({
    // The below properties are deprecated and added since v1.
    // This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
    /// 変更前の開始日（非推奨）
    /// ピル番号変更前のピルシート開始日
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime beforeBeginingDate,
    /// 変更後の開始日（非推奨）
    /// ピル番号変更後のピルシート開始日
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime afterBeginingDate,
    /// 変更前の今日のピル番号（非推奨）
    /// 変更操作前の今日に対応するピル番号
    required int beforeTodayPillNumber,
    /// 変更後の今日のピル番号（非推奨）
    /// 変更操作後の今日に対応するピル番号
    required int afterTodayPillNumber,
    /// 変更前のグループインデックス（非推奨）
    /// ピルシートグループ内での順序番号（デフォルト：1）
    @Default(1) int beforeGroupIndex,
    /// 変更後のグループインデックス（非推奨）
    /// ピルシートグループ内での順序番号（デフォルト：1）
    @Default(1) int afterGroupIndex,
  }) = _ChangedPillNumberValue;

  factory ChangedPillNumberValue.fromJson(Map<String, dynamic> json) => _$ChangedPillNumberValueFromJson(json);
}

/// ピルシート終了時の履歴情報を記録するクラス
/// シートの服用完了や手動終了時の終了記録日と最終服用日を保存
/// サーバー側で記録される終了処理の正式な記録として使用される
@freezed
class EndedPillSheetValue with _$EndedPillSheetValue {
  const EndedPillSheetValue._();
  @JsonSerializable(explicitToJson: true)
  const factory EndedPillSheetValue({
    /// 終了記録日（必須）
    /// サーバーで書き込まれるピルシート終了の公式記録日時
    // 終了した日付。サーバーで書き込まれる
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime endRecordDate,
    /// 終了時点での最終服用日（必須）
    /// シート終了時の最後に服用したピルの日付
    // 終了した時点での最終服用日
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime lastTakenDate,
  }) = _EndedPillSheetValue;

  factory EndedPillSheetValue.fromJson(Map<String, dynamic> json) => _$EndedPillSheetValueFromJson(json);
}

/// 休薬期間開始時の履歴情報を記録するクラス
/// ユーザーが服用を一時停止した際の休薬期間情報を保存
/// v1で追加されたクラスで、特定しやすいよう詳細な休薬期間データを記録
@freezed
class BeganRestDurationValue with _$BeganRestDurationValue {
  const BeganRestDurationValue._();
  @JsonSerializable(explicitToJson: true)
  const factory BeganRestDurationValue({
    // ============ BEGIN: Added since v1 ============
    /// 開始された休薬期間の詳細情報（v1追加）
    /// どの服用お休み期間かを特定するため完全な休薬期間データを記録
    // どの服用お休み期間か特定するのが大変なので記録したものを使用する
    required RestDuration restDuration,
    // ============ END: Added since v1 ============
  }) = _BeganRestDurationValue;

  factory BeganRestDurationValue.fromJson(Map<String, dynamic> json) => _$BeganRestDurationValueFromJson(json);
}

/// 休薬期間終了時の履歴情報を記録するクラス
/// 休薬期間が終了し服用を再開した際の休薬期間情報を保存
/// v1で追加されたクラスで、特定しやすいよう詳細な休薬期間データを記録
@freezed
class EndedRestDurationValue with _$EndedRestDurationValue {
  const EndedRestDurationValue._();
  @JsonSerializable(explicitToJson: true)
  const factory EndedRestDurationValue({
    // ============ BEGIN: Added since v1 ============
    /// 終了された休薬期間の詳細情報（v1追加）
    /// どの服用お休み期間かを特定するため完全な休薬期間データを記録
    // どの服用お休み期間か特定するのが大変なので記録したものを使用する
    required RestDuration restDuration,
    // ============ END: Added since v1 ============
  }) = _EndedRestDurationValue;

  factory EndedRestDurationValue.fromJson(Map<String, dynamic> json) => _$EndedRestDurationValueFromJson(json);
}

/// 休薬期間の開始日変更時の履歴情報を記録するクラス
/// 既存の休薬期間の開始日を変更した際のbefore/after情報を保存
/// v2から導入された新しい構造のクラス
// ChangedRestDurationBeginDateValue は v2 からの構造体
@freezed
class ChangedRestDurationBeginDateValue with _$ChangedRestDurationBeginDateValue {
  const ChangedRestDurationBeginDateValue._();
  @JsonSerializable(explicitToJson: true)
  const factory ChangedRestDurationBeginDateValue({
    /// 変更前の休薬期間情報（v2追加）
    /// 開始日変更前の完全な休薬期間データ
    required RestDuration beforeRestDuration,
    /// 変更後の休薬期間情報（v2追加）
    /// 開始日変更後の完全な休薬期間データ
    required RestDuration afterRestDuration,
  }) = _ChangedRestDurationBeginDateValue;

  factory ChangedRestDurationBeginDateValue.fromJson(Map<String, dynamic> json) => _$ChangedRestDurationBeginDateValueFromJson(json);
}

/// 休薬期間の内容変更時の履歴情報を記録するクラス
/// 休薬期間の設定内容を変更した際のbefore/after情報を保存
/// v2から導入された新しい構造のクラス
// ChangedRestDurationValue は v2 からの構造体
@freezed
class ChangedRestDurationValue with _$ChangedRestDurationValue {
  const ChangedRestDurationValue._();
  @JsonSerializable(explicitToJson: true)
  const factory ChangedRestDurationValue({
    /// 変更前の休薬期間情報（v2追加）
    /// 内容変更前の完全な休薬期間データ
    required RestDuration beforeRestDuration,
    /// 変更後の休薬期間情報（v2追加）
    /// 内容変更後の完全な休薬期間データ
    required RestDuration afterRestDuration,
  }) = _ChangedRestDurationValue;

  factory ChangedRestDurationValue.fromJson(Map<String, dynamic> json) => _$ChangedRestDurationValueFromJson(json);
}

/// 表示開始番号変更時の履歴情報を記録するクラス
/// ピルシートの表示番号の開始値を変更した際のbefore/after設定を保存
/// カスタム表示機能で使用される表示番号設定の変更履歴を管理
/// v1時代の構造で現在は非推奨プロパティとなっている
@freezed
class ChangedBeginDisplayNumberValue with _$ChangedBeginDisplayNumberValue {
  const ChangedBeginDisplayNumberValue._();
  @JsonSerializable(explicitToJson: true)
  const factory ChangedBeginDisplayNumberValue({
    // The below properties are deprecated and added since v1.
    // This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
    /// 変更前の表示番号設定（非推奨、nullable）
    /// 番号を変更したことがない場合はnullとなる
    // 番号を変更した事が無い場合もあるのでnullable
    required PillSheetGroupDisplayNumberSetting? beforeDisplayNumberSetting,
    /// 変更後の表示番号設定（非推奨）
    /// 変更操作後の新しい表示番号設定
    required PillSheetGroupDisplayNumberSetting afterDisplayNumberSetting,
  }) = _ChangedBeginDisplayNumberValue;

  factory ChangedBeginDisplayNumberValue.fromJson(Map<String, dynamic> json) => _$ChangedBeginDisplayNumberValueFromJson(json);
}

/// 表示終了番号変更時の履歴情報を記録するクラス
/// ピルシートの表示番号の終了値を変更した際のbefore/after設定を保存
/// カスタム表示機能で使用される表示番号設定の変更履歴を管理
/// v1時代の構造で現在は非推奨プロパティとなっている
@freezed
class ChangedEndDisplayNumberValue with _$ChangedEndDisplayNumberValue {
  const ChangedEndDisplayNumberValue._();
  @JsonSerializable(explicitToJson: true)
  const factory ChangedEndDisplayNumberValue({
    // The below properties are deprecated and added since v1.
    // This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
    /// 変更前の表示番号設定（非推奨、nullable）
    /// 番号を変更したことがない場合はnullとなる
    // 番号を変更した事が無い場合もあるのでnullable
    required PillSheetGroupDisplayNumberSetting? beforeDisplayNumberSetting,
    /// 変更後の表示番号設定（非推奨）
    /// 変更操作後の新しい表示番号設定
    required PillSheetGroupDisplayNumberSetting afterDisplayNumberSetting,
  }) = _ChangedEndDisplayNumberValue;

  factory ChangedEndDisplayNumberValue.fromJson(Map<String, dynamic> json) => _$ChangedEndDisplayNumberValueFromJson(json);
}
