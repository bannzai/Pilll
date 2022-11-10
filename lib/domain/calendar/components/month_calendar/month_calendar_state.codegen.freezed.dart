// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'month_calendar_state.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MonthCalendarState {
  DateTime get dateForMonth => throw _privateConstructorUsedError;
  List<Diary> get diaries => throw _privateConstructorUsedError;
  List<Schedule> get schedules => throw _privateConstructorUsedError;
  List<Menstruation> get menstruations => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MonthCalendarStateCopyWith<MonthCalendarState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthCalendarStateCopyWith<$Res> {
  factory $MonthCalendarStateCopyWith(
          MonthCalendarState value, $Res Function(MonthCalendarState) then) =
      _$MonthCalendarStateCopyWithImpl<$Res, MonthCalendarState>;
  @useResult
  $Res call(
      {DateTime dateForMonth,
      List<Diary> diaries,
      List<Schedule> schedules,
      List<Menstruation> menstruations});
}

/// @nodoc
class _$MonthCalendarStateCopyWithImpl<$Res, $Val extends MonthCalendarState>
    implements $MonthCalendarStateCopyWith<$Res> {
  _$MonthCalendarStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dateForMonth = null,
    Object? diaries = null,
    Object? schedules = null,
    Object? menstruations = null,
  }) {
    return _then(_value.copyWith(
      dateForMonth: null == dateForMonth
          ? _value.dateForMonth
          : dateForMonth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      diaries: null == diaries
          ? _value.diaries
          : diaries // ignore: cast_nullable_to_non_nullable
              as List<Diary>,
      schedules: null == schedules
          ? _value.schedules
          : schedules // ignore: cast_nullable_to_non_nullable
              as List<Schedule>,
      menstruations: null == menstruations
          ? _value.menstruations
          : menstruations // ignore: cast_nullable_to_non_nullable
              as List<Menstruation>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MonthCalendarStateCopyWith<$Res>
    implements $MonthCalendarStateCopyWith<$Res> {
  factory _$$_MonthCalendarStateCopyWith(_$_MonthCalendarState value,
          $Res Function(_$_MonthCalendarState) then) =
      __$$_MonthCalendarStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime dateForMonth,
      List<Diary> diaries,
      List<Schedule> schedules,
      List<Menstruation> menstruations});
}

/// @nodoc
class __$$_MonthCalendarStateCopyWithImpl<$Res>
    extends _$MonthCalendarStateCopyWithImpl<$Res, _$_MonthCalendarState>
    implements _$$_MonthCalendarStateCopyWith<$Res> {
  __$$_MonthCalendarStateCopyWithImpl(
      _$_MonthCalendarState _value, $Res Function(_$_MonthCalendarState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dateForMonth = null,
    Object? diaries = null,
    Object? schedules = null,
    Object? menstruations = null,
  }) {
    return _then(_$_MonthCalendarState(
      dateForMonth: null == dateForMonth
          ? _value.dateForMonth
          : dateForMonth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      diaries: null == diaries
          ? _value._diaries
          : diaries // ignore: cast_nullable_to_non_nullable
              as List<Diary>,
      schedules: null == schedules
          ? _value._schedules
          : schedules // ignore: cast_nullable_to_non_nullable
              as List<Schedule>,
      menstruations: null == menstruations
          ? _value._menstruations
          : menstruations // ignore: cast_nullable_to_non_nullable
              as List<Menstruation>,
    ));
  }
}

/// @nodoc

class _$_MonthCalendarState extends _MonthCalendarState {
  _$_MonthCalendarState(
      {required this.dateForMonth,
      required final List<Diary> diaries,
      required final List<Schedule> schedules,
      required final List<Menstruation> menstruations})
      : _diaries = diaries,
        _schedules = schedules,
        _menstruations = menstruations,
        super._();

  @override
  final DateTime dateForMonth;
  final List<Diary> _diaries;
  @override
  List<Diary> get diaries {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_diaries);
  }

  final List<Schedule> _schedules;
  @override
  List<Schedule> get schedules {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_schedules);
  }

  final List<Menstruation> _menstruations;
  @override
  List<Menstruation> get menstruations {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_menstruations);
  }

  @override
  String toString() {
    return 'MonthCalendarState(dateForMonth: $dateForMonth, diaries: $diaries, schedules: $schedules, menstruations: $menstruations)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MonthCalendarState &&
            (identical(other.dateForMonth, dateForMonth) ||
                other.dateForMonth == dateForMonth) &&
            const DeepCollectionEquality().equals(other._diaries, _diaries) &&
            const DeepCollectionEquality()
                .equals(other._schedules, _schedules) &&
            const DeepCollectionEquality()
                .equals(other._menstruations, _menstruations));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      dateForMonth,
      const DeepCollectionEquality().hash(_diaries),
      const DeepCollectionEquality().hash(_schedules),
      const DeepCollectionEquality().hash(_menstruations));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MonthCalendarStateCopyWith<_$_MonthCalendarState> get copyWith =>
      __$$_MonthCalendarStateCopyWithImpl<_$_MonthCalendarState>(
          this, _$identity);
}

abstract class _MonthCalendarState extends MonthCalendarState {
  factory _MonthCalendarState(
      {required final DateTime dateForMonth,
      required final List<Diary> diaries,
      required final List<Schedule> schedules,
      required final List<Menstruation> menstruations}) = _$_MonthCalendarState;
  _MonthCalendarState._() : super._();

  @override
  DateTime get dateForMonth;
  @override
  List<Diary> get diaries;
  @override
  List<Schedule> get schedules;
  @override
  List<Menstruation> get menstruations;
  @override
  @JsonKey(ignore: true)
  _$$_MonthCalendarStateCopyWith<_$_MonthCalendarState> get copyWith =>
      throw _privateConstructorUsedError;
}
