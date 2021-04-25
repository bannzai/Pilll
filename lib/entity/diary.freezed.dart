// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'diary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Diary _$DiaryFromJson(Map<String, dynamic> json) {
  return _Diary.fromJson(json);
}

/// @nodoc
class _$DiaryTearOff {
  const _$DiaryTearOff();

  _Diary call(
      {@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime date,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          required DateTime? createdAt,
      PhysicalConditionStatus? physicalConditionStatus,
      required List<String> physicalConditions,
      required bool hasSex,
      required String memo}) {
    return _Diary(
      date: date,
      createdAt: createdAt,
      physicalConditionStatus: physicalConditionStatus,
      physicalConditions: physicalConditions,
      hasSex: hasSex,
      memo: memo,
    );
  }

  Diary fromJson(Map<String, Object> json) {
    return Diary.fromJson(json);
  }
}

/// @nodoc
const $Diary = _$DiaryTearOff();

/// @nodoc
mixin _$Diary {
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get date =>
      throw _privateConstructorUsedError; // NOTE: OLD data does't have createdAt
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  PhysicalConditionStatus? get physicalConditionStatus =>
      throw _privateConstructorUsedError;
  List<String> get physicalConditions => throw _privateConstructorUsedError;
  bool get hasSex => throw _privateConstructorUsedError;
  String get memo => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DiaryCopyWith<Diary> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiaryCopyWith<$Res> {
  factory $DiaryCopyWith(Diary value, $Res Function(Diary) then) =
      _$DiaryCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime date,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? createdAt,
      PhysicalConditionStatus? physicalConditionStatus,
      List<String> physicalConditions,
      bool hasSex,
      String memo});
}

/// @nodoc
class _$DiaryCopyWithImpl<$Res> implements $DiaryCopyWith<$Res> {
  _$DiaryCopyWithImpl(this._value, this._then);

  final Diary _value;
  // ignore: unused_field
  final $Res Function(Diary) _then;

  @override
  $Res call({
    Object? date = freezed,
    Object? createdAt = freezed,
    Object? physicalConditionStatus = freezed,
    Object? physicalConditions = freezed,
    Object? hasSex = freezed,
    Object? memo = freezed,
  }) {
    return _then(_value.copyWith(
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      physicalConditionStatus: physicalConditionStatus == freezed
          ? _value.physicalConditionStatus
          : physicalConditionStatus // ignore: cast_nullable_to_non_nullable
              as PhysicalConditionStatus?,
      physicalConditions: physicalConditions == freezed
          ? _value.physicalConditions
          : physicalConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      hasSex: hasSex == freezed
          ? _value.hasSex
          : hasSex // ignore: cast_nullable_to_non_nullable
              as bool,
      memo: memo == freezed
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$DiaryCopyWith<$Res> implements $DiaryCopyWith<$Res> {
  factory _$DiaryCopyWith(_Diary value, $Res Function(_Diary) then) =
      __$DiaryCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime date,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? createdAt,
      PhysicalConditionStatus? physicalConditionStatus,
      List<String> physicalConditions,
      bool hasSex,
      String memo});
}

/// @nodoc
class __$DiaryCopyWithImpl<$Res> extends _$DiaryCopyWithImpl<$Res>
    implements _$DiaryCopyWith<$Res> {
  __$DiaryCopyWithImpl(_Diary _value, $Res Function(_Diary) _then)
      : super(_value, (v) => _then(v as _Diary));

  @override
  _Diary get _value => super._value as _Diary;

  @override
  $Res call({
    Object? date = freezed,
    Object? createdAt = freezed,
    Object? physicalConditionStatus = freezed,
    Object? physicalConditions = freezed,
    Object? hasSex = freezed,
    Object? memo = freezed,
  }) {
    return _then(_Diary(
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      physicalConditionStatus: physicalConditionStatus == freezed
          ? _value.physicalConditionStatus
          : physicalConditionStatus // ignore: cast_nullable_to_non_nullable
              as PhysicalConditionStatus?,
      physicalConditions: physicalConditions == freezed
          ? _value.physicalConditions
          : physicalConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      hasSex: hasSex == freezed
          ? _value.hasSex
          : hasSex // ignore: cast_nullable_to_non_nullable
              as bool,
      memo: memo == freezed
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_Diary extends _Diary {
  _$_Diary(
      {@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.date,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          required this.createdAt,
      this.physicalConditionStatus,
      required this.physicalConditions,
      required this.hasSex,
      required this.memo})
      : super._();

  factory _$_Diary.fromJson(Map<String, dynamic> json) =>
      _$_$_DiaryFromJson(json);

  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime date;
  @override // NOTE: OLD data does't have createdAt
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  final DateTime? createdAt;
  @override
  final PhysicalConditionStatus? physicalConditionStatus;
  @override
  final List<String> physicalConditions;
  @override
  final bool hasSex;
  @override
  final String memo;

  @override
  String toString() {
    return 'Diary(date: $date, createdAt: $createdAt, physicalConditionStatus: $physicalConditionStatus, physicalConditions: $physicalConditions, hasSex: $hasSex, memo: $memo)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Diary &&
            (identical(other.date, date) ||
                const DeepCollectionEquality().equals(other.date, date)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(
                    other.physicalConditionStatus, physicalConditionStatus) ||
                const DeepCollectionEquality().equals(
                    other.physicalConditionStatus, physicalConditionStatus)) &&
            (identical(other.physicalConditions, physicalConditions) ||
                const DeepCollectionEquality()
                    .equals(other.physicalConditions, physicalConditions)) &&
            (identical(other.hasSex, hasSex) ||
                const DeepCollectionEquality().equals(other.hasSex, hasSex)) &&
            (identical(other.memo, memo) ||
                const DeepCollectionEquality().equals(other.memo, memo)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(date) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(physicalConditionStatus) ^
      const DeepCollectionEquality().hash(physicalConditions) ^
      const DeepCollectionEquality().hash(hasSex) ^
      const DeepCollectionEquality().hash(memo);

  @JsonKey(ignore: true)
  @override
  _$DiaryCopyWith<_Diary> get copyWith =>
      __$DiaryCopyWithImpl<_Diary>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_DiaryToJson(this);
  }
}

abstract class _Diary extends Diary {
  factory _Diary(
      {@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime date,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          required DateTime? createdAt,
      PhysicalConditionStatus? physicalConditionStatus,
      required List<String> physicalConditions,
      required bool hasSex,
      required String memo}) = _$_Diary;
  _Diary._() : super._();

  factory _Diary.fromJson(Map<String, dynamic> json) = _$_Diary.fromJson;

  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get date => throw _privateConstructorUsedError;
  @override // NOTE: OLD data does't have createdAt
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @override
  PhysicalConditionStatus? get physicalConditionStatus =>
      throw _privateConstructorUsedError;
  @override
  List<String> get physicalConditions => throw _privateConstructorUsedError;
  @override
  bool get hasSex => throw _privateConstructorUsedError;
  @override
  String get memo => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$DiaryCopyWith<_Diary> get copyWith => throw _privateConstructorUsedError;
}
