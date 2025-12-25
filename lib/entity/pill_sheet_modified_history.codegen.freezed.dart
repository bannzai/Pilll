// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pill_sheet_modified_history.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PillSheetModifiedHistory {

// Added since 2023-08-01
 dynamic get version;// ============ BEGIN: Added since v1 ============
@JsonKey(includeIfNull: false) String? get id; String get actionType;@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime get estimatedEventCausingDate;@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime get createdAt;// ============ END: Added since v1 ============
// ============ BEGIN: Added since v2 ============
// beforePillSheetGroup and afterPillSheetGroup is nullable
// Because, actions for createdPillSheet and deletedPillSheet are not exists target single pill sheet
 PillSheetGroup? get beforePillSheetGroup; PillSheetGroup? get afterPillSheetGroup;@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? get ttlExpiresDateTime;// TODO: [Archive-PillSheetModifiedHistory]: 2024-04以降に対応
// 古いPillSheetModifiedHistoryのisArchivedにインデックスが貼られないため、TTLの期間内のデータが残っている間はこのフィールドが使えない
// null含めて値を入れないとクエリの条件に合致しないので、2024-04まではarchivedDateTime,isArchivedのデータが必ず存在するPillSheetModifiedHistoryの準備機関とする
// バッチを書いても良いが件数が多いのでこの方法をとっている
@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? get archivedDateTime;// archivedDateTime isNull: false の条件だと、下記のエラーの条件に引っ掛かるため、archivedDateTime以外にもisArchivedを用意している。isArchived == true | isArchived == false の用途で使う
// You can combine constraints with a logical AND by chaining multiple equality operators (== or array-contains). However, you must create a composite index to combine equality operators with the inequality operators, <, <=, >, and !=.
 bool get isArchived;// ============ END: Added since v2 ============
// The below properties are deprecated and added since v1.
// This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
// Instead of calculating from beforePillSheetGroup and afterPillSheetGroup
 PillSheetModifiedHistoryValue get value;// This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
// Instead of beforePillSheetID and afterPillSheetID
 String? get pillSheetID;// This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
// There are new properties for pill_sheet grouping. So it's all optional
 String? get pillSheetGroupID; String? get beforePillSheetID; String? get afterPillSheetID;// This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
// Instead of beforePillSheetGroup and afterPillSheetGroup
// before and after is nullable
// Because, actions for createdPillSheet and deletedPillSheet are not exists target single pill sheet
 PillSheet? get before; PillSheet? get after;
/// Create a copy of PillSheetModifiedHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PillSheetModifiedHistoryCopyWith<PillSheetModifiedHistory> get copyWith => _$PillSheetModifiedHistoryCopyWithImpl<PillSheetModifiedHistory>(this as PillSheetModifiedHistory, _$identity);

  /// Serializes this PillSheetModifiedHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PillSheetModifiedHistory&&const DeepCollectionEquality().equals(other.version, version)&&(identical(other.id, id) || other.id == id)&&(identical(other.actionType, actionType) || other.actionType == actionType)&&(identical(other.estimatedEventCausingDate, estimatedEventCausingDate) || other.estimatedEventCausingDate == estimatedEventCausingDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.beforePillSheetGroup, beforePillSheetGroup) || other.beforePillSheetGroup == beforePillSheetGroup)&&(identical(other.afterPillSheetGroup, afterPillSheetGroup) || other.afterPillSheetGroup == afterPillSheetGroup)&&(identical(other.ttlExpiresDateTime, ttlExpiresDateTime) || other.ttlExpiresDateTime == ttlExpiresDateTime)&&(identical(other.archivedDateTime, archivedDateTime) || other.archivedDateTime == archivedDateTime)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&(identical(other.value, value) || other.value == value)&&(identical(other.pillSheetID, pillSheetID) || other.pillSheetID == pillSheetID)&&(identical(other.pillSheetGroupID, pillSheetGroupID) || other.pillSheetGroupID == pillSheetGroupID)&&(identical(other.beforePillSheetID, beforePillSheetID) || other.beforePillSheetID == beforePillSheetID)&&(identical(other.afterPillSheetID, afterPillSheetID) || other.afterPillSheetID == afterPillSheetID)&&(identical(other.before, before) || other.before == before)&&(identical(other.after, after) || other.after == after));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(version),id,actionType,estimatedEventCausingDate,createdAt,beforePillSheetGroup,afterPillSheetGroup,ttlExpiresDateTime,archivedDateTime,isArchived,value,pillSheetID,pillSheetGroupID,beforePillSheetID,afterPillSheetID,before,after);

