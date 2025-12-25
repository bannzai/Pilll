// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diary_setting.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DiarySetting implements DiagnosticableTreeMixin {

/// 日記機能で選択可能な体調項目のリスト
/// デフォルトでは事前定義された14種類の体調項目が設定される
/// ユーザーによる項目のカスタマイズが可能
 List<String> get physicalConditions;/// 設定が作成された日時
/// Firestoreのタイムスタンプ形式で保存され、読み書き時に自動変換される
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime get createdAt;
/// Create a copy of DiarySetting
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiarySettingCopyWith<DiarySetting> get copyWith => _$DiarySettingCopyWithImpl<DiarySetting>(this as DiarySetting, _$identity);

  /// Serializes this DiarySetting to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'DiarySetting'))
    ..add(DiagnosticsProperty('physicalConditions', physicalConditions))..add(DiagnosticsProperty('createdAt', createdAt));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiarySetting&&const DeepCollectionEquality().equals(other.physicalConditions, physicalConditions)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(physicalConditions),createdAt);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'DiarySetting(physicalConditions: $physicalConditions, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $DiarySettingCopyWith<$Res>  {
  factory $DiarySettingCopyWith(DiarySetting value, $Res Function(DiarySetting) _then) = _$DiarySettingCopyWithImpl;
@useResult
$Res call({
 List<String> physicalConditions,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime createdAt
});




}
/// @nodoc
class _$DiarySettingCopyWithImpl<$Res>
    implements $DiarySettingCopyWith<$Res> {
  _$DiarySettingCopyWithImpl(this._self, this._then);

  final DiarySetting _self;
  final $Res Function(DiarySetting) _then;

/// Create a copy of DiarySetting
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? physicalConditions = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
physicalConditions: null == physicalConditions ? _self.physicalConditions : physicalConditions // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DiarySetting].
extension DiarySettingPatterns on DiarySetting {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiarySetting value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiarySetting() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiarySetting value)  $default,){
final _that = this;
switch (_that) {
case _DiarySetting():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiarySetting value)?  $default,){
final _that = this;
switch (_that) {
case _DiarySetting() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> physicalConditions, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiarySetting() when $default != null:
return $default(_that.physicalConditions,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> physicalConditions, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _DiarySetting():
return $default(_that.physicalConditions,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> physicalConditions, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _DiarySetting() when $default != null:
return $default(_that.physicalConditions,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _DiarySetting extends DiarySetting with DiagnosticableTreeMixin {
  const _DiarySetting({final  List<String> physicalConditions = defaultPhysicalConditions, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.createdAt}): _physicalConditions = physicalConditions,super._();
  factory _DiarySetting.fromJson(Map<String, dynamic> json) => _$DiarySettingFromJson(json);

/// 日記機能で選択可能な体調項目のリスト
/// デフォルトでは事前定義された14種類の体調項目が設定される
/// ユーザーによる項目のカスタマイズが可能
 final  List<String> _physicalConditions;
/// 日記機能で選択可能な体調項目のリスト
/// デフォルトでは事前定義された14種類の体調項目が設定される
/// ユーザーによる項目のカスタマイズが可能
@override@JsonKey() List<String> get physicalConditions {
  if (_physicalConditions is EqualUnmodifiableListView) return _physicalConditions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_physicalConditions);
}

/// 設定が作成された日時
/// Firestoreのタイムスタンプ形式で保存され、読み書き時に自動変換される
@override@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) final  DateTime createdAt;

/// Create a copy of DiarySetting
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiarySettingCopyWith<_DiarySetting> get copyWith => __$DiarySettingCopyWithImpl<_DiarySetting>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiarySettingToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'DiarySetting'))
    ..add(DiagnosticsProperty('physicalConditions', physicalConditions))..add(DiagnosticsProperty('createdAt', createdAt));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiarySetting&&const DeepCollectionEquality().equals(other._physicalConditions, _physicalConditions)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_physicalConditions),createdAt);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'DiarySetting(physicalConditions: $physicalConditions, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$DiarySettingCopyWith<$Res> implements $DiarySettingCopyWith<$Res> {
  factory _$DiarySettingCopyWith(_DiarySetting value, $Res Function(_DiarySetting) _then) = __$DiarySettingCopyWithImpl;
@override @useResult
$Res call({
 List<String> physicalConditions,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime createdAt
});




}
/// @nodoc
class __$DiarySettingCopyWithImpl<$Res>
    implements _$DiarySettingCopyWith<$Res> {
  __$DiarySettingCopyWithImpl(this._self, this._then);

  final _DiarySetting _self;
  final $Res Function(_DiarySetting) _then;

/// Create a copy of DiarySetting
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? physicalConditions = null,Object? createdAt = null,}) {
  return _then(_DiarySetting(
physicalConditions: null == physicalConditions ? _self._physicalConditions : physicalConditions // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
