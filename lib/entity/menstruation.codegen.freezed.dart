// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'menstruation.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Menstruation {

/// FirestoreドキュメントのID
/// 新規作成時はnullで、保存時に自動生成される
@JsonKey(includeIfNull: false) String? get id;/// 生理開始日
/// 生理周期計算の基準となる重要な日付
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime get beginDate;/// 生理終了日
/// 生理期間の長さを決定する日付
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime get endDate;/// 論理削除日時
/// nullの場合は有効な記録、値がある場合は削除済み
@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? get deletedAt;/// 生理記録の作成日時
/// データの作成順序や履歴管理に使用される
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime get createdAt;/// HealthKitサンプルデータのUUID
/// HealthKitから取得したデータとの紐付けに使用
 String? get healthKitSampleDataUUID;
/// Create a copy of Menstruation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MenstruationCopyWith<Menstruation> get copyWith => _$MenstruationCopyWithImpl<Menstruation>(this as Menstruation, _$identity);

  /// Serializes this Menstruation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Menstruation&&(identical(other.id, id) || other.id == id)&&(identical(other.beginDate, beginDate) || other.beginDate == beginDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.healthKitSampleDataUUID, healthKitSampleDataUUID) || other.healthKitSampleDataUUID == healthKitSampleDataUUID));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,beginDate,endDate,deletedAt,createdAt,healthKitSampleDataUUID);

@override
String toString() {
  return 'Menstruation(id: $id, beginDate: $beginDate, endDate: $endDate, deletedAt: $deletedAt, createdAt: $createdAt, healthKitSampleDataUUID: $healthKitSampleDataUUID)';
}


}

/// @nodoc
abstract mixin class $MenstruationCopyWith<$Res>  {
  factory $MenstruationCopyWith(Menstruation value, $Res Function(Menstruation) _then) = _$MenstruationCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeIfNull: false) String? id,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime beginDate,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime endDate,@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? deletedAt,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime createdAt, String? healthKitSampleDataUUID
});




}
/// @nodoc
class _$MenstruationCopyWithImpl<$Res>
    implements $MenstruationCopyWith<$Res> {
  _$MenstruationCopyWithImpl(this._self, this._then);

  final Menstruation _self;
  final $Res Function(Menstruation) _then;

/// Create a copy of Menstruation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? beginDate = null,Object? endDate = null,Object? deletedAt = freezed,Object? createdAt = null,Object? healthKitSampleDataUUID = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,beginDate: null == beginDate ? _self.beginDate : beginDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,healthKitSampleDataUUID: freezed == healthKitSampleDataUUID ? _self.healthKitSampleDataUUID : healthKitSampleDataUUID // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Menstruation].
extension MenstruationPatterns on Menstruation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Menstruation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Menstruation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Menstruation value)  $default,){
final _that = this;
switch (_that) {
case _Menstruation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Menstruation value)?  $default,){
final _that = this;
switch (_that) {
case _Menstruation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  String? id, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime beginDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime endDate, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? deletedAt, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime createdAt,  String? healthKitSampleDataUUID)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Menstruation() when $default != null:
return $default(_that.id,_that.beginDate,_that.endDate,_that.deletedAt,_that.createdAt,_that.healthKitSampleDataUUID);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  String? id, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime beginDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime endDate, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? deletedAt, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime createdAt,  String? healthKitSampleDataUUID)  $default,) {final _that = this;
switch (_that) {
case _Menstruation():
return $default(_that.id,_that.beginDate,_that.endDate,_that.deletedAt,_that.createdAt,_that.healthKitSampleDataUUID);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeIfNull: false)  String? id, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime beginDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime endDate, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? deletedAt, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime createdAt,  String? healthKitSampleDataUUID)?  $default,) {final _that = this;
switch (_that) {
case _Menstruation() when $default != null:
return $default(_that.id,_that.beginDate,_that.endDate,_that.deletedAt,_that.createdAt,_that.healthKitSampleDataUUID);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Menstruation extends Menstruation {
  const _Menstruation({@JsonKey(includeIfNull: false) this.id, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.beginDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.endDate, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) this.deletedAt, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.createdAt, this.healthKitSampleDataUUID}): super._();
  factory _Menstruation.fromJson(Map<String, dynamic> json) => _$MenstruationFromJson(json);

/// FirestoreドキュメントのID
/// 新規作成時はnullで、保存時に自動生成される
@override@JsonKey(includeIfNull: false) final  String? id;
/// 生理開始日
/// 生理周期計算の基準となる重要な日付
@override@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) final  DateTime beginDate;
/// 生理終了日
/// 生理期間の長さを決定する日付
@override@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) final  DateTime endDate;
/// 論理削除日時
/// nullの場合は有効な記録、値がある場合は削除済み
@override@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) final  DateTime? deletedAt;
/// 生理記録の作成日時
/// データの作成順序や履歴管理に使用される
@override@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) final  DateTime createdAt;
/// HealthKitサンプルデータのUUID
/// HealthKitから取得したデータとの紐付けに使用
@override final  String? healthKitSampleDataUUID;

/// Create a copy of Menstruation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MenstruationCopyWith<_Menstruation> get copyWith => __$MenstruationCopyWithImpl<_Menstruation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MenstruationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Menstruation&&(identical(other.id, id) || other.id == id)&&(identical(other.beginDate, beginDate) || other.beginDate == beginDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.healthKitSampleDataUUID, healthKitSampleDataUUID) || other.healthKitSampleDataUUID == healthKitSampleDataUUID));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,beginDate,endDate,deletedAt,createdAt,healthKitSampleDataUUID);

@override
String toString() {
  return 'Menstruation(id: $id, beginDate: $beginDate, endDate: $endDate, deletedAt: $deletedAt, createdAt: $createdAt, healthKitSampleDataUUID: $healthKitSampleDataUUID)';
}


}

/// @nodoc
abstract mixin class _$MenstruationCopyWith<$Res> implements $MenstruationCopyWith<$Res> {
  factory _$MenstruationCopyWith(_Menstruation value, $Res Function(_Menstruation) _then) = __$MenstruationCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeIfNull: false) String? id,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime beginDate,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime endDate,@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? deletedAt,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime createdAt, String? healthKitSampleDataUUID
});




}
/// @nodoc
class __$MenstruationCopyWithImpl<$Res>
    implements _$MenstruationCopyWith<$Res> {
  __$MenstruationCopyWithImpl(this._self, this._then);

  final _Menstruation _self;
  final $Res Function(_Menstruation) _then;

/// Create a copy of Menstruation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? beginDate = null,Object? endDate = null,Object? deletedAt = freezed,Object? createdAt = null,Object? healthKitSampleDataUUID = freezed,}) {
  return _then(_Menstruation(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,beginDate: null == beginDate ? _self.beginDate : beginDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,healthKitSampleDataUUID: freezed == healthKitSampleDataUUID ? _self.healthKitSampleDataUUID : healthKitSampleDataUUID // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