@override
String toString() {
  return 'PillSheetModifiedHistory(version: $version, id: $id, actionType: $actionType, estimatedEventCausingDate: $estimatedEventCausingDate, createdAt: $createdAt, beforePillSheetGroup: $beforePillSheetGroup, afterPillSheetGroup: $afterPillSheetGroup, ttlExpiresDateTime: $ttlExpiresDateTime, archivedDateTime: $archivedDateTime, isArchived: $isArchived, value: $value, pillSheetID: $pillSheetID, pillSheetGroupID: $pillSheetGroupID, beforePillSheetID: $beforePillSheetID, afterPillSheetID: $afterPillSheetID, before: $before, after: $after)';
}


}

/// @nodoc
abstract mixin class $PillSheetModifiedHistoryCopyWith<$Res>  {
  factory $PillSheetModifiedHistoryCopyWith(PillSheetModifiedHistory value, $Res Function(PillSheetModifiedHistory) _then) = _$PillSheetModifiedHistoryCopyWithImpl;
@useResult
$Res call({
 dynamic version,@JsonKey(includeIfNull: false) String? id, String actionType,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime estimatedEventCausingDate,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime createdAt, PillSheetGroup? beforePillSheetGroup, PillSheetGroup? afterPillSheetGroup,@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? ttlExpiresDateTime,@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? archivedDateTime, bool isArchived, PillSheetModifiedHistoryValue value, String? pillSheetID, String? pillSheetGroupID, String? beforePillSheetID, String? afterPillSheetID, PillSheet? before, PillSheet? after
});


$PillSheetGroupCopyWith<$Res>? get beforePillSheetGroup;$PillSheetGroupCopyWith<$Res>? get afterPillSheetGroup;$PillSheetModifiedHistoryValueCopyWith<$Res> get value;$PillSheetCopyWith<$Res>? get before;$PillSheetCopyWith<$Res>? get after;

}
/// @nodoc
class _$PillSheetModifiedHistoryCopyWithImpl<$Res>
    implements $PillSheetModifiedHistoryCopyWith<$Res> {
  _$PillSheetModifiedHistoryCopyWithImpl(this._self, this._then);

  final PillSheetModifiedHistory _self;
  final $Res Function(PillSheetModifiedHistory) _then;

/// Create a copy of PillSheetModifiedHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = freezed,Object? id = freezed,Object? actionType = null,Object? estimatedEventCausingDate = null,Object? createdAt = null,Object? beforePillSheetGroup = freezed,Object? afterPillSheetGroup = freezed,Object? ttlExpiresDateTime = freezed,Object? archivedDateTime = freezed,Object? isArchived = null,Object? value = null,Object? pillSheetID = freezed,Object? pillSheetGroupID = freezed,Object? beforePillSheetID = freezed,Object? afterPillSheetID = freezed,Object? before = freezed,Object? after = freezed,}) {
  return _then(_self.copyWith(
version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as dynamic,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,actionType: null == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as String,estimatedEventCausingDate: null == estimatedEventCausingDate ? _self.estimatedEventCausingDate : estimatedEventCausingDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,beforePillSheetGroup: freezed == beforePillSheetGroup ? _self.beforePillSheetGroup : beforePillSheetGroup // ignore: cast_nullable_to_non_nullable
as PillSheetGroup?,afterPillSheetGroup: freezed == afterPillSheetGroup ? _self.afterPillSheetGroup : afterPillSheetGroup // ignore: cast_nullable_to_non_nullable
as PillSheetGroup?,ttlExpiresDateTime: freezed == ttlExpiresDateTime ? _self.ttlExpiresDateTime : ttlExpiresDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,archivedDateTime: freezed == archivedDateTime ? _self.archivedDateTime : archivedDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as PillSheetModifiedHistoryValue,pillSheetID: freezed == pillSheetID ? _self.pillSheetID : pillSheetID // ignore: cast_nullable_to_non_nullable
as String?,pillSheetGroupID: freezed == pillSheetGroupID ? _self.pillSheetGroupID : pillSheetGroupID // ignore: cast_nullable_to_non_nullable
as String?,beforePillSheetID: freezed == beforePillSheetID ? _self.beforePillSheetID : beforePillSheetID // ignore: cast_nullable_to_non_nullable
as String?,afterPillSheetID: freezed == afterPillSheetID ? _self.afterPillSheetID : afterPillSheetID // ignore: cast_nullable_to_non_nullable
as String?,before: freezed == before ? _self.before : before // ignore: cast_nullable_to_non_nullable
as PillSheet?,after: freezed == after ? _self.after : after // ignore: cast_nullable_to_non_nullable
as PillSheet?,
  ));
}
/// Create a copy of PillSheetModifiedHistory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PillSheetGroupCopyWith<$Res>? get beforePillSheetGroup {
    if (_self.beforePillSheetGroup == null) {
    return null;
  }

  return $PillSheetGroupCopyWith<$Res>(_self.beforePillSheetGroup!, (value) {
    return _then(_self.copyWith(beforePillSheetGroup: value));
  });
}/// Create a copy of PillSheetModifiedHistory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PillSheetGroupCopyWith<$Res>? get afterPillSheetGroup {
    if (_self.afterPillSheetGroup == null) {
    return null;
  }

  return $PillSheetGroupCopyWith<$Res>(_self.afterPillSheetGroup!, (value) {
    return _then(_self.copyWith(afterPillSheetGroup: value));
  });
}/// Create a copy of PillSheetModifiedHistory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PillSheetModifiedHistoryValueCopyWith<$Res> get value {
  
  return $PillSheetModifiedHistoryValueCopyWith<$Res>(_self.value, (value) {
    return _then(_self.copyWith(value: value));
  });
}/// Create a copy of PillSheetModifiedHistory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PillSheetCopyWith<$Res>? get before {
    if (_self.before == null) {
    return null;
  }

  return $PillSheetCopyWith<$Res>(_self.before!, (value) {
    return _then(_self.copyWith(before: value));
  });
}/// Create a copy of PillSheetModifiedHistory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PillSheetCopyWith<$Res>? get after {
    if (_self.after == null) {
    return null;
  }

  return $PillSheetCopyWith<$Res>(_self.after!, (value) {
    return _then(_self.copyWith(after: value));
  });
}
}


