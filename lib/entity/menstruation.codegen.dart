import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/utils/datetime/date_range.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/datetime/day.dart';

part 'menstruation.codegen.g.dart';
part 'menstruation.codegen.freezed.dart';

/// Firestoreの生理記録コレクションで使用されるフィールド名を定義するクラス
/// データベースアクセス時のキー名の一貫性を保つために使用される
class MenstruationFirestoreKey {
  /// 生理開始日のフィールド名
  static const String beginDate = 'beginDate';

  /// 論理削除日時のフィールド名
  static const String deletedAt = 'deletedAt';
}

/// 生理期間の記録を表現するEntityクラス
/// 生理の開始日から終了日までの期間と、作成・削除情報を管理する
/// Firestoreのmenstruationsコレクションに対応するドキュメント構造
/// HealthKitとの連携機能もサポートしている
@freezed
class Menstruation with _$Menstruation {
  factory Menstruation.fromJson(Map<String, dynamic> json) => _$MenstruationFromJson(json);
  const Menstruation._();

  @JsonSerializable(explicitToJson: true)
  const factory Menstruation({
    /// FirestoreドキュメントのID
    /// 新規作成時はnullで、保存時に自動生成される
    @JsonKey(includeIfNull: false) String? id,

    /// 生理開始日
    /// 生理周期計算の基準となる重要な日付
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime beginDate,

    /// 生理終了日
    /// 生理期間の長さを決定する日付
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime endDate,

    /// 論理削除日時
    /// nullの場合は有効な記録、値がある場合は削除済み
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    DateTime? deletedAt,

    /// 生理記録の作成日時
    /// データの作成順序や履歴管理に使用される
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime createdAt,

    /// HealthKitサンプルデータのUUID
    /// HealthKitから取得したデータとの紐付けに使用
    String? healthKitSampleDataUUID,
  }) = _Menstruation;

  /// 生理期間をDateRange形式で取得する
  /// 日付範囲の計算や比較処理で使用される
  DateRange get dateRange => DateRange(beginDate, endDate);

  /// 生理期間をFlutterのDateTimeRange形式で取得する
  /// UI表示やカレンダー選択で使用される
  DateTimeRange get dateTimeRange => DateTimeRange(start: beginDate, end: endDate);

  /// 現在生理中かどうかを判定する
  /// 今日の日付が生理期間内に含まれるかをチェック
  bool get isActive => dateRange.inRange(today());
}

/// 2つの生理記録間の日数差を計算する関数
/// 生理周期の長さを算出する際に使用される
/// [lhs] 基準となる生理記録
/// [rhs] 比較対象の生理記録（nullの場合はnullを返す）
/// 戻り値: 2つの生理開始日の日数差の絶対値、rhsがnullの場合はnull
int? menstruationsDiff(Menstruation lhs, Menstruation? rhs) {
  if (rhs == null) {
    return null;
  }
  final range = DateRange(lhs.beginDate, rhs.beginDate);
  return range.days.abs();
}
