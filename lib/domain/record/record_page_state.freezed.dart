// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'record_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$RecordPageStateTearOff {
  const _$RecordPageStateTearOff();

  _RecordPageState call(
      {required PillSheet? entity,
      Setting? setting,
      bool firstLoadIsEnded = false}) {
    return _RecordPageState(
      entity: entity,
      setting: setting,
      firstLoadIsEnded: firstLoadIsEnded,
    );
  }
}

/// @nodoc
const $RecordPageState = _$RecordPageStateTearOff();

/// @nodoc
mixin _$RecordPageState {
  PillSheet? get entity => throw _privateConstructorUsedError;
  Setting? get setting => throw _privateConstructorUsedError;
  bool get firstLoadIsEnded => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RecordPageStateCopyWith<RecordPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecordPageStateCopyWith<$Res> {
  factory $RecordPageStateCopyWith(
          RecordPageState value, $Res Function(RecordPageState) then) =
      _$RecordPageStateCopyWithImpl<$Res>;
  $Res call({PillSheet? entity, Setting? setting, bool firstLoadIsEnded});

  $PillSheetModelCopyWith<$Res>? get entity;
  $SettingCopyWith<$Res>? get setting;
}

/// @nodoc
class _$RecordPageStateCopyWithImpl<$Res>
    implements $RecordPageStateCopyWith<$Res> {
  _$RecordPageStateCopyWithImpl(this._value, this._then);

  final RecordPageState _value;
  // ignore: unused_field
  final $Res Function(RecordPageState) _then;

  @override
  $Res call({
    Object? entity = freezed,
    Object? setting = freezed,
    Object? firstLoadIsEnded = freezed,
  }) {
    return _then(_value.copyWith(
      entity: entity == freezed
          ? _value.entity
          : entity // ignore: cast_nullable_to_non_nullable
              as PillSheet?,
      setting: setting == freezed
          ? _value.setting
          : setting // ignore: cast_nullable_to_non_nullable
              as Setting?,
      firstLoadIsEnded: firstLoadIsEnded == freezed
          ? _value.firstLoadIsEnded
          : firstLoadIsEnded // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  @override
  $PillSheetModelCopyWith<$Res>? get entity {
    if (_value.entity == null) {
      return null;
    }

    return $PillSheetModelCopyWith<$Res>(_value.entity!, (value) {
      return _then(_value.copyWith(entity: value));
    });
  }

  @override
  $SettingCopyWith<$Res>? get setting {
    if (_value.setting == null) {
      return null;
    }

    return $SettingCopyWith<$Res>(_value.setting!, (value) {
      return _then(_value.copyWith(setting: value));
    });
  }
}

/// @nodoc
abstract class _$RecordPageStateCopyWith<$Res>
    implements $RecordPageStateCopyWith<$Res> {
  factory _$RecordPageStateCopyWith(
          _RecordPageState value, $Res Function(_RecordPageState) then) =
      __$RecordPageStateCopyWithImpl<$Res>;
  @override
  $Res call({PillSheet? entity, Setting? setting, bool firstLoadIsEnded});

  @override
  $PillSheetModelCopyWith<$Res>? get entity;
  @override
  $SettingCopyWith<$Res>? get setting;
}

/// @nodoc
class __$RecordPageStateCopyWithImpl<$Res>
    extends _$RecordPageStateCopyWithImpl<$Res>
    implements _$RecordPageStateCopyWith<$Res> {
  __$RecordPageStateCopyWithImpl(
      _RecordPageState _value, $Res Function(_RecordPageState) _then)
      : super(_value, (v) => _then(v as _RecordPageState));

  @override
  _RecordPageState get _value => super._value as _RecordPageState;

  @override
  $Res call({
    Object? entity = freezed,
    Object? setting = freezed,
    Object? firstLoadIsEnded = freezed,
  }) {
    return _then(_RecordPageState(
      entity: entity == freezed
          ? _value.entity
          : entity // ignore: cast_nullable_to_non_nullable
              as PillSheet?,
      setting: setting == freezed
          ? _value.setting
          : setting // ignore: cast_nullable_to_non_nullable
              as Setting?,
      firstLoadIsEnded: firstLoadIsEnded == freezed
          ? _value.firstLoadIsEnded
          : firstLoadIsEnded // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_RecordPageState extends _RecordPageState {
  _$_RecordPageState(
      {required this.entity, this.setting, this.firstLoadIsEnded = false})
      : super._();

  @override
  final PillSheet? entity;
  @override
  final Setting? setting;
  @JsonKey(defaultValue: false)
  @override
  final bool firstLoadIsEnded;

  @override
  String toString() {
    return 'RecordPageState(entity: $entity, setting: $setting, firstLoadIsEnded: $firstLoadIsEnded)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _RecordPageState &&
            (identical(other.entity, entity) ||
                const DeepCollectionEquality().equals(other.entity, entity)) &&
            (identical(other.setting, setting) ||
                const DeepCollectionEquality()
                    .equals(other.setting, setting)) &&
            (identical(other.firstLoadIsEnded, firstLoadIsEnded) ||
                const DeepCollectionEquality()
                    .equals(other.firstLoadIsEnded, firstLoadIsEnded)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(entity) ^
      const DeepCollectionEquality().hash(setting) ^
      const DeepCollectionEquality().hash(firstLoadIsEnded);

  @JsonKey(ignore: true)
  @override
  _$RecordPageStateCopyWith<_RecordPageState> get copyWith =>
      __$RecordPageStateCopyWithImpl<_RecordPageState>(this, _$identity);
}

abstract class _RecordPageState extends RecordPageState {
  factory _RecordPageState(
      {required PillSheet? entity,
      Setting? setting,
      bool firstLoadIsEnded}) = _$_RecordPageState;
  _RecordPageState._() : super._();

  @override
  PillSheet? get entity => throw _privateConstructorUsedError;
  @override
  Setting? get setting => throw _privateConstructorUsedError;
  @override
  bool get firstLoadIsEnded => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$RecordPageStateCopyWith<_RecordPageState> get copyWith =>
      throw _privateConstructorUsedError;
}
