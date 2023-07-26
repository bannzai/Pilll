// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pill.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PillTaken _$PillTakenFromJson(Map<String, dynamic> json) {
  return _PillTaken.fromJson(json);
}

/// @nodoc
mixin _$PillTaken {
// 同時服用を行った場合は対象となるPillTakenのrecordedTakenDateTimeは同一にする
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get recordedTakenDateTime => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdDateTime => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get updatedDateTime =>
      throw _privateConstructorUsedError; // backendで自動的に記録された場合にtrue
  bool get isAutomaticallyRecorded => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PillTakenCopyWith<PillTaken> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PillTakenCopyWith<$Res> {
  factory $PillTakenCopyWith(PillTaken value, $Res Function(PillTaken) then) =
      _$PillTakenCopyWithImpl<$Res, PillTaken>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime recordedTakenDateTime,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime createdDateTime,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime updatedDateTime,
      bool isAutomaticallyRecorded});
}

/// @nodoc
class _$PillTakenCopyWithImpl<$Res, $Val extends PillTaken>
    implements $PillTakenCopyWith<$Res> {
  _$PillTakenCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recordedTakenDateTime = null,
    Object? createdDateTime = null,
    Object? updatedDateTime = null,
    Object? isAutomaticallyRecorded = null,
  }) {
    return _then(_value.copyWith(
      recordedTakenDateTime: null == recordedTakenDateTime
          ? _value.recordedTakenDateTime
          : recordedTakenDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdDateTime: null == createdDateTime
          ? _value.createdDateTime
          : createdDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedDateTime: null == updatedDateTime
          ? _value.updatedDateTime
          : updatedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isAutomaticallyRecorded: null == isAutomaticallyRecorded
          ? _value.isAutomaticallyRecorded
          : isAutomaticallyRecorded // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PillTakenCopyWith<$Res> implements $PillTakenCopyWith<$Res> {
  factory _$$_PillTakenCopyWith(
          _$_PillTaken value, $Res Function(_$_PillTaken) then) =
      __$$_PillTakenCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime recordedTakenDateTime,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime createdDateTime,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime updatedDateTime,
      bool isAutomaticallyRecorded});
}

/// @nodoc
class __$$_PillTakenCopyWithImpl<$Res>
    extends _$PillTakenCopyWithImpl<$Res, _$_PillTaken>
    implements _$$_PillTakenCopyWith<$Res> {
  __$$_PillTakenCopyWithImpl(
      _$_PillTaken _value, $Res Function(_$_PillTaken) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recordedTakenDateTime = null,
    Object? createdDateTime = null,
    Object? updatedDateTime = null,
    Object? isAutomaticallyRecorded = null,
  }) {
    return _then(_$_PillTaken(
      recordedTakenDateTime: null == recordedTakenDateTime
          ? _value.recordedTakenDateTime
          : recordedTakenDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdDateTime: null == createdDateTime
          ? _value.createdDateTime
          : createdDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedDateTime: null == updatedDateTime
          ? _value.updatedDateTime
          : updatedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isAutomaticallyRecorded: null == isAutomaticallyRecorded
          ? _value.isAutomaticallyRecorded
          : isAutomaticallyRecorded // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_PillTaken implements _PillTaken {
  const _$_PillTaken(
      {@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.recordedTakenDateTime,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.createdDateTime,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.updatedDateTime,
      this.isAutomaticallyRecorded = false});

  factory _$_PillTaken.fromJson(Map<String, dynamic> json) =>
      _$$_PillTakenFromJson(json);

// 同時服用を行った場合は対象となるPillTakenのrecordedTakenDateTimeは同一にする
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime recordedTakenDateTime;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime createdDateTime;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime updatedDateTime;
// backendで自動的に記録された場合にtrue
  @override
  @JsonKey()
  final bool isAutomaticallyRecorded;

  @override
  String toString() {
    return 'PillTaken(recordedTakenDateTime: $recordedTakenDateTime, createdDateTime: $createdDateTime, updatedDateTime: $updatedDateTime, isAutomaticallyRecorded: $isAutomaticallyRecorded)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PillTaken &&
            (identical(other.recordedTakenDateTime, recordedTakenDateTime) ||
                other.recordedTakenDateTime == recordedTakenDateTime) &&
            (identical(other.createdDateTime, createdDateTime) ||
                other.createdDateTime == createdDateTime) &&
            (identical(other.updatedDateTime, updatedDateTime) ||
                other.updatedDateTime == updatedDateTime) &&
            (identical(
                    other.isAutomaticallyRecorded, isAutomaticallyRecorded) ||
                other.isAutomaticallyRecorded == isAutomaticallyRecorded));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, recordedTakenDateTime,
      createdDateTime, updatedDateTime, isAutomaticallyRecorded);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PillTakenCopyWith<_$_PillTaken> get copyWith =>
      __$$_PillTakenCopyWithImpl<_$_PillTaken>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PillTakenToJson(
      this,
    );
  }
}

