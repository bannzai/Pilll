// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pill_sheet.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PillSheetTypeInfo {

/// ピルシート種類の参照パス（Firestore参照）
/// 具体的なピルシート設定情報への参照を保持
 String get pillSheetTypeReferencePath;/// ピルシート名（例：「マーベロン28」）
/// ユーザーに表示される商品名
 String get name;/// ピルシート内の総ピル数
/// 21錠、28錠など、シートに含まれる全てのピル数
 int get totalCount;/// 服用期間（実薬期間）の日数
/// 偽薬を除いた実際に効果のあるピルの服用日数
 int get dosingPeriod;
/// Create a copy of PillSheetTypeInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PillSheetTypeInfoCopyWith<PillSheetTypeInfo> get copyWith => _$PillSheetTypeInfoCopyWithImpl<PillSheetTypeInfo>(this as PillSheetTypeInfo, _$identity);

  /// Serializes this PillSheetTypeInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PillSheetTypeInfo&&(identical(other.pillSheetTypeReferencePath, pillSheetTypeReferencePath) || other.pillSheetTypeReferencePath == pillSheetTypeReferencePath)&&(identical(other.name, name) || other.name == name)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.dosingPeriod, dosingPeriod) || other.dosingPeriod == dosingPeriod));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pillSheetTypeReferencePath,name,totalCount,dosingPeriod);

@override
String toString() {
  return 'PillSheetTypeInfo(pillSheetTypeReferencePath: $pillSheetTypeReferencePath, name: $name, totalCount: $totalCount, dosingPeriod: $dosingPeriod)';
}


}

