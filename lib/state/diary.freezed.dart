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
  _DiaryState call({Diary entity}) {
    return _DiaryState(
      entity: entity,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $DiaryState = _$DiaryStateTearOff();

/// @nodoc
mixin _$DiaryState {
  Diary get entity;

  $DiaryStateCopyWith<DiaryState> get copyWith;
}

/// @nodoc
abstract class $DiaryStateCopyWith<$Res> {
  factory $DiaryStateCopyWith(
          DiaryState value, $Res Function(DiaryState) then) =
      _$DiaryStateCopyWithImpl<$Res>;
  $Res call({Diary entity});

  $DiaryCopyWith<$Res> get entity;
}

/// @nodoc
class _$DiaryStateCopyWithImpl<$Res> implements $DiaryStateCopyWith<$Res> {
  _$DiaryStateCopyWithImpl(this._value, this._then);

  final DiaryState _value;
  // ignore: unused_field
  final $Res Function(DiaryState) _then;

  @override
  $Res call({
    Object entity = freezed,
  }) {
    return _then(_value.copyWith(
      entity: entity == freezed ? _value.entity : entity as Diary,
    ));
  }

  @override
  $DiaryCopyWith<$Res> get entity {
    if (_value.entity == null) {
      return null;
    }
    return $DiaryCopyWith<$Res>(_value.entity, (value) {
      return _then(_value.copyWith(entity: value));
    });
  }
}

/// @nodoc
abstract class _$DiaryStateCopyWith<$Res> implements $DiaryStateCopyWith<$Res> {
  factory _$DiaryStateCopyWith(
          _DiaryState value, $Res Function(_DiaryState) then) =
      __$DiaryStateCopyWithImpl<$Res>;
  @override
  $Res call({Diary entity});

  @override
  $DiaryCopyWith<$Res> get entity;
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
    Object entity = freezed,
  }) {
    return _then(_DiaryState(
      entity: entity == freezed ? _value.entity : entity as Diary,
    ));
  }
}

/// @nodoc
class _$_DiaryState extends _DiaryState {
  _$_DiaryState({this.entity}) : super._();

  @override
  final Diary entity;

  @override
  String toString() {
    return 'DiaryState(entity: $entity)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _DiaryState &&
            (identical(other.entity, entity) ||
                const DeepCollectionEquality().equals(other.entity, entity)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(entity);

  @override
  _$DiaryStateCopyWith<_DiaryState> get copyWith =>
      __$DiaryStateCopyWithImpl<_DiaryState>(this, _$identity);
}

abstract class _DiaryState extends DiaryState {
  _DiaryState._() : super._();
  factory _DiaryState({Diary entity}) = _$_DiaryState;

  @override
  Diary get entity;
  @override
  _$DiaryStateCopyWith<_DiaryState> get copyWith;
}
