// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inquiry.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Inquiry {

/// ドキュメントID。Firestore保存時に自動設定される
@JsonKey(includeIfNull: false) String? get id;/// お問い合わせの種別
 InquiryType get inquiryType;/// その他を選択した場合の自由入力テキスト
/// inquiryType == InquiryType.other の場合のみ値が入る
 String? get otherTypeText;/// ユーザーのメールアドレス（返信用）
 String get email;/// お問い合わせ内容（長文）
 String get content;/// 作成日時
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime get createdAt;
/// Create a copy of Inquiry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InquiryCopyWith<Inquiry> get copyWith => _$InquiryCopyWithImpl<Inquiry>(this as Inquiry, _$identity);

  /// Serializes this Inquiry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Inquiry&&(identical(other.id, id) || other.id == id)&&(identical(other.inquiryType, inquiryType) || other.inquiryType == inquiryType)&&(identical(other.otherTypeText, otherTypeText) || other.otherTypeText == otherTypeText)&&(identical(other.email, email) || other.email == email)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,inquiryType,otherTypeText,email,content,createdAt);

@override
String toString() {
  return 'Inquiry(id: $id, inquiryType: $inquiryType, otherTypeText: $otherTypeText, email: $email, content: $content, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $InquiryCopyWith<$Res>  {
  factory $InquiryCopyWith(Inquiry value, $Res Function(Inquiry) _then) = _$InquiryCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeIfNull: false) String? id, InquiryType inquiryType, String? otherTypeText, String email, String content,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime createdAt
});




}
/// @nodoc
class _$InquiryCopyWithImpl<$Res>
    implements $InquiryCopyWith<$Res> {
  _$InquiryCopyWithImpl(this._self, this._then);

  final Inquiry _self;
  final $Res Function(Inquiry) _then;

/// Create a copy of Inquiry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? inquiryType = null,Object? otherTypeText = freezed,Object? email = null,Object? content = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,inquiryType: null == inquiryType ? _self.inquiryType : inquiryType // ignore: cast_nullable_to_non_nullable
as InquiryType,otherTypeText: freezed == otherTypeText ? _self.otherTypeText : otherTypeText // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Inquiry].
extension InquiryPatterns on Inquiry {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Inquiry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Inquiry() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Inquiry value)  $default,){
final _that = this;
switch (_that) {
case _Inquiry():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Inquiry value)?  $default,){
final _that = this;
switch (_that) {
case _Inquiry() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  String? id,  InquiryType inquiryType,  String? otherTypeText,  String email,  String content, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Inquiry() when $default != null:
return $default(_that.id,_that.inquiryType,_that.otherTypeText,_that.email,_that.content,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  String? id,  InquiryType inquiryType,  String? otherTypeText,  String email,  String content, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Inquiry():
return $default(_that.id,_that.inquiryType,_that.otherTypeText,_that.email,_that.content,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeIfNull: false)  String? id,  InquiryType inquiryType,  String? otherTypeText,  String email,  String content, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Inquiry() when $default != null:
return $default(_that.id,_that.inquiryType,_that.otherTypeText,_that.email,_that.content,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Inquiry extends Inquiry {
  const _Inquiry({@JsonKey(includeIfNull: false) this.id, required this.inquiryType, this.otherTypeText, required this.email, required this.content, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.createdAt}): super._();
  factory _Inquiry.fromJson(Map<String, dynamic> json) => _$InquiryFromJson(json);

/// ドキュメントID。Firestore保存時に自動設定される
@override@JsonKey(includeIfNull: false) final  String? id;
/// お問い合わせの種別
@override final  InquiryType inquiryType;
/// その他を選択した場合の自由入力テキスト
/// inquiryType == InquiryType.other の場合のみ値が入る
@override final  String? otherTypeText;
/// ユーザーのメールアドレス（返信用）
@override final  String email;
/// お問い合わせ内容（長文）
@override final  String content;
/// 作成日時
@override@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) final  DateTime createdAt;

/// Create a copy of Inquiry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InquiryCopyWith<_Inquiry> get copyWith => __$InquiryCopyWithImpl<_Inquiry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InquiryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Inquiry&&(identical(other.id, id) || other.id == id)&&(identical(other.inquiryType, inquiryType) || other.inquiryType == inquiryType)&&(identical(other.otherTypeText, otherTypeText) || other.otherTypeText == otherTypeText)&&(identical(other.email, email) || other.email == email)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,inquiryType,otherTypeText,email,content,createdAt);

@override
String toString() {
  return 'Inquiry(id: $id, inquiryType: $inquiryType, otherTypeText: $otherTypeText, email: $email, content: $content, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$InquiryCopyWith<$Res> implements $InquiryCopyWith<$Res> {
  factory _$InquiryCopyWith(_Inquiry value, $Res Function(_Inquiry) _then) = __$InquiryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeIfNull: false) String? id, InquiryType inquiryType, String? otherTypeText, String email, String content,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime createdAt
});




}
/// @nodoc
class __$InquiryCopyWithImpl<$Res>
    implements _$InquiryCopyWith<$Res> {
  __$InquiryCopyWithImpl(this._self, this._then);

  final _Inquiry _self;
  final $Res Function(_Inquiry) _then;

/// Create a copy of Inquiry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? inquiryType = null,Object? otherTypeText = freezed,Object? email = null,Object? content = null,Object? createdAt = null,}) {
  return _then(_Inquiry(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,inquiryType: null == inquiryType ? _self.inquiryType : inquiryType // ignore: cast_nullable_to_non_nullable
as InquiryType,otherTypeText: freezed == otherTypeText ? _self.otherTypeText : otherTypeText // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
