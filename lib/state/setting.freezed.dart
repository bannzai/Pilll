// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$SettingStateTearOff {
  const _$SettingStateTearOff();

  _SettingState call(
      {Setting? entity, required bool userIsUpdatedFrom132 = false}) {
    return _SettingState(
      entity: entity,
      userIsUpdatedFrom132: userIsUpdatedFrom132,
    );
  }
}

/// @nodoc
const $SettingState = _$SettingStateTearOff();

/// @nodoc
mixin _$SettingState {
  Setting? get entity => throw _privateConstructorUsedError;
  bool get userIsUpdatedFrom132 => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SettingStateCopyWith<SettingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingStateCopyWith<$Res> {
  factory $SettingStateCopyWith(
          SettingState value, $Res Function(SettingState) then) =
      _$SettingStateCopyWithImpl<$Res>;
  $Res call({Setting? entity, bool userIsUpdatedFrom132});

  $SettingCopyWith<$Res>? get entity;
}

/// @nodoc
class _$SettingStateCopyWithImpl<$Res> implements $SettingStateCopyWith<$Res> {
  _$SettingStateCopyWithImpl(this._value, this._then);

  final SettingState _value;
  // ignore: unused_field
  final $Res Function(SettingState) _then;

  @override
  $Res call({
    Object? entity = freezed,
    Object? userIsUpdatedFrom132 = freezed,
  }) {
    return _then(_value.copyWith(
      entity: entity == freezed
          ? _value.entity
          : entity // ignore: cast_nullable_to_non_nullable
              as Setting?,
      userIsUpdatedFrom132: userIsUpdatedFrom132 == freezed
          ? _value.userIsUpdatedFrom132
          : userIsUpdatedFrom132 // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  @override
  $SettingCopyWith<$Res>? get entity {
    if (_value.entity == null) {
      return null;
    }

    return $SettingCopyWith<$Res>(_value.entity!, (value) {
      return _then(_value.copyWith(entity: value));
    });
  }
}

/// @nodoc
abstract class _$SettingStateCopyWith<$Res>
    implements $SettingStateCopyWith<$Res> {
  factory _$SettingStateCopyWith(
          _SettingState value, $Res Function(_SettingState) then) =
      __$SettingStateCopyWithImpl<$Res>;
  @override
  $Res call({Setting? entity, bool userIsUpdatedFrom132});

  @override
  $SettingCopyWith<$Res>? get entity;
}

/// @nodoc
class __$SettingStateCopyWithImpl<$Res> extends _$SettingStateCopyWithImpl<$Res>
    implements _$SettingStateCopyWith<$Res> {
  __$SettingStateCopyWithImpl(
      _SettingState _value, $Res Function(_SettingState) _then)
      : super(_value, (v) => _then(v as _SettingState));

  @override
  _SettingState get _value => super._value as _SettingState;

  @override
  $Res call({
    Object? entity = freezed,
    Object? userIsUpdatedFrom132 = freezed,
  }) {
    return _then(_SettingState(
      entity: entity == freezed
          ? _value.entity
          : entity // ignore: cast_nullable_to_non_nullable
              as Setting?,
      userIsUpdatedFrom132: userIsUpdatedFrom132 == freezed
          ? _value.userIsUpdatedFrom132
          : userIsUpdatedFrom132 // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
class _$_SettingState extends _SettingState {
  _$_SettingState({this.entity, required this.userIsUpdatedFrom132 = false})
      : super._();

  @override
  final Setting? entity;
  @JsonKey(defaultValue: false)
  @override
  final bool userIsUpdatedFrom132;

  @override
  String toString() {
    return 'SettingState(entity: $entity, userIsUpdatedFrom132: $userIsUpdatedFrom132)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _SettingState &&
            (identical(other.entity, entity) ||
                const DeepCollectionEquality().equals(other.entity, entity)) &&
            (identical(other.userIsUpdatedFrom132, userIsUpdatedFrom132) ||
                const DeepCollectionEquality()
                    .equals(other.userIsUpdatedFrom132, userIsUpdatedFrom132)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(entity) ^
      const DeepCollectionEquality().hash(userIsUpdatedFrom132);

  @JsonKey(ignore: true)
  @override
  _$SettingStateCopyWith<_SettingState> get copyWith =>
      __$SettingStateCopyWithImpl<_SettingState>(this, _$identity);
}

abstract class _SettingState extends SettingState {
  factory _SettingState({Setting? entity, required bool userIsUpdatedFrom132}) =
      _$_SettingState;
  _SettingState._() : super._();

  @override
  Setting? get entity => throw _privateConstructorUsedError;
  @override
  bool get userIsUpdatedFrom132 => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$SettingStateCopyWith<_SettingState> get copyWith =>
      throw _privateConstructorUsedError;
}