/// @nodoc
abstract mixin class $PillSheetTypeInfoCopyWith<$Res>  {
  factory $PillSheetTypeInfoCopyWith(PillSheetTypeInfo value, $Res Function(PillSheetTypeInfo) _then) = _$PillSheetTypeInfoCopyWithImpl;
@useResult
$Res call({
 String pillSheetTypeReferencePath, String name, int totalCount, int dosingPeriod
});




}
/// @nodoc
class _$PillSheetTypeInfoCopyWithImpl<$Res>
    implements $PillSheetTypeInfoCopyWith<$Res> {
  _$PillSheetTypeInfoCopyWithImpl(this._self, this._then);

  final PillSheetTypeInfo _self;
  final $Res Function(PillSheetTypeInfo) _then;

/// Create a copy of PillSheetTypeInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pillSheetTypeReferencePath = null,Object? name = null,Object? totalCount = null,Object? dosingPeriod = null,}) {
  return _then(_self.copyWith(
pillSheetTypeReferencePath: null == pillSheetTypeReferencePath ? _self.pillSheetTypeReferencePath : pillSheetTypeReferencePath // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,dosingPeriod: null == dosingPeriod ? _self.dosingPeriod : dosingPeriod // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PillSheetTypeInfo].
extension PillSheetTypeInfoPatterns on PillSheetTypeInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PillSheetTypeInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PillSheetTypeInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PillSheetTypeInfo value)  $default,){
final _that = this;
switch (_that) {
case _PillSheetTypeInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PillSheetTypeInfo value)?  $default,){
final _that = this;
switch (_that) {
case _PillSheetTypeInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String pillSheetTypeReferencePath,  String name,  int totalCount,  int dosingPeriod)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PillSheetTypeInfo() when $default != null:
return $default(_that.pillSheetTypeReferencePath,_that.name,_that.totalCount,_that.dosingPeriod);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String pillSheetTypeReferencePath,  String name,  int totalCount,  int dosingPeriod)  $default,) {final _that = this;
switch (_that) {
case _PillSheetTypeInfo():
return $default(_that.pillSheetTypeReferencePath,_that.name,_that.totalCount,_that.dosingPeriod);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String pillSheetTypeReferencePath,  String name,  int totalCount,  int dosingPeriod)?  $default,) {final _that = this;
switch (_that) {
case _PillSheetTypeInfo() when $default != null:
return $default(_that.pillSheetTypeReferencePath,_that.name,_that.totalCount,_that.dosingPeriod);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PillSheetTypeInfo implements PillSheetTypeInfo {
  const _PillSheetTypeInfo({required this.pillSheetTypeReferencePath, required this.name, required this.totalCount, required this.dosingPeriod});
  factory _PillSheetTypeInfo.fromJson(Map<String, dynamic> json) => _$PillSheetTypeInfoFromJson(json);

/// ピルシート種類の参照パス（Firestore参照）
/// 具体的なピルシート設定情報への参照を保持
@override final  String pillSheetTypeReferencePath;
/// ピルシート名（例：「マーベロン28」）
/// ユーザーに表示される商品名
@override final  String name;
/// ピルシート内の総ピル数
/// 21錠、28錠など、シートに含まれる全てのピル数
@override final  int totalCount;
/// 服用期間（実薬期間）の日数
/// 偽薬を除いた実際に効果のあるピルの服用日数
@override final  int dosingPeriod;

/// Create a copy of PillSheetTypeInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PillSheetTypeInfoCopyWith<_PillSheetTypeInfo> get copyWith => __$PillSheetTypeInfoCopyWithImpl<_PillSheetTypeInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PillSheetTypeInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PillSheetTypeInfo&&(identical(other.pillSheetTypeReferencePath, pillSheetTypeReferencePath) || other.pillSheetTypeReferencePath == pillSheetTypeReferencePath)&&(identical(other.name, name) || other.name == name)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.dosingPeriod, dosingPeriod) || other.dosingPeriod == dosingPeriod));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pillSheetTypeReferencePath,name,totalCount,dosingPeriod);

@override
String toString() {
  return 'PillSheetTypeInfo(pillSheetTypeReferencePath: $pillSheetTypeReferencePath, name: $name, totalCount: $totalCount, dosingPeriod: $dosingPeriod)';
}


}

/// @nodoc
abstract mixin class _$PillSheetTypeInfoCopyWith<$Res> implements $PillSheetTypeInfoCopyWith<$Res> {
  factory _$PillSheetTypeInfoCopyWith(_PillSheetTypeInfo value, $Res Function(_PillSheetTypeInfo) _then) = __$PillSheetTypeInfoCopyWithImpl;
@override @useResult
$Res call({
 String pillSheetTypeReferencePath, String name, int totalCount, int dosingPeriod
});




}
/// @nodoc
class __$PillSheetTypeInfoCopyWithImpl<$Res>
    implements _$PillSheetTypeInfoCopyWith<$Res> {
  __$PillSheetTypeInfoCopyWithImpl(this._self, this._then);

  final _PillSheetTypeInfo _self;
  final $Res Function(_PillSheetTypeInfo) _then;

/// Create a copy of PillSheetTypeInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pillSheetTypeReferencePath = null,Object? name = null,Object? totalCount = null,Object? dosingPeriod = null,}) {
  return _then(_PillSheetTypeInfo(
pillSheetTypeReferencePath: null == pillSheetTypeReferencePath ? _self.pillSheetTypeReferencePath : pillSheetTypeReferencePath // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,dosingPeriod: null == dosingPeriod ? _self.dosingPeriod : dosingPeriod // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$RestDuration {

// from: 2024-03-28の実装時に追加。調査しやすいようにuuidを入れておく
/// 休薬期間の一意識別子
/// デバッグや調査時の追跡のためのUUID
 String? get id;@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime get beginDate;@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? get endDate;@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime get createdDate;
/// Create a copy of RestDuration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RestDurationCopyWith<RestDuration> get copyWith => _$RestDurationCopyWithImpl<RestDuration>(this as RestDuration, _$identity);

  /// Serializes this RestDuration to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RestDuration&&(identical(other.id, id) || other.id == id)&&(identical(other.beginDate, beginDate) || other.beginDate == beginDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.createdDate, createdDate) || other.createdDate == createdDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,beginDate,endDate,createdDate);

@override
String toString() {
  return 'RestDuration(id: $id, beginDate: $beginDate, endDate: $endDate, createdDate: $createdDate)';
}


}

/// @nodoc
abstract mixin class $RestDurationCopyWith<$Res>  {
  factory $RestDurationCopyWith(RestDuration value, $Res Function(RestDuration) _then) = _$RestDurationCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime beginDate,@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? endDate,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime createdDate
});




}
/// @nodoc
class _$RestDurationCopyWithImpl<$Res>
    implements $RestDurationCopyWith<$Res> {
  _$RestDurationCopyWithImpl(this._self, this._then);

  final RestDuration _self;
  final $Res Function(RestDuration) _then;

/// Create a copy of RestDuration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? beginDate = null,Object? endDate = freezed,Object? createdDate = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,beginDate: null == beginDate ? _self.beginDate : beginDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdDate: null == createdDate ? _self.createdDate : createdDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RestDuration].
extension RestDurationPatterns on RestDuration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RestDuration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RestDuration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RestDuration value)  $default,){
final _that = this;
switch (_that) {
case _RestDuration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RestDuration value)?  $default,){
final _that = this;
switch (_that) {
case _RestDuration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime beginDate, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? endDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime createdDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RestDuration() when $default != null:
return $default(_that.id,_that.beginDate,_that.endDate,_that.createdDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime beginDate, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? endDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime createdDate)  $default,) {final _that = this;
switch (_that) {
case _RestDuration():
return $default(_that.id,_that.beginDate,_that.endDate,_that.createdDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime beginDate, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? endDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime createdDate)?  $default,) {final _that = this;
switch (_that) {
case _RestDuration() when $default != null:
return $default(_that.id,_that.beginDate,_that.endDate,_that.createdDate);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _RestDuration extends RestDuration {
  const _RestDuration({required this.id, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.beginDate, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) this.endDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.createdDate}): super._();
  factory _RestDuration.fromJson(Map<String, dynamic> json) => _$RestDurationFromJson(json);

// from: 2024-03-28の実装時に追加。調査しやすいようにuuidを入れておく
/// 休薬期間の一意識別子
/// デバッグや調査時の追跡のためのUUID
@override final  String? id;
@override@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) final  DateTime beginDate;
@override@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) final  DateTime? endDate;
@override@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) final  DateTime createdDate;

/// Create a copy of RestDuration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RestDurationCopyWith<_RestDuration> get copyWith => __$RestDurationCopyWithImpl<_RestDuration>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RestDurationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RestDuration&&(identical(other.id, id) || other.id == id)&&(identical(other.beginDate, beginDate) || other.beginDate == beginDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.createdDate, createdDate) || other.createdDate == createdDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,beginDate,endDate,createdDate);

@override
String toString() {
  return 'RestDuration(id: $id, beginDate: $beginDate, endDate: $endDate, createdDate: $createdDate)';
}


}

/// @nodoc
abstract mixin class _$RestDurationCopyWith<$Res> implements $RestDurationCopyWith<$Res> {
  factory _$RestDurationCopyWith(_RestDuration value, $Res Function(_RestDuration) _then) = __$RestDurationCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime beginDate,@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? endDate,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime createdDate
});




}
/// @nodoc
class __$RestDurationCopyWithImpl<$Res>
    implements _$RestDurationCopyWith<$Res> {
  __$RestDurationCopyWithImpl(this._self, this._then);

  final _RestDuration _self;
  final $Res Function(_RestDuration) _then;

/// Create a copy of RestDuration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? beginDate = null,Object? endDate = freezed,Object? createdDate = null,}) {
  return _then(_RestDuration(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,beginDate: null == beginDate ? _self.beginDate : beginDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdDate: null == createdDate ? _self.createdDate : createdDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$PillSheet {

 List<DateTime> get dates;/// FirestoreドキュメントID
/// データベース保存時に自動生成される一意識別子
@JsonKey(includeIfNull: false) String? get id;/// ピルシートの種類情報
/// シート名、総数、服用期間などの基本設定
@JsonKey() PillSheetTypeInfo get typeInfo;@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime get beginingDate;// NOTE: [SyncData:Widget] このプロパティはWidgetに同期されてる
@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? get lastTakenDate;@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? get createdAt;@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? get deletedAt;/// グループインデックス
/// 複数のピルシートをグループ化する際の順序番号
 int get groupIndex;/// 休薬期間のリスト
/// このピルシート期間中の全ての休薬期間記録
 List<RestDuration> get restDurations;
/// Create a copy of PillSheet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PillSheetCopyWith<PillSheet> get copyWith => _$PillSheetCopyWithImpl<PillSheet>(this as PillSheet, _$identity);

  /// Serializes this PillSheet to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PillSheet&&const DeepCollectionEquality().equals(other.dates, dates)&&(identical(other.id, id) || other.id == id)&&(identical(other.typeInfo, typeInfo) || other.typeInfo == typeInfo)&&(identical(other.beginingDate, beginingDate) || other.beginingDate == beginingDate)&&(identical(other.lastTakenDate, lastTakenDate) || other.lastTakenDate == lastTakenDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.groupIndex, groupIndex) || other.groupIndex == groupIndex)&&const DeepCollectionEquality().equals(other.restDurations, restDurations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(dates),id,typeInfo,beginingDate,lastTakenDate,createdAt,deletedAt,groupIndex,const DeepCollectionEquality().hash(restDurations));

@override
String toString() {
  return 'PillSheet(dates: $dates, id: $id, typeInfo: $typeInfo, beginingDate: $beginingDate, lastTakenDate: $lastTakenDate, createdAt: $createdAt, deletedAt: $deletedAt, groupIndex: $groupIndex, restDurations: $restDurations)';
}


}

/// @nodoc
abstract mixin class $PillSheetCopyWith<$Res>  {
  factory $PillSheetCopyWith(PillSheet value, $Res Function(PillSheet) _then) = _$PillSheetCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeIfNull: false) String? id,@JsonKey() PillSheetTypeInfo typeInfo,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime beginingDate,@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? lastTakenDate,@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? createdAt,@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? deletedAt, int groupIndex, List<RestDuration> restDurations
});


$PillSheetTypeInfoCopyWith<$Res> get typeInfo;

}
/// @nodoc
class _$PillSheetCopyWithImpl<$Res>
    implements $PillSheetCopyWith<$Res> {
  _$PillSheetCopyWithImpl(this._self, this._then);

  final PillSheet _self;
  final $Res Function(PillSheet) _then;

/// Create a copy of PillSheet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? typeInfo = null,Object? beginingDate = null,Object? lastTakenDate = freezed,Object? createdAt = freezed,Object? deletedAt = freezed,Object? groupIndex = null,Object? restDurations = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,typeInfo: null == typeInfo ? _self.typeInfo : typeInfo // ignore: cast_nullable_to_non_nullable
as PillSheetTypeInfo,beginingDate: null == beginingDate ? _self.beginingDate : beginingDate // ignore: cast_nullable_to_non_nullable
as DateTime,lastTakenDate: freezed == lastTakenDate ? _self.lastTakenDate : lastTakenDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,groupIndex: null == groupIndex ? _self.groupIndex : groupIndex // ignore: cast_nullable_to_non_nullable
as int,restDurations: null == restDurations ? _self.restDurations : restDurations // ignore: cast_nullable_to_non_nullable
as List<RestDuration>,
  ));
}
/// Create a copy of PillSheet
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PillSheetTypeInfoCopyWith<$Res> get typeInfo {
  
  return $PillSheetTypeInfoCopyWith<$Res>(_self.typeInfo, (value) {
    return _then(_self.copyWith(typeInfo: value));
  });
}
}


