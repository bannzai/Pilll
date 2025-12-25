// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'initial_setting_state.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InitialSettingTodayPillNumber {

 int get pageIndex; int get pillNumberInPillSheet;
/// Create a copy of InitialSettingTodayPillNumber
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InitialSettingTodayPillNumberCopyWith<InitialSettingTodayPillNumber> get copyWith => _$InitialSettingTodayPillNumberCopyWithImpl<InitialSettingTodayPillNumber>(this as InitialSettingTodayPillNumber, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InitialSettingTodayPillNumber&&(identical(other.pageIndex, pageIndex) || other.pageIndex == pageIndex)&&(identical(other.pillNumberInPillSheet, pillNumberInPillSheet) || other.pillNumberInPillSheet == pillNumberInPillSheet));
}


@override
int get hashCode => Object.hash(runtimeType,pageIndex,pillNumberInPillSheet);

@override
String toString() {
  return 'InitialSettingTodayPillNumber(pageIndex: $pageIndex, pillNumberInPillSheet: $pillNumberInPillSheet)';
}


}

/// @nodoc
abstract mixin class $InitialSettingTodayPillNumberCopyWith<$Res>  {
  factory $InitialSettingTodayPillNumberCopyWith(InitialSettingTodayPillNumber value, $Res Function(InitialSettingTodayPillNumber) _then) = _$InitialSettingTodayPillNumberCopyWithImpl;
@useResult
$Res call({
 int pageIndex, int pillNumberInPillSheet
});




}
/// @nodoc
class _$InitialSettingTodayPillNumberCopyWithImpl<$Res>
    implements $InitialSettingTodayPillNumberCopyWith<$Res> {
  _$InitialSettingTodayPillNumberCopyWithImpl(this._self, this._then);

  final InitialSettingTodayPillNumber _self;
  final $Res Function(InitialSettingTodayPillNumber) _then;

/// Create a copy of InitialSettingTodayPillNumber
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pageIndex = null,Object? pillNumberInPillSheet = null,}) {
  return _then(_self.copyWith(
pageIndex: null == pageIndex ? _self.pageIndex : pageIndex // ignore: cast_nullable_to_non_nullable
as int,pillNumberInPillSheet: null == pillNumberInPillSheet ? _self.pillNumberInPillSheet : pillNumberInPillSheet // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [InitialSettingTodayPillNumber].
extension InitialSettingTodayPillNumberPatterns on InitialSettingTodayPillNumber {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InitialSettingTodayPillNumber value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InitialSettingTodayPillNumber() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InitialSettingTodayPillNumber value)  $default,){
final _that = this;
switch (_that) {
case _InitialSettingTodayPillNumber():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InitialSettingTodayPillNumber value)?  $default,){
final _that = this;
switch (_that) {
case _InitialSettingTodayPillNumber() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int pageIndex,  int pillNumberInPillSheet)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InitialSettingTodayPillNumber() when $default != null:
return $default(_that.pageIndex,_that.pillNumberInPillSheet);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int pageIndex,  int pillNumberInPillSheet)  $default,) {final _that = this;
switch (_that) {
case _InitialSettingTodayPillNumber():
return $default(_that.pageIndex,_that.pillNumberInPillSheet);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int pageIndex,  int pillNumberInPillSheet)?  $default,) {final _that = this;
switch (_that) {
case _InitialSettingTodayPillNumber() when $default != null:
return $default(_that.pageIndex,_that.pillNumberInPillSheet);case _:
  return null;

}
}

}

/// @nodoc


class _InitialSettingTodayPillNumber implements InitialSettingTodayPillNumber {
  const _InitialSettingTodayPillNumber({this.pageIndex = 0, this.pillNumberInPillSheet = 0});
  

@override@JsonKey() final  int pageIndex;
@override@JsonKey() final  int pillNumberInPillSheet;

/// Create a copy of InitialSettingTodayPillNumber
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InitialSettingTodayPillNumberCopyWith<_InitialSettingTodayPillNumber> get copyWith => __$InitialSettingTodayPillNumberCopyWithImpl<_InitialSettingTodayPillNumber>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InitialSettingTodayPillNumber&&(identical(other.pageIndex, pageIndex) || other.pageIndex == pageIndex)&&(identical(other.pillNumberInPillSheet, pillNumberInPillSheet) || other.pillNumberInPillSheet == pillNumberInPillSheet));
}


