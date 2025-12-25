// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pill_sheet_group.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PillSheetGroup {

 List<PillSheetGroupPillNumberDomainPillMarkValue> get pillNumbersInPillSheet; List<PillSheetGroupPillNumberDomainPillMarkValue> get pillNumbersForCyclicSequential;/// FirestoreドキュメントID（自動生成される場合はnull）
@JsonKey(includeIfNull: false) String? get id;/// このグループに含まれるピルシートのIDリスト
/// pillSheetsプロパティと対応関係を持つ
 List<String> get pillSheetIDs;/// このグループに含まれる実際のピルシートデータ
/// 服用状況や日程計算の基準となる
 List<PillSheet> get pillSheets;/// グループ作成日時（必須項目）
/// Firestoreのタイムスタンプとして保存される
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime get createdAt;/// 削除日時（論理削除で使用）
/// nullの場合は削除されていない状態を表す
@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? get deletedAt;// NOTE: [SyncData:Widget] このプロパティはWidgetに同期されてる
/// ピル番号の表示設定（カスタマイズ用）
/// 開始番号・終了番号のユーザーカスタマイズを管理
 PillSheetGroupDisplayNumberSetting? get displayNumberSetting;/// ピルシートの表示モード設定
/// 番号表示、日付表示、連続番号表示の切り替えを制御
 PillSheetAppearanceMode get pillSheetAppearanceMode;
/// Create a copy of PillSheetGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PillSheetGroupCopyWith<PillSheetGroup> get copyWith => _$PillSheetGroupCopyWithImpl<PillSheetGroup>(this as PillSheetGroup, _$identity);

  /// Serializes this PillSheetGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PillSheetGroup&&const DeepCollectionEquality().equals(other.pillNumbersInPillSheet, pillNumbersInPillSheet)&&const DeepCollectionEquality().equals(other.pillNumbersForCyclicSequential, pillNumbersForCyclicSequential)&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.pillSheetIDs, pillSheetIDs)&&const DeepCollectionEquality().equals(other.pillSheets, pillSheets)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.displayNumberSetting, displayNumberSetting) || other.displayNumberSetting == displayNumberSetting)&&(identical(other.pillSheetAppearanceMode, pillSheetAppearanceMode) || other.pillSheetAppearanceMode == pillSheetAppearanceMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(pillNumbersInPillSheet),const DeepCollectionEquality().hash(pillNumbersForCyclicSequential),id,const DeepCollectionEquality().hash(pillSheetIDs),const DeepCollectionEquality().hash(pillSheets),createdAt,deletedAt,displayNumberSetting,pillSheetAppearanceMode);

@override
String toString() {
  return 'PillSheetGroup(pillNumbersInPillSheet: $pillNumbersInPillSheet, pillNumbersForCyclicSequential: $pillNumbersForCyclicSequential, id: $id, pillSheetIDs: $pillSheetIDs, pillSheets: $pillSheets, createdAt: $createdAt, deletedAt: $deletedAt, displayNumberSetting: $displayNumberSetting, pillSheetAppearanceMode: $pillSheetAppearanceMode)';
}


}

/// @nodoc
abstract mixin class $PillSheetGroupCopyWith<$Res>  {
  factory $PillSheetGroupCopyWith(PillSheetGroup value, $Res Function(PillSheetGroup) _then) = _$PillSheetGroupCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeIfNull: false) String? id, List<String> pillSheetIDs, List<PillSheet> pillSheets,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime createdAt,@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? deletedAt, PillSheetGroupDisplayNumberSetting? displayNumberSetting, PillSheetAppearanceMode pillSheetAppearanceMode
});


