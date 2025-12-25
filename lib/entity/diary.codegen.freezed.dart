// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diary.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Diary {

/// 日記の対象日付
///
/// 日記エントリが作成された日付を表す
/// Firestoreとの変換時にTimestampConverterを使用
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime get date;/// 日記の作成日時
///
/// 日記が実際に作成された日時を記録
/// 古いデータでは存在しない可能性があるためnullable
// NOTE: OLD data does't have createdAt
@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? get createdAt;/// 体調状態の総合評価
///
/// fine（良好）またはbad（不調）の2段階評価
/// 未選択の場合はnull
 PhysicalConditionStatus? get physicalConditionStatus;/// 詳細な体調状態のリスト
///
/// ユーザーが選択した具体的な体調症状を文字列で保存
/// 空のリストも許可される
 List<String> get physicalConditions;/// 性行為の有無
///
/// 妊娠リスクの管理のために記録される
/// trueの場合は性行為あり、falseの場合はなし
 bool get hasSex;/// 自由記述のメモ
///
/// ユーザーが自由にテキストを入力できるフィールド
/// 空文字列も許可される
 String get memo;
/// Create a copy of Diary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiaryCopyWith<Diary> get copyWith => _$DiaryCopyWithImpl<Diary>(this as Diary, _$identity);

  /// Serializes this Diary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Diary&&(identical(other.date, date) || other.date == date)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.physicalConditionStatus, physicalConditionStatus) || other.physicalConditionStatus == physicalConditionStatus)&&const DeepCollectionEquality().equals(other.physicalConditions, physicalConditions)&&(identical(other.hasSex, hasSex) || other.hasSex == hasSex)&&(identical(other.memo, memo) || other.memo == memo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,createdAt,physicalConditionStatus,const DeepCollectionEquality().hash(physicalConditions),hasSex,memo);

@override
String toString() {
  return 'Diary(date: $date, createdAt: $createdAt, physicalConditionStatus: $physicalConditionStatus, physicalConditions: $physicalConditions, hasSex: $hasSex, memo: $memo)';
}


}

