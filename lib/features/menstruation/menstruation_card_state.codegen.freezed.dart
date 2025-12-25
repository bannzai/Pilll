// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'menstruation_card_state.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MenstruationCardState {

 String get title; DateTime get scheduleDate; String get countdownString;
/// Create a copy of MenstruationCardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MenstruationCardStateCopyWith<MenstruationCardState> get copyWith => _$MenstruationCardStateCopyWithImpl<MenstruationCardState>(this as MenstruationCardState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MenstruationCardState&&(identical(other.title, title) || other.title == title)&&(identical(other.scheduleDate, scheduleDate) || other.scheduleDate == scheduleDate)&&(identical(other.countdownString, countdownString) || other.countdownString == countdownString));
}


@override
int get hashCode => Object.hash(runtimeType,title,scheduleDate,countdownString);

@override
String toString() {
  return 'MenstruationCardState(title: $title, scheduleDate: $scheduleDate, countdownString: $countdownString)';
}


}

/// @nodoc
abstract mixin class $MenstruationCardStateCopyWith<$Res>  {
  factory $MenstruationCardStateCopyWith(MenstruationCardState value, $Res Function(MenstruationCardState) _then) = _$MenstruationCardStateCopyWithImpl;
@useResult
$Res call({
 String title, DateTime scheduleDate, String countdownString
});




}
/// @nodoc
class _$MenstruationCardStateCopyWithImpl<$Res>
    implements $MenstruationCardStateCopyWith<$Res> {
  _$MenstruationCardStateCopyWithImpl(this._self, this._then);

  final MenstruationCardState _self;
  final $Res Function(MenstruationCardState) _then;

/// Create a copy of MenstruationCardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? scheduleDate = null,Object? countdownString = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,scheduleDate: null == scheduleDate ? _self.scheduleDate : scheduleDate // ignore: cast_nullable_to_non_nullable
as DateTime,countdownString: null == countdownString ? _self.countdownString : countdownString // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MenstruationCardState].
extension MenstruationCardStatePatterns on MenstruationCardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MenstruationCardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MenstruationCardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MenstruationCardState value)  $default,){
final _that = this;
switch (_that) {
case _MenstruationCardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MenstruationCardState value)?  $default,){
final _that = this;
switch (_that) {
case _MenstruationCardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  DateTime scheduleDate,  String countdownString)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MenstruationCardState() when $default != null:
return $default(_that.title,_that.scheduleDate,_that.countdownString);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  DateTime scheduleDate,  String countdownString)  $default,) {final _that = this;
switch (_that) {
case _MenstruationCardState():
return $default(_that.title,_that.scheduleDate,_that.countdownString);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  DateTime scheduleDate,  String countdownString)?  $default,) {final _that = this;
switch (_that) {
case _MenstruationCardState() when $default != null:
return $default(_that.title,_that.scheduleDate,_that.countdownString);case _:
  return null;

}
}

}

/// @nodoc


class _MenstruationCardState extends MenstruationCardState {
  const _MenstruationCardState({required this.title, required this.scheduleDate, required this.countdownString}): super._();
  

@override final  String title;
@override final  DateTime scheduleDate;
@override final  String countdownString;

/// Create a copy of MenstruationCardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MenstruationCardStateCopyWith<_MenstruationCardState> get copyWith => __$MenstruationCardStateCopyWithImpl<_MenstruationCardState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MenstruationCardState&&(identical(other.title, title) || other.title == title)&&(identical(other.scheduleDate, scheduleDate) || other.scheduleDate == scheduleDate)&&(identical(other.countdownString, countdownString) || other.countdownString == countdownString));
}


@override
int get hashCode => Object.hash(runtimeType,title,scheduleDate,countdownString);

@override
String toString() {
  return 'MenstruationCardState(title: $title, scheduleDate: $scheduleDate, countdownString: $countdownString)';
}


}

/// @nodoc
abstract mixin class _$MenstruationCardStateCopyWith<$Res> implements $MenstruationCardStateCopyWith<$Res> {
  factory _$MenstruationCardStateCopyWith(_MenstruationCardState value, $Res Function(_MenstruationCardState) _then) = __$MenstruationCardStateCopyWithImpl;
@override @useResult
$Res call({
 String title, DateTime scheduleDate, String countdownString
});




}
/// @nodoc
class __$MenstruationCardStateCopyWithImpl<$Res>
    implements _$MenstruationCardStateCopyWith<$Res> {
  __$MenstruationCardStateCopyWithImpl(this._self, this._then);

  final _MenstruationCardState _self;
  final $Res Function(_MenstruationCardState) _then;

/// Create a copy of MenstruationCardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? scheduleDate = null,Object? countdownString = null,}) {
  return _then(_MenstruationCardState(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,scheduleDate: null == scheduleDate ? _self.scheduleDate : scheduleDate // ignore: cast_nullable_to_non_nullable
as DateTime,countdownString: null == countdownString ? _self.countdownString : countdownString // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