/// Adds pattern-matching-related methods to [PillSheet].
extension PillSheetPatterns on PillSheet {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PillSheet value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PillSheet() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PillSheet value)  $default,){
final _that = this;
switch (_that) {
case _PillSheet():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PillSheet value)?  $default,){
final _that = this;
switch (_that) {
case _PillSheet() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  String? id, @JsonKey()  PillSheetTypeInfo typeInfo, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime beginingDate, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? lastTakenDate, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? createdAt, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? deletedAt,  int groupIndex,  List<RestDuration> restDurations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PillSheet() when $default != null:
return $default(_that.id,_that.typeInfo,_that.beginingDate,_that.lastTakenDate,_that.createdAt,_that.deletedAt,_that.groupIndex,_that.restDurations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  String? id, @JsonKey()  PillSheetTypeInfo typeInfo, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime beginingDate, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? lastTakenDate, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? createdAt, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? deletedAt,  int groupIndex,  List<RestDuration> restDurations)  $default,) {final _that = this;
switch (_that) {
case _PillSheet():
return $default(_that.id,_that.typeInfo,_that.beginingDate,_that.lastTakenDate,_that.createdAt,_that.deletedAt,_that.groupIndex,_that.restDurations);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeIfNull: false)  String? id, @JsonKey()  PillSheetTypeInfo typeInfo, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime beginingDate, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? lastTakenDate, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? createdAt, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? deletedAt,  int groupIndex,  List<RestDuration> restDurations)?  $default,) {final _that = this;
switch (_that) {
case _PillSheet() when $default != null:
return $default(_that.id,_that.typeInfo,_that.beginingDate,_that.lastTakenDate,_that.createdAt,_that.deletedAt,_that.groupIndex,_that.restDurations);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PillSheet extends PillSheet {
   _PillSheet({@JsonKey(includeIfNull: false) required this.id, @JsonKey() required this.typeInfo, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.beginingDate, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) required this.lastTakenDate, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) required this.createdAt, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) this.deletedAt, this.groupIndex = 0, final  List<RestDuration> restDurations = const []}): _restDurations = restDurations,super._();
  factory _PillSheet.fromJson(Map<String, dynamic> json) => _$PillSheetFromJson(json);