$PillSheetGroupDisplayNumberSettingCopyWith<$Res>? get displayNumberSetting;

}
/// @nodoc
class _$PillSheetGroupCopyWithImpl<$Res>
    implements $PillSheetGroupCopyWith<$Res> {
  _$PillSheetGroupCopyWithImpl(this._self, this._then);

  final PillSheetGroup _self;
  final $Res Function(PillSheetGroup) _then;

/// Create a copy of PillSheetGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? pillSheetIDs = null,Object? pillSheets = null,Object? createdAt = null,Object? deletedAt = freezed,Object? displayNumberSetting = freezed,Object? pillSheetAppearanceMode = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,pillSheetIDs: null == pillSheetIDs ? _self.pillSheetIDs : pillSheetIDs // ignore: cast_nullable_to_non_nullable
as List<String>,pillSheets: null == pillSheets ? _self.pillSheets : pillSheets // ignore: cast_nullable_to_non_nullable
as List<PillSheet>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,displayNumberSetting: freezed == displayNumberSetting ? _self.displayNumberSetting : displayNumberSetting // ignore: cast_nullable_to_non_nullable
as PillSheetGroupDisplayNumberSetting?,pillSheetAppearanceMode: null == pillSheetAppearanceMode ? _self.pillSheetAppearanceMode : pillSheetAppearanceMode // ignore: cast_nullable_to_non_nullable
as PillSheetAppearanceMode,
  ));
}
/// Create a copy of PillSheetGroup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PillSheetGroupDisplayNumberSettingCopyWith<$Res>? get displayNumberSetting {
    if (_self.displayNumberSetting == null) {
    return null;
  }

  return $PillSheetGroupDisplayNumberSettingCopyWith<$Res>(_self.displayNumberSetting!, (value) {
    return _then(_self.copyWith(displayNumberSetting: value));
  });
}
}


/// Adds pattern-matching-related methods to [PillSheetGroup].
extension PillSheetGroupPatterns on PillSheetGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PillSheetGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PillSheetGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PillSheetGroup value)  $default,){
final _that = this;
switch (_that) {
case _PillSheetGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PillSheetGroup value)?  $default,){
final _that = this;
switch (_that) {
case _PillSheetGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  String? id,  List<String> pillSheetIDs,  List<PillSheet> pillSheets, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime createdAt, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? deletedAt,  PillSheetGroupDisplayNumberSetting? displayNumberSetting,  PillSheetAppearanceMode pillSheetAppearanceMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PillSheetGroup() when $default != null:
return $default(_that.id,_that.pillSheetIDs,_that.pillSheets,_that.createdAt,_that.deletedAt,_that.displayNumberSetting,_that.pillSheetAppearanceMode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  String? id,  List<String> pillSheetIDs,  List<PillSheet> pillSheets, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime createdAt, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? deletedAt,  PillSheetGroupDisplayNumberSetting? displayNumberSetting,  PillSheetAppearanceMode pillSheetAppearanceMode)  $default,) {final _that = this;
switch (_that) {
case _PillSheetGroup():
return $default(_that.id,_that.pillSheetIDs,_that.pillSheets,_that.createdAt,_that.deletedAt,_that.displayNumberSetting,_that.pillSheetAppearanceMode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeIfNull: false)  String? id,  List<String> pillSheetIDs,  List<PillSheet> pillSheets, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime createdAt, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? deletedAt,  PillSheetGroupDisplayNumberSetting? displayNumberSetting,  PillSheetAppearanceMode pillSheetAppearanceMode)?  $default,) {final _that = this;
switch (_that) {
case _PillSheetGroup() when $default != null:
return $default(_that.id,_that.pillSheetIDs,_that.pillSheets,_that.createdAt,_that.deletedAt,_that.displayNumberSetting,_that.pillSheetAppearanceMode);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PillSheetGroup extends PillSheetGroup {
   _PillSheetGroup({@JsonKey(includeIfNull: false) this.id, required final  List<String> pillSheetIDs, required final  List<PillSheet> pillSheets, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.createdAt, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) this.deletedAt, this.displayNumberSetting, this.pillSheetAppearanceMode = PillSheetAppearanceMode.number}): _pillSheetIDs = pillSheetIDs,_pillSheets = pillSheets,super._();
  factory _PillSheetGroup.fromJson(Map<String, dynamic> json) => _$PillSheetGroupFromJson(json);

/// FirestoreドキュメントID（自動生成される場合はnull）
@override@JsonKey(includeIfNull: false) final  String? id;
/// このグループに含まれるピルシートのIDリスト
/// pillSheetsプロパティと対応関係を持つ
 final  List<String> _pillSheetIDs;
/// このグループに含まれるピルシートのIDリスト
/// pillSheetsプロパティと対応関係を持つ
@override List<String> get pillSheetIDs {
  if (_pillSheetIDs is EqualUnmodifiableListView) return _pillSheetIDs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pillSheetIDs);
}

/// このグループに含まれる実際のピルシートデータ
/// 服用状況や日程計算の基準となる
 final  List<PillSheet> _pillSheets;
/// このグループに含まれる実際のピルシートデータ
/// 服用状況や日程計算の基準となる
@override List<PillSheet> get pillSheets {
  if (_pillSheets is EqualUnmodifiableListView) return _pillSheets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pillSheets);
}

/// グループ作成日時（必須項目）
/// Firestoreのタイムスタンプとして保存される
@override@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) final  DateTime createdAt;
/// 削除日時（論理削除で使用）
/// nullの場合は削除されていない状態を表す
@override@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) final  DateTime? deletedAt;
// NOTE: [SyncData:Widget] このプロパティはWidgetに同期されてる
/// ピル番号の表示設定（カスタマイズ用）
/// 開始番号・終了番号のユーザーカスタマイズを管理
@override final  PillSheetGroupDisplayNumberSetting? displayNumberSetting;
/// ピルシートの表示モード設定
/// 番号表示、日付表示、連続番号表示の切り替えを制御
@override@JsonKey() final  PillSheetAppearanceMode pillSheetAppearanceMode;

