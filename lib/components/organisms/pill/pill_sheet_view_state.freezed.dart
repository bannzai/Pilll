// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'pill_sheet_view_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PillSheetViewStateTearOff {
  const _$PillSheetViewStateTearOff();

  _PillSheetViewState call({required PillSheet pillSheet}) {
    return _PillSheetViewState(
      pillSheet: pillSheet,
    );
  }
}

/// @nodoc
const $PillSheetViewState = _$PillSheetViewStateTearOff();

/// @nodoc
mixin _$PillSheetViewState {
  PillSheet get pillSheet => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PillSheetViewStateCopyWith<PillSheetViewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PillSheetViewStateCopyWith<$Res> {
  factory $PillSheetViewStateCopyWith(
          PillSheetViewState value, $Res Function(PillSheetViewState) then) =
      _$PillSheetViewStateCopyWithImpl<$Res>;
  $Res call({PillSheet pillSheet});

  $PillSheetCopyWith<$Res> get pillSheet;
}

/// @nodoc
class _$PillSheetViewStateCopyWithImpl<$Res>
    implements $PillSheetViewStateCopyWith<$Res> {
  _$PillSheetViewStateCopyWithImpl(this._value, this._then);

  final PillSheetViewState _value;
  // ignore: unused_field
  final $Res Function(PillSheetViewState) _then;

  @override
  $Res call({
    Object? pillSheet = freezed,
  }) {
    return _then(_value.copyWith(
      pillSheet: pillSheet == freezed
          ? _value.pillSheet
          : pillSheet // ignore: cast_nullable_to_non_nullable
              as PillSheet,
    ));
  }

  @override
  $PillSheetCopyWith<$Res> get pillSheet {
    return $PillSheetCopyWith<$Res>(_value.pillSheet, (value) {
      return _then(_value.copyWith(pillSheet: value));
    });
  }
}

/// @nodoc
abstract class _$PillSheetViewStateCopyWith<$Res>
    implements $PillSheetViewStateCopyWith<$Res> {
  factory _$PillSheetViewStateCopyWith(
          _PillSheetViewState value, $Res Function(_PillSheetViewState) then) =
      __$PillSheetViewStateCopyWithImpl<$Res>;
  @override
  $Res call({PillSheet pillSheet});

  @override
  $PillSheetCopyWith<$Res> get pillSheet;
}

/// @nodoc
class __$PillSheetViewStateCopyWithImpl<$Res>
    extends _$PillSheetViewStateCopyWithImpl<$Res>
    implements _$PillSheetViewStateCopyWith<$Res> {
  __$PillSheetViewStateCopyWithImpl(
      _PillSheetViewState _value, $Res Function(_PillSheetViewState) _then)
      : super(_value, (v) => _then(v as _PillSheetViewState));

  @override
  _PillSheetViewState get _value => super._value as _PillSheetViewState;

  @override
  $Res call({
    Object? pillSheet = freezed,
  }) {
    return _then(_PillSheetViewState(
      pillSheet: pillSheet == freezed
          ? _value.pillSheet
          : pillSheet // ignore: cast_nullable_to_non_nullable
              as PillSheet,
    ));
  }
}

/// @nodoc

class _$_PillSheetViewState extends _PillSheetViewState {
  _$_PillSheetViewState({required this.pillSheet}) : super._();

  @override
  final PillSheet pillSheet;

  @override
  String toString() {
    return 'PillSheetViewState(pillSheet: $pillSheet)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _PillSheetViewState &&
            (identical(other.pillSheet, pillSheet) ||
                const DeepCollectionEquality()
                    .equals(other.pillSheet, pillSheet)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(pillSheet);

  @JsonKey(ignore: true)
  @override
  _$PillSheetViewStateCopyWith<_PillSheetViewState> get copyWith =>
      __$PillSheetViewStateCopyWithImpl<_PillSheetViewState>(this, _$identity);
}

abstract class _PillSheetViewState extends PillSheetViewState {
  factory _PillSheetViewState({required PillSheet pillSheet}) =
      _$_PillSheetViewState;
  _PillSheetViewState._() : super._();

  @override
  PillSheet get pillSheet => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$PillSheetViewStateCopyWith<_PillSheetViewState> get copyWith =>
      throw _privateConstructorUsedError;
}
