// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'premium_trial_modal_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PremiumTrialModalStateTearOff {
  const _$PremiumTrialModalStateTearOff();

  _PremiumTrialModalState call(
      {DateTime? beginTrialDate,
      bool isLoading = false,
      bool isTrial = false,
      Setting? setting,
      Object? exception}) {
    return _PremiumTrialModalState(
      beginTrialDate: beginTrialDate,
      isLoading: isLoading,
      isTrial: isTrial,
      setting: setting,
      exception: exception,
    );
  }
}

/// @nodoc
const $PremiumTrialModalState = _$PremiumTrialModalStateTearOff();

/// @nodoc
mixin _$PremiumTrialModalState {
  DateTime? get beginTrialDate => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isTrial => throw _privateConstructorUsedError;
  Setting? get setting => throw _privateConstructorUsedError;
  Object? get exception => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PremiumTrialModalStateCopyWith<PremiumTrialModalState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PremiumTrialModalStateCopyWith<$Res> {
  factory $PremiumTrialModalStateCopyWith(PremiumTrialModalState value,
          $Res Function(PremiumTrialModalState) then) =
      _$PremiumTrialModalStateCopyWithImpl<$Res>;
  $Res call(
      {DateTime? beginTrialDate,
      bool isLoading,
      bool isTrial,
      Setting? setting,
      Object? exception});

  $SettingCopyWith<$Res>? get setting;
}

/// @nodoc
class _$PremiumTrialModalStateCopyWithImpl<$Res>
    implements $PremiumTrialModalStateCopyWith<$Res> {
  _$PremiumTrialModalStateCopyWithImpl(this._value, this._then);

  final PremiumTrialModalState _value;
  // ignore: unused_field
  final $Res Function(PremiumTrialModalState) _then;

  @override
  $Res call({
    Object? beginTrialDate = freezed,
    Object? isLoading = freezed,
    Object? isTrial = freezed,
    Object? setting = freezed,
    Object? exception = freezed,
  }) {
    return _then(_value.copyWith(
      beginTrialDate: beginTrialDate == freezed
          ? _value.beginTrialDate
          : beginTrialDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isLoading: isLoading == freezed
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isTrial: isTrial == freezed
          ? _value.isTrial
          : isTrial // ignore: cast_nullable_to_non_nullable
              as bool,
      setting: setting == freezed
          ? _value.setting
          : setting // ignore: cast_nullable_to_non_nullable
              as Setting?,
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
}

/// @nodoc
abstract class _$PremiumTrialModalStateCopyWith<$Res>
    implements $PremiumTrialModalStateCopyWith<$Res> {
  factory _$PremiumTrialModalStateCopyWith(_PremiumTrialModalState value,
          $Res Function(_PremiumTrialModalState) then) =
      __$PremiumTrialModalStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {DateTime? beginTrialDate,
      bool isLoading,
      bool isTrial,
      Setting? setting,
      Object? exception});

  @override
  $SettingCopyWith<$Res>? get setting;
}

/// @nodoc
class __$PremiumTrialModalStateCopyWithImpl<$Res>
    extends _$PremiumTrialModalStateCopyWithImpl<$Res>
    implements _$PremiumTrialModalStateCopyWith<$Res> {
  __$PremiumTrialModalStateCopyWithImpl(_PremiumTrialModalState _value,
      $Res Function(_PremiumTrialModalState) _then)
      : super(_value, (v) => _then(v as _PremiumTrialModalState));

  @override
  _PremiumTrialModalState get _value => super._value as _PremiumTrialModalState;

  @override
  $Res call({
    Object? beginTrialDate = freezed,
    Object? isLoading = freezed,
    Object? isTrial = freezed,
    Object? setting = freezed,
    Object? exception = freezed,
  }) {
    return _then(_PremiumTrialModalState(
      beginTrialDate: beginTrialDate == freezed
          ? _value.beginTrialDate
          : beginTrialDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isLoading: isLoading == freezed
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isTrial: isTrial == freezed
          ? _value.isTrial
          : isTrial // ignore: cast_nullable_to_non_nullable
              as bool,
      setting: setting == freezed
          ? _value.setting
          : setting // ignore: cast_nullable_to_non_nullable
              as Setting?,
      exception: exception == freezed ? _value.exception : exception,
    ));
  }
}

/// @nodoc

class _$_PremiumTrialModalState extends _PremiumTrialModalState {
  const _$_PremiumTrialModalState(
      {this.beginTrialDate,
      this.isLoading = false,
      this.isTrial = false,
      this.setting,
      this.exception})
      : super._();

  @override
  final DateTime? beginTrialDate;
  @JsonKey()
  @override
  final bool isLoading;
  @JsonKey()
  @override
  final bool isTrial;
  @override
  final Setting? setting;
  @override
  final Object? exception;

  @override
  String toString() {
    return 'PremiumTrialModalState(beginTrialDate: $beginTrialDate, isLoading: $isLoading, isTrial: $isTrial, setting: $setting, exception: $exception)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PremiumTrialModalState &&
            const DeepCollectionEquality()
                .equals(other.beginTrialDate, beginTrialDate) &&
            const DeepCollectionEquality().equals(other.isLoading, isLoading) &&
            const DeepCollectionEquality().equals(other.isTrial, isTrial) &&
            const DeepCollectionEquality().equals(other.setting, setting) &&
            const DeepCollectionEquality().equals(other.exception, exception));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(beginTrialDate),
      const DeepCollectionEquality().hash(isLoading),
      const DeepCollectionEquality().hash(isTrial),
      const DeepCollectionEquality().hash(setting),
      const DeepCollectionEquality().hash(exception));

  @JsonKey(ignore: true)
  @override
  _$PremiumTrialModalStateCopyWith<_PremiumTrialModalState> get copyWith =>
      __$PremiumTrialModalStateCopyWithImpl<_PremiumTrialModalState>(
          this, _$identity);
}

abstract class _PremiumTrialModalState extends PremiumTrialModalState {
  const factory _PremiumTrialModalState(
      {DateTime? beginTrialDate,
      bool isLoading,
      bool isTrial,
      Setting? setting,
      Object? exception}) = _$_PremiumTrialModalState;
  const _PremiumTrialModalState._() : super._();

  @override
  DateTime? get beginTrialDate;
  @override
  bool get isLoading;
  @override
  bool get isTrial;
  @override
  Setting? get setting;
  @override
  Object? get exception;
  @override
  @JsonKey(ignore: true)
  _$PremiumTrialModalStateCopyWith<_PremiumTrialModalState> get copyWith =>
      throw _privateConstructorUsedError;
}
