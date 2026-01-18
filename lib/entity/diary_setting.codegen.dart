import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'diary_setting.codegen.g.dart';
part 'diary_setting.codegen.freezed.dart';

/// ユーザーの日記機能で使用可能な体調項目のデフォルトリスト
/// ユーザーは日記画面でこれらの項目から体調を選択して記録できる
/// 各項目は日本語で記述され、ユーザーに表示される
const List<String> defaultPhysicalConditions = ['頭痛', '腹痛', '吐き気', '貧血', '下痢', '便秘', 'ほてり', '眠気', '腰痛', '動悸', '不正出血', '食欲不振', '胸の張り', '不眠'];
// TODO: [Localizations] const にしないとfreezedでエラー
// final List<String> defaultPhysicalConditions = [
//   L.headache,
//   L.abdominalPain,
//   L.nausea,
//   L.anemia,
//   L.diarrhea,
//   L.constipation,
//   L.drowsiness,
//   L.backPain,
//   L.palpitation,
//   L.irregularBleeding,
//   L.lossOfAppetite,
//   L.chestTightness,
//   L.insomnia,
// ];

/// ユーザーの日記機能に関する設定情報を管理するエンティティクラス
/// Firestoreの`diary_settings`コレクションに保存される
/// 日記画面で記録可能な体調項目の管理や設定作成日時の記録を行う
/// イミュータブルなデータクラスとして実装されている
@freezed
class DiarySetting with _$DiarySetting {
  const DiarySetting._();
  @JsonSerializable(explicitToJson: true)
  const factory DiarySetting({
    /// 日記機能で選択可能な体調項目のリスト
    /// デフォルトでは事前定義された14種類の体調項目が設定される
    /// ユーザーによる項目のカスタマイズが可能
    @Default(defaultPhysicalConditions) List<String> physicalConditions,

    /// 設定が作成された日時
    /// Firestoreのタイムスタンプ形式で保存され、読み書き時に自動変換される
    @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
    required DateTime createdAt,
  }) = _DiarySetting;

  factory DiarySetting.fromJson(Map<String, dynamic> json) => _$DiarySettingFromJson(json);
}
