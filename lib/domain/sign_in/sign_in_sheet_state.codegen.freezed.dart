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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

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
      _$SignInSheetStateCopyWithImpl<$Res, SignInSheetState>;
  @useResult
  $Res call(
      {bool isLoading, SignInSheetStateContext context, Object? exception});
}

/// @nodoc
class _$SignInSheetStateCopyWithImpl<$Res, $Val extends SignInSheetState>
    implements $SignInSheetStateCopyWith<$Res> {
  _$SignInSheetStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? context = null,
    Object? exception = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      context: null == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as SignInSheetStateContext,
      exception: freezed == exception ? _value.exception : exception,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SignInSheetStateCopyWith<$Res>
    implements $SignInSheetStateCopyWith<$Res> {
  factory _$$_SignInSheetStateCopyWith(
          _$_SignInSheetState value, $Res Function(_$_SignInSheetState) then) =
      __$$_SignInSheetStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading, SignInSheetStateContext context, Object? exception});
}

/// @nodoc
class __$$_SignInSheetStateCopyWithImpl<$Res>
    extends _$SignInSheetStateCopyWithImpl<$Res, _$_SignInSheetState>
    implements _$$_SignInSheetStateCopyWith<$Res> {
  __$$_SignInSheetStateCopyWithImpl(
      _$_SignInSheetState _value, $Res Function(_$_SignInSheetState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? context = null,
    Object? exception = freezed,
  }) {
    return _then(_$_SignInSheetState(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      context: null == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as SignInSheetStateContext,
      exception: freezed == exception ? _value.exception : exception,
    ));
  }
}

/// @nodoc

class _$_SignInSheetState extends _SignInSheetState {
  const _$_SignInSheetState(
      {this.isLoading = false, required this.context, this.exception})
      : super._();

  @override
  @JsonKey()
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
            other is _$_SignInSheetState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.context, context) || other.context == context) &&
            const DeepCollectionEquality().equals(other.exception, exception));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, context,
      const DeepCollectionEquality().hash(exception));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SignInSheetStateCopyWith<_$_SignInSheetState> get copyWith =>
      __$$_SignInSheetStateCopyWithImpl<_$_SignInSheetState>(this, _$identity);
}

abstract class _SignInSheetState extends SignInSheetState {
  const factory _SignInSheetState(
      {final bool isLoading,
      required final SignInSheetStateContext context,
      final Object? exception}) = _$_SignInSheetState;
  const _SignInSheetState._() : super._();

  @override
  bool get isLoading;
  @override
  SignInSheetStateContext get context;
  @override
  Object? get exception;
  @override
  @JsonKey(ignore: true)
  _$$_SignInSheetStateCopyWith<_$_SignInSheetState> get copyWith =>
      throw _privateConstructorUsedError;
}