@override
int get hashCode => Object.hash(runtimeType,pageIndex,pillNumberInPillSheet);

@override
String toString() {
  return 'InitialSettingTodayPillNumber(pageIndex: $pageIndex, pillNumberInPillSheet: $pillNumberInPillSheet)';
}


}

/// @nodoc
abstract mixin class _$InitialSettingTodayPillNumberCopyWith<$Res> implements $InitialSettingTodayPillNumberCopyWith<$Res> {
  factory _$InitialSettingTodayPillNumberCopyWith(_InitialSettingTodayPillNumber value, $Res Function(_InitialSettingTodayPillNumber) _then) = __$InitialSettingTodayPillNumberCopyWithImpl;
@override @useResult
$Res call({
 int pageIndex, int pillNumberInPillSheet
});




}
/// @nodoc
class __$InitialSettingTodayPillNumberCopyWithImpl<$Res>
    implements _$InitialSettingTodayPillNumberCopyWith<$Res> {
  __$InitialSettingTodayPillNumberCopyWithImpl(this._self, this._then);

  final _InitialSettingTodayPillNumber _self;
  final $Res Function(_InitialSettingTodayPillNumber) _then;

/// Create a copy of InitialSettingTodayPillNumber
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pageIndex = null,Object? pillNumberInPillSheet = null,}) {
  return _then(_InitialSettingTodayPillNumber(
pageIndex: null == pageIndex ? _self.pageIndex : pageIndex // ignore: cast_nullable_to_non_nullable
as int,pillNumberInPillSheet: null == pillNumberInPillSheet ? _self.pillNumberInPillSheet : pillNumberInPillSheet // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$InitialSettingState {

 List<PillSheetType> get pillSheetTypes; InitialSettingTodayPillNumber? get todayPillNumber; List<ReminderTime> get reminderTimes; bool get isOnReminder; bool get isLoading; bool get settingIsExist; LinkAccountType? get accountType;
/// Create a copy of InitialSettingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InitialSettingStateCopyWith<InitialSettingState> get copyWith => _$InitialSettingStateCopyWithImpl<InitialSettingState>(this as InitialSettingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InitialSettingState&&const DeepCollectionEquality().equals(other.pillSheetTypes, pillSheetTypes)&&(identical(other.todayPillNumber, todayPillNumber) || other.todayPillNumber == todayPillNumber)&&const DeepCollectionEquality().equals(other.reminderTimes, reminderTimes)&&(identical(other.isOnReminder, isOnReminder) || other.isOnReminder == isOnReminder)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.settingIsExist, settingIsExist) || other.settingIsExist == settingIsExist)&&(identical(other.accountType, accountType) || other.accountType == accountType));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(pillSheetTypes),todayPillNumber,const DeepCollectionEquality().hash(reminderTimes),isOnReminder,isLoading,settingIsExist,accountType);

@override
String toString() {
  return 'InitialSettingState(pillSheetTypes: $pillSheetTypes, todayPillNumber: $todayPillNumber, reminderTimes: $reminderTimes, isOnReminder: $isOnReminder, isLoading: $isLoading, settingIsExist: $settingIsExist, accountType: $accountType)';
}


}

/// @nodoc
abstract mixin class $InitialSettingStateCopyWith<$Res>  {
  factory $InitialSettingStateCopyWith(InitialSettingState value, $Res Function(InitialSettingState) _then) = _$InitialSettingStateCopyWithImpl;
@useResult
$Res call({
 List<PillSheetType> pillSheetTypes, InitialSettingTodayPillNumber? todayPillNumber, List<ReminderTime> reminderTimes, bool isOnReminder, bool isLoading, bool settingIsExist, LinkAccountType? accountType
});


$InitialSettingTodayPillNumberCopyWith<$Res>? get todayPillNumber;

}
/// @nodoc
class _$InitialSettingStateCopyWithImpl<$Res>
    implements $InitialSettingStateCopyWith<$Res> {
  _$InitialSettingStateCopyWithImpl(this._self, this._then);

  final InitialSettingState _self;
  final $Res Function(InitialSettingState) _then;

/// Create a copy of InitialSettingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pillSheetTypes = null,Object? todayPillNumber = freezed,Object? reminderTimes = null,Object? isOnReminder = null,Object? isLoading = null,Object? settingIsExist = null,Object? accountType = freezed,}) {
  return _then(_self.copyWith(
pillSheetTypes: null == pillSheetTypes ? _self.pillSheetTypes : pillSheetTypes // ignore: cast_nullable_to_non_nullable
as List<PillSheetType>,todayPillNumber: freezed == todayPillNumber ? _self.todayPillNumber : todayPillNumber // ignore: cast_nullable_to_non_nullable
as InitialSettingTodayPillNumber?,reminderTimes: null == reminderTimes ? _self.reminderTimes : reminderTimes // ignore: cast_nullable_to_non_nullable
as List<ReminderTime>,isOnReminder: null == isOnReminder ? _self.isOnReminder : isOnReminder // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,settingIsExist: null == settingIsExist ? _self.settingIsExist : settingIsExist // ignore: cast_nullable_to_non_nullable
as bool,accountType: freezed == accountType ? _self.accountType : accountType // ignore: cast_nullable_to_non_nullable
as LinkAccountType?,
  ));
}
/// Create a copy of InitialSettingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InitialSettingTodayPillNumberCopyWith<$Res>? get todayPillNumber {
    if (_self.todayPillNumber == null) {
    return null;
  }

  return $InitialSettingTodayPillNumberCopyWith<$Res>(_self.todayPillNumber!, (value) {
    return _then(_self.copyWith(todayPillNumber: value));
  });
}
}


