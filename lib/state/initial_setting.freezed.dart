// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'initial_setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$InitialSettingStateTearOff {
  const _$InitialSettingStateTearOff();

  _InitialSettingState call(InitialSettingModel entity) {
    return _InitialSettingState(
      entity,
    );
  }
}

/// @nodoc
const $InitialSettingState = _$InitialSettingStateTearOff();

/// @nodoc
mixin _$InitialSettingState {
  InitialSettingModel get entity => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $InitialSettingStateCopyWith<InitialSettingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InitialSettingStateCopyWith<$Res> {
  factory $InitialSettingStateCopyWith(
          InitialSettingState value, $Res Function(InitialSettingState) then) =
      _$InitialSettingStateCopyWithImpl<$Res>;
  $Res call({InitialSettingModel entity});

  $InitialSettingModelCopyWith<$Res> get entity;
}

/// @nodoc
class _$InitialSettingStateCopyWithImpl<$Res>
    implements $InitialSettingStateCopyWith<$Res> {
  _$InitialSettingStateCopyWithImpl(this._value, this._then);

  final InitialSettingState _value;
  // ignore: unused_field
  final $Res Function(InitialSettingState) _then;

  @override
  $Res call({
    Object? entity = freezed,
  }) {
    return _then(_value.copyWith(
      entity: entity == freezed
          ? _value.entity
          : entity // ignore: cast_nullable_to_non_nullable
              as InitialSettingModel,
    ));
  }

  @override
  $InitialSettingModelCopyWith<$Res> get entity {
    return $InitialSettingModelCopyWith<$Res>(_value.entity, (value) {
      return _then(_value.copyWith(entity: value));
    });
  }
}

/// @nodoc
abstract class _$InitialSettingStateCopyWith<$Res>
    implements $InitialSettingStateCopyWith<$Res> {
  factory _$InitialSettingStateCopyWith(_InitialSettingState value,
          $Res Function(_InitialSettingState) then) =
      __$InitialSettingStateCopyWithImpl<$Res>;
  @override
  $Res call({InitialSettingModel entity});

  @override
  $InitialSettingModelCopyWith<$Res> get entity;
}

/// @nodoc
class __$InitialSettingStateCopyWithImpl<$Res>
    extends _$InitialSettingStateCopyWithImpl<$Res>
    implements _$InitialSettingStateCopyWith<$Res> {
  __$InitialSettingStateCopyWithImpl(
      _InitialSettingState _value, $Res Function(_InitialSettingState) _then)
      : super(_value, (v) => _then(v as _InitialSettingState));

  @override
  _InitialSettingState get _value => super._value as _InitialSettingState;

  @override
  $Res call({
    Object? entity = freezed,
  }) {
    return _then(_InitialSettingState(
      entity == freezed
          ? _value.entity
          : entity // ignore: cast_nullable_to_non_nullable
              as InitialSettingModel,
    ));
  }
}

/// @nodoc
class _$_InitialSettingState extends _InitialSettingState {
  _$_InitialSettingState(this.entity) : super._();

  @override
  final InitialSettingModel entity;

  @override
  String toString() {
    return 'InitialSettingState(entity: $entity)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _InitialSettingState &&
            (identical(other.entity, entity) ||
                const DeepCollectionEquality().equals(other.entity, entity)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(entity);

  @JsonKey(ignore: true)
  @override
  _$InitialSettingStateCopyWith<_InitialSettingState> get copyWith =>
      __$InitialSettingStateCopyWithImpl<_InitialSettingState>(
          this, _$identity);
}

abstract class _InitialSettingState extends InitialSettingState {
  factory _InitialSettingState(InitialSettingModel entity) =
      _$_InitialSettingState;
  _InitialSettingState._() : super._();

  @override
  InitialSettingModel get entity => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$InitialSettingStateCopyWith<_InitialSettingState> get copyWith =>
      throw _privateConstructorUsedError;
}