/// Create a copy of PillSheetGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PillSheetGroupCopyWith<_PillSheetGroup> get copyWith => __$PillSheetGroupCopyWithImpl<_PillSheetGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PillSheetGroupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PillSheetGroup&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._pillSheetIDs, _pillSheetIDs)&&const DeepCollectionEquality().equals(other._pillSheets, _pillSheets)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.displayNumberSetting, displayNumberSetting) || other.displayNumberSetting == displayNumberSetting)&&(identical(other.pillSheetAppearanceMode, pillSheetAppearanceMode) || other.pillSheetAppearanceMode == pillSheetAppearanceMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_pillSheetIDs),const DeepCollectionEquality().hash(_pillSheets),createdAt,deletedAt,displayNumberSetting,pillSheetAppearanceMode);

@override
String toString() {
  return 'PillSheetGroup(id: $id, pillSheetIDs: $pillSheetIDs, pillSheets: $pillSheets, createdAt: $createdAt, deletedAt: $deletedAt, displayNumberSetting: $displayNumberSetting, pillSheetAppearanceMode: $pillSheetAppearanceMode)';
}


}

/// @nodoc
abstract mixin class _$PillSheetGroupCopyWith<$Res> implements $PillSheetGroupCopyWith<$Res> {
  factory _$PillSheetGroupCopyWith(_PillSheetGroup value, $Res Function(_PillSheetGroup) _then) = __$PillSheetGroupCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeIfNull: false) String? id, List<String> pillSheetIDs, List<PillSheet> pillSheets,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime createdAt,@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? deletedAt, PillSheetGroupDisplayNumberSetting? displayNumberSetting, PillSheetAppearanceMode pillSheetAppearanceMode
});


