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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$MonthCalendarStateTearOff {
  const _$MonthCalendarStateTearOff();

  _MonthCalendarState call(
      {required DateTime dateForMonth,
      required List<Diary> diaries,
      required List<Menstruation> menstruations}) {
    return _MonthCalendarState(
      dateForMonth: dateForMonth,
      diaries: diaries,
      menstruations: menstruations,
    );
  }
}

/// @nodoc
const $MonthCalendarState = _$MonthCalendarStateTearOff();

/// @nodoc
mixin _$MonthCalendarState {
  DateTime get dateForMonth => throw _privateConstructorUsedError;
  List<Diary> get diaries => throw _privateConstructorUsedError;
  List<Menstruation> get menstruations => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MonthCalendarStateCopyWith<MonthCalendarState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthCalendarStateCopyWith<$Res> {
  factory $MonthCalendarStateCopyWith(
          MonthCalendarState value, $Res Function(MonthCalendarState) then) =
      _$MonthCalendarStateCopyWithImpl<$Res>;
  $Res call(
      {DateTime dateForMonth,
      List<Diary> diaries,
      List<Menstruation> menstruations});
}

/// @nodoc
class _$MonthCalendarStateCopyWithImpl<$Res>
    implements $MonthCalendarStateCopyWith<$Res> {
  _$MonthCalendarStateCopyWithImpl(this._value, this._then);

  final MonthCalendarState _value;
  // ignore: unused_field
  final $Res Function(MonthCalendarState) _then;

  @override
  $Res call({
    Object? dateForMonth = freezed,
    Object? diaries = freezed,
    Object? menstruations = freezed,
  }) {
    return _then(_value.copyWith(
      dateForMonth: dateForMonth == freezed
          ? _value.dateForMonth
          : dateForMonth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      diaries: diaries == freezed
          ? _value.diaries
          : diaries // ignore: cast_nullable_to_non_nullable
              as List<Diary>,
      menstruations: menstruations == freezed
          ? _value.menstruations
          : menstruations // ignore: cast_nullable_to_non_nullable
              as List<Menstruation>,
    ));
  }
}

/// @nodoc
abstract class _$MonthCalendarStateCopyWith<$Res>
    implements $MonthCalendarStateCopyWith<$Res> {
  factory _$MonthCalendarStateCopyWith(
          _MonthCalendarState value, $Res Function(_MonthCalendarState) then) =
      __$MonthCalendarStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {DateTime dateForMonth,
      List<Diary> diaries,
      List<Menstruation> menstruations});
}

/// @nodoc
class __$MonthCalendarStateCopyWithImpl<$Res>
    extends _$MonthCalendarStateCopyWithImpl<$Res>
    implements _$MonthCalendarStateCopyWith<$Res> {
  __$MonthCalendarStateCopyWithImpl(
      _MonthCalendarState _value, $Res Function(_MonthCalendarState) _then)
      : super(_value, (v) => _then(v as _MonthCalendarState));

  @override
  _MonthCalendarState get _value => super._value as _MonthCalendarState;

  @override
  $Res call({
    Object? dateForMonth = freezed,
    Object? diaries = freezed,
    Object? menstruations = freezed,
  }) {
    return _then(_MonthCalendarState(
      dateForMonth: dateForMonth == freezed
          ? _value.dateForMonth
          : dateForMonth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      diaries: diaries == freezed
          ? _value.diaries
          : diaries // ignore: cast_nullable_to_non_nullable
              as List<Diary>,
      menstruations: menstruations == freezed
          ? _value.menstruations
          : menstruations // ignore: cast_nullable_to_non_nullable
              as List<Menstruation>,
    ));
  }
}

/// @nodoc

class _$_MonthCalendarState extends _MonthCalendarState {
  _$_MonthCalendarState(
      {required this.dateForMonth,
      required this.diaries,
      required this.menstruations})
      : super._();

  @override
  final DateTime dateForMonth;
  @override
  final List<Diary> diaries;
  @override
  final List<Menstruation> menstruations;

  @override
  String toString() {
    return 'MonthCalendarState(dateForMonth: $dateForMonth, diaries: $diaries, menstruations: $menstruations)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MonthCalendarState &&
            const DeepCollectionEquality()
                .equals(other.dateForMonth, dateForMonth) &&
            const DeepCollectionEquality().equals(other.diaries, diaries) &&
            const DeepCollectionEquality()
                .equals(other.menstruations, menstruations));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(dateForMonth),
      const DeepCollectionEquality().hash(diaries),
      const DeepCollectionEquality().hash(menstruations));

  @JsonKey(ignore: true)
  @override
  _$MonthCalendarStateCopyWith<_MonthCalendarState> get copyWith =>
      __$MonthCalendarStateCopyWithImpl<_MonthCalendarState>(this, _$identity);
}

abstract class _MonthCalendarState extends MonthCalendarState {
  factory _MonthCalendarState(
      {required DateTime dateForMonth,
      required List<Diary> diaries,
      required List<Menstruation> menstruations}) = _$_MonthCalendarState;
  _MonthCalendarState._() : super._();

  @override
  DateTime get dateForMonth;
  @override
  List<Diary> get diaries;
  @override
  List<Menstruation> get menstruations;
  @override
  @JsonKey(ignore: true)
  _$MonthCalendarStateCopyWith<_MonthCalendarState> get copyWith =>
      throw _privateConstructorUsedError;
}