/// Adds pattern-matching-related methods to [PillSheetModifiedHistory].
extension PillSheetModifiedHistoryPatterns on PillSheetModifiedHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PillSheetModifiedHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PillSheetModifiedHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PillSheetModifiedHistory value)  $default,){
final _that = this;
switch (_that) {
case _PillSheetModifiedHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PillSheetModifiedHistory value)?  $default,){
final _that = this;
switch (_that) {
case _PillSheetModifiedHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( dynamic version, @JsonKey(includeIfNull: false)  String? id,  String actionType, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime estimatedEventCausingDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime createdAt,  PillSheetGroup? beforePillSheetGroup,  PillSheetGroup? afterPillSheetGroup, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? ttlExpiresDateTime, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? archivedDateTime,  bool isArchived,  PillSheetModifiedHistoryValue value,  String? pillSheetID,  String? pillSheetGroupID,  String? beforePillSheetID,  String? afterPillSheetID,  PillSheet? before,  PillSheet? after)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PillSheetModifiedHistory() when $default != null:
return $default(_that.version,_that.id,_that.actionType,_that.estimatedEventCausingDate,_that.createdAt,_that.beforePillSheetGroup,_that.afterPillSheetGroup,_that.ttlExpiresDateTime,_that.archivedDateTime,_that.isArchived,_that.value,_that.pillSheetID,_that.pillSheetGroupID,_that.beforePillSheetID,_that.afterPillSheetID,_that.before,_that.after);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( dynamic version, @JsonKey(includeIfNull: false)  String? id,  String actionType, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime estimatedEventCausingDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime createdAt,  PillSheetGroup? beforePillSheetGroup,  PillSheetGroup? afterPillSheetGroup, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? ttlExpiresDateTime, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? archivedDateTime,  bool isArchived,  PillSheetModifiedHistoryValue value,  String? pillSheetID,  String? pillSheetGroupID,  String? beforePillSheetID,  String? afterPillSheetID,  PillSheet? before,  PillSheet? after)  $default,) {final _that = this;
switch (_that) {
case _PillSheetModifiedHistory():
return $default(_that.version,_that.id,_that.actionType,_that.estimatedEventCausingDate,_that.createdAt,_that.beforePillSheetGroup,_that.afterPillSheetGroup,_that.ttlExpiresDateTime,_that.archivedDateTime,_that.isArchived,_that.value,_that.pillSheetID,_that.pillSheetGroupID,_that.beforePillSheetID,_that.afterPillSheetID,_that.before,_that.after);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( dynamic version, @JsonKey(includeIfNull: false)  String? id,  String actionType, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime estimatedEventCausingDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime createdAt,  PillSheetGroup? beforePillSheetGroup,  PillSheetGroup? afterPillSheetGroup, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? ttlExpiresDateTime, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? archivedDateTime,  bool isArchived,  PillSheetModifiedHistoryValue value,  String? pillSheetID,  String? pillSheetGroupID,  String? beforePillSheetID,  String? afterPillSheetID,  PillSheet? before,  PillSheet? after)?  $default,) {final _that = this;
switch (_that) {
case _PillSheetModifiedHistory() when $default != null:
return $default(_that.version,_that.id,_that.actionType,_that.estimatedEventCausingDate,_that.createdAt,_that.beforePillSheetGroup,_that.afterPillSheetGroup,_that.ttlExpiresDateTime,_that.archivedDateTime,_that.isArchived,_that.value,_that.pillSheetID,_that.pillSheetGroupID,_that.beforePillSheetID,_that.afterPillSheetID,_that.before,_that.after);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PillSheetModifiedHistory extends PillSheetModifiedHistory {
  const _PillSheetModifiedHistory({this.version = 'v1', @JsonKey(includeIfNull: false) required this.id, required this.actionType, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.estimatedEventCausingDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.createdAt, required this.beforePillSheetGroup, required this.afterPillSheetGroup, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) this.ttlExpiresDateTime, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) this.archivedDateTime, this.isArchived = false, required this.value, required this.pillSheetID, required this.pillSheetGroupID, required this.beforePillSheetID, required this.afterPillSheetID, required this.before, required this.after}): super._();
  factory _PillSheetModifiedHistory.fromJson(Map<String, dynamic> json) => _$PillSheetModifiedHistoryFromJson(json);

// Added since 2023-08-01
@override@JsonKey() final  dynamic version;
// ============ BEGIN: Added since v1 ============
@override@JsonKey(includeIfNull: false) final  String? id;
@override final  String actionType;
@override@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) final  DateTime estimatedEventCausingDate;
@override@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) final  DateTime createdAt;
// ============ END: Added since v1 ============
// ============ BEGIN: Added since v2 ============
// beforePillSheetGroup and afterPillSheetGroup is nullable
// Because, actions for createdPillSheet and deletedPillSheet are not exists target single pill sheet
@override final  PillSheetGroup? beforePillSheetGroup;
@override final  PillSheetGroup? afterPillSheetGroup;
@override@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) final  DateTime? ttlExpiresDateTime;
// TODO: [Archive-PillSheetModifiedHistory]: 2024-04以降に対応
// 古いPillSheetModifiedHistoryのisArchivedにインデックスが貼られないため、TTLの期間内のデータが残っている間はこのフィールドが使えない
// null含めて値を入れないとクエリの条件に合致しないので、2024-04まではarchivedDateTime,isArchivedのデータが必ず存在するPillSheetModifiedHistoryの準備機関とする
// バッチを書いても良いが件数が多いのでこの方法をとっている
@override@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) final  DateTime? archivedDateTime;
// archivedDateTime isNull: false の条件だと、下記のエラーの条件に引っ掛かるため、archivedDateTime以外にもisArchivedを用意している。isArchived == true | isArchived == false の用途で使う
// You can combine constraints with a logical AND by chaining multiple equality operators (== or array-contains). However, you must create a composite index to combine equality operators with the inequality operators, <, <=, >, and !=.
@override@JsonKey() final  bool isArchived;
// ============ END: Added since v2 ============
// The below properties are deprecated and added since v1.
// This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
// Instead of calculating from beforePillSheetGroup and afterPillSheetGroup
@override final  PillSheetModifiedHistoryValue value;
// This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
// Instead of beforePillSheetID and afterPillSheetID
@override final  String? pillSheetID;
// This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
// There are new properties for pill_sheet grouping. So it's all optional
@override final  String? pillSheetGroupID;
@override final  String? beforePillSheetID;
@override final  String? afterPillSheetID;
// This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
// Instead of beforePillSheetGroup and afterPillSheetGroup
// before and after is nullable
// Because, actions for createdPillSheet and deletedPillSheet are not exists target single pill sheet
@override final  PillSheet? before;
@override final  PillSheet? after;

