// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'setting_account_cooperation_list_page_state.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SettingAccountCooperationListState {
  User? get user => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  Object? get exception => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SettingAccountCooperationListStateCopyWith<
          SettingAccountCooperationListState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingAccountCooperationListStateCopyWith<$Res> {
  factory $SettingAccountCooperationListStateCopyWith(
          SettingAccountCooperationListState value,
          $Res Function(SettingAccountCooperationListState) then) =
      _$SettingAccountCooperationListStateCopyWithImpl<$Res,
          SettingAccountCooperationListState>;
  @useResult
  $Res call({User? user, bool isLoading, Object? exception});
}

/// @nodoc
class _$SettingAccountCooperationListStateCopyWithImpl<$Res,
        $Val extends SettingAccountCooperationListState>
    implements $SettingAccountCooperationListStateCopyWith<$Res> {
  _$SettingAccountCooperationListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? isLoading = null,
    Object? exception = freezed,
  }) {
    return _then(_value.copyWith(
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      exception: freezed == exception ? _value.exception : exception,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SettingAccountCooperationListStateCopyWith<$Res>
    implements $SettingAccountCooperationListStateCopyWith<$Res> {
  factory _$$_SettingAccountCooperationListStateCopyWith(
          _$_SettingAccountCooperationListState value,
          $Res Function(_$_SettingAccountCooperationListState) then) =
      __$$_SettingAccountCooperationListStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({User? user, bool isLoading, Object? exception});
}

/// @nodoc
class __$$_SettingAccountCooperationListStateCopyWithImpl<$Res>
    extends _$SettingAccountCooperationListStateCopyWithImpl<$Res,
        _$_SettingAccountCooperationListState>
    implements _$$_SettingAccountCooperationListStateCopyWith<$Res> {
  __$$_SettingAccountCooperationListStateCopyWithImpl(
      _$_SettingAccountCooperationListState _value,
      $Res Function(_$_SettingAccountCooperationListState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? isLoading = null,
    Object? exception = freezed,
  }) {
    return _then(_$_SettingAccountCooperationListState(
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      exception: freezed == exception ? _value.exception : exception,
    ));
  }
}

/// @nodoc

class _$_SettingAccountCooperationListState
    extends _SettingAccountCooperationListState {
  const _$_SettingAccountCooperationListState(
      {required this.user, this.isLoading = false, this.exception})
      : super._();

  @override
  final User? user;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final Object? exception;

  @override
  String toString() {
    return 'SettingAccountCooperationListState(user: $user, isLoading: $isLoading, exception: $exception)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SettingAccountCooperationListState &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other.exception, exception));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, isLoading,
      const DeepCollectionEquality().hash(exception));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SettingAccountCooperationListStateCopyWith<
          _$_SettingAccountCooperationListState>
      get copyWith => __$$_SettingAccountCooperationListStateCopyWithImpl<
          _$_SettingAccountCooperationListState>(this, _$identity);
}

abstract class _SettingAccountCooperationListState
    extends SettingAccountCooperationListState {
  const factory _SettingAccountCooperationListState(
      {required final User? user,
      final bool isLoading,
      final Object? exception}) = _$_SettingAccountCooperationListState;
  const _SettingAccountCooperationListState._() : super._();

  @override
  User? get user;
  @override
  bool get isLoading;
  @override
  Object? get exception;
  @override
  @JsonKey(ignore: true)
  _$$_SettingAccountCooperationListStateCopyWith<
          _$_SettingAccountCooperationListState>
      get copyWith => throw _privateConstructorUsedError;
}
