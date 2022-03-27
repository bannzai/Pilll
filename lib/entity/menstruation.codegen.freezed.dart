// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'menstruation.codegen.dart';

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
          required DateTime createdAt,
      String? healthKitSampleDataUUID}) {
    return _Menstruation(
      id: id,
      beginDate: beginDate,
      endDate: endDate,
      deletedAt: deletedAt,
      createdAt: createdAt,
      healthKitSampleDataUUID: healthKitSampleDataUUID,
    );
  }

  Menstruation fromJson(Map<String, Object?> json) {
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
  String? get healthKitSampleDataUUID => throw _privateConstructorUsedError;

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
          DateTime createdAt,
      String? healthKitSampleDataUUID});
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
    Object? healthKitSampleDataUUID = freezed,
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
      healthKitSampleDataUUID: healthKitSampleDataUUID == freezed
          ? _value.healthKitSampleDataUUID
          : healthKitSampleDataUUID // ignore: cast_nullable_to_non_nullable
              as String?,
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
          DateTime createdAt,
      String? healthKitSampleDataUUID});
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
    Object? healthKitSampleDataUUID = freezed,
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
      healthKitSampleDataUUID: healthKitSampleDataUUID == freezed
          ? _value.healthKitSampleDataUUID
          : healthKitSampleDataUUID // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_Menstruation extends _Menstruation {
  const _$_Menstruation(
      {@JsonKey(includeIfNull: false, toJson: toNull)
          this.id,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.beginDate,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.endDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          this.deletedAt,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.createdAt,
      this.healthKitSampleDataUUID})
      : super._();

  factory _$_Menstruation.fromJson(Map<String, dynamic> json) =>
      _$$_MenstruationFromJson(json);

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
  final String? healthKitSampleDataUUID;

  @override
  String toString() {
    return 'Menstruation(id: $id, beginDate: $beginDate, endDate: $endDate, deletedAt: $deletedAt, createdAt: $createdAt, healthKitSampleDataUUID: $healthKitSampleDataUUID)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Menstruation &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.beginDate, beginDate) &&
            const DeepCollectionEquality().equals(other.endDate, endDate) &&
            const DeepCollectionEquality().equals(other.deletedAt, deletedAt) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality().equals(
                other.healthKitSampleDataUUID, healthKitSampleDataUUID));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(beginDate),
      const DeepCollectionEquality().hash(endDate),
      const DeepCollectionEquality().hash(deletedAt),
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(healthKitSampleDataUUID));

  @JsonKey(ignore: true)
  @override
  _$MenstruationCopyWith<_Menstruation> get copyWith =>
      __$MenstruationCopyWithImpl<_Menstruation>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MenstruationToJson(this);
  }
}

abstract class _Menstruation extends Menstruation {
  const factory _Menstruation(
      {@JsonKey(includeIfNull: false, toJson: toNull)
          String? id,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime beginDate,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime endDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? deletedAt,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime createdAt,
      String? healthKitSampleDataUUID}) = _$_Menstruation;
  const _Menstruation._() : super._();

  factory _Menstruation.fromJson(Map<String, dynamic> json) =
      _$_Menstruation.fromJson;

  @override
  @JsonKey(includeIfNull: false, toJson: toNull)
  String? get id;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get beginDate;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get endDate;
  @override
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get deletedAt;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdAt;
  @override
  String? get healthKitSampleDataUUID;
  @override
  @JsonKey(ignore: true)
  _$MenstruationCopyWith<_Menstruation> get copyWith =>
      throw _privateConstructorUsedError;
}