/// FirestoreドキュメントID
/// データベース保存時に自動生成される一意識別子
@override@JsonKey(includeIfNull: false) final  String? id;
/// ピルシートの種類情報
/// シート名、総数、服用期間などの基本設定
@override@JsonKey() final  PillSheetTypeInfo typeInfo;
@override@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) final  DateTime beginingDate;
// NOTE: [SyncData:Widget] このプロパティはWidgetに同期されてる
@override@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) final  DateTime? lastTakenDate;
@override@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) final  DateTime? createdAt;
@override@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) final  DateTime? deletedAt;
/// グループインデックス
/// 複数のピルシートをグループ化する際の順序番号
@override@JsonKey() final  int groupIndex;
/// 休薬期間のリスト
/// このピルシート期間中の全ての休薬期間記録
 final  List<RestDuration> _restDurations;
/// 休薬期間のリスト
/// このピルシート期間中の全ての休薬期間記録
@override@JsonKey() List<RestDuration> get restDurations {
  if (_restDurations is EqualUnmodifiableListView) return _restDurations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_restDurations);
}


/// Create a copy of PillSheet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PillSheetCopyWith<_PillSheet> get copyWith => __$PillSheetCopyWithImpl<_PillSheet>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PillSheetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PillSheet&&(identical(other.id, id) || other.id == id)&&(identical(other.typeInfo, typeInfo) || other.typeInfo == typeInfo)&&(identical(other.beginingDate, beginingDate) || other.beginingDate == beginingDate)&&(identical(other.lastTakenDate, lastTakenDate) || other.lastTakenDate == lastTakenDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.groupIndex, groupIndex) || other.groupIndex == groupIndex)&&const DeepCollectionEquality().equals(other._restDurations, _restDurations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,typeInfo,beginingDate,lastTakenDate,createdAt,deletedAt,groupIndex,const DeepCollectionEquality().hash(_restDurations));

