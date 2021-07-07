// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'pill_sheet_type_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PillSheetTypeStateTearOff {
  const _$PillSheetTypeStateTearOff();

  _PillSheetTypeState call(
      {required Setting? setting,
      required PillSheet? pillSheet,
      Object? exception}) {
    return _PillSheetTypeState(
      setting: setting,
      pillSheet: pillSheet,
      exception: exception,
    );
  }
}

/// @nodoc
const $PillSheetTypeState = _$PillSheetTypeStateTearOff();

/// @nodoc
mixin _$PillSheetTypeState {
  Setting? get setting => throw _privateConstructorUsedError;
  PillSheet? get pillSheet => throw _privateConstructorUsedError;
  Object? get exception => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PillSheetTypeStateCopyWith<PillSheetTypeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PillSheetTypeStateCopyWith<$Res> {
  factory $PillSheetTypeStateCopyWith(
          PillSheetTypeState value, $Res Function(PillSheetTypeState) then) =
      _$PillSheetTypeStateCopyWithImpl<$Res>;
  $Res call({Setting? setting, PillSheet? pillSheet, Object? exception});

  $SettingCopyWith<$Res>? get setting;
  $PillSheetCopyWith<$Res>? get pillSheet;
}

/// @nodoc
class _$PillSheetTypeStateCopyWithImpl<$Res>
    implements $PillSheetTypeStateCopyWith<$Res> {
  _$PillSheetTypeStateCopyWithImpl(this._value, this._then);

  final PillSheetTypeState _value;
  // ignore: unused_field
  final $Res Function(PillSheetTypeState) _then;

  @override
  $Res call({
    Object? setting = freezed,
    Object? pillSheet = freezed,
    Object? exception = freezed,
  }) {
    return _then(_value.copyWith(
      setting: setting == freezed
          ? _value.setting
          : setting // ignore: cast_nullable_to_non_nullable
              as Setting?,
      pillSheet: pillSheet == freezed
          ? _value.pillSheet
          : pillSheet // ignore: cast_nullable_to_non_nullable
              as PillSheet?,
      exception: exception == freezed ? _value.exception : exception,
    ));
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

  @override
  $PillSheetCopyWith<$Res>? get pillSheet {
    if (_value.pillSheet == null) {
      return null;
    }

    return $PillSheetCopyWith<$Res>(_value.pillSheet!, (value) {
      return _then(_value.copyWith(pillSheet: value));
    });
  }
}

/// @nodoc
abstract class _$PillSheetTypeStateCopyWith<$Res>
    implements $PillSheetTypeStateCopyWith<$Res> {
  factory _$PillSheetTypeStateCopyWith(
          _PillSheetTypeState value, $Res Function(_PillSheetTypeState) then) =
      __$PillSheetTypeStateCopyWithImpl<$Res>;
  @override
  $Res call({Setting? setting, PillSheet? pillSheet, Object? exception});

  @override
  $SettingCopyWith<$Res>? get setting;
  @override
  $PillSheetCopyWith<$Res>? get pillSheet;
}

/// @nodoc
class __$PillSheetTypeStateCopyWithImpl<$Res>
    extends _$PillSheetTypeStateCopyWithImpl<$Res>
    implements _$PillSheetTypeStateCopyWith<$Res> {
  __$PillSheetTypeStateCopyWithImpl(
      _PillSheetTypeState _value, $Res Function(_PillSheetTypeState) _then)
      : super(_value, (v) => _then(v as _PillSheetTypeState));

  @override
  _PillSheetTypeState get _value => super._value as _PillSheetTypeState;

  @override
  $Res call({
    Object? setting = freezed,
    Object? pillSheet = freezed,
    Object? exception = freezed,
  }) {
    return _then(_PillSheetTypeState(
      setting: setting == freezed
          ? _value.setting
          : setting // ignore: cast_nullable_to_non_nullable
              as Setting?,
      pillSheet: pillSheet == freezed
          ? _value.pillSheet
          : pillSheet // ignore: cast_nullable_to_non_nullable
              as PillSheet?,
      exception: exception == freezed ? _value.exception : exception,
    ));
  }
}

/// @nodoc

class _$_PillSheetTypeState extends _PillSheetTypeState {
  _$_PillSheetTypeState(
      {required this.setting, required this.pillSheet, this.exception})
      : super._();

  @override
  final Setting? setting;
  @override
  final PillSheet? pillSheet;
  @override
  final Object? exception;

  @override
  String toString() {
    return 'PillSheetTypeState(setting: $setting, pillSheet: $pillSheet, exception: $exception)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _PillSheetTypeState &&
            (identical(other.setting, setting) ||
                const DeepCollectionEquality()
                    .equals(other.setting, setting)) &&
            (identical(other.pillSheet, pillSheet) ||
                const DeepCollectionEquality()
                    .equals(other.pillSheet, pillSheet)) &&
            (identical(other.exception, exception) ||
                const DeepCollectionEquality()
                    .equals(other.exception, exception)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(setting) ^
      const DeepCollectionEquality().hash(pillSheet) ^
      const DeepCollectionEquality().hash(exception);

  @JsonKey(ignore: true)
  @override
  _$PillSheetTypeStateCopyWith<_PillSheetTypeState> get copyWith =>
      __$PillSheetTypeStateCopyWithImpl<_PillSheetTypeState>(this, _$identity);
}

abstract class _PillSheetTypeState extends PillSheetTypeState {
  factory _PillSheetTypeState(
      {required Setting? setting,
      required PillSheet? pillSheet,
      Object? exception}) = _$_PillSheetTypeState;
  _PillSheetTypeState._() : super._();

  @override
  Setting? get setting => throw _privateConstructorUsedError;
  @override
  PillSheet? get pillSheet => throw _privateConstructorUsedError;
  @override
  Object? get exception => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$PillSheetTypeStateCopyWith<_PillSheetTypeState> get copyWith =>
      throw _privateConstructorUsedError;
}
