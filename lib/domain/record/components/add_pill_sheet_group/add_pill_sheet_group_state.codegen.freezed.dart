// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'add_pill_sheet_group_state.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$AddPillSheetGroupStateTearOff {
  const _$AddPillSheetGroupStateTearOff();

  _$AddPillSheetGroupState call(
      {PillSheetGroup? pillSheetGroup,
      required PillSheetAppearanceMode pillSheetAppearanceMode}) {
    return _$AddPillSheetGroupState(
      pillSheetGroup: pillSheetGroup,
      pillSheetAppearanceMode: pillSheetAppearanceMode,
    );
  }
}

/// @nodoc
const $AddPillSheetGroupState = _$AddPillSheetGroupStateTearOff();

/// @nodoc
mixin _$AddPillSheetGroupState {
  PillSheetGroup? get pillSheetGroup => throw _privateConstructorUsedError;
  PillSheetAppearanceMode get pillSheetAppearanceMode =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AddPillSheetGroupStateCopyWith<AddPillSheetGroupState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddPillSheetGroupStateCopyWith<$Res> {
  factory $AddPillSheetGroupStateCopyWith(AddPillSheetGroupState value,
          $Res Function(AddPillSheetGroupState) then) =
      _$AddPillSheetGroupStateCopyWithImpl<$Res>;
  $Res call(
      {PillSheetGroup? pillSheetGroup,
      PillSheetAppearanceMode pillSheetAppearanceMode});

  $PillSheetGroupCopyWith<$Res>? get pillSheetGroup;
}

/// @nodoc
class _$AddPillSheetGroupStateCopyWithImpl<$Res>
    implements $AddPillSheetGroupStateCopyWith<$Res> {
  _$AddPillSheetGroupStateCopyWithImpl(this._value, this._then);

  final AddPillSheetGroupState _value;
  // ignore: unused_field
  final $Res Function(AddPillSheetGroupState) _then;

  @override
  $Res call({
    Object? pillSheetGroup = freezed,
    Object? pillSheetAppearanceMode = freezed,
  }) {
    return _then(_value.copyWith(
      pillSheetGroup: pillSheetGroup == freezed
          ? _value.pillSheetGroup
          : pillSheetGroup // ignore: cast_nullable_to_non_nullable
              as PillSheetGroup?,
      pillSheetAppearanceMode: pillSheetAppearanceMode == freezed
          ? _value.pillSheetAppearanceMode
          : pillSheetAppearanceMode // ignore: cast_nullable_to_non_nullable
              as PillSheetAppearanceMode,
    ));
  }

  @override
  $PillSheetGroupCopyWith<$Res>? get pillSheetGroup {
    if (_value.pillSheetGroup == null) {
      return null;
    }

    return $PillSheetGroupCopyWith<$Res>(_value.pillSheetGroup!, (value) {
      return _then(_value.copyWith(pillSheetGroup: value));
    });
  }
}

/// @nodoc
abstract class _$$AddPillSheetGroupStateCopyWith<$Res>
    implements $AddPillSheetGroupStateCopyWith<$Res> {
  factory _$$AddPillSheetGroupStateCopyWith(_$AddPillSheetGroupState value,
          $Res Function(_$AddPillSheetGroupState) then) =
      __$$AddPillSheetGroupStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {PillSheetGroup? pillSheetGroup,
      PillSheetAppearanceMode pillSheetAppearanceMode});

  @override
  $PillSheetGroupCopyWith<$Res>? get pillSheetGroup;
}

/// @nodoc
class __$$AddPillSheetGroupStateCopyWithImpl<$Res>
    extends _$AddPillSheetGroupStateCopyWithImpl<$Res>
    implements _$$AddPillSheetGroupStateCopyWith<$Res> {
  __$$AddPillSheetGroupStateCopyWithImpl(_$AddPillSheetGroupState _value,
      $Res Function(_$AddPillSheetGroupState) _then)
      : super(_value, (v) => _then(v as _$AddPillSheetGroupState));

  @override
  _$AddPillSheetGroupState get _value =>
      super._value as _$AddPillSheetGroupState;

  @override
  $Res call({
    Object? pillSheetGroup = freezed,
    Object? pillSheetAppearanceMode = freezed,
  }) {
    return _then(_$AddPillSheetGroupState(
      pillSheetGroup: pillSheetGroup == freezed
          ? _value.pillSheetGroup
          : pillSheetGroup // ignore: cast_nullable_to_non_nullable
              as PillSheetGroup?,
      pillSheetAppearanceMode: pillSheetAppearanceMode == freezed
          ? _value.pillSheetAppearanceMode
          : pillSheetAppearanceMode // ignore: cast_nullable_to_non_nullable
              as PillSheetAppearanceMode,
    ));
  }
}

/// @nodoc

class _$_$AddPillSheetGroupState extends _$AddPillSheetGroupState {
  _$_$AddPillSheetGroupState(
      {this.pillSheetGroup, required this.pillSheetAppearanceMode})
      : super._();

  @override
  final PillSheetGroup? pillSheetGroup;
  @override
  final PillSheetAppearanceMode pillSheetAppearanceMode;

  @override
  String toString() {
    return 'AddPillSheetGroupState(pillSheetGroup: $pillSheetGroup, pillSheetAppearanceMode: $pillSheetAppearanceMode)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddPillSheetGroupState &&
            const DeepCollectionEquality()
                .equals(other.pillSheetGroup, pillSheetGroup) &&
            const DeepCollectionEquality().equals(
                other.pillSheetAppearanceMode, pillSheetAppearanceMode));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(pillSheetGroup),
      const DeepCollectionEquality().hash(pillSheetAppearanceMode));

  @JsonKey(ignore: true)
  @override
  _$$AddPillSheetGroupStateCopyWith<_$AddPillSheetGroupState> get copyWith =>
      __$$AddPillSheetGroupStateCopyWithImpl<_$AddPillSheetGroupState>(
          this, _$identity);
}

abstract class _$AddPillSheetGroupState extends AddPillSheetGroupState {
  factory _$AddPillSheetGroupState(
          {PillSheetGroup? pillSheetGroup,
          required PillSheetAppearanceMode pillSheetAppearanceMode}) =
      _$_$AddPillSheetGroupState;
  _$AddPillSheetGroupState._() : super._();

  @override
  PillSheetGroup? get pillSheetGroup;
  @override
  PillSheetAppearanceMode get pillSheetAppearanceMode;
  @override
  @JsonKey(ignore: true)
  _$$AddPillSheetGroupStateCopyWith<_$AddPillSheetGroupState> get copyWith =>
      throw _privateConstructorUsedError;
}
