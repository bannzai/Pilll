import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';

part 'pilll_ads.codegen.freezed.dart';
part 'pilll_ads.codegen.g.dart';

/// Pilllアプリ内で表示される広告情報を管理するEntityクラス
/// ホーム画面に表示されるバナー広告や企業からの純広告の設定を保持する
/// 広告の表示期間、見た目、遷移先などの情報を含む
/// FirestoreのpilllAdsコレクションに対応する
@freezed
abstract class PilllAds with _$PilllAds {
  @JsonSerializable(explicitToJson: true)
  factory PilllAds({
    /// 広告の表示開始日時
    /// この時刻以降に広告が表示される
    @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
    required DateTime startDateTime,

    /// 広告の表示終了日時
    /// この時刻以降は広告が表示されなくなる
    @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
    required DateTime endDateTime,

    /// 広告のテキスト説明
    /// バナーに表示される広告文言
    required String description,

    /// 広告画像のURL
    /// nullの場合はテキストのみの広告として表示される
    required String? imageURL,

    /// 広告タップ時の遷移先URL
    /// WebViewまたは外部ブラウザで開かれる
    required String destinationURL,

    /// 広告バナーの背景色
    /// 16進数カラーコード（例: "FF0000"）
    required String hexColor,

    /// 閉じるボタンの色
    /// 16進数カラーコード、デフォルトは白色
    @Default('FFFFFF') String closeButtonColor,

    /// 右向き矢印アイコンの色
    /// 16進数カラーコード、デフォルトは白色
    @Default('FFFFFF') String chevronRightColor,
  }) = _PilllAds;
  PilllAds._();

  factory PilllAds.fromJson(Map<String, dynamic> json) => _$PilllAdsFromJson(json);
}