/// @nodoc
abstract mixin class $DiaryCopyWith<$Res>  {
  factory $DiaryCopyWith(Diary value, $Res Function(Diary) _then) = _$DiaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime date,@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? createdAt, PhysicalConditionStatus? physicalConditionStatus, List<String> physicalConditions, bool hasSex, String memo
});




}
/// @nodoc
class _$DiaryCopyWithImpl<$Res>
    implements $DiaryCopyWith<$Res> {
  _$DiaryCopyWithImpl(this._self, this._then);

  final Diary _self;
  final $Res Function(Diary) _then;

/// Create a copy of Diary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? createdAt = freezed,Object? physicalConditionStatus = freezed,Object? physicalConditions = null,Object? hasSex = null,Object? memo = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,physicalConditionStatus: freezed == physicalConditionStatus ? _self.physicalConditionStatus : physicalConditionStatus // ignore: cast_nullable_to_non_nullable
as PhysicalConditionStatus?,physicalConditions: null == physicalConditions ? _self.physicalConditions : physicalConditions // ignore: cast_nullable_to_non_nullable
as List<String>,hasSex: null == hasSex ? _self.hasSex : hasSex // ignore: cast_nullable_to_non_nullable
as bool,memo: null == memo ? _self.memo : memo // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Diary].
extension DiaryPatterns on Diary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Diary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Diary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Diary value)  $default,){
final _that = this;
switch (_that) {
case _Diary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Diary value)?  $default,){
final _that = this;
switch (_that) {
case _Diary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime date, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? createdAt,  PhysicalConditionStatus? physicalConditionStatus,  List<String> physicalConditions,  bool hasSex,  String memo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Diary() when $default != null:
return $default(_that.date,_that.createdAt,_that.physicalConditionStatus,_that.physicalConditions,_that.hasSex,_that.memo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime date, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? createdAt,  PhysicalConditionStatus? physicalConditionStatus,  List<String> physicalConditions,  bool hasSex,  String memo)  $default,) {final _that = this;
switch (_that) {
case _Diary():
return $default(_that.date,_that.createdAt,_that.physicalConditionStatus,_that.physicalConditions,_that.hasSex,_that.memo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime date, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? createdAt,  PhysicalConditionStatus? physicalConditionStatus,  List<String> physicalConditions,  bool hasSex,  String memo)?  $default,) {final _that = this;
switch (_that) {
case _Diary() when $default != null:
return $default(_that.date,_that.createdAt,_that.physicalConditionStatus,_that.physicalConditions,_that.hasSex,_that.memo);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Diary extends Diary {
  const _Diary({@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.date, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) required this.createdAt, this.physicalConditionStatus, required final  List<String> physicalConditions, required this.hasSex, required this.memo}): _physicalConditions = physicalConditions,super._();
  factory _Diary.fromJson(Map<String, dynamic> json) => _$DiaryFromJson(json);

/// 日記の対象日付
///
/// 日記エントリが作成された日付を表す
/// Firestoreとの変換時にTimestampConverterを使用
@override@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) final  DateTime date;
/// 日記の作成日時
///
/// 日記が実際に作成された日時を記録
/// 古いデータでは存在しない可能性があるためnullable
// NOTE: OLD data does't have createdAt
@override@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) final  DateTime? createdAt;
/// 体調状態の総合評価
///
/// fine（良好）またはbad（不調）の2段階評価
/// 未選択の場合はnull
@override final  PhysicalConditionStatus? physicalConditionStatus;
/// 詳細な体調状態のリスト
///
/// ユーザーが選択した具体的な体調症状を文字列で保存
/// 空のリストも許可される
 final  List<String> _physicalConditions;
/// 詳細な体調状態のリスト
///
/// ユーザーが選択した具体的な体調症状を文字列で保存
/// 空のリストも許可される
@override List<String> get physicalConditions {
  if (_physicalConditions is EqualUnmodifiableListView) return _physicalConditions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_physicalConditions);
}

/// 性行為の有無
///
/// 妊娠リスクの管理のために記録される
/// trueの場合は性行為あり、falseの場合はなし
@override final  bool hasSex;
/// 自由記述のメモ
///
/// ユーザーが自由にテキストを入力できるフィールド
/// 空文字列も許可される
@override final  String memo;

/// Create a copy of Diary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiaryCopyWith<_Diary> get copyWith => __$DiaryCopyWithImpl<_Diary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Diary&&(identical(other.date, date) || other.date == date)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.physicalConditionStatus, physicalConditionStatus) || other.physicalConditionStatus == physicalConditionStatus)&&const DeepCollectionEquality().equals(other._physicalConditions, _physicalConditions)&&(identical(other.hasSex, hasSex) || other.hasSex == hasSex)&&(identical(other.memo, memo) || other.memo == memo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,createdAt,physicalConditionStatus,const DeepCollectionEquality().hash(_physicalConditions),hasSex,memo);

@override
String toString() {
  return 'Diary(date: $date, createdAt: $createdAt, physicalConditionStatus: $physicalConditionStatus, physicalConditions: $physicalConditions, hasSex: $hasSex, memo: $memo)';
}


}

/// @nodoc
abstract mixin class _$DiaryCopyWith<$Res> implements $DiaryCopyWith<$Res> {
  factory _$DiaryCopyWith(_Diary value, $Res Function(_Diary) _then) = __$DiaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime date,@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? createdAt, PhysicalConditionStatus? physicalConditionStatus, List<String> physicalConditions, bool hasSex, String memo
});




}
/// @nodoc
class __$DiaryCopyWithImpl<$Res>
    implements _$DiaryCopyWith<$Res> {
  __$DiaryCopyWithImpl(this._self, this._then);

  final _Diary _self;
  final $Res Function(_Diary) _then;

/// Create a copy of Diary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? createdAt = freezed,Object? physicalConditionStatus = freezed,Object? physicalConditions = null,Object? hasSex = null,Object? memo = null,}) {
  return _then(_Diary(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,physicalConditionStatus: freezed == physicalConditionStatus ? _self.physicalConditionStatus : physicalConditionStatus // ignore: cast_nullable_to_non_nullable
as PhysicalConditionStatus?,physicalConditions: null == physicalConditions ? _self._physicalConditions : physicalConditions // ignore: cast_nullable_to_non_nullable
as List<String>,hasSex: null == hasSex ? _self.hasSex : hasSex // ignore: cast_nullable_to_non_nullable
as bool,memo: null == memo ? _self.memo : memo // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
