// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'state.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$SchedulePostStateTearOff {
  const _$SchedulePostStateTearOff();

  _SchedulePostState call(
      {required User user, required PremiumAndTrial premiumAndTrial}) {
    return _SchedulePostState(
      user: user,
      premiumAndTrial: premiumAndTrial,
    );
  }
}

/// @nodoc
const $SchedulePostState = _$SchedulePostStateTearOff();

/// @nodoc
mixin _$SchedulePostState {
  User get user => throw _privateConstructorUsedError;
  PremiumAndTrial get premiumAndTrial => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SchedulePostStateCopyWith<SchedulePostState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SchedulePostStateCopyWith<$Res> {
  factory $SchedulePostStateCopyWith(
          SchedulePostState value, $Res Function(SchedulePostState) then) =
      _$SchedulePostStateCopyWithImpl<$Res>;
  $Res call({User user, PremiumAndTrial premiumAndTrial});

  $PremiumAndTrialCopyWith<$Res> get premiumAndTrial;
}

/// @nodoc
class _$SchedulePostStateCopyWithImpl<$Res>
    implements $SchedulePostStateCopyWith<$Res> {
  _$SchedulePostStateCopyWithImpl(this._value, this._then);

  final SchedulePostState _value;
  // ignore: unused_field
  final $Res Function(SchedulePostState) _then;

  @override
  $Res call({
    Object? user = freezed,
    Object? premiumAndTrial = freezed,
  }) {
    return _then(_value.copyWith(
      user: user == freezed
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      premiumAndTrial: premiumAndTrial == freezed
          ? _value.premiumAndTrial
          : premiumAndTrial // ignore: cast_nullable_to_non_nullable
              as PremiumAndTrial,
    ));
  }

  @override
  $PremiumAndTrialCopyWith<$Res> get premiumAndTrial {
    return $PremiumAndTrialCopyWith<$Res>(_value.premiumAndTrial, (value) {
      return _then(_value.copyWith(premiumAndTrial: value));
    });
  }
}

/// @nodoc
abstract class _$SchedulePostStateCopyWith<$Res>
    implements $SchedulePostStateCopyWith<$Res> {
  factory _$SchedulePostStateCopyWith(
          _SchedulePostState value, $Res Function(_SchedulePostState) then) =
      __$SchedulePostStateCopyWithImpl<$Res>;
  @override
  $Res call({User user, PremiumAndTrial premiumAndTrial});

  @override
  $PremiumAndTrialCopyWith<$Res> get premiumAndTrial;
}

/// @nodoc
class __$SchedulePostStateCopyWithImpl<$Res>
    extends _$SchedulePostStateCopyWithImpl<$Res>
    implements _$SchedulePostStateCopyWith<$Res> {
  __$SchedulePostStateCopyWithImpl(
      _SchedulePostState _value, $Res Function(_SchedulePostState) _then)
      : super(_value, (v) => _then(v as _SchedulePostState));

  @override
  _SchedulePostState get _value => super._value as _SchedulePostState;

  @override
  $Res call({
    Object? user = freezed,
    Object? premiumAndTrial = freezed,
  }) {
    return _then(_SchedulePostState(
      user: user == freezed
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      premiumAndTrial: premiumAndTrial == freezed
          ? _value.premiumAndTrial
          : premiumAndTrial // ignore: cast_nullable_to_non_nullable
              as PremiumAndTrial,
    ));
  }
}

/// @nodoc

class _$_SchedulePostState extends _SchedulePostState {
  _$_SchedulePostState({required this.user, required this.premiumAndTrial})
      : super._();

  @override
  final User user;
  @override
  final PremiumAndTrial premiumAndTrial;

  @override
  String toString() {
    return 'SchedulePostState(user: $user, premiumAndTrial: $premiumAndTrial)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SchedulePostState &&
            const DeepCollectionEquality().equals(other.user, user) &&
            const DeepCollectionEquality()
                .equals(other.premiumAndTrial, premiumAndTrial));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(user),
      const DeepCollectionEquality().hash(premiumAndTrial));

  @JsonKey(ignore: true)
  @override
  _$SchedulePostStateCopyWith<_SchedulePostState> get copyWith =>
      __$SchedulePostStateCopyWithImpl<_SchedulePostState>(this, _$identity);
}

abstract class _SchedulePostState extends SchedulePostState {
  factory _SchedulePostState(
      {required User user,
      required PremiumAndTrial premiumAndTrial}) = _$_SchedulePostState;
  _SchedulePostState._() : super._();

  @override
  User get user;
  @override
  PremiumAndTrial get premiumAndTrial;
  @override
  @JsonKey(ignore: true)
  _$SchedulePostStateCopyWith<_SchedulePostState> get copyWith =>
      throw _privateConstructorUsedError;
}
