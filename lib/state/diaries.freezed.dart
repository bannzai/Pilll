// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'diaries.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$DiariesStateTearOff {
  const _$DiariesStateTearOff();

  _DiariesState call({List<Diary> entities = const []}) {
    return _DiariesState(
      entities: entities,
    );
  }
}

/// @nodoc
const $DiariesState = _$DiariesStateTearOff();

/// @nodoc
mixin _$DiariesState {
  List<Diary> get entities => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DiariesStateCopyWith<DiariesState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiariesStateCopyWith<$Res> {
  factory $DiariesStateCopyWith(
          DiariesState value, $Res Function(DiariesState) then) =
      _$DiariesStateCopyWithImpl<$Res>;
  $Res call({List<Diary> entities});
}

/// @nodoc
class _$DiariesStateCopyWithImpl<$Res> implements $DiariesStateCopyWith<$Res> {
  _$DiariesStateCopyWithImpl(this._value, this._then);

  final DiariesState _value;
  // ignore: unused_field
  final $Res Function(DiariesState) _then;

  @override
  $Res call({
    Object? entities = freezed,
  }) {
    return _then(_value.copyWith(
      entities: entities == freezed
          ? _value.entities
          : entities // ignore: cast_nullable_to_non_nullable
              as List<Diary>,
    ));
  }
}

/// @nodoc
abstract class _$DiariesStateCopyWith<$Res>
    implements $DiariesStateCopyWith<$Res> {
  factory _$DiariesStateCopyWith(
          _DiariesState value, $Res Function(_DiariesState) then) =
      __$DiariesStateCopyWithImpl<$Res>;
  @override
  $Res call({List<Diary> entities});
}

/// @nodoc
class __$DiariesStateCopyWithImpl<$Res> extends _$DiariesStateCopyWithImpl<$Res>
    implements _$DiariesStateCopyWith<$Res> {
  __$DiariesStateCopyWithImpl(
      _DiariesState _value, $Res Function(_DiariesState) _then)
      : super(_value, (v) => _then(v as _DiariesState));

  @override
  _DiariesState get _value => super._value as _DiariesState;

  @override
  $Res call({
    Object? entities = freezed,
  }) {
    return _then(_DiariesState(
      entities: entities == freezed
          ? _value.entities
          : entities // ignore: cast_nullable_to_non_nullable
              as List<Diary>,
    ));
  }
}

/// @nodoc

class _$_DiariesState extends _DiariesState {
  _$_DiariesState({this.entities = const []}) : super._();

  @JsonKey(defaultValue: const [])
  @override
  final List<Diary> entities;

  @override
  String toString() {
    return 'DiariesState(entities: $entities)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _DiariesState &&
            (identical(other.entities, entities) ||
                const DeepCollectionEquality()
                    .equals(other.entities, entities)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(entities);

  @JsonKey(ignore: true)
  @override
  _$DiariesStateCopyWith<_DiariesState> get copyWith =>
      __$DiariesStateCopyWithImpl<_DiariesState>(this, _$identity);
}

abstract class _DiariesState extends DiariesState {
  factory _DiariesState({List<Diary> entities}) = _$_DiariesState;
  _DiariesState._() : super._();

  @override
  List<Diary> get entities => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$DiariesStateCopyWith<_DiariesState> get copyWith =>
      throw _privateConstructorUsedError;
}