/// Adds pattern-matching-related methods to [InitialSettingState].
extension InitialSettingStatePatterns on InitialSettingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InitialSettingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InitialSettingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InitialSettingState value)  $default,){
final _that = this;
switch (_that) {
case _InitialSettingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InitialSettingState value)?  $default,){
final _that = this;
switch (_that) {
case _InitialSettingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PillSheetType> pillSheetTypes,  InitialSettingTodayPillNumber? todayPillNumber,  List<ReminderTime> reminderTimes,  bool isOnReminder,  bool isLoading,  bool settingIsExist,  LinkAccountType? accountType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InitialSettingState() when $default != null:
return $default(_that.pillSheetTypes,_that.todayPillNumber,_that.reminderTimes,_that.isOnReminder,_that.isLoading,_that.settingIsExist,_that.accountType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PillSheetType> pillSheetTypes,  InitialSettingTodayPillNumber? todayPillNumber,  List<ReminderTime> reminderTimes,  bool isOnReminder,  bool isLoading,  bool settingIsExist,  LinkAccountType? accountType)  $default,) {final _that = this;
switch (_that) {
case _InitialSettingState():
return $default(_that.pillSheetTypes,_that.todayPillNumber,_that.reminderTimes,_that.isOnReminder,_that.isLoading,_that.settingIsExist,_that.accountType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PillSheetType> pillSheetTypes,  InitialSettingTodayPillNumber? todayPillNumber,  List<ReminderTime> reminderTimes,  bool isOnReminder,  bool isLoading,  bool settingIsExist,  LinkAccountType? accountType)?  $default,) {final _that = this;
switch (_that) {
case _InitialSettingState() when $default != null:
return $default(_that.pillSheetTypes,_that.todayPillNumber,_that.reminderTimes,_that.isOnReminder,_that.isLoading,_that.settingIsExist,_that.accountType);case _:
  return null;

}
}

}

/// @nodoc


class _InitialSettingState extends InitialSettingState {
  const _InitialSettingState({final  List<PillSheetType> pillSheetTypes = const [], this.todayPillNumber, required final  List<ReminderTime> reminderTimes, this.isOnReminder = true, this.isLoading = false, this.settingIsExist = false, this.accountType}): _pillSheetTypes = pillSheetTypes,_reminderTimes = reminderTimes,super._();
  

 final  List<PillSheetType> _pillSheetTypes;
@override@JsonKey() List<PillSheetType> get pillSheetTypes {
  if (_pillSheetTypes is EqualUnmodifiableListView) return _pillSheetTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pillSheetTypes);
}

@override final  InitialSettingTodayPillNumber? todayPillNumber;
 final  List<ReminderTime> _reminderTimes;
@override List<ReminderTime> get reminderTimes {
  if (_reminderTimes is EqualUnmodifiableListView) return _reminderTimes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reminderTimes);
}