@override
String toString() {
  return 'PillSheet(id: $id, typeInfo: $typeInfo, beginingDate: $beginingDate, lastTakenDate: $lastTakenDate, createdAt: $createdAt, deletedAt: $deletedAt, groupIndex: $groupIndex, restDurations: $restDurations)';
}


}

/// @nodoc
abstract mixin class _$PillSheetCopyWith<$Res> implements $PillSheetCopyWith<$Res> {
  factory _$PillSheetCopyWith(_PillSheet value, $Res Function(_PillSheet) _then) = __$PillSheetCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeIfNull: false) String? id,@JsonKey() PillSheetTypeInfo typeInfo,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime beginingDate,@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? lastTakenDate,@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? createdAt,@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? deletedAt, int groupIndex, List<RestDuration> restDurations
});


@override $PillSheetTypeInfoCopyWith<$Res> get typeInfo;

}
/// @nodoc
class __$PillSheetCopyWithImpl<$Res>
    implements _$PillSheetCopyWith<$Res> {
  __$PillSheetCopyWithImpl(this._self, this._then);

  final _PillSheet _self;
  final $Res Function(_PillSheet) _then;

/// Create a copy of PillSheet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? typeInfo = null,Object? beginingDate = null,Object? lastTakenDate = freezed,Object? createdAt = freezed,Object? deletedAt = freezed,Object? groupIndex = null,Object? restDurations = null,}) {
  return _then(_PillSheet(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,typeInfo: null == typeInfo ? _self.typeInfo : typeInfo // ignore: cast_nullable_to_non_nullable
as PillSheetTypeInfo,beginingDate: null == beginingDate ? _self.beginingDate : beginingDate // ignore: cast_nullable_to_non_nullable
as DateTime,lastTakenDate: freezed == lastTakenDate ? _self.lastTakenDate : lastTakenDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,groupIndex: null == groupIndex ? _self.groupIndex : groupIndex // ignore: cast_nullable_to_non_nullable
as int,restDurations: null == restDurations ? _self._restDurations : restDurations // ignore: cast_nullable_to_non_nullable
as List<RestDuration>,
  ));
}

/// Create a copy of PillSheet
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PillSheetTypeInfoCopyWith<$Res> get typeInfo {
  
  return $PillSheetTypeInfoCopyWith<$Res>(_self.typeInfo, (value) {
    return _then(_self.copyWith(typeInfo: value));
  });
}
}

// dart format on
