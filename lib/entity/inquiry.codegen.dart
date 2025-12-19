import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'inquiry.codegen.g.dart';
part 'inquiry.codegen.freezed.dart';

/// お問い合わせの種別を表すenum
enum InquiryType {
  /// 不具合報告
  bugReport,

  /// ご意見・ご要望
  featureRequest,

  /// その他
  other,
}

/// ユーザーからのお問い合わせを表すエンティティ
/// Firestoreの /users/{userId}/inquiries コレクションに保存される
@freezed
class Inquiry with _$Inquiry {
  @JsonSerializable(explicitToJson: true)
  const factory Inquiry({
    /// ドキュメントID。Firestore保存時に自動設定される
    @JsonKey(includeIfNull: false) String? id,

    /// お問い合わせの種別
    required InquiryType inquiryType,

    /// その他を選択した場合の自由入力テキスト
    /// inquiryType == InquiryType.other の場合のみ値が入る
    String? otherTypeText,

    /// ユーザーのメールアドレス（返信用）
    required String email,

    /// お問い合わせ内容（長文）
    required String content,

    /// 作成日時
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime createdAt,
  }) = _Inquiry;
  const Inquiry._();

  factory Inquiry.fromJson(Map<String, dynamic> json) => _$InquiryFromJson(json);
}