@override $PillSheetGroupDisplayNumberSettingCopyWith<$Res>? get displayNumberSetting;

}
/// @nodoc
class __$PillSheetGroupCopyWithImpl<$Res>
    implements _$PillSheetGroupCopyWith<$Res> {
  __$PillSheetGroupCopyWithImpl(this._self, this._then);

  final _PillSheetGroup _self;
  final $Res Function(_PillSheetGroup) _then;

/// Create a copy of PillSheetGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? pillSheetIDs = null,Object? pillSheets = null,Object? createdAt = null,Object? deletedAt = freezed,Object? displayNumberSetting = freezed,Object? pillSheetAppearanceMode = null,}) {
  return _then(_PillSheetGroup(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,pillSheetIDs: null == pillSheetIDs ? _self._pillSheetIDs : pillSheetIDs // ignore: cast_nullable_to_non_nullable
as List<String>,pillSheets: null == pillSheets ? _self._pillSheets : pillSheets // ignore: cast_nullable_to_non_nullable
as List<PillSheet>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,displayNumberSetting: freezed == displayNumberSetting ? _self.displayNumberSetting : displayNumberSetting // ignore: cast_nullable_to_non_nullable
as PillSheetGroupDisplayNumberSetting?,pillSheetAppearanceMode: null == pillSheetAppearanceMode ? _self.pillSheetAppearanceMode : pillSheetAppearanceMode // ignore: cast_nullable_to_non_nullable
as PillSheetAppearanceMode,
  ));
}

/// Create a copy of PillSheetGroup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PillSheetGroupDisplayNumberSettingCopyWith<$Res>? get displayNumberSetting {
    if (_self.displayNumberSetting == null) {
    return null;
  }

  return $PillSheetGroupDisplayNumberSettingCopyWith<$Res>(_self.displayNumberSetting!, (value) {
    return _then(_self.copyWith(displayNumberSetting: value));
  });
}
}

/// @nodoc
mixin _$PillSheetGroupPillNumberDomainPillMarkValue {

/// 対象となるピルシート情報
 PillSheet get pillSheet;/// 対象となる日付
 DateTime get date;/// 表示番号
 int get number;
/// Create a copy of PillSheetGroupPillNumberDomainPillMarkValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PillSheetGroupPillNumberDomainPillMarkValueCopyWith<PillSheetGroupPillNumberDomainPillMarkValue> get copyWith => _$PillSheetGroupPillNumberDomainPillMarkValueCopyWithImpl<PillSheetGroupPillNumberDomainPillMarkValue>(this as PillSheetGroupPillNumberDomainPillMarkValue, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PillSheetGroupPillNumberDomainPillMarkValue&&(identical(other.pillSheet, pillSheet) || other.pillSheet == pillSheet)&&(identical(other.date, date) || other.date == date)&&(identical(other.number, number) || other.number == number));
}


@override
int get hashCode => Object.hash(runtimeType,pillSheet,date,number);

@override
String toString() {
  return 'PillSheetGroupPillNumberDomainPillMarkValue(pillSheet: $pillSheet, date: $date, number: $number)';
}


}

