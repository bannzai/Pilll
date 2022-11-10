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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

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
      _$SchedulePostStateCopyWithImpl<$Res, SchedulePostState>;
  @useResult
  $Res call(
      {DateTime date,
      User user,
      PremiumAndTrial premiumAndTrial,
      List<Schedule> schedules});

  $UserCopyWith<$Res> get user;
  $PremiumAndTrialCopyWith<$Res> get premiumAndTrial;
}

/// @nodoc
class _$SchedulePostStateCopyWithImpl<$Res, $Val extends SchedulePostState>
    implements $SchedulePostStateCopyWith<$Res> {
  _$SchedulePostStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? user = null,
    Object? premiumAndTrial = null,
    Object? schedules = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      premiumAndTrial: null == premiumAndTrial
          ? _value.premiumAndTrial
          : premiumAndTrial // ignore: cast_nullable_to_non_nullable
              as PremiumAndTrial,
      schedules: null == schedules
          ? _value.schedules
          : schedules // ignore: cast_nullable_to_non_nullable
              as List<Schedule>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PremiumAndTrialCopyWith<$Res> get premiumAndTrial {
    return $PremiumAndTrialCopyWith<$Res>(_value.premiumAndTrial, (value) {
      return _then(_value.copyWith(premiumAndTrial: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_SchedulePostStateCopyWith<$Res>
    implements $SchedulePostStateCopyWith<$Res> {
  factory _$$_SchedulePostStateCopyWith(_$_SchedulePostState value,
          $Res Function(_$_SchedulePostState) then) =
      __$$_SchedulePostStateCopyWithImpl<$Res>;
  @override
  @useResult
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
class __$$_SchedulePostStateCopyWithImpl<$Res>
    extends _$SchedulePostStateCopyWithImpl<$Res, _$_SchedulePostState>
    implements _$$_SchedulePostStateCopyWith<$Res> {
  __$$_SchedulePostStateCopyWithImpl(
      _$_SchedulePostState _value, $Res Function(_$_SchedulePostState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? user = null,
    Object? premiumAndTrial = null,
    Object? schedules = null,
  }) {
    return _then(_$_SchedulePostState(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      premiumAndTrial: null == premiumAndTrial
          ? _value.premiumAndTrial
          : premiumAndTrial // ignore: cast_nullable_to_non_nullable
              as PremiumAndTrial,
      schedules: null == schedules
          ? _value._schedules
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
      required final List<Schedule> schedules})
      : _schedules = schedules,
        super._();

  @override
  final DateTime date;
  @override
  final User user;
  @override
  final PremiumAndTrial premiumAndTrial;
  final List<Schedule> _schedules;
  @override
  List<Schedule> get schedules {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_schedules);
  }

  @override
  String toString() {
    return 'SchedulePostState(date: $date, user: $user, premiumAndTrial: $premiumAndTrial, schedules: $schedules)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SchedulePostState &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.premiumAndTrial, premiumAndTrial) ||
                other.premiumAndTrial == premiumAndTrial) &&
            const DeepCollectionEquality()
                .equals(other._schedules, _schedules));
  }

  @override
  int get hashCode => Object.hash(runtimeType, date, user, premiumAndTrial,
      const DeepCollectionEquality().hash(_schedules));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SchedulePostStateCopyWith<_$_SchedulePostState> get copyWith =>
      __$$_SchedulePostStateCopyWithImpl<_$_SchedulePostState>(
          this, _$identity);
}

abstract class _SchedulePostState extends SchedulePostState {
  factory _SchedulePostState(
      {required final DateTime date,
      required final User user,
      required final PremiumAndTrial premiumAndTrial,
      required final List<Schedule> schedules}) = _$_SchedulePostState;
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
  _$$_SchedulePostStateCopyWith<_$_SchedulePostState> get copyWith =>
      throw _privateConstructorUsedError;
}