/// Create a copy of PillSheetModifiedHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PillSheetModifiedHistoryCopyWith<_PillSheetModifiedHistory> get copyWith => __$PillSheetModifiedHistoryCopyWithImpl<_PillSheetModifiedHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PillSheetModifiedHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PillSheetModifiedHistory&&const DeepCollectionEquality().equals(other.version, version)&&(identical(other.id, id) || other.id == id)&&(identical(other.actionType, actionType) || other.actionType == actionType)&&(identical(other.estimatedEventCausingDate, estimatedEventCausingDate) || other.estimatedEventCausingDate == estimatedEventCausingDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.beforePillSheetGroup, beforePillSheetGroup) || other.beforePillSheetGroup == beforePillSheetGroup)&&(identical(other.afterPillSheetGroup, afterPillSheetGroup) || other.afterPillSheetGroup == afterPillSheetGroup)&&(identical(other.ttlExpiresDateTime, ttlExpiresDateTime) || other.ttlExpiresDateTime == ttlExpiresDateTime)&&(identical(other.archivedDateTime, archivedDateTime) || other.archivedDateTime == archivedDateTime)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&(identical(other.value, value) || other.value == value)&&(identical(other.pillSheetID, pillSheetID) || other.pillSheetID == pillSheetID)&&(identical(other.pillSheetGroupID, pillSheetGroupID) || other.pillSheetGroupID == pillSheetGroupID)&&(identical(other.beforePillSheetID, beforePillSheetID) || other.beforePillSheetID == beforePillSheetID)&&(identical(other.afterPillSheetID, afterPillSheetID) || other.afterPillSheetID == afterPillSheetID)&&(identical(other.before, before) || other.before == before)&&(identical(other.after, after) || other.after == after));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(version),id,actionType,estimatedEventCausingDate,createdAt,beforePillSheetGroup,afterPillSheetGroup,ttlExpiresDateTime,archivedDateTime,isArchived,value,pillSheetID,pillSheetGroupID,beforePillSheetID,afterPillSheetID,before,after);

