// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'calendar_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$CalendarPageStateTearOff {
  const _$CalendarPageStateTearOff();

  _CalendarPageState call(
      {required List<Menstruation> menstruations,
      Setting? setting,
      PillSheet? latestPillSheet}) {
    return _CalendarPageState(
      menstruations: menstruations,
      setting: setting,
      latestPillSheet: latestPillSheet,
    );
  }
}

/// @nodoc
const $CalendarPageState = _$CalendarPageStateTearOff();

/// @nodoc
mixin _$CalendarPageState {
  List<Menstruation> get menstruations => throw _privateConstructorUsedError;
  Setting? get setting => throw _privateConstructorUsedError;
  PillSheet? get latestPillSheet => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CalendarPageStateCopyWith<CalendarPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalendarPageStateCopyWith<$Res> {
  factory $CalendarPageStateCopyWith(
          CalendarPageState value, $Res Function(CalendarPageState) then) =
      _$CalendarPageStateCopyWithImpl<$Res>;
  $Res call(
      {List<Menstruation> menstruations,
      Setting? setting,
      PillSheet? latestPillSheet});

  $SettingCopyWith<$Res>? get setting;
}

/// @nodoc
class _$CalendarPageStateCopyWithImpl<$Res>
    implements $CalendarPageStateCopyWith<$Res> {
  _$CalendarPageStateCopyWithImpl(this._value, this._then);

  final CalendarPageState _value;
  // ignore: unused_field
  final $Res Function(CalendarPageState) _then;

  @override
  $Res call({
    Object? menstruations = freezed,
    Object? setting = freezed,
    Object? latestPillSheet = freezed,
  }) {
    return _then(_value.copyWith(
      menstruations: menstruations == freezed
          ? _value.menstruations
          : menstruations // ignore: cast_nullable_to_non_nullable
              as List<Menstruation>,
      setting: setting == freezed
          ? _value.setting
          : setting // ignore: cast_nullable_to_non_nullable
              as Setting?,
      latestPillSheet: latestPillSheet == freezed
          ? _value.latestPillSheet
          : latestPillSheet // ignore: cast_nullable_to_non_nullable
              as PillSheet?,
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
}

/// @nodoc
abstract class _$CalendarPageStateCopyWith<$Res>
    implements $CalendarPageStateCopyWith<$Res> {
  factory _$CalendarPageStateCopyWith(
          _CalendarPageState value, $Res Function(_CalendarPageState) then) =
      __$CalendarPageStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {List<Menstruation> menstruations,
      Setting? setting,
      PillSheet? latestPillSheet});

  @override
  $SettingCopyWith<$Res>? get setting;
}

/// @nodoc
class __$CalendarPageStateCopyWithImpl<$Res>
    extends _$CalendarPageStateCopyWithImpl<$Res>
    implements _$CalendarPageStateCopyWith<$Res> {
  __$CalendarPageStateCopyWithImpl(
      _CalendarPageState _value, $Res Function(_CalendarPageState) _then)
      : super(_value, (v) => _then(v as _CalendarPageState));

  @override
  _CalendarPageState get _value => super._value as _CalendarPageState;

  @override
  $Res call({
    Object? menstruations = freezed,
    Object? setting = freezed,
    Object? latestPillSheet = freezed,
  }) {
    return _then(_CalendarPageState(
      menstruations: menstruations == freezed
          ? _value.menstruations
          : menstruations // ignore: cast_nullable_to_non_nullable
              as List<Menstruation>,
      setting: setting == freezed
          ? _value.setting
          : setting // ignore: cast_nullable_to_non_nullable
              as Setting?,
      latestPillSheet: latestPillSheet == freezed
          ? _value.latestPillSheet
          : latestPillSheet // ignore: cast_nullable_to_non_nullable
              as PillSheet?,
    ));
  }
}

/// @nodoc
class _$_CalendarPageState extends _CalendarPageState {
  _$_CalendarPageState(
      {required this.menstruations, this.setting, this.latestPillSheet})
      : super._();

  @override
  final List<Menstruation> menstruations;
  @override
  final Setting? setting;
  @override
  final PillSheet? latestPillSheet;

  @override
  String toString() {
    return 'CalendarPageState(menstruations: $menstruations, setting: $setting, latestPillSheet: $latestPillSheet)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _CalendarPageState &&
            (identical(other.menstruations, menstruations) ||
                const DeepCollectionEquality()
                    .equals(other.menstruations, menstruations)) &&
            (identical(other.setting, setting) ||
                const DeepCollectionEquality()
                    .equals(other.setting, setting)) &&
            (identical(other.latestPillSheet, latestPillSheet) ||
                const DeepCollectionEquality()
                    .equals(other.latestPillSheet, latestPillSheet)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(menstruations) ^
      const DeepCollectionEquality().hash(setting) ^
      const DeepCollectionEquality().hash(latestPillSheet);

  @JsonKey(ignore: true)
  @override
  _$CalendarPageStateCopyWith<_CalendarPageState> get copyWith =>
      __$CalendarPageStateCopyWithImpl<_CalendarPageState>(this, _$identity);
}

abstract class _CalendarPageState extends CalendarPageState {
  factory _CalendarPageState(
      {required List<Menstruation> menstruations,
      Setting? setting,
      PillSheet? latestPillSheet}) = _$_CalendarPageState;
  _CalendarPageState._() : super._();

  @override
  List<Menstruation> get menstruations => throw _privateConstructorUsedError;
  @override
  Setting? get setting => throw _privateConstructorUsedError;
  @override
  PillSheet? get latestPillSheet => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$CalendarPageStateCopyWith<_CalendarPageState> get copyWith =>
      throw _privateConstructorUsedError;
}
