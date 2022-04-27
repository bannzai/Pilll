// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'sign_in_sheet_state.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$SignInSheetStateTearOff {
  const _$SignInSheetStateTearOff();

  _SignInSheetState call(
      {bool isLoading = false,
      required SignInSheetStateContext context,
      Object? exception}) {
    return _SignInSheetState(
      isLoading: isLoading,
      context: context,
      exception: exception,
    );
  }
}

/// @nodoc
const $SignInSheetState = _$SignInSheetStateTearOff();

/// @nodoc
mixin _$SignInSheetState {
  bool get isLoading => throw _privateConstructorUsedError;
  SignInSheetStateContext get context => throw _privateConstructorUsedError;
  Object? get exception => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SignInSheetStateCopyWith<SignInSheetState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignInSheetStateCopyWith<$Res> {
  factory $SignInSheetStateCopyWith(
          SignInSheetState value, $Res Function(SignInSheetState) then) =
      _$SignInSheetStateCopyWithImpl<$Res>;
  $Res call(
      {bool isLoading, SignInSheetStateContext context, Object? exception});
}

/// @nodoc
class _$SignInSheetStateCopyWithImpl<$Res>
    implements $SignInSheetStateCopyWith<$Res> {
  _$SignInSheetStateCopyWithImpl(this._value, this._then);

  final SignInSheetState _value;
  // ignore: unused_field
  final $Res Function(SignInSheetState) _then;

  @override
  $Res call({
    Object? isLoading = freezed,
    Object? context = freezed,
    Object? exception = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: isLoading == freezed
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      context: context == freezed
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as SignInSheetStateContext,
      exception: exception == freezed ? _value.exception : exception,
    ));
  }
}

/// @nodoc
abstract class _$SignInSheetStateCopyWith<$Res>
    implements $SignInSheetStateCopyWith<$Res> {
  factory _$SignInSheetStateCopyWith(
          _SignInSheetState value, $Res Function(_SignInSheetState) then) =
      __$SignInSheetStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {bool isLoading, SignInSheetStateContext context, Object? exception});
}

/// @nodoc
class __$SignInSheetStateCopyWithImpl<$Res>
    extends _$SignInSheetStateCopyWithImpl<$Res>
    implements _$SignInSheetStateCopyWith<$Res> {
  __$SignInSheetStateCopyWithImpl(
      _SignInSheetState _value, $Res Function(_SignInSheetState) _then)
      : super(_value, (v) => _then(v as _SignInSheetState));

  @override
  _SignInSheetState get _value => super._value as _SignInSheetState;

  @override
  $Res call({
    Object? isLoading = freezed,
    Object? context = freezed,
    Object? exception = freezed,
  }) {
    return _then(_SignInSheetState(
      isLoading: isLoading == freezed
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      context: context == freezed
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as SignInSheetStateContext,
      exception: exception == freezed ? _value.exception : exception,
    ));
  }
}

/// @nodoc

class _$_SignInSheetState extends _SignInSheetState {
  const _$_SignInSheetState(
      {this.isLoading = false, required this.context, this.exception})
      : super._();

  @JsonKey()
  @override
  final bool isLoading;
  @override
  final SignInSheetStateContext context;
  @override
  final Object? exception;

  @override
  String toString() {
    return 'SignInSheetState(isLoading: $isLoading, context: $context, exception: $exception)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SignInSheetState &&
            const DeepCollectionEquality().equals(other.isLoading, isLoading) &&
            const DeepCollectionEquality().equals(other.context, context) &&
            const DeepCollectionEquality().equals(other.exception, exception));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(isLoading),
      const DeepCollectionEquality().hash(context),
      const DeepCollectionEquality().hash(exception));

  @JsonKey(ignore: true)
  @override
  _$SignInSheetStateCopyWith<_SignInSheetState> get copyWith =>
      __$SignInSheetStateCopyWithImpl<_SignInSheetState>(this, _$identity);
}

abstract class _SignInSheetState extends SignInSheetState {
  const factory _SignInSheetState(
      {bool isLoading,
      required SignInSheetStateContext context,
      Object? exception}) = _$_SignInSheetState;
  const _SignInSheetState._() : super._();

  @override
  bool get isLoading;
  @override
  SignInSheetStateContext get context;
  @override
  Object? get exception;
  @override
  @JsonKey(ignore: true)
  _$SignInSheetStateCopyWith<_SignInSheetState> get copyWith =>
      throw _privateConstructorUsedError;
}
