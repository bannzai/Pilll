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
  Menstruation? get menstruation => throw _privateConstructorUsedError;

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
  $Res call({DateTime dateForMonth, Menstruation? menstruation});

  $MenstruationCopyWith<$Res>? get menstruation;
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
    Object? menstruation = freezed,
  }) {
    return _then(_value.copyWith(
      dateForMonth: null == dateForMonth
          ? _value.dateForMonth
          : dateForMonth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      menstruation: freezed == menstruation
          ? _value.menstruation
          : menstruation // ignore: cast_nullable_to_non_nullable
              as Menstruation?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MenstruationCopyWith<$Res>? get menstruation {
    if (_value.menstruation == null) {
      return null;
    }

    return $MenstruationCopyWith<$Res>(_value.menstruation!, (value) {
      return _then(_value.copyWith(menstruation: value) as $Val);
    });
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
  $Res call({DateTime dateForMonth, Menstruation? menstruation});

  @override
  $MenstruationCopyWith<$Res>? get menstruation;
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
    Object? menstruation = freezed,
  }) {
    return _then(_$_MonthCalendarState(
      dateForMonth: null == dateForMonth
          ? _value.dateForMonth
          : dateForMonth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      menstruation: freezed == menstruation
          ? _value.menstruation
          : menstruation // ignore: cast_nullable_to_non_nullable
              as Menstruation?,
    ));
  }
}

/// @nodoc

class _$_MonthCalendarState extends _MonthCalendarState {
  _$_MonthCalendarState(
      {required this.dateForMonth, required this.menstruation})
      : super._();

  @override
  final DateTime dateForMonth;
  @override
  final Menstruation? menstruation;

  @override
  String toString() {
    return 'MonthCalendarState(dateForMonth: $dateForMonth, menstruation: $menstruation)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MonthCalendarState &&
            (identical(other.dateForMonth, dateForMonth) ||
                other.dateForMonth == dateForMonth) &&
            (identical(other.menstruation, menstruation) ||
                other.menstruation == menstruation));
  }

  @override
  int get hashCode => Object.hash(runtimeType, dateForMonth, menstruation);

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
      required final Menstruation? menstruation}) = _$_MonthCalendarState;
  _MonthCalendarState._() : super._();

  @override
  DateTime get dateForMonth;
  @override
  Menstruation? get menstruation;
  @override
  @JsonKey(ignore: true)
  _$$_MonthCalendarStateCopyWith<_$_MonthCalendarState> get copyWith =>
      throw _privateConstructorUsedError;
}
