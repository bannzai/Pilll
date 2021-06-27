// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

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
      {bool isLoading = false, bool isTrial = false, Object? exception}) {
    return _PremiumTrialModalState(
      isLoading: isLoading,
      isTrial: isTrial,
      exception: exception,
    );
  }
}

/// @nodoc
const $PremiumTrialModalState = _$PremiumTrialModalStateTearOff();

/// @nodoc
mixin _$PremiumTrialModalState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isTrial => throw _privateConstructorUsedError;
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
  $Res call({bool isLoading, bool isTrial, Object? exception});
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
    Object? isLoading = freezed,
    Object? isTrial = freezed,
    Object? exception = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: isLoading == freezed
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isTrial: isTrial == freezed
          ? _value.isTrial
          : isTrial // ignore: cast_nullable_to_non_nullable
              as bool,
      exception: exception == freezed ? _value.exception : exception,
    ));
  }
}

/// @nodoc
abstract class _$PremiumTrialModalStateCopyWith<$Res>
    implements $PremiumTrialModalStateCopyWith<$Res> {
  factory _$PremiumTrialModalStateCopyWith(_PremiumTrialModalState value,
          $Res Function(_PremiumTrialModalState) then) =
      __$PremiumTrialModalStateCopyWithImpl<$Res>;
  @override
  $Res call({bool isLoading, bool isTrial, Object? exception});
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
    Object? isLoading = freezed,
    Object? isTrial = freezed,
    Object? exception = freezed,
  }) {
    return _then(_PremiumTrialModalState(
      isLoading: isLoading == freezed
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isTrial: isTrial == freezed
          ? _value.isTrial
          : isTrial // ignore: cast_nullable_to_non_nullable
              as bool,
      exception: exception == freezed ? _value.exception : exception,
    ));
  }
}

/// @nodoc

class _$_PremiumTrialModalState extends _PremiumTrialModalState {
  _$_PremiumTrialModalState(
      {this.isLoading = false, this.isTrial = false, this.exception})
      : super._();

  @JsonKey(defaultValue: false)
  @override
  final bool isLoading;
  @JsonKey(defaultValue: false)
  @override
  final bool isTrial;
  @override
  final Object? exception;

  @override
  String toString() {
    return 'PremiumTrialModalState(isLoading: $isLoading, isTrial: $isTrial, exception: $exception)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _PremiumTrialModalState &&
            (identical(other.isLoading, isLoading) ||
                const DeepCollectionEquality()
                    .equals(other.isLoading, isLoading)) &&
            (identical(other.isTrial, isTrial) ||
                const DeepCollectionEquality()
                    .equals(other.isTrial, isTrial)) &&
            (identical(other.exception, exception) ||
                const DeepCollectionEquality()
                    .equals(other.exception, exception)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(isLoading) ^
      const DeepCollectionEquality().hash(isTrial) ^
      const DeepCollectionEquality().hash(exception);

  @JsonKey(ignore: true)
  @override
  _$PremiumTrialModalStateCopyWith<_PremiumTrialModalState> get copyWith =>
      __$PremiumTrialModalStateCopyWithImpl<_PremiumTrialModalState>(
          this, _$identity);
}

abstract class _PremiumTrialModalState extends PremiumTrialModalState {
  factory _PremiumTrialModalState(
      {bool isLoading,
      bool isTrial,
      Object? exception}) = _$_PremiumTrialModalState;
  _PremiumTrialModalState._() : super._();

  @override
  bool get isLoading => throw _privateConstructorUsedError;
  @override
  bool get isTrial => throw _privateConstructorUsedError;
  @override
  Object? get exception => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$PremiumTrialModalStateCopyWith<_PremiumTrialModalState> get copyWith =>
      throw _privateConstructorUsedError;
}
