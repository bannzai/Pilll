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
      {@JsonKey(includeIfNull: false, toJson: toNull)
          String? id,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime beginDate,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime endDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? deletedAt,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime createdAt}) {
    return _Menstruation(
      id: id,
      beginDate: beginDate,
      endDate: endDate,
      deletedAt: deletedAt,
      createdAt: createdAt,
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
  @JsonKey(includeIfNull: false, toJson: toNull)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get beginDate => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get endDate => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdAt => throw _privateConstructorUsedError;

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
      {@JsonKey(includeIfNull: false, toJson: toNull)
          String? id,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime beginDate,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime endDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? deletedAt,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime createdAt});
}

/// @nodoc
class _$MenstruationCopyWithImpl<$Res> implements $MenstruationCopyWith<$Res> {
  _$MenstruationCopyWithImpl(this._value, this._then);

  final Menstruation _value;
  // ignore: unused_field
  final $Res Function(Menstruation) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? beginDate = freezed,
    Object? endDate = freezed,
    Object? deletedAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      beginDate: beginDate == freezed
          ? _value.beginDate
          : beginDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: endDate == freezed
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deletedAt: deletedAt == freezed
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
      {@JsonKey(includeIfNull: false, toJson: toNull)
          String? id,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime beginDate,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime endDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? deletedAt,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime createdAt});
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
    Object? id = freezed,
    Object? beginDate = freezed,
    Object? endDate = freezed,
    Object? deletedAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_Menstruation(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      beginDate: beginDate == freezed
          ? _value.beginDate
          : beginDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: endDate == freezed
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deletedAt: deletedAt == freezed
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

@JsonSerializable(explicitToJson: true)

/// @nodoc
class _$_Menstruation extends _Menstruation {
  _$_Menstruation(
      {@JsonKey(includeIfNull: false, toJson: toNull)
          this.id,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.beginDate,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.endDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          this.deletedAt,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.createdAt})
      : super._();

  factory _$_Menstruation.fromJson(Map<String, dynamic> json) =>
      _$_$_MenstruationFromJson(json);

  @override
  @JsonKey(includeIfNull: false, toJson: toNull)
  final String? id;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime beginDate;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime endDate;
  @override
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  final DateTime? deletedAt;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime createdAt;

  @override
  String toString() {
    return 'Menstruation(id: $id, beginDate: $beginDate, endDate: $endDate, deletedAt: $deletedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Menstruation &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.beginDate, beginDate) ||
                const DeepCollectionEquality()
                    .equals(other.beginDate, beginDate)) &&
            (identical(other.endDate, endDate) ||
                const DeepCollectionEquality()
                    .equals(other.endDate, endDate)) &&
            (identical(other.deletedAt, deletedAt) ||
                const DeepCollectionEquality()
                    .equals(other.deletedAt, deletedAt)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(beginDate) ^
      const DeepCollectionEquality().hash(endDate) ^
      const DeepCollectionEquality().hash(deletedAt) ^
      const DeepCollectionEquality().hash(createdAt);

  @JsonKey(ignore: true)
  @override
  _$MenstruationCopyWith<_Menstruation> get copyWith =>
      __$MenstruationCopyWithImpl<_Menstruation>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_MenstruationToJson(this);
  }
}

abstract class _Menstruation extends Menstruation {
  factory _Menstruation(
      {@JsonKey(includeIfNull: false, toJson: toNull)
          String? id,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime beginDate,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime endDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? deletedAt,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime createdAt}) = _$_Menstruation;
  _Menstruation._() : super._();

  factory _Menstruation.fromJson(Map<String, dynamic> json) =
      _$_Menstruation.fromJson;

  @override
  @JsonKey(includeIfNull: false, toJson: toNull)
  String? get id => throw _privateConstructorUsedError;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get beginDate => throw _privateConstructorUsedError;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get endDate => throw _privateConstructorUsedError;
  @override
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$MenstruationCopyWith<_Menstruation> get copyWith =>
      throw _privateConstructorUsedError;
}