@override
String toString() {
  return 'PillSheetModifiedHistory(version: $version, id: $id, actionType: $actionType, estimatedEventCausingDate: $estimatedEventCausingDate, createdAt: $createdAt, beforePillSheetGroup: $beforePillSheetGroup, afterPillSheetGroup: $afterPillSheetGroup, ttlExpiresDateTime: $ttlExpiresDateTime, archivedDateTime: $archivedDateTime, isArchived: $isArchived, value: $value, pillSheetID: $pillSheetID, pillSheetGroupID: $pillSheetGroupID, beforePillSheetID: $beforePillSheetID, afterPillSheetID: $afterPillSheetID, before: $before, after: $after)';
}


}

/// @nodoc
abstract mixin class _$PillSheetModifiedHistoryCopyWith<$Res> implements $PillSheetModifiedHistoryCopyWith<$Res> {
  factory _$PillSheetModifiedHistoryCopyWith(_PillSheetModifiedHistory value, $Res Function(_PillSheetModifiedHistory) _then) = __$PillSheetModifiedHistoryCopyWithImpl;
@override @useResult
$Res call({
 dynamic version,@JsonKey(includeIfNull: false) String? id, String actionType,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime estimatedEventCausingDate,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime createdAt, PillSheetGroup? beforePillSheetGroup, PillSheetGroup? afterPillSheetGroup,@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? ttlExpiresDateTime,@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? archivedDateTime, bool isArchived, PillSheetModifiedHistoryValue value, String? pillSheetID, String? pillSheetGroupID, String? beforePillSheetID, String? afterPillSheetID, PillSheet? before, PillSheet? after
});


@override $PillSheetGroupCopyWith<$Res>? get beforePillSheetGroup;@override $PillSheetGroupCopyWith<$Res>? get afterPillSheetGroup;@override $PillSheetModifiedHistoryValueCopyWith<$Res> get value;@override $PillSheetCopyWith<$Res>? get before;@override $PillSheetCopyWith<$Res>? get after;

}
/// @nodoc
class __$PillSheetModifiedHistoryCopyWithImpl<$Res>
    implements _$PillSheetModifiedHistoryCopyWith<$Res> {
  __$PillSheetModifiedHistoryCopyWithImpl(this._self, this._then);

  final _PillSheetModifiedHistory _self;
  final $Res Function(_PillSheetModifiedHistory) _then;

/// Create a copy of PillSheetModifiedHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = freezed,Object? id = freezed,Object? actionType = null,Object? estimatedEventCausingDate = null,Object? createdAt = null,Object? beforePillSheetGroup = freezed,Object? afterPillSheetGroup = freezed,Object? ttlExpiresDateTime = freezed,Object? archivedDateTime = freezed,Object? isArchived = null,Object? value = null,Object? pillSheetID = freezed,Object? pillSheetGroupID = freezed,Object? beforePillSheetID = freezed,Object? afterPillSheetID = freezed,Object? before = freezed,Object? after = freezed,}) {
  return _then(_PillSheetModifiedHistory(
version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as dynamic,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,actionType: null == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as String,estimatedEventCausingDate: null == estimatedEventCausingDate ? _self.estimatedEventCausingDate : estimatedEventCausingDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,beforePillSheetGroup: freezed == beforePillSheetGroup ? _self.beforePillSheetGroup : beforePillSheetGroup // ignore: cast_nullable_to_non_nullable
as PillSheetGroup?,afterPillSheetGroup: freezed == afterPillSheetGroup ? _self.afterPillSheetGroup : afterPillSheetGroup // ignore: cast_nullable_to_non_nullable
as PillSheetGroup?,ttlExpiresDateTime: freezed == ttlExpiresDateTime ? _self.ttlExpiresDateTime : ttlExpiresDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,archivedDateTime: freezed == archivedDateTime ? _self.archivedDateTime : archivedDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as PillSheetModifiedHistoryValue,pillSheetID: freezed == pillSheetID ? _self.pillSheetID : pillSheetID // ignore: cast_nullable_to_non_nullable
as String?,pillSheetGroupID: freezed == pillSheetGroupID ? _self.pillSheetGroupID : pillSheetGroupID // ignore: cast_nullable_to_non_nullable
as String?,beforePillSheetID: freezed == beforePillSheetID ? _self.beforePillSheetID : beforePillSheetID // ignore: cast_nullable_to_non_nullable
as String?,afterPillSheetID: freezed == afterPillSheetID ? _self.afterPillSheetID : afterPillSheetID // ignore: cast_nullable_to_non_nullable
as String?,before: freezed == before ? _self.before : before // ignore: cast_nullable_to_non_nullable
as PillSheet?,after: freezed == after ? _self.after : after // ignore: cast_nullable_to_non_nullable
as PillSheet?,
  ));
}