/// @nodoc
abstract mixin class $PillSheetGroupPillNumberDomainPillMarkValueCopyWith<$Res>  {
  factory $PillSheetGroupPillNumberDomainPillMarkValueCopyWith(PillSheetGroupPillNumberDomainPillMarkValue value, $Res Function(PillSheetGroupPillNumberDomainPillMarkValue) _then) = _$PillSheetGroupPillNumberDomainPillMarkValueCopyWithImpl;
@useResult
$Res call({
 PillSheet pillSheet, DateTime date, int number
});


$PillSheetCopyWith<$Res> get pillSheet;

}
/// @nodoc
class _$PillSheetGroupPillNumberDomainPillMarkValueCopyWithImpl<$Res>
    implements $PillSheetGroupPillNumberDomainPillMarkValueCopyWith<$Res> {
  _$PillSheetGroupPillNumberDomainPillMarkValueCopyWithImpl(this._self, this._then);

  final PillSheetGroupPillNumberDomainPillMarkValue _self;
  final $Res Function(PillSheetGroupPillNumberDomainPillMarkValue) _then;

/// Create a copy of PillSheetGroupPillNumberDomainPillMarkValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pillSheet = null,Object? date = null,Object? number = null,}) {
  return _then(_self.copyWith(
pillSheet: null == pillSheet ? _self.pillSheet : pillSheet // ignore: cast_nullable_to_non_nullable
as PillSheet,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of PillSheetGroupPillNumberDomainPillMarkValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PillSheetCopyWith<$Res> get pillSheet {
  
  return $PillSheetCopyWith<$Res>(_self.pillSheet, (value) {
    return _then(_self.copyWith(pillSheet: value));
  });
}
}


/// Adds pattern-matching-related methods to [PillSheetGroupPillNumberDomainPillMarkValue].
extension PillSheetGroupPillNumberDomainPillMarkValuePatterns on PillSheetGroupPillNumberDomainPillMarkValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PillSheetGroupPillNumberDomainPillMarkValue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PillSheetGroupPillNumberDomainPillMarkValue() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PillSheetGroupPillNumberDomainPillMarkValue value)  $default,){
final _that = this;
switch (_that) {
case _PillSheetGroupPillNumberDomainPillMarkValue():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PillSheetGroupPillNumberDomainPillMarkValue value)?  $default,){
final _that = this;
switch (_that) {
case _PillSheetGroupPillNumberDomainPillMarkValue() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PillSheet pillSheet,  DateTime date,  int number)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PillSheetGroupPillNumberDomainPillMarkValue() when $default != null:
return $default(_that.pillSheet,_that.date,_that.number);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PillSheet pillSheet,  DateTime date,  int number)  $default,) {final _that = this;
switch (_that) {
case _PillSheetGroupPillNumberDomainPillMarkValue():
return $default(_that.pillSheet,_that.date,_that.number);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PillSheet pillSheet,  DateTime date,  int number)?  $default,) {final _that = this;
switch (_that) {
case _PillSheetGroupPillNumberDomainPillMarkValue() when $default != null:
return $default(_that.pillSheet,_that.date,_that.number);case _:
  return null;

}
}

}

/// @nodoc


class _PillSheetGroupPillNumberDomainPillMarkValue implements PillSheetGroupPillNumberDomainPillMarkValue {
  const _PillSheetGroupPillNumberDomainPillMarkValue({required this.pillSheet, required this.date, required this.number});
  

/// 対象となるピルシート情報
@override final  PillSheet pillSheet;
/// 対象となる日付
@override final  DateTime date;
/// 表示番号
@override final  int number;

/// Create a copy of PillSheetGroupPillNumberDomainPillMarkValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PillSheetGroupPillNumberDomainPillMarkValueCopyWith<_PillSheetGroupPillNumberDomainPillMarkValue> get copyWith => __$PillSheetGroupPillNumberDomainPillMarkValueCopyWithImpl<_PillSheetGroupPillNumberDomainPillMarkValue>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PillSheetGroupPillNumberDomainPillMarkValue&&(identical(other.pillSheet, pillSheet) || other.pillSheet == pillSheet)&&(identical(other.date, date) || other.date == date)&&(identical(other.number, number) || other.number == number));
}


@override
int get hashCode => Object.hash(runtimeType,pillSheet,date,number);

@override
String toString() {
  return 'PillSheetGroupPillNumberDomainPillMarkValue(pillSheet: $pillSheet, date: $date, number: $number)';
}


}

