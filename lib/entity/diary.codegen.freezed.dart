// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diary.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Diary _$DiaryFromJson(Map<String, dynamic> json) {
  return _Diary.fromJson(json);
}

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
      _$DiaryCopyWithImpl<$Res, Diary>;
  @useResult
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
class _$DiaryCopyWithImpl<$Res, $Val extends Diary>
    implements $DiaryCopyWith<$Res> {
  _$DiaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? createdAt = freezed,
    Object? physicalConditionStatus = freezed,
    Object? physicalConditions = null,
    Object? hasSex = null,
    Object? memo = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      physicalConditionStatus: freezed == physicalConditionStatus
          ? _value.physicalConditionStatus
          : physicalConditionStatus // ignore: cast_nullable_to_non_nullable
              as PhysicalConditionStatus?,
      physicalConditions: null == physicalConditions
          ? _value.physicalConditions
          : physicalConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      hasSex: null == hasSex
          ? _value.hasSex
          : hasSex // ignore: cast_nullable_to_non_nullable
              as bool,
      memo: null == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_DiaryCopyWith<$Res> implements $DiaryCopyWith<$Res> {
  factory _$$_DiaryCopyWith(_$_Diary value, $Res Function(_$_Diary) then) =
      __$$_DiaryCopyWithImpl<$Res>;
  @override
  @useResult
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
class __$$_DiaryCopyWithImpl<$Res> extends _$DiaryCopyWithImpl<$Res, _$_Diary>
    implements _$$_DiaryCopyWith<$Res> {
  __$$_DiaryCopyWithImpl(_$_Diary _value, $Res Function(_$_Diary) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? createdAt = freezed,
    Object? physicalConditionStatus = freezed,
    Object? physicalConditions = null,
    Object? hasSex = null,
    Object? memo = null,
  }) {
    return _then(_$_Diary(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      physicalConditionStatus: freezed == physicalConditionStatus
          ? _value.physicalConditionStatus
          : physicalConditionStatus // ignore: cast_nullable_to_non_nullable
              as PhysicalConditionStatus?,
      physicalConditions: null == physicalConditions
          ? _value._physicalConditions
          : physicalConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      hasSex: null == hasSex
          ? _value.hasSex
          : hasSex // ignore: cast_nullable_to_non_nullable
              as bool,
      memo: null == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_Diary extends _Diary {
  const _$_Diary(
      {@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.date,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          required this.createdAt,
      this.physicalConditionStatus,
      required final List<String> physicalConditions,
      required this.hasSex,
      required this.memo})
      : _physicalConditions = physicalConditions,
        super._();

  factory _$_Diary.fromJson(Map<String, dynamic> json) =>
      _$$_DiaryFromJson(json);

  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime date;
// NOTE: OLD data does't have createdAt
  @override
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  final DateTime? createdAt;
  @override
  final PhysicalConditionStatus? physicalConditionStatus;
  final List<String> _physicalConditions;
  @override
  List<String> get physicalConditions {
    if (_physicalConditions is EqualUnmodifiableListView)
      return _physicalConditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_physicalConditions);
  }

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
        (other.runtimeType == runtimeType &&
            other is _$_Diary &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(
                    other.physicalConditionStatus, physicalConditionStatus) ||
                other.physicalConditionStatus == physicalConditionStatus) &&
            const DeepCollectionEquality()
                .equals(other._physicalConditions, _physicalConditions) &&
            (identical(other.hasSex, hasSex) || other.hasSex == hasSex) &&
            (identical(other.memo, memo) || other.memo == memo));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      date,
      createdAt,
      physicalConditionStatus,
      const DeepCollectionEquality().hash(_physicalConditions),
      hasSex,
      memo);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_DiaryCopyWith<_$_Diary> get copyWith =>
      __$$_DiaryCopyWithImpl<_$_Diary>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_DiaryToJson(
      this,
    );
  }
}

abstract class _Diary extends Diary {
  const factory _Diary(
      {@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required final DateTime date,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          required final DateTime? createdAt,
      final PhysicalConditionStatus? physicalConditionStatus,
      required final List<String> physicalConditions,
      required final bool hasSex,
      required final String memo}) = _$_Diary;
  const _Diary._() : super._();

  factory _Diary.fromJson(Map<String, dynamic> json) = _$_Diary.fromJson;

  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get date;
  @override // NOTE: OLD data does't have createdAt
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get createdAt;
  @override
  PhysicalConditionStatus? get physicalConditionStatus;
  @override
  List<String> get physicalConditions;
  @override
  bool get hasSex;
  @override
  String get memo;
  @override
  @JsonKey(ignore: true)
  _$$_DiaryCopyWith<_$_Diary> get copyWith =>
      throw _privateConstructorUsedError;
}