/// Create a copy of PillSheetModifiedHistory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PillSheetGroupCopyWith<$Res>? get beforePillSheetGroup {
    if (_self.beforePillSheetGroup == null) {
    return null;
  }

  return $PillSheetGroupCopyWith<$Res>(_self.beforePillSheetGroup!, (value) {
    return _then(_self.copyWith(beforePillSheetGroup: value));
  });
}/// Create a copy of PillSheetModifiedHistory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PillSheetGroupCopyWith<$Res>? get afterPillSheetGroup {
    if (_self.afterPillSheetGroup == null) {
    return null;
  }

  return $PillSheetGroupCopyWith<$Res>(_self.afterPillSheetGroup!, (value) {
    return _then(_self.copyWith(afterPillSheetGroup: value));
  });
}/// Create a copy of PillSheetModifiedHistory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PillSheetModifiedHistoryValueCopyWith<$Res> get value {
  
  return $PillSheetModifiedHistoryValueCopyWith<$Res>(_self.value, (value) {
    return _then(_self.copyWith(value: value));
  });
}/// Create a copy of PillSheetModifiedHistory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PillSheetCopyWith<$Res>? get before {
    if (_self.before == null) {
    return null;
  }

  return $PillSheetCopyWith<$Res>(_self.before!, (value) {
    return _then(_self.copyWith(before: value));
  });
}/// Create a copy of PillSheetModifiedHistory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PillSheetCopyWith<$Res>? get after {
    if (_self.after == null) {
    return null;
  }

  return $PillSheetCopyWith<$Res>(_self.after!, (value) {
    return _then(_self.copyWith(after: value));
  });
}
}

// dart format on
