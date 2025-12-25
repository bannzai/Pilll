import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'diary.codegen.g.dart';
part 'diary.codegen.freezed.dart';

/// Firestoreの日記ドキュメントのフィールド名定数を管理するクラス
///
/// データベースアクセス時のフィールド名の統一と
/// タイプセーフティを保証するために使用される
class DiaryFirestoreKey {
  /// 日記の日付フィールド名
  /// Firestoreドキュメントの日付を識別するキー
  static const String date = 'date';
}

/// ユーザーの体調状態を表現するenum
///
/// 日記機能でユーザーが自身の体調を記録する際に使用される
/// 体調の良し悪しを2段階で分類する
enum PhysicalConditionStatus {
  /// 体調良好な状態
  fine,

  /// 体調不良な状態
  bad,
}

/// ユーザーの日記エンティティクラス
///
/// Pilllアプリの日記機能で使用される主要なデータモデル
/// 日付ごとのユーザーの体調、性行為の有無、メモを管理する
/// Firestoreの日記コレクションと1対1で対応する
@freezed
abstract class Diary with _$Diary {
  /// 日記のユニークID
  ///
  /// 日付ベースで生成される識別子
  /// フォーマット: "Diary_YYYYMMDD"
  String get id => 'Diary_${DateTimeFormatter.diaryIdentifier(date)}';

  @JsonSerializable(explicitToJson: true)
  const factory Diary({
    /// 日記の対象日付
    ///
    /// 日記エントリが作成された日付を表す
    /// Firestoreとの変換時にTimestampConverterを使用
    @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required DateTime date,

    /// 日記の作成日時
    ///
    /// 日記が実際に作成された日時を記録
    /// 古いデータでは存在しない可能性があるためnullable
    // NOTE: OLD data does't have createdAt
    @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) required DateTime? createdAt,

    /// 体調状態の総合評価
    ///
    /// fine（良好）またはbad（不調）の2段階評価
    /// 未選択の場合はnull
    PhysicalConditionStatus? physicalConditionStatus,

    /// 詳細な体調状態のリスト
    ///
    /// ユーザーが選択した具体的な体調症状を文字列で保存
    /// 空のリストも許可される
    required List<String> physicalConditions,

    /// 性行為の有無
    ///
    /// 妊娠リスクの管理のために記録される
    /// trueの場合は性行為あり、falseの場合はなし
    required bool hasSex,

    /// 自由記述のメモ
    ///
    /// ユーザーが自由にテキストを入力できるフィールド
    /// 空文字列も許可される
    required String memo,
  }) = _Diary;
  const Diary._();

  /// 指定された日付の空の日記を作成するファクトリコンストラクタ
  ///
  /// 新規日記作成時の初期値を設定する
  /// メモは空文字、体調リストは空、性行為はfalseで初期化
  factory Diary.fromDate(DateTime date) => Diary(date: date, memo: '', createdAt: now(), physicalConditions: [], hasSex: false);

  factory Diary.fromJson(Map<String, dynamic> json) => _$DiaryFromJson(json);

  /// 体調状態が設定されているかどうかを判定
  ///
  /// physicalConditionStatusがnullでない場合にtrueを返す
  bool get hasPhysicalConditionStatus => physicalConditionStatus != null;

  /// 指定された体調状態と一致するかどうかを判定
  ///
  /// [status] - 比較対象の体調状態
  /// 現在の体調状態と引数の状態が一致する場合にtrueを返す
  bool hasPhysicalConditionStatusFor(PhysicalConditionStatus status) => physicalConditionStatus == status;
}
