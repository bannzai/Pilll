import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/utils/datetime/date_compare.dart';
import 'package:pilll/utils/datetime/day.dart';

part 'pill.codegen.g.dart';
part 'pill.codegen.freezed.dart';

/// ピルの服用記録を表すクラス
/// 1回の服用操作に対応する情報を保持
/// 同時服用（2錠飲み等）の場合は同一のrecordedTakenDateTimeを持つ
@freezed
class PillTaken with _$PillTaken {
  @JsonSerializable(explicitToJson: true)
  const factory PillTaken({
    /// 服用記録日時
    /// 同時服用を行った場合は対象となるPillTakenのrecordedTakenDateTimeは同一にする
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime recordedTakenDateTime,

    /// レコード作成日時
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime createdDateTime,

    /// レコード更新日時
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime updatedDateTime,

    /// バックエンドで自動的に記録された場合にtrue
    @Default(false) bool isAutomaticallyRecorded,
  }) = _PillTaken;

  factory PillTaken.fromJson(Map<String, dynamic> json) => _$PillTakenFromJson(json);
}

/// ピルシート内の1つのピルを表すクラス
/// ピル番号（index）と服用記録のリストを保持
/// 2錠飲みの場合はpillTakensに2つの記録が入る
@freezed
class Pill with _$Pill {
  const Pill._();
  @JsonSerializable(explicitToJson: true)
  const factory Pill({
    /// ピルシート内のインデックス（0始まり）
    required int index,

    /// このピルで服用すべき回数
    /// 1日2錠の場合は2、1日1錠の場合は1
    required int takenCount,

    /// レコード作成日時
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime createdDateTime,

    /// レコード更新日時
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime updatedDateTime,

    /// 服用記録のリスト
    /// 2錠飲みの場合は2つのPillTakenが入る
    required List<PillTaken> pillTakens,
  }) = _Pill;

  factory Pill.fromJson(Map<String, dynamic> json) => _$PillFromJson(json);

  /// ピルシートの初期化時にPillリストを生成する
  /// lastTakenDateまでの各ピルにpillTakenCount個の服用記録を埋める
  static List<Pill> generateAndFillTo({
    required PillSheetType pillSheetType,
    required DateTime fromDate,
    required DateTime? lastTakenDate,
    required int pillTakenCount,
  }) {
    final currentDate = now();
    return List.generate(pillSheetType.totalCount, (index) {
      final date = fromDate.add(Duration(days: index));
      return Pill(
        index: index,
        takenCount: pillTakenCount,
        createdDateTime: currentDate,
        updatedDateTime: currentDate,
        pillTakens: lastTakenDate != null && (date.isBefore(lastTakenDate) || isSameDay(date, lastTakenDate))
            ? List.generate(
                pillTakenCount,
                (i) {
                  // ピルは複数飲む場合もあるので、dateでtakenDateTimeを更新するのではなく、引数でもらったlastTakenDateを使って値を埋める
                  return PillTaken(
                    recordedTakenDateTime: lastTakenDate,
                    createdDateTime: currentDate,
                    updatedDateTime: currentDate,
                  );
                },
              )
            : [],
      );
    });
  }

  /// テスト用のPillリスト生成メソッド
  /// generateAndFillToとの違いは、各ピルの服用予定日がtakenDateTimeにセットされる点
  @visibleForTesting
  static List<Pill> testGenerateAndIterateTo({
    required PillSheetType pillSheetType,
    required DateTime fromDate,
    required DateTime? lastTakenDate,
    required int pillTakenCount,
  }) {
    return List.generate(pillSheetType.totalCount, (index) {
      final date = fromDate.add(Duration(days: index));
      return Pill(
        index: index,
        takenCount: pillTakenCount,
        createdDateTime: now(),
        updatedDateTime: now(),
        pillTakens: lastTakenDate != null && (date.isBefore(lastTakenDate) || isSameDay(date, lastTakenDate))
            ? List.generate(
                pillTakenCount,
                (i) {
                  // generateAndFillToとの違いはここになる。lastTakenDateではなく、そのピルが通常服用する予定だった服用日がtakenDateTimeにセットされる
                  return PillTaken(
                    recordedTakenDateTime: date,
                    createdDateTime: now(),
                    updatedDateTime: now(),
                  );
                },
              )
            : [],
      );
    });
  }

  /// このピルの服用が完了しているかどうか
  bool get isCompleted => pillTakens.length >= takenCount;

  /// このピルの残り服用回数
  int get remainingTakenCount => takenCount - pillTakens.length;
}
