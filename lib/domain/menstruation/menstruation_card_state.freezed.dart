// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'menstruation_card_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$MenstruationCardStateTearOff {
  const _$MenstruationCardStateTearOff();

  _MenstruationCardState call(
      {required DateTime scheduleDate, required String countdownString}) {
    return _MenstruationCardState(
      scheduleDate: scheduleDate,
      countdownString: countdownString,
    );
  }
}

/// @nodoc
const $MenstruationCardState = _$MenstruationCardStateTearOff();

/// @nodoc
mixin _$MenstruationCardState {
  DateTime get scheduleDate => throw _privateConstructorUsedError;
  String get countdownString => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MenstruationCardStateCopyWith<MenstruationCardState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MenstruationCardStateCopyWith<$Res> {
  factory $MenstruationCardStateCopyWith(MenstruationCardState value,
          $Res Function(MenstruationCardState) then) =
      _$MenstruationCardStateCopyWithImpl<$Res>;
  $Res call({DateTime scheduleDate, String countdownString});
}

/// @nodoc
class _$MenstruationCardStateCopyWithImpl<$Res>
    implements $MenstruationCardStateCopyWith<$Res> {
  _$MenstruationCardStateCopyWithImpl(this._value, this._then);

  final MenstruationCardState _value;
  // ignore: unused_field
  final $Res Function(MenstruationCardState) _then;

  @override
  $Res call({
    Object? scheduleDate = freezed,
    Object? countdownString = freezed,
  }) {
    return _then(_value.copyWith(
      scheduleDate: scheduleDate == freezed
          ? _value.scheduleDate
          : scheduleDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      countdownString: countdownString == freezed
          ? _value.countdownString
          : countdownString // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$MenstruationCardStateCopyWith<$Res>
    implements $MenstruationCardStateCopyWith<$Res> {
  factory _$MenstruationCardStateCopyWith(_MenstruationCardState value,
          $Res Function(_MenstruationCardState) then) =
      __$MenstruationCardStateCopyWithImpl<$Res>;
  @override
  $Res call({DateTime scheduleDate, String countdownString});
}

/// @nodoc
class __$MenstruationCardStateCopyWithImpl<$Res>
    extends _$MenstruationCardStateCopyWithImpl<$Res>
    implements _$MenstruationCardStateCopyWith<$Res> {
  __$MenstruationCardStateCopyWithImpl(_MenstruationCardState _value,
      $Res Function(_MenstruationCardState) _then)
      : super(_value, (v) => _then(v as _MenstruationCardState));

  @override
  _MenstruationCardState get _value => super._value as _MenstruationCardState;

  @override
  $Res call({
    Object? scheduleDate = freezed,
    Object? countdownString = freezed,
  }) {
    return _then(_MenstruationCardState(
      scheduleDate: scheduleDate == freezed
          ? _value.scheduleDate
          : scheduleDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      countdownString: countdownString == freezed
          ? _value.countdownString
          : countdownString // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
class _$_MenstruationCardState extends _MenstruationCardState {
  _$_MenstruationCardState(
      {required this.scheduleDate, required this.countdownString})
      : super._();

  @override
  final DateTime scheduleDate;
  @override
  final String countdownString;

  @override
  String toString() {
    return 'MenstruationCardState(scheduleDate: $scheduleDate, countdownString: $countdownString)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _MenstruationCardState &&
            (identical(other.scheduleDate, scheduleDate) ||
                const DeepCollectionEquality()
                    .equals(other.scheduleDate, scheduleDate)) &&
            (identical(other.countdownString, countdownString) ||
                const DeepCollectionEquality()
                    .equals(other.countdownString, countdownString)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(scheduleDate) ^
      const DeepCollectionEquality().hash(countdownString);

  @JsonKey(ignore: true)
  @override
  _$MenstruationCardStateCopyWith<_MenstruationCardState> get copyWith =>
      __$MenstruationCardStateCopyWithImpl<_MenstruationCardState>(
          this, _$identity);
}

abstract class _MenstruationCardState extends MenstruationCardState {
  factory _MenstruationCardState(
      {required DateTime scheduleDate,
      required String countdownString}) = _$_MenstruationCardState;
  _MenstruationCardState._() : super._();

  @override
  DateTime get scheduleDate => throw _privateConstructorUsedError;
  @override
  String get countdownString => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$MenstruationCardStateCopyWith<_MenstruationCardState> get copyWith =>
      throw _privateConstructorUsedError;
}
