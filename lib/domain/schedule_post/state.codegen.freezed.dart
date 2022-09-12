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
      {required DateTime date,
      required User user,
      required PremiumAndTrial premiumAndTrial,
      required List<Schedule> schedules}) {
    return _SchedulePostState(
      date: date,
      user: user,
      premiumAndTrial: premiumAndTrial,
      schedules: schedules,
    );
  }
}

/// @nodoc
const $SchedulePostState = _$SchedulePostStateTearOff();

/// @nodoc
mixin _$SchedulePostState {
  DateTime get date => throw _privateConstructorUsedError;
  User get user => throw _privateConstructorUsedError;
  PremiumAndTrial get premiumAndTrial => throw _privateConstructorUsedError;
  List<Schedule> get schedules => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SchedulePostStateCopyWith<SchedulePostState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SchedulePostStateCopyWith<$Res> {
  factory $SchedulePostStateCopyWith(
          SchedulePostState value, $Res Function(SchedulePostState) then) =
      _$SchedulePostStateCopyWithImpl<$Res>;
  $Res call(
      {DateTime date,
      User user,
      PremiumAndTrial premiumAndTrial,
      List<Schedule> schedules});

  $UserCopyWith<$Res> get user;
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
    Object? date = freezed,
    Object? user = freezed,
    Object? premiumAndTrial = freezed,
    Object? schedules = freezed,
  }) {
    return _then(_value.copyWith(
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      user: user == freezed
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      premiumAndTrial: premiumAndTrial == freezed
          ? _value.premiumAndTrial
          : premiumAndTrial // ignore: cast_nullable_to_non_nullable
              as PremiumAndTrial,
      schedules: schedules == freezed
          ? _value.schedules
          : schedules // ignore: cast_nullable_to_non_nullable
              as List<Schedule>,
    ));
  }

  @override
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value));
    });
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
  $Res call(
      {DateTime date,
      User user,
      PremiumAndTrial premiumAndTrial,
      List<Schedule> schedules});

  @override
  $UserCopyWith<$Res> get user;
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
    Object? date = freezed,
    Object? user = freezed,
    Object? premiumAndTrial = freezed,
    Object? schedules = freezed,
  }) {
    return _then(_SchedulePostState(
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      user: user == freezed
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      premiumAndTrial: premiumAndTrial == freezed
          ? _value.premiumAndTrial
          : premiumAndTrial // ignore: cast_nullable_to_non_nullable
              as PremiumAndTrial,
      schedules: schedules == freezed
          ? _value.schedules
          : schedules // ignore: cast_nullable_to_non_nullable
              as List<Schedule>,
    ));
  }
}

/// @nodoc

class _$_SchedulePostState extends _SchedulePostState {
  _$_SchedulePostState(
      {required this.date,
      required this.user,
      required this.premiumAndTrial,
      required this.schedules})
      : super._();

  @override
  final DateTime date;
  @override
  final User user;
  @override
  final PremiumAndTrial premiumAndTrial;
  @override
  final List<Schedule> schedules;

  @override
  String toString() {
    return 'SchedulePostState(date: $date, user: $user, premiumAndTrial: $premiumAndTrial, schedules: $schedules)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SchedulePostState &&
            const DeepCollectionEquality().equals(other.date, date) &&
            const DeepCollectionEquality().equals(other.user, user) &&
            const DeepCollectionEquality()
                .equals(other.premiumAndTrial, premiumAndTrial) &&
            const DeepCollectionEquality().equals(other.schedules, schedules));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(date),
      const DeepCollectionEquality().hash(user),
      const DeepCollectionEquality().hash(premiumAndTrial),
      const DeepCollectionEquality().hash(schedules));

  @JsonKey(ignore: true)
  @override
  _$SchedulePostStateCopyWith<_SchedulePostState> get copyWith =>
      __$SchedulePostStateCopyWithImpl<_SchedulePostState>(this, _$identity);
}

abstract class _SchedulePostState extends SchedulePostState {
  factory _SchedulePostState(
      {required DateTime date,
      required User user,
      required PremiumAndTrial premiumAndTrial,
      required List<Schedule> schedules}) = _$_SchedulePostState;
  _SchedulePostState._() : super._();

  @override
  DateTime get date;
  @override
  User get user;
  @override
  PremiumAndTrial get premiumAndTrial;
  @override
  List<Schedule> get schedules;
  @override
  @JsonKey(ignore: true)
  _$SchedulePostStateCopyWith<_SchedulePostState> get copyWith =>
      throw _privateConstructorUsedError;
}