/// @nodoc
abstract mixin class _$PillSheetGroupPillNumberDomainPillMarkValueCopyWith<$Res> implements $PillSheetGroupPillNumberDomainPillMarkValueCopyWith<$Res> {
  factory _$PillSheetGroupPillNumberDomainPillMarkValueCopyWith(_PillSheetGroupPillNumberDomainPillMarkValue value, $Res Function(_PillSheetGroupPillNumberDomainPillMarkValue) _then) = __$PillSheetGroupPillNumberDomainPillMarkValueCopyWithImpl;
@override @useResult
$Res call({
 PillSheet pillSheet, DateTime date, int number
});


@override $PillSheetCopyWith<$Res> get pillSheet;

}
/// @nodoc
class __$PillSheetGroupPillNumberDomainPillMarkValueCopyWithImpl<$Res>
    implements _$PillSheetGroupPillNumberDomainPillMarkValueCopyWith<$Res> {
  __$PillSheetGroupPillNumberDomainPillMarkValueCopyWithImpl(this._self, this._then);

  final _PillSheetGroupPillNumberDomainPillMarkValue _self;
  final $Res Function(_PillSheetGroupPillNumberDomainPillMarkValue) _then;

/// Create a copy of PillSheetGroupPillNumberDomainPillMarkValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pillSheet = null,Object? date = null,Object? number = null,}) {
  return _then(_PillSheetGroupPillNumberDomainPillMarkValue(
pillSheet: null == pillSheet ? _self.pillSheet : pillSheet // ignore: cast_nullable_to_non_nullable
as PillSheet,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of PillSheetGroupPillNumberDomainPillMarkValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PillSheetCopyWith<$Res> get pillSheet {
  
  return $PillSheetCopyWith<$Res>(_self.pillSheet, (value) {
    return _then(_self.copyWith(pillSheet: value));
  });
}
}


/// @nodoc
mixin _$PillSheetGroupDisplayNumberSetting {

// 開始番号はピルシートグループの開始の番号。周期ではない。終了の番号に到達・もしくは服用お休み期間あとは1番から始まる
/// グループ全体での開始番号設定
/// nullの場合は1から開始される
 int? get beginPillNumber;// 開始番号は周期の終了番号。周期の終了した数・服用お休みの有無に関わらずこの番号が最終番号となる
/// 周期の終了番号設定
/// nullの場合は終了番号制限なしで連続番号付けされる
 int? get endPillNumber;
/// Create a copy of PillSheetGroupDisplayNumberSetting
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PillSheetGroupDisplayNumberSettingCopyWith<PillSheetGroupDisplayNumberSetting> get copyWith => _$PillSheetGroupDisplayNumberSettingCopyWithImpl<PillSheetGroupDisplayNumberSetting>(this as PillSheetGroupDisplayNumberSetting, _$identity);

  /// Serializes this PillSheetGroupDisplayNumberSetting to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PillSheetGroupDisplayNumberSetting&&(identical(other.beginPillNumber, beginPillNumber) || other.beginPillNumber == beginPillNumber)&&(identical(other.endPillNumber, endPillNumber) || other.endPillNumber == endPillNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,beginPillNumber,endPillNumber);

@override
String toString() {
  return 'PillSheetGroupDisplayNumberSetting(beginPillNumber: $beginPillNumber, endPillNumber: $endPillNumber)';
}


}

/// @nodoc
abstract mixin class $PillSheetGroupDisplayNumberSettingCopyWith<$Res>  {
  factory $PillSheetGroupDisplayNumberSettingCopyWith(PillSheetGroupDisplayNumberSetting value, $Res Function(PillSheetGroupDisplayNumberSetting) _then) = _$PillSheetGroupDisplayNumberSettingCopyWithImpl;
@useResult
$Res call({
 int? beginPillNumber, int? endPillNumber
});




}
/// @nodoc
class _$PillSheetGroupDisplayNumberSettingCopyWithImpl<$Res>
    implements $PillSheetGroupDisplayNumberSettingCopyWith<$Res> {
  _$PillSheetGroupDisplayNumberSettingCopyWithImpl(this._self, this._then);

  final PillSheetGroupDisplayNumberSetting _self;
  final $Res Function(PillSheetGroupDisplayNumberSetting) _then;

/// Create a copy of PillSheetGroupDisplayNumberSetting
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? beginPillNumber = freezed,Object? endPillNumber = freezed,}) {
  return _then(_self.copyWith(
beginPillNumber: freezed == beginPillNumber ? _self.beginPillNumber : beginPillNumber // ignore: cast_nullable_to_non_nullable
as int?,endPillNumber: freezed == endPillNumber ? _self.endPillNumber : endPillNumber // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [PillSheetGroupDisplayNumberSetting].
extension PillSheetGroupDisplayNumberSettingPatterns on PillSheetGroupDisplayNumberSetting {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PillSheetGroupDisplayNumberSetting value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PillSheetGroupDisplayNumberSetting() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PillSheetGroupDisplayNumberSetting value)  $default,){
final _that = this;
switch (_that) {
case _PillSheetGroupDisplayNumberSetting():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PillSheetGroupDisplayNumberSetting value)?  $default,){
final _that = this;
switch (_that) {
case _PillSheetGroupDisplayNumberSetting() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? beginPillNumber,  int? endPillNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PillSheetGroupDisplayNumberSetting() when $default != null:
return $default(_that.beginPillNumber,_that.endPillNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? beginPillNumber,  int? endPillNumber)  $default,) {final _that = this;
switch (_that) {
case _PillSheetGroupDisplayNumberSetting():
return $default(_that.beginPillNumber,_that.endPillNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? beginPillNumber,  int? endPillNumber)?  $default,) {final _that = this;
switch (_that) {
case _PillSheetGroupDisplayNumberSetting() when $default != null:
return $default(_that.beginPillNumber,_that.endPillNumber);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PillSheetGroupDisplayNumberSetting implements PillSheetGroupDisplayNumberSetting {
  const _PillSheetGroupDisplayNumberSetting({this.beginPillNumber, this.endPillNumber});
  factory _PillSheetGroupDisplayNumberSetting.fromJson(Map<String, dynamic> json) => _$PillSheetGroupDisplayNumberSettingFromJson(json);

// 開始番号はピルシートグループの開始の番号。周期ではない。終了の番号に到達・もしくは服用お休み期間あとは1番から始まる
/// グループ全体での開始番号設定
/// nullの場合は1から開始される
@override final  int? beginPillNumber;
// 開始番号は周期の終了番号。周期の終了した数・服用お休みの有無に関わらずこの番号が最終番号となる
/// 周期の終了番号設定
/// nullの場合は終了番号制限なしで連続番号付けされる
@override final  int? endPillNumber;

/// Create a copy of PillSheetGroupDisplayNumberSetting
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PillSheetGroupDisplayNumberSettingCopyWith<_PillSheetGroupDisplayNumberSetting> get copyWith => __$PillSheetGroupDisplayNumberSettingCopyWithImpl<_PillSheetGroupDisplayNumberSetting>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PillSheetGroupDisplayNumberSettingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PillSheetGroupDisplayNumberSetting&&(identical(other.beginPillNumber, beginPillNumber) || other.beginPillNumber == beginPillNumber)&&(identical(other.endPillNumber, endPillNumber) || other.endPillNumber == endPillNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,beginPillNumber,endPillNumber);

@override
String toString() {
  return 'PillSheetGroupDisplayNumberSetting(beginPillNumber: $beginPillNumber, endPillNumber: $endPillNumber)';
}


}

/// @nodoc
abstract mixin class _$PillSheetGroupDisplayNumberSettingCopyWith<$Res> implements $PillSheetGroupDisplayNumberSettingCopyWith<$Res> {
  factory _$PillSheetGroupDisplayNumberSettingCopyWith(_PillSheetGroupDisplayNumberSetting value, $Res Function(_PillSheetGroupDisplayNumberSetting) _then) = __$PillSheetGroupDisplayNumberSettingCopyWithImpl;
@override @useResult
$Res call({
 int? beginPillNumber, int? endPillNumber
});




}
/// @nodoc
class __$PillSheetGroupDisplayNumberSettingCopyWithImpl<$Res>
    implements _$PillSheetGroupDisplayNumberSettingCopyWith<$Res> {
  __$PillSheetGroupDisplayNumberSettingCopyWithImpl(this._self, this._then);

  final _PillSheetGroupDisplayNumberSetting _self;
  final $Res Function(_PillSheetGroupDisplayNumberSetting) _then;

/// Create a copy of PillSheetGroupDisplayNumberSetting
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? beginPillNumber = freezed,Object? endPillNumber = freezed,}) {
  return _then(_PillSheetGroupDisplayNumberSetting(
beginPillNumber: freezed == beginPillNumber ? _self.beginPillNumber : beginPillNumber // ignore: cast_nullable_to_non_nullable
as int?,endPillNumber: freezed == endPillNumber ? _self.endPillNumber : endPillNumber // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
