// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'state.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$DisplayNumberSettingStateTearOff {
  const _$DisplayNumberSettingStateTearOff();

  _DisplayNumberSettingState call(
      {PillSheetGroup? beforePillSheetGroup,
      required PillSheetGroup pillSheetGroup}) {
    return _DisplayNumberSettingState(
      beforePillSheetGroup: beforePillSheetGroup,
      pillSheetGroup: pillSheetGroup,
    );
  }
}

/// @nodoc
const $DisplayNumberSettingState = _$DisplayNumberSettingStateTearOff();

/// @nodoc
mixin _$DisplayNumberSettingState {
  PillSheetGroup? get beforePillSheetGroup =>
      throw _privateConstructorUsedError;
  PillSheetGroup get pillSheetGroup => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DisplayNumberSettingStateCopyWith<DisplayNumberSettingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DisplayNumberSettingStateCopyWith<$Res> {
  factory $DisplayNumberSettingStateCopyWith(DisplayNumberSettingState value,
          $Res Function(DisplayNumberSettingState) then) =
      _$DisplayNumberSettingStateCopyWithImpl<$Res>;
  $Res call(
      {PillSheetGroup? beforePillSheetGroup, PillSheetGroup pillSheetGroup});

  $PillSheetGroupCopyWith<$Res>? get beforePillSheetGroup;
  $PillSheetGroupCopyWith<$Res> get pillSheetGroup;
}

/// @nodoc
class _$DisplayNumberSettingStateCopyWithImpl<$Res>
    implements $DisplayNumberSettingStateCopyWith<$Res> {
  _$DisplayNumberSettingStateCopyWithImpl(this._value, this._then);

  final DisplayNumberSettingState _value;
  // ignore: unused_field
  final $Res Function(DisplayNumberSettingState) _then;

  @override
  $Res call({
    Object? beforePillSheetGroup = freezed,
    Object? pillSheetGroup = freezed,
  }) {
    return _then(_value.copyWith(
      beforePillSheetGroup: beforePillSheetGroup == freezed
          ? _value.beforePillSheetGroup
          : beforePillSheetGroup // ignore: cast_nullable_to_non_nullable
              as PillSheetGroup?,
      pillSheetGroup: pillSheetGroup == freezed
          ? _value.pillSheetGroup
          : pillSheetGroup // ignore: cast_nullable_to_non_nullable
              as PillSheetGroup,
    ));
  }

  @override
  $PillSheetGroupCopyWith<$Res>? get beforePillSheetGroup {
    if (_value.beforePillSheetGroup == null) {
      return null;
    }

    return $PillSheetGroupCopyWith<$Res>(_value.beforePillSheetGroup!, (value) {
      return _then(_value.copyWith(beforePillSheetGroup: value));
    });
  }

  @override
  $PillSheetGroupCopyWith<$Res> get pillSheetGroup {
    return $PillSheetGroupCopyWith<$Res>(_value.pillSheetGroup, (value) {
      return _then(_value.copyWith(pillSheetGroup: value));
    });
  }
}

/// @nodoc
abstract class _$DisplayNumberSettingStateCopyWith<$Res>
    implements $DisplayNumberSettingStateCopyWith<$Res> {
  factory _$DisplayNumberSettingStateCopyWith(_DisplayNumberSettingState value,
          $Res Function(_DisplayNumberSettingState) then) =
      __$DisplayNumberSettingStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {PillSheetGroup? beforePillSheetGroup, PillSheetGroup pillSheetGroup});

  @override
  $PillSheetGroupCopyWith<$Res>? get beforePillSheetGroup;
  @override
  $PillSheetGroupCopyWith<$Res> get pillSheetGroup;
}

/// @nodoc
class __$DisplayNumberSettingStateCopyWithImpl<$Res>
    extends _$DisplayNumberSettingStateCopyWithImpl<$Res>
    implements _$DisplayNumberSettingStateCopyWith<$Res> {
  __$DisplayNumberSettingStateCopyWithImpl(_DisplayNumberSettingState _value,
      $Res Function(_DisplayNumberSettingState) _then)
      : super(_value, (v) => _then(v as _DisplayNumberSettingState));

  @override
  _DisplayNumberSettingState get _value =>
      super._value as _DisplayNumberSettingState;

  @override
  $Res call({
    Object? beforePillSheetGroup = freezed,
    Object? pillSheetGroup = freezed,
  }) {
    return _then(_DisplayNumberSettingState(
      beforePillSheetGroup: beforePillSheetGroup == freezed
          ? _value.beforePillSheetGroup
          : beforePillSheetGroup // ignore: cast_nullable_to_non_nullable
              as PillSheetGroup?,
      pillSheetGroup: pillSheetGroup == freezed
          ? _value.pillSheetGroup
          : pillSheetGroup // ignore: cast_nullable_to_non_nullable
              as PillSheetGroup,
    ));
  }
}

/// @nodoc

class _$_DisplayNumberSettingState extends _DisplayNumberSettingState {
  _$_DisplayNumberSettingState(
      {this.beforePillSheetGroup, required this.pillSheetGroup})
      : super._();

  @override
  final PillSheetGroup? beforePillSheetGroup;
  @override
  final PillSheetGroup pillSheetGroup;

  @override
  String toString() {
    return 'DisplayNumberSettingState(beforePillSheetGroup: $beforePillSheetGroup, pillSheetGroup: $pillSheetGroup)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DisplayNumberSettingState &&
            const DeepCollectionEquality()
                .equals(other.beforePillSheetGroup, beforePillSheetGroup) &&
            const DeepCollectionEquality()
                .equals(other.pillSheetGroup, pillSheetGroup));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(beforePillSheetGroup),
      const DeepCollectionEquality().hash(pillSheetGroup));

  @JsonKey(ignore: true)
  @override
  _$DisplayNumberSettingStateCopyWith<_DisplayNumberSettingState>
      get copyWith =>
          __$DisplayNumberSettingStateCopyWithImpl<_DisplayNumberSettingState>(
              this, _$identity);
}

abstract class _DisplayNumberSettingState extends DisplayNumberSettingState {
  factory _DisplayNumberSettingState(
      {PillSheetGroup? beforePillSheetGroup,
      required PillSheetGroup pillSheetGroup}) = _$_DisplayNumberSettingState;
  _DisplayNumberSettingState._() : super._();

  @override
  PillSheetGroup? get beforePillSheetGroup;
  @override
  PillSheetGroup get pillSheetGroup;
  @override
  @JsonKey(ignore: true)
  _$DisplayNumberSettingStateCopyWith<_DisplayNumberSettingState>
      get copyWith => throw _privateConstructorUsedError;
}
