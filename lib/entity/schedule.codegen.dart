import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'schedule.codegen.g.dart';
part 'schedule.codegen.freezed.dart';

/// Firestoreのスケジュールコレクションで使用するフィールド名定数
/// データベースクエリやドキュメント操作時の型安全性を提供
class ScheduleFirestoreKey {
  static const String date = 'date';
}

/// ユーザーが登録した将来の予定を表すエンティティ
/// 通院予定や重要な日程などをカレンダーUIで管理するために使用
/// Firestoreの schedules コレクションに保存される
@freezed
class Schedule with _$Schedule {
  @JsonSerializable(explicitToJson: true)
  const factory Schedule({
    /// ドキュメントID。Firestore保存時に自動設定される
    /// nullの場合は新規作成、値がある場合は既存ドキュメントの更新を示す
    @JsonKey(includeIfNull: false) String? id,

    /// 予定のタイトル。ユーザーが入力する予定名
    /// 例：「婦人科受診」「定期検診」など
    required String title,

    /// 予定日時。ユーザーがカレンダーUIで選択した日付
    /// Firestoreのタイムスタンプ形式で保存される
    @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required DateTime date,

    /// ローカル通知の設定。nullの場合は通知なし
    /// 予定前にリマインドを送るための設定
    LocalNotification? localNotification,

    /// 予定作成日時。レコード作成時の記録用
    /// データの管理やソート処理で使用される
    @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
    required DateTime createdDateTime,
  }) = _Schedule;
  const Schedule._();

  factory Schedule.fromJson(Map<String, dynamic> json) => _$ScheduleFromJson(json);
}

/// スケジュールに関連付けられるローカル通知の設定
/// iOSとAndroidのローカル通知システムを通じて予定のリマインドを提供
@freezed
class LocalNotification with _$LocalNotification {
  @JsonSerializable(explicitToJson: true)
  const factory LocalNotification({
    /// flutter_local_notificationsプラグインで使用する通知ID
    /// 通知のキャンセルや更新時に必要な一意識別子
    required int localNotificationID,

    /// 通知を送信する日時
    /// ユーザーが設定したリマインド時刻に基づいて計算される
    @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
    required DateTime remindDateTime,
  }) = _LocalNotification;
  const LocalNotification._();

  factory LocalNotification.fromJson(Map<String, dynamic> json) => _$LocalNotificationFromJson(json);
}