@override@JsonKey() final  bool isOnReminder;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool settingIsExist;
@override final  LinkAccountType? accountType;

/// Create a copy of InitialSettingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InitialSettingStateCopyWith<_InitialSettingState> get copyWith => __$InitialSettingStateCopyWithImpl<_InitialSettingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InitialSettingState&&const DeepCollectionEquality().equals(other._pillSheetTypes, _pillSheetTypes)&&(identical(other.todayPillNumber, todayPillNumber) || other.todayPillNumber == todayPillNumber)&&const DeepCollectionEquality().equals(other._reminderTimes, _reminderTimes)&&(identical(other.isOnReminder, isOnReminder) || other.isOnReminder == isOnReminder)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.settingIsExist, settingIsExist) || other.settingIsExist == settingIsExist)&&(identical(other.accountType, accountType) || other.accountType == accountType));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_pillSheetTypes),todayPillNumber,const DeepCollectionEquality().hash(_reminderTimes),isOnReminder,isLoading,settingIsExist,accountType);

@override
String toString() {
  return 'InitialSettingState(pillSheetTypes: $pillSheetTypes, todayPillNumber: $todayPillNumber, reminderTimes: $reminderTimes, isOnReminder: $isOnReminder, isLoading: $isLoading, settingIsExist: $settingIsExist, accountType: $accountType)';
}


}

/// @nodoc
abstract mixin class _$InitialSettingStateCopyWith<$Res> implements $InitialSettingStateCopyWith<$Res> {
  factory _$InitialSettingStateCopyWith(_InitialSettingState value, $Res Function(_InitialSettingState) _then) = __$InitialSettingStateCopyWithImpl;
@override @useResult
$Res call({
 List<PillSheetType> pillSheetTypes, InitialSettingTodayPillNumber? todayPillNumber, List<ReminderTime> reminderTimes, bool isOnReminder, bool isLoading, bool settingIsExist, LinkAccountType? accountType
});


@override $InitialSettingTodayPillNumberCopyWith<$Res>? get todayPillNumber;

}
/// @nodoc
class __$InitialSettingStateCopyWithImpl<$Res>
    implements _$InitialSettingStateCopyWith<$Res> {
  __$InitialSettingStateCopyWithImpl(this._self, this._then);

  final _InitialSettingState _self;
  final $Res Function(_InitialSettingState) _then;

/// Create a copy of InitialSettingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pillSheetTypes = null,Object? todayPillNumber = freezed,Object? reminderTimes = null,Object? isOnReminder = null,Object? isLoading = null,Object? settingIsExist = null,Object? accountType = freezed,}) {
  return _then(_InitialSettingState(
pillSheetTypes: null == pillSheetTypes ? _self._pillSheetTypes : pillSheetTypes // ignore: cast_nullable_to_non_nullable
as List<PillSheetType>,todayPillNumber: freezed == todayPillNumber ? _self.todayPillNumber : todayPillNumber // ignore: cast_nullable_to_non_nullable
as InitialSettingTodayPillNumber?,reminderTimes: null == reminderTimes ? _self._reminderTimes : reminderTimes // ignore: cast_nullable_to_non_nullable
as List<ReminderTime>,isOnReminder: null == isOnReminder ? _self.isOnReminder : isOnReminder // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,settingIsExist: null == settingIsExist ? _self.settingIsExist : settingIsExist // ignore: cast_nullable_to_non_nullable
as bool,accountType: freezed == accountType ? _self.accountType : accountType // ignore: cast_nullable_to_non_nullable
as LinkAccountType?,
  ));
}

/// Create a copy of InitialSettingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InitialSettingTodayPillNumberCopyWith<$Res>? get todayPillNumber {
    if (_self.todayPillNumber == null) {
    return null;
  }

  return $InitialSettingTodayPillNumberCopyWith<$Res>(_self.todayPillNumber!, (value) {
    return _then(_self.copyWith(todayPillNumber: value));
  });
}
}

// dart format on
