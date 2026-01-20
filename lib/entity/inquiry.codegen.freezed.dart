// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inquiry.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Inquiry _$InquiryFromJson(Map<String, dynamic> json) {
  return _Inquiry.fromJson(json);
}

/// @nodoc
mixin _$Inquiry {
  /// ドキュメントID。Firestore保存時に自動設定される
  @JsonKey(includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;

  /// お問い合わせの種別
  InquiryType get inquiryType => throw _privateConstructorUsedError;

  /// その他を選択した場合の自由入力テキスト
  /// inquiryType == InquiryType.other の場合のみ値が入る
  String? get otherTypeText => throw _privateConstructorUsedError;

  /// ユーザーのメールアドレス（返信用）
  String get email => throw _privateConstructorUsedError;

  /// お問い合わせ内容（長文）
  String get content => throw _privateConstructorUsedError;

  /// 作成日時
  @JsonKey(
    fromJson: NonNullTimestampConverter.timestampToDateTime,
    toJson: NonNullTimestampConverter.dateTimeToTimestamp,
  )
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InquiryCopyWith<Inquiry> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InquiryCopyWith<$Res> {
  factory $InquiryCopyWith(Inquiry value, $Res Function(Inquiry) then) =
      _$InquiryCopyWithImpl<$Res, Inquiry>;
  @useResult
  $Res call({
    @JsonKey(includeIfNull: false) String? id,
    InquiryType inquiryType,
    String? otherTypeText,
    String email,
    String content,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    DateTime createdAt,
  });
}

/// @nodoc
class _$InquiryCopyWithImpl<$Res, $Val extends Inquiry>
    implements $InquiryCopyWith<$Res> {
  _$InquiryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? inquiryType = null,
    Object? otherTypeText = freezed,
    Object? email = null,
    Object? content = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            inquiryType: null == inquiryType
                ? _value.inquiryType
                : inquiryType // ignore: cast_nullable_to_non_nullable
                      as InquiryType,
            otherTypeText: freezed == otherTypeText
                ? _value.otherTypeText
                : otherTypeText // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InquiryImplCopyWith<$Res> implements $InquiryCopyWith<$Res> {
  factory _$$InquiryImplCopyWith(
    _$InquiryImpl value,
    $Res Function(_$InquiryImpl) then,
  ) = __$$InquiryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(includeIfNull: false) String? id,
    InquiryType inquiryType,
    String? otherTypeText,
    String email,
    String content,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    DateTime createdAt,
  });
}

/// @nodoc
class __$$InquiryImplCopyWithImpl<$Res>
    extends _$InquiryCopyWithImpl<$Res, _$InquiryImpl>
    implements _$$InquiryImplCopyWith<$Res> {
  __$$InquiryImplCopyWithImpl(
    _$InquiryImpl _value,
    $Res Function(_$InquiryImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? inquiryType = null,
    Object? otherTypeText = freezed,
    Object? email = null,
    Object? content = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$InquiryImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        inquiryType: null == inquiryType
            ? _value.inquiryType
            : inquiryType // ignore: cast_nullable_to_non_nullable
                  as InquiryType,
        otherTypeText: freezed == otherTypeText
            ? _value.otherTypeText
            : otherTypeText // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$InquiryImpl extends _Inquiry {
  const _$InquiryImpl({
    @JsonKey(includeIfNull: false) this.id,
    required this.inquiryType,
    this.otherTypeText,
    required this.email,
    required this.content,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required this.createdAt,
  }) : super._();

  factory _$InquiryImpl.fromJson(Map<String, dynamic> json) =>
      _$$InquiryImplFromJson(json);

  /// ドキュメントID。Firestore保存時に自動設定される
  @override
  @JsonKey(includeIfNull: false)
  final String? id;

  /// お問い合わせの種別
  @override
  final InquiryType inquiryType;

  /// その他を選択した場合の自由入力テキスト
  /// inquiryType == InquiryType.other の場合のみ値が入る
  @override
  final String? otherTypeText;

  /// ユーザーのメールアドレス（返信用）
  @override
  final String email;

  /// お問い合わせ内容（長文）
  @override
  final String content;

  /// 作成日時
  @override
  @JsonKey(
    fromJson: NonNullTimestampConverter.timestampToDateTime,
    toJson: NonNullTimestampConverter.dateTimeToTimestamp,
  )
  final DateTime createdAt;

  @override
  String toString() {
    return 'Inquiry(id: $id, inquiryType: $inquiryType, otherTypeText: $otherTypeText, email: $email, content: $content, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InquiryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.inquiryType, inquiryType) ||
                other.inquiryType == inquiryType) &&
            (identical(other.otherTypeText, otherTypeText) ||
                other.otherTypeText == otherTypeText) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    inquiryType,
    otherTypeText,
    email,
    content,
    createdAt,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InquiryImplCopyWith<_$InquiryImpl> get copyWith =>
      __$$InquiryImplCopyWithImpl<_$InquiryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InquiryImplToJson(this);
  }
}

abstract class _Inquiry extends Inquiry {
  const factory _Inquiry({
    @JsonKey(includeIfNull: false) final String? id,
    required final InquiryType inquiryType,
    final String? otherTypeText,
    required final String email,
    required final String content,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required final DateTime createdAt,
  }) = _$InquiryImpl;
  const _Inquiry._() : super._();

  factory _Inquiry.fromJson(Map<String, dynamic> json) = _$InquiryImpl.fromJson;

  @override
  /// ドキュメントID。Firestore保存時に自動設定される
  @JsonKey(includeIfNull: false)
  String? get id;
  @override
  /// お問い合わせの種別
  InquiryType get inquiryType;
  @override
  /// その他を選択した場合の自由入力テキスト
  /// inquiryType == InquiryType.other の場合のみ値が入る
  String? get otherTypeText;
  @override
  /// ユーザーのメールアドレス（返信用）
  String get email;
  @override
  /// お問い合わせ内容（長文）
  String get content;
  @override
  /// 作成日時
  @JsonKey(
    fromJson: NonNullTimestampConverter.timestampToDateTime,
    toJson: NonNullTimestampConverter.dateTimeToTimestamp,
  )
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$InquiryImplCopyWith<_$InquiryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
