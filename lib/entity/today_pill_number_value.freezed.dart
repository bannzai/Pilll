// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'today_pill_number_value.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$TodayPillNumberValueTearOff {
  const _$TodayPillNumberValueTearOff();

  _TodayPillNumberValue call(
      {required int pillNumberIntoPillSheet,
      required int sequentialPillNumber}) {
    return _TodayPillNumberValue(
      pillNumberIntoPillSheet: pillNumberIntoPillSheet,
      sequentialPillNumber: sequentialPillNumber,
    );
  }
}

/// @nodoc
const $TodayPillNumberValue = _$TodayPillNumberValueTearOff();

/// @nodoc
mixin _$TodayPillNumberValue {
  int get pillNumberIntoPillSheet => throw _privateConstructorUsedError;
  int get sequentialPillNumber => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TodayPillNumberValueCopyWith<TodayPillNumberValue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TodayPillNumberValueCopyWith<$Res> {
  factory $TodayPillNumberValueCopyWith(TodayPillNumberValue value,
          $Res Function(TodayPillNumberValue) then) =
      _$TodayPillNumberValueCopyWithImpl<$Res>;
  $Res call({int pillNumberIntoPillSheet, int sequentialPillNumber});
}

/// @nodoc
class _$TodayPillNumberValueCopyWithImpl<$Res>
    implements $TodayPillNumberValueCopyWith<$Res> {
  _$TodayPillNumberValueCopyWithImpl(this._value, this._then);

  final TodayPillNumberValue _value;
  // ignore: unused_field
  final $Res Function(TodayPillNumberValue) _then;

  @override
  $Res call({
    Object? pillNumberIntoPillSheet = freezed,
    Object? sequentialPillNumber = freezed,
  }) {
    return _then(_value.copyWith(
      pillNumberIntoPillSheet: pillNumberIntoPillSheet == freezed
          ? _value.pillNumberIntoPillSheet
          : pillNumberIntoPillSheet // ignore: cast_nullable_to_non_nullable
              as int,
      sequentialPillNumber: sequentialPillNumber == freezed
          ? _value.sequentialPillNumber
          : sequentialPillNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$TodayPillNumberValueCopyWith<$Res>
    implements $TodayPillNumberValueCopyWith<$Res> {
  factory _$TodayPillNumberValueCopyWith(_TodayPillNumberValue value,
          $Res Function(_TodayPillNumberValue) then) =
      __$TodayPillNumberValueCopyWithImpl<$Res>;
  @override
  $Res call({int pillNumberIntoPillSheet, int sequentialPillNumber});
}

/// @nodoc
class __$TodayPillNumberValueCopyWithImpl<$Res>
    extends _$TodayPillNumberValueCopyWithImpl<$Res>
    implements _$TodayPillNumberValueCopyWith<$Res> {
  __$TodayPillNumberValueCopyWithImpl(
      _TodayPillNumberValue _value, $Res Function(_TodayPillNumberValue) _then)
      : super(_value, (v) => _then(v as _TodayPillNumberValue));

  @override
  _TodayPillNumberValue get _value => super._value as _TodayPillNumberValue;

  @override
  $Res call({
    Object? pillNumberIntoPillSheet = freezed,
    Object? sequentialPillNumber = freezed,
  }) {
    return _then(_TodayPillNumberValue(
      pillNumberIntoPillSheet: pillNumberIntoPillSheet == freezed
          ? _value.pillNumberIntoPillSheet
          : pillNumberIntoPillSheet // ignore: cast_nullable_to_non_nullable
              as int,
      sequentialPillNumber: sequentialPillNumber == freezed
          ? _value.sequentialPillNumber
          : sequentialPillNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_TodayPillNumberValue extends _TodayPillNumberValue {
  _$_TodayPillNumberValue(
      {required this.pillNumberIntoPillSheet,
      required this.sequentialPillNumber})
      : super._();

  @override
  final int pillNumberIntoPillSheet;
  @override
  final int sequentialPillNumber;

  @override
  String toString() {
    return 'TodayPillNumberValue(pillNumberIntoPillSheet: $pillNumberIntoPillSheet, sequentialPillNumber: $sequentialPillNumber)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _TodayPillNumberValue &&
            (identical(
                    other.pillNumberIntoPillSheet, pillNumberIntoPillSheet) ||
                const DeepCollectionEquality().equals(
                    other.pillNumberIntoPillSheet, pillNumberIntoPillSheet)) &&
            (identical(other.sequentialPillNumber, sequentialPillNumber) ||
                const DeepCollectionEquality()
                    .equals(other.sequentialPillNumber, sequentialPillNumber)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(pillNumberIntoPillSheet) ^
      const DeepCollectionEquality().hash(sequentialPillNumber);

  @JsonKey(ignore: true)
  @override
  _$TodayPillNumberValueCopyWith<_TodayPillNumberValue> get copyWith =>
      __$TodayPillNumberValueCopyWithImpl<_TodayPillNumberValue>(
          this, _$identity);
}

abstract class _TodayPillNumberValue extends TodayPillNumberValue {
  factory _TodayPillNumberValue(
      {required int pillNumberIntoPillSheet,
      required int sequentialPillNumber}) = _$_TodayPillNumberValue;
  _TodayPillNumberValue._() : super._();

  @override
  int get pillNumberIntoPillSheet => throw _privateConstructorUsedError;
  @override
  int get sequentialPillNumber => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$TodayPillNumberValueCopyWith<_TodayPillNumberValue> get copyWith =>
      throw _privateConstructorUsedError;
}