abstract class _PillTaken implements PillTaken {
  const factory _PillTaken(
      {@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required final DateTime recordedTakenDateTime,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required final DateTime createdDateTime,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required final DateTime updatedDateTime,
      final bool isAutomaticallyRecorded}) = _$_PillTaken;

  factory _PillTaken.fromJson(Map<String, dynamic> json) =
      _$_PillTaken.fromJson;

  @override // 同時服用を行った場合は対象となるPillTakenのrecordedTakenDateTimeは同一にする
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get recordedTakenDateTime;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdDateTime;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get updatedDateTime;
  @override // backendで自動的に記録された場合にtrue
  bool get isAutomaticallyRecorded;
  @override
  @JsonKey(ignore: true)
  _$$_PillTakenCopyWith<_$_PillTaken> get copyWith =>
      throw _privateConstructorUsedError;
}

Pill _$PillFromJson(Map<String, dynamic> json) {
  return _Pill.fromJson(json);
}

/// @nodoc
mixin _$Pill {
  int get index => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdDateTime => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get updatedDateTime => throw _privateConstructorUsedError;
  List<PillTaken> get pillTakens => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PillCopyWith<Pill> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PillCopyWith<$Res> {
  factory $PillCopyWith(Pill value, $Res Function(Pill) then) =
      _$PillCopyWithImpl<$Res, Pill>;
  @useResult
  $Res call(
      {int index,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime createdDateTime,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime updatedDateTime,
      List<PillTaken> pillTakens});
}

/// @nodoc
class _$PillCopyWithImpl<$Res, $Val extends Pill>
    implements $PillCopyWith<$Res> {
  _$PillCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? createdDateTime = null,
    Object? updatedDateTime = null,
    Object? pillTakens = null,
  }) {
    return _then(_value.copyWith(
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      createdDateTime: null == createdDateTime
          ? _value.createdDateTime
          : createdDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedDateTime: null == updatedDateTime
          ? _value.updatedDateTime
          : updatedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      pillTakens: null == pillTakens
          ? _value.pillTakens
          : pillTakens // ignore: cast_nullable_to_non_nullable
              as List<PillTaken>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PillCopyWith<$Res> implements $PillCopyWith<$Res> {
  factory _$$_PillCopyWith(_$_Pill value, $Res Function(_$_Pill) then) =
      __$$_PillCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int index,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime createdDateTime,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime updatedDateTime,
      List<PillTaken> pillTakens});
}

/// @nodoc
class __$$_PillCopyWithImpl<$Res> extends _$PillCopyWithImpl<$Res, _$_Pill>
    implements _$$_PillCopyWith<$Res> {
  __$$_PillCopyWithImpl(_$_Pill _value, $Res Function(_$_Pill) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? createdDateTime = null,
    Object? updatedDateTime = null,
    Object? pillTakens = null,
  }) {
    return _then(_$_Pill(
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      createdDateTime: null == createdDateTime
          ? _value.createdDateTime
          : createdDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedDateTime: null == updatedDateTime
          ? _value.updatedDateTime
          : updatedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      pillTakens: null == pillTakens
          ? _value._pillTakens
          : pillTakens // ignore: cast_nullable_to_non_nullable
              as List<PillTaken>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_Pill extends _Pill {
  const _$_Pill(
      {required this.index,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.createdDateTime,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.updatedDateTime,
      required final List<PillTaken> pillTakens})
      : _pillTakens = pillTakens,
        super._();

  factory _$_Pill.fromJson(Map<String, dynamic> json) => _$$_PillFromJson(json);

  @override
  final int index;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime createdDateTime;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime updatedDateTime;
  final List<PillTaken> _pillTakens;
  @override
  List<PillTaken> get pillTakens {
    if (_pillTakens is EqualUnmodifiableListView) return _pillTakens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pillTakens);
  }

  @override
  String toString() {
    return 'Pill(index: $index, createdDateTime: $createdDateTime, updatedDateTime: $updatedDateTime, pillTakens: $pillTakens)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Pill &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.createdDateTime, createdDateTime) ||
                other.createdDateTime == createdDateTime) &&
            (identical(other.updatedDateTime, updatedDateTime) ||
                other.updatedDateTime == updatedDateTime) &&
            const DeepCollectionEquality()
                .equals(other._pillTakens, _pillTakens));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, index, createdDateTime,
      updatedDateTime, const DeepCollectionEquality().hash(_pillTakens));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PillCopyWith<_$_Pill> get copyWith =>
      __$$_PillCopyWithImpl<_$_Pill>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PillToJson(
      this,
    );
  }
}

abstract class _Pill extends Pill {
  const factory _Pill(
      {required final int index,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required final DateTime createdDateTime,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required final DateTime updatedDateTime,
      required final List<PillTaken> pillTakens}) = _$_Pill;
  const _Pill._() : super._();

  factory _Pill.fromJson(Map<String, dynamic> json) = _$_Pill.fromJson;

  @override
  int get index;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdDateTime;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get updatedDateTime;
  @override
  List<PillTaken> get pillTakens;
  @override
  @JsonKey(ignore: true)
  _$$_PillCopyWith<_$_Pill> get copyWith => throw _privateConstructorUsedError;
}
