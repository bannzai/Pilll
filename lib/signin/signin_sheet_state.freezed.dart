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

  _SigninSheetState call({bool isLoginMode = false}) {
    return _SigninSheetState(
      isLoginMode: isLoginMode,
    );
  }
}

/// @nodoc
const $SigninSheetState = _$SigninSheetStateTearOff();

/// @nodoc
mixin _$SigninSheetState {
  bool get isLoginMode => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SigninSheetStateCopyWith<SigninSheetState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SigninSheetStateCopyWith<$Res> {
  factory $SigninSheetStateCopyWith(
          SigninSheetState value, $Res Function(SigninSheetState) then) =
      _$SigninSheetStateCopyWithImpl<$Res>;
  $Res call({bool isLoginMode});
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
  }) {
    return _then(_value.copyWith(
      isLoginMode: isLoginMode == freezed
          ? _value.isLoginMode
          : isLoginMode // ignore: cast_nullable_to_non_nullable
              as bool,
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
  $Res call({bool isLoginMode});
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
  }) {
    return _then(_SigninSheetState(
      isLoginMode: isLoginMode == freezed
          ? _value.isLoginMode
          : isLoginMode // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_SigninSheetState extends _SigninSheetState {
  _$_SigninSheetState({this.isLoginMode = false}) : super._();

  @JsonKey(defaultValue: false)
  @override
  final bool isLoginMode;

  @override
  String toString() {
    return 'SigninSheetState(isLoginMode: $isLoginMode)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _SigninSheetState &&
            (identical(other.isLoginMode, isLoginMode) ||
                const DeepCollectionEquality()
                    .equals(other.isLoginMode, isLoginMode)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(isLoginMode);

  @JsonKey(ignore: true)
  @override
  _$SigninSheetStateCopyWith<_SigninSheetState> get copyWith =>
      __$SigninSheetStateCopyWithImpl<_SigninSheetState>(this, _$identity);
}

abstract class _SigninSheetState extends SigninSheetState {
  factory _SigninSheetState({bool isLoginMode}) = _$_SigninSheetState;
  _SigninSheetState._() : super._();

  @override
  bool get isLoginMode => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$SigninSheetStateCopyWith<_SigninSheetState> get copyWith =>
      throw _privateConstructorUsedError;
}
