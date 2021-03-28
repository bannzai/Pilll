// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'menstruation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Menstruation _$MenstruationFromJson(Map<String, dynamic> json) {
  return _Menstruation.fromJson(json);
}

/// @nodoc
class _$MenstruationTearOff {
  const _$MenstruationTearOff();

  _Menstruation call(
      {@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime begin,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime end,
      required bool isPreview}) {
    return _Menstruation(
      begin: begin,
      end: end,
      isPreview: isPreview,
    );
  }

  Menstruation fromJson(Map<String, Object> json) {
    return Menstruation.fromJson(json);
  }
}

/// @nodoc
const $Menstruation = _$MenstruationTearOff();

/// @nodoc
mixin _$Menstruation {
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get begin => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get end => throw _privateConstructorUsedError;
  bool get isPreview => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MenstruationCopyWith<Menstruation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MenstruationCopyWith<$Res> {
  factory $MenstruationCopyWith(
          Menstruation value, $Res Function(Menstruation) then) =
      _$MenstruationCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime begin,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime end,
      bool isPreview});
}

/// @nodoc
class _$MenstruationCopyWithImpl<$Res> implements $MenstruationCopyWith<$Res> {
  _$MenstruationCopyWithImpl(this._value, this._then);

  final Menstruation _value;
  // ignore: unused_field
  final $Res Function(Menstruation) _then;

  @override
  $Res call({
    Object? begin = freezed,
    Object? end = freezed,
    Object? isPreview = freezed,
  }) {
    return _then(_value.copyWith(
      begin: begin == freezed
          ? _value.begin
          : begin // ignore: cast_nullable_to_non_nullable
              as DateTime,
      end: end == freezed
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isPreview: isPreview == freezed
          ? _value.isPreview
          : isPreview // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$MenstruationCopyWith<$Res>
    implements $MenstruationCopyWith<$Res> {
  factory _$MenstruationCopyWith(
          _Menstruation value, $Res Function(_Menstruation) then) =
      __$MenstruationCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime begin,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime end,
      bool isPreview});
}

/// @nodoc
class __$MenstruationCopyWithImpl<$Res> extends _$MenstruationCopyWithImpl<$Res>
    implements _$MenstruationCopyWith<$Res> {
  __$MenstruationCopyWithImpl(
      _Menstruation _value, $Res Function(_Menstruation) _then)
      : super(_value, (v) => _then(v as _Menstruation));

  @override
  _Menstruation get _value => super._value as _Menstruation;

  @override
  $Res call({
    Object? begin = freezed,
    Object? end = freezed,
    Object? isPreview = freezed,
  }) {
    return _then(_Menstruation(
      begin: begin == freezed
          ? _value.begin
          : begin // ignore: cast_nullable_to_non_nullable
              as DateTime,
      end: end == freezed
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isPreview: isPreview == freezed
          ? _value.isPreview
          : isPreview // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

@JsonSerializable(explicitToJson: true)

/// @nodoc
class _$_Menstruation implements _Menstruation {
  _$_Menstruation(
      {@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.begin,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.end,
      required this.isPreview});

  factory _$_Menstruation.fromJson(Map<String, dynamic> json) =>
      _$_$_MenstruationFromJson(json);

  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime begin;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime end;
  @override
  final bool isPreview;

  @override
  String toString() {
    return 'Menstruation(begin: $begin, end: $end, isPreview: $isPreview)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Menstruation &&
            (identical(other.begin, begin) ||
                const DeepCollectionEquality().equals(other.begin, begin)) &&
            (identical(other.end, end) ||
                const DeepCollectionEquality().equals(other.end, end)) &&
            (identical(other.isPreview, isPreview) ||
                const DeepCollectionEquality()
                    .equals(other.isPreview, isPreview)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(begin) ^
      const DeepCollectionEquality().hash(end) ^
      const DeepCollectionEquality().hash(isPreview);

  @JsonKey(ignore: true)
  @override
  _$MenstruationCopyWith<_Menstruation> get copyWith =>
      __$MenstruationCopyWithImpl<_Menstruation>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_MenstruationToJson(this);
  }
}

abstract class _Menstruation implements Menstruation {
  factory _Menstruation(
      {@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime begin,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime end,
      required bool isPreview}) = _$_Menstruation;

  factory _Menstruation.fromJson(Map<String, dynamic> json) =
      _$_Menstruation.fromJson;

  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get begin => throw _privateConstructorUsedError;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get end => throw _privateConstructorUsedError;
  @override
  bool get isPreview => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$MenstruationCopyWith<_Menstruation> get copyWith =>
      throw _privateConstructorUsedError;
}
