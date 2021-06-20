// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'signin_sheet_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$SigninSheetStateTearOff {
  const _$SigninSheetStateTearOff();

  _SigninSheetState call(
      {required bool isLoginMode, bool isLoading = false, Object? exception}) {
    return _SigninSheetState(
      isLoginMode: isLoginMode,
      isLoading: isLoading,
      exception: exception,
    );
  }
}

/// @nodoc
const $SigninSheetState = _$SigninSheetStateTearOff();

/// @nodoc
mixin _$SigninSheetState {
  bool get isLoginMode => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  Object? get exception => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SigninSheetStateCopyWith<SigninSheetState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SigninSheetStateCopyWith<$Res> {
  factory $SigninSheetStateCopyWith(
          SigninSheetState value, $Res Function(SigninSheetState) then) =
      _$SigninSheetStateCopyWithImpl<$Res>;
  $Res call({bool isLoginMode, bool isLoading, Object? exception});
}

/// @nodoc
class _$SigninSheetStateCopyWithImpl<$Res>
    implements $SigninSheetStateCopyWith<$Res> {
  _$SigninSheetStateCopyWithImpl(this._value, this._then);

  final SigninSheetState _value;
  // ignore: unused_field
  final $Res Function(SigninSheetState) _then;

  @override
  $Res call({
    Object? isLoginMode = freezed,
    Object? isLoading = freezed,
    Object? exception = freezed,
  }) {
    return _then(_value.copyWith(
      isLoginMode: isLoginMode == freezed
          ? _value.isLoginMode
          : isLoginMode // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: isLoading == freezed
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      exception: exception == freezed ? _value.exception : exception,
    ));
  }
}

/// @nodoc
abstract class _$SigninSheetStateCopyWith<$Res>
    implements $SigninSheetStateCopyWith<$Res> {
  factory _$SigninSheetStateCopyWith(
          _SigninSheetState value, $Res Function(_SigninSheetState) then) =
      __$SigninSheetStateCopyWithImpl<$Res>;
  @override
  $Res call({bool isLoginMode, bool isLoading, Object? exception});
}

/// @nodoc
class __$SigninSheetStateCopyWithImpl<$Res>
    extends _$SigninSheetStateCopyWithImpl<$Res>
    implements _$SigninSheetStateCopyWith<$Res> {
  __$SigninSheetStateCopyWithImpl(
      _SigninSheetState _value, $Res Function(_SigninSheetState) _then)
      : super(_value, (v) => _then(v as _SigninSheetState));

  @override
  _SigninSheetState get _value => super._value as _SigninSheetState;

  @override
  $Res call({
    Object? isLoginMode = freezed,
    Object? isLoading = freezed,
    Object? exception = freezed,
  }) {
    return _then(_SigninSheetState(
      isLoginMode: isLoginMode == freezed
          ? _value.isLoginMode
          : isLoginMode // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: isLoading == freezed
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      exception: exception == freezed ? _value.exception : exception,
    ));
  }
}

/// @nodoc

class _$_SigninSheetState extends _SigninSheetState {
  _$_SigninSheetState(
      {required this.isLoginMode, this.isLoading = false, this.exception})
      : super._();

  @override
  final bool isLoginMode;
  @JsonKey(defaultValue: false)
  @override
  final bool isLoading;
  @override
  final Object? exception;

  @override
  String toString() {
    return 'SigninSheetState(isLoginMode: $isLoginMode, isLoading: $isLoading, exception: $exception)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _SigninSheetState &&
            (identical(other.isLoginMode, isLoginMode) ||
                const DeepCollectionEquality()
                    .equals(other.isLoginMode, isLoginMode)) &&
            (identical(other.isLoading, isLoading) ||
                const DeepCollectionEquality()
                    .equals(other.isLoading, isLoading)) &&
            (identical(other.exception, exception) ||
                const DeepCollectionEquality()
                    .equals(other.exception, exception)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(isLoginMode) ^
      const DeepCollectionEquality().hash(isLoading) ^
      const DeepCollectionEquality().hash(exception);

  @JsonKey(ignore: true)
  @override
  _$SigninSheetStateCopyWith<_SigninSheetState> get copyWith =>
      __$SigninSheetStateCopyWithImpl<_SigninSheetState>(this, _$identity);
}

abstract class _SigninSheetState extends SigninSheetState {
  factory _SigninSheetState(
      {required bool isLoginMode,
      bool isLoading,
      Object? exception}) = _$_SigninSheetState;
  _SigninSheetState._() : super._();

  @override
  bool get isLoginMode => throw _privateConstructorUsedError;
  @override
  bool get isLoading => throw _privateConstructorUsedError;
  @override
  Object? get exception => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$SigninSheetStateCopyWith<_SigninSheetState> get copyWith =>
      throw _privateConstructorUsedError;
}
