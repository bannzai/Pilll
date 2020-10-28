// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'diary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$DiaryStateTearOff {
  const _$DiaryStateTearOff();

// ignore: unused_element
  _DiaryState call({List<Diary> entities = const []}) {
    return _DiaryState(
      entities: entities,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $DiaryState = _$DiaryStateTearOff();

/// @nodoc
mixin _$DiaryState {
  List<Diary> get entities;

  $DiaryStateCopyWith<DiaryState> get copyWith;
}

/// @nodoc
abstract class $DiaryStateCopyWith<$Res> {
  factory $DiaryStateCopyWith(
          DiaryState value, $Res Function(DiaryState) then) =
      _$DiaryStateCopyWithImpl<$Res>;
  $Res call({List<Diary> entities});
}

/// @nodoc
class _$DiaryStateCopyWithImpl<$Res> implements $DiaryStateCopyWith<$Res> {
  _$DiaryStateCopyWithImpl(this._value, this._then);

  final DiaryState _value;
  // ignore: unused_field
  final $Res Function(DiaryState) _then;

  @override
  $Res call({
    Object entities = freezed,
  }) {
    return _then(_value.copyWith(
      entities: entities == freezed ? _value.entities : entities as List<Diary>,
    ));
  }
}

/// @nodoc
abstract class _$DiaryStateCopyWith<$Res> implements $DiaryStateCopyWith<$Res> {
  factory _$DiaryStateCopyWith(
          _DiaryState value, $Res Function(_DiaryState) then) =
      __$DiaryStateCopyWithImpl<$Res>;
  @override
  $Res call({List<Diary> entities});
}

/// @nodoc
class __$DiaryStateCopyWithImpl<$Res> extends _$DiaryStateCopyWithImpl<$Res>
    implements _$DiaryStateCopyWith<$Res> {
  __$DiaryStateCopyWithImpl(
      _DiaryState _value, $Res Function(_DiaryState) _then)
      : super(_value, (v) => _then(v as _DiaryState));

  @override
  _DiaryState get _value => super._value as _DiaryState;

  @override
  $Res call({
    Object entities = freezed,
  }) {
    return _then(_DiaryState(
      entities: entities == freezed ? _value.entities : entities as List<Diary>,
    ));
  }
}

/// @nodoc
class _$_DiaryState extends _DiaryState {
  _$_DiaryState({this.entities = const []})
      : assert(entities != null),
        super._();

  @JsonKey(defaultValue: const [])
  @override
  final List<Diary> entities;

  @override
  String toString() {
    return 'DiaryState(entities: $entities)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _DiaryState &&
            (identical(other.entities, entities) ||
                const DeepCollectionEquality()
                    .equals(other.entities, entities)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(entities);

  @override
  _$DiaryStateCopyWith<_DiaryState> get copyWith =>
      __$DiaryStateCopyWithImpl<_DiaryState>(this, _$identity);
}

abstract class _DiaryState extends DiaryState {
  _DiaryState._() : super._();
  factory _DiaryState({List<Diary> entities}) = _$_DiaryState;

  @override
  List<Diary> get entities;
  @override
  _$DiaryStateCopyWith<_DiaryState> get copyWith;
}
