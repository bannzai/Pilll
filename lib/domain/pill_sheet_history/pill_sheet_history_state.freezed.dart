// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'pill_sheet_history_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PillSheetHistoryStateTearOff {
  const _$PillSheetHistoryStateTearOff();

  _PillSheetHistoryState call({List<PillSheet> pillSheets = const []}) {
    return _PillSheetHistoryState(
      pillSheets: pillSheets,
    );
  }
}

/// @nodoc
const $PillSheetHistoryState = _$PillSheetHistoryStateTearOff();

/// @nodoc
mixin _$PillSheetHistoryState {
  List<PillSheet> get pillSheets => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PillSheetHistoryStateCopyWith<PillSheetHistoryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PillSheetHistoryStateCopyWith<$Res> {
  factory $PillSheetHistoryStateCopyWith(PillSheetHistoryState value,
          $Res Function(PillSheetHistoryState) then) =
      _$PillSheetHistoryStateCopyWithImpl<$Res>;
  $Res call({List<PillSheet> pillSheets});
}

/// @nodoc
class _$PillSheetHistoryStateCopyWithImpl<$Res>
    implements $PillSheetHistoryStateCopyWith<$Res> {
  _$PillSheetHistoryStateCopyWithImpl(this._value, this._then);

  final PillSheetHistoryState _value;
  // ignore: unused_field
  final $Res Function(PillSheetHistoryState) _then;

  @override
  $Res call({
    Object? pillSheets = freezed,
  }) {
    return _then(_value.copyWith(
      pillSheets: pillSheets == freezed
          ? _value.pillSheets
          : pillSheets // ignore: cast_nullable_to_non_nullable
              as List<PillSheet>,
    ));
  }
}

/// @nodoc
abstract class _$PillSheetHistoryStateCopyWith<$Res>
    implements $PillSheetHistoryStateCopyWith<$Res> {
  factory _$PillSheetHistoryStateCopyWith(_PillSheetHistoryState value,
          $Res Function(_PillSheetHistoryState) then) =
      __$PillSheetHistoryStateCopyWithImpl<$Res>;
  @override
  $Res call({List<PillSheet> pillSheets});
}

/// @nodoc
class __$PillSheetHistoryStateCopyWithImpl<$Res>
    extends _$PillSheetHistoryStateCopyWithImpl<$Res>
    implements _$PillSheetHistoryStateCopyWith<$Res> {
  __$PillSheetHistoryStateCopyWithImpl(_PillSheetHistoryState _value,
      $Res Function(_PillSheetHistoryState) _then)
      : super(_value, (v) => _then(v as _PillSheetHistoryState));

  @override
  _PillSheetHistoryState get _value => super._value as _PillSheetHistoryState;

  @override
  $Res call({
    Object? pillSheets = freezed,
  }) {
    return _then(_PillSheetHistoryState(
      pillSheets: pillSheets == freezed
          ? _value.pillSheets
          : pillSheets // ignore: cast_nullable_to_non_nullable
              as List<PillSheet>,
    ));
  }
}

/// @nodoc

class _$_PillSheetHistoryState extends _PillSheetHistoryState {
  _$_PillSheetHistoryState({this.pillSheets = const []}) : super._();

  @JsonKey(defaultValue: const [])
  @override
  final List<PillSheet> pillSheets;

  @override
  String toString() {
    return 'PillSheetHistoryState(pillSheets: $pillSheets)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _PillSheetHistoryState &&
            (identical(other.pillSheets, pillSheets) ||
                const DeepCollectionEquality()
                    .equals(other.pillSheets, pillSheets)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(pillSheets);

  @JsonKey(ignore: true)
  @override
  _$PillSheetHistoryStateCopyWith<_PillSheetHistoryState> get copyWith =>
      __$PillSheetHistoryStateCopyWithImpl<_PillSheetHistoryState>(
          this, _$identity);
}

abstract class _PillSheetHistoryState extends PillSheetHistoryState {
  factory _PillSheetHistoryState({List<PillSheet> pillSheets}) =
      _$_PillSheetHistoryState;
  _PillSheetHistoryState._() : super._();

  @override
  List<PillSheet> get pillSheets => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$PillSheetHistoryStateCopyWith<_PillSheetHistoryState> get copyWith =>
      throw _privateConstructorUsedError;
}
