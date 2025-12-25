// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'state.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiarySettingPhysicalConditionDetailState {

 DiarySetting? get diarySetting;
/// Create a copy of DiarySettingPhysicalConditionDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiarySettingPhysicalConditionDetailStateCopyWith<DiarySettingPhysicalConditionDetailState> get copyWith => _$DiarySettingPhysicalConditionDetailStateCopyWithImpl<DiarySettingPhysicalConditionDetailState>(this as DiarySettingPhysicalConditionDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiarySettingPhysicalConditionDetailState&&(identical(other.diarySetting, diarySetting) || other.diarySetting == diarySetting));
}


@override
int get hashCode => Object.hash(runtimeType,diarySetting);

@override
String toString() {
  return 'DiarySettingPhysicalConditionDetailState(diarySetting: $diarySetting)';
}


}

/// @nodoc
abstract mixin class $DiarySettingPhysicalConditionDetailStateCopyWith<$Res>  {
  factory $DiarySettingPhysicalConditionDetailStateCopyWith(DiarySettingPhysicalConditionDetailState value, $Res Function(DiarySettingPhysicalConditionDetailState) _then) = _$DiarySettingPhysicalConditionDetailStateCopyWithImpl;
@useResult
$Res call({
 DiarySetting? diarySetting
});


$DiarySettingCopyWith<$Res>? get diarySetting;

}
/// @nodoc
class _$DiarySettingPhysicalConditionDetailStateCopyWithImpl<$Res>
    implements $DiarySettingPhysicalConditionDetailStateCopyWith<$Res> {
  _$DiarySettingPhysicalConditionDetailStateCopyWithImpl(this._self, this._then);

  final DiarySettingPhysicalConditionDetailState _self;
  final $Res Function(DiarySettingPhysicalConditionDetailState) _then;

/// Create a copy of DiarySettingPhysicalConditionDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? diarySetting = freezed,}) {
  return _then(_self.copyWith(
diarySetting: freezed == diarySetting ? _self.diarySetting : diarySetting // ignore: cast_nullable_to_non_nullable
as DiarySetting?,
  ));
}
/// Create a copy of DiarySettingPhysicalConditionDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiarySettingCopyWith<$Res>? get diarySetting {
    if (_self.diarySetting == null) {
    return null;
  }

  return $DiarySettingCopyWith<$Res>(_self.diarySetting!, (value) {
    return _then(_self.copyWith(diarySetting: value));
  });
}
}


/// Adds pattern-matching-related methods to [DiarySettingPhysicalConditionDetailState].
extension DiarySettingPhysicalConditionDetailStatePatterns on DiarySettingPhysicalConditionDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiarySettingPhysicalConditionDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiarySettingPhysicalConditionDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiarySettingPhysicalConditionDetailState value)  $default,){
final _that = this;
switch (_that) {
case _DiarySettingPhysicalConditionDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiarySettingPhysicalConditionDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _DiarySettingPhysicalConditionDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DiarySetting? diarySetting)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiarySettingPhysicalConditionDetailState() when $default != null:
return $default(_that.diarySetting);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DiarySetting? diarySetting)  $default,) {final _that = this;
switch (_that) {
case _DiarySettingPhysicalConditionDetailState():
return $default(_that.diarySetting);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DiarySetting? diarySetting)?  $default,) {final _that = this;
switch (_that) {
case _DiarySettingPhysicalConditionDetailState() when $default != null:
return $default(_that.diarySetting);case _:
  return null;

}
}

}

/// @nodoc


class _DiarySettingPhysicalConditionDetailState extends DiarySettingPhysicalConditionDetailState {
   _DiarySettingPhysicalConditionDetailState({required this.diarySetting}): super._();
  

@override final  DiarySetting? diarySetting;

/// Create a copy of DiarySettingPhysicalConditionDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiarySettingPhysicalConditionDetailStateCopyWith<_DiarySettingPhysicalConditionDetailState> get copyWith => __$DiarySettingPhysicalConditionDetailStateCopyWithImpl<_DiarySettingPhysicalConditionDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiarySettingPhysicalConditionDetailState&&(identical(other.diarySetting, diarySetting) || other.diarySetting == diarySetting));
}


@override
int get hashCode => Object.hash(runtimeType,diarySetting);

@override
String toString() {
  return 'DiarySettingPhysicalConditionDetailState(diarySetting: $diarySetting)';
}


}

/// @nodoc
abstract mixin class _$DiarySettingPhysicalConditionDetailStateCopyWith<$Res> implements $DiarySettingPhysicalConditionDetailStateCopyWith<$Res> {
  factory _$DiarySettingPhysicalConditionDetailStateCopyWith(_DiarySettingPhysicalConditionDetailState value, $Res Function(_DiarySettingPhysicalConditionDetailState) _then) = __$DiarySettingPhysicalConditionDetailStateCopyWithImpl;
@override @useResult
$Res call({
 DiarySetting? diarySetting
});


@override $DiarySettingCopyWith<$Res>? get diarySetting;

}
/// @nodoc
class __$DiarySettingPhysicalConditionDetailStateCopyWithImpl<$Res>
    implements _$DiarySettingPhysicalConditionDetailStateCopyWith<$Res> {
  __$DiarySettingPhysicalConditionDetailStateCopyWithImpl(this._self, this._then);

  final _DiarySettingPhysicalConditionDetailState _self;
  final $Res Function(_DiarySettingPhysicalConditionDetailState) _then;

/// Create a copy of DiarySettingPhysicalConditionDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? diarySetting = freezed,}) {
  return _then(_DiarySettingPhysicalConditionDetailState(
diarySetting: freezed == diarySetting ? _self.diarySetting : diarySetting // ignore: cast_nullable_to_non_nullable
as DiarySetting?,
  ));
}

/// Create a copy of DiarySettingPhysicalConditionDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiarySettingCopyWith<$Res>? get diarySetting {
    if (_self.diarySetting == null) {
    return null;
  }

  return $DiarySettingCopyWith<$Res>(_self.diarySetting!, (value) {
    return _then(_self.copyWith(diarySetting: value));
  });
}
}

// dart format on
