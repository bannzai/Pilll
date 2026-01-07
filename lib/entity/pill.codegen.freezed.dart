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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PillTaken _$PillTakenFromJson(Map<String, dynamic> json) {
  return _PillTaken.fromJson(json);
}

/// @nodoc
mixin _$PillTaken {
  /// 服用記録日時
  /// 同時服用を行った場合は対象となるPillTakenのrecordedTakenDateTimeは同一にする
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get recordedTakenDateTime => throw _privateConstructorUsedError;

  /// レコード作成日時
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdDateTime => throw _privateConstructorUsedError;

  /// レコード更新日時
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get updatedDateTime => throw _privateConstructorUsedError;

  /// バックエンドで自動的に記録された場合にtrue
  bool get isAutomaticallyRecorded => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PillTakenCopyWith<PillTaken> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PillTakenCopyWith<$Res> {
  factory $PillTakenCopyWith(PillTaken value, $Res Function(PillTaken) then) = _$PillTakenCopyWithImpl<$Res, PillTaken>;
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
class _$PillTakenCopyWithImpl<$Res, $Val extends PillTaken> implements $PillTakenCopyWith<$Res> {
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
abstract class _$$PillTakenImplCopyWith<$Res> implements $PillTakenCopyWith<$Res> {
  factory _$$PillTakenImplCopyWith(_$PillTakenImpl value, $Res Function(_$PillTakenImpl) then) = __$$PillTakenImplCopyWithImpl<$Res>;
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
class __$$PillTakenImplCopyWithImpl<$Res> extends _$PillTakenCopyWithImpl<$Res, _$PillTakenImpl> implements _$$PillTakenImplCopyWith<$Res> {
  __$$PillTakenImplCopyWithImpl(_$PillTakenImpl _value, $Res Function(_$PillTakenImpl) _then) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recordedTakenDateTime = null,
    Object? createdDateTime = null,
    Object? updatedDateTime = null,
    Object? isAutomaticallyRecorded = null,
  }) {
    return _then(_$PillTakenImpl(
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
class _$PillTakenImpl implements _PillTaken {
  const _$PillTakenImpl(
      {@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      required this.recordedTakenDateTime,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      required this.createdDateTime,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      required this.updatedDateTime,
      this.isAutomaticallyRecorded = false});

  factory _$PillTakenImpl.fromJson(Map<String, dynamic> json) => _$$PillTakenImplFromJson(json);

  /// 服用記録日時
  /// 同時服用を行った場合は対象となるPillTakenのrecordedTakenDateTimeは同一にする
  @override
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime recordedTakenDateTime;

  /// レコード作成日時
  @override
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime createdDateTime;

  /// レコード更新日時
  @override
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime updatedDateTime;

  /// バックエンドで自動的に記録された場合にtrue
  @override
  @JsonKey()
  final bool isAutomaticallyRecorded;

  @override
  String toString() {
    return 'PillTaken(recordedTakenDateTime: $recordedTakenDateTime, createdDateTime: $createdDateTime, updatedDateTime: $updatedDateTime, isAutomaticallyRecorded: $isAutomaticallyRecorded)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PillTakenImpl &&
            (identical(other.recordedTakenDateTime, recordedTakenDateTime) || other.recordedTakenDateTime == recordedTakenDateTime) &&
            (identical(other.createdDateTime, createdDateTime) || other.createdDateTime == createdDateTime) &&
            (identical(other.updatedDateTime, updatedDateTime) || other.updatedDateTime == updatedDateTime) &&
            (identical(other.isAutomaticallyRecorded, isAutomaticallyRecorded) || other.isAutomaticallyRecorded == isAutomaticallyRecorded));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, recordedTakenDateTime, createdDateTime, updatedDateTime, isAutomaticallyRecorded);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PillTakenImplCopyWith<_$PillTakenImpl> get copyWith => __$$PillTakenImplCopyWithImpl<_$PillTakenImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PillTakenImplToJson(
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
      final bool isAutomaticallyRecorded}) = _$PillTakenImpl;

  factory _PillTaken.fromJson(Map<String, dynamic> json) = _$PillTakenImpl.fromJson;

  @override

  /// 服用記録日時
  /// 同時服用を行った場合は対象となるPillTakenのrecordedTakenDateTimeは同一にする
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get recordedTakenDateTime;
  @override

  /// レコード作成日時
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdDateTime;
  @override

  /// レコード更新日時
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get updatedDateTime;
  @override

  /// バックエンドで自動的に記録された場合にtrue
  bool get isAutomaticallyRecorded;
  @override
  @JsonKey(ignore: true)
  _$$PillTakenImplCopyWith<_$PillTakenImpl> get copyWith => throw _privateConstructorUsedError;
}

Pill _$PillFromJson(Map<String, dynamic> json) {
  return _Pill.fromJson(json);
}

/// @nodoc
mixin _$Pill {
  /// ピルシート内のインデックス（0始まり）
  int get index => throw _privateConstructorUsedError;

  /// このピルで服用すべき回数
  /// 1日2錠の場合は2、1日1錠の場合は1
  int get takenCount => throw _privateConstructorUsedError;

  /// レコード作成日時
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdDateTime => throw _privateConstructorUsedError;

  /// レコード更新日時
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get updatedDateTime => throw _privateConstructorUsedError;

  /// 服用記録のリスト
  /// 2錠飲みの場合は2つのPillTakenが入る
  List<PillTaken> get pillTakens => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PillCopyWith<Pill> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PillCopyWith<$Res> {
  factory $PillCopyWith(Pill value, $Res Function(Pill) then) = _$PillCopyWithImpl<$Res, Pill>;
  @useResult
  $Res call(
      {int index,
      int takenCount,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      DateTime createdDateTime,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      DateTime updatedDateTime,
      List<PillTaken> pillTakens});
}

/// @nodoc
class _$PillCopyWithImpl<$Res, $Val extends Pill> implements $PillCopyWith<$Res> {
  _$PillCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? takenCount = null,
    Object? createdDateTime = null,
    Object? updatedDateTime = null,
    Object? pillTakens = null,
  }) {
    return _then(_value.copyWith(
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      takenCount: null == takenCount
          ? _value.takenCount
          : takenCount // ignore: cast_nullable_to_non_nullable
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
abstract class _$$PillImplCopyWith<$Res> implements $PillCopyWith<$Res> {
  factory _$$PillImplCopyWith(_$PillImpl value, $Res Function(_$PillImpl) then) = __$$PillImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int index,
      int takenCount,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      DateTime createdDateTime,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      DateTime updatedDateTime,
      List<PillTaken> pillTakens});
}

/// @nodoc
class __$$PillImplCopyWithImpl<$Res> extends _$PillCopyWithImpl<$Res, _$PillImpl> implements _$$PillImplCopyWith<$Res> {
  __$$PillImplCopyWithImpl(_$PillImpl _value, $Res Function(_$PillImpl) _then) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? takenCount = null,
    Object? createdDateTime = null,
    Object? updatedDateTime = null,
    Object? pillTakens = null,
  }) {
    return _then(_$PillImpl(
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      takenCount: null == takenCount
          ? _value.takenCount
          : takenCount // ignore: cast_nullable_to_non_nullable
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
class _$PillImpl extends _Pill {
  const _$PillImpl(
      {required this.index,
      required this.takenCount,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      required this.createdDateTime,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      required this.updatedDateTime,
      required final List<PillTaken> pillTakens})
      : _pillTakens = pillTakens,
        super._();

  factory _$PillImpl.fromJson(Map<String, dynamic> json) => _$$PillImplFromJson(json);

  /// ピルシート内のインデックス（0始まり）
  @override
  final int index;

  /// このピルで服用すべき回数
  /// 1日2錠の場合は2、1日1錠の場合は1
  @override
  final int takenCount;

  /// レコード作成日時
  @override
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime createdDateTime;

  /// レコード更新日時
  @override
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime updatedDateTime;

  /// 服用記録のリスト
  /// 2錠飲みの場合は2つのPillTakenが入る
  final List<PillTaken> _pillTakens;

  /// 服用記録のリスト
  /// 2錠飲みの場合は2つのPillTakenが入る
  @override
  List<PillTaken> get pillTakens {
    if (_pillTakens is EqualUnmodifiableListView) return _pillTakens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pillTakens);
  }

  @override
  String toString() {
    return 'Pill(index: $index, takenCount: $takenCount, createdDateTime: $createdDateTime, updatedDateTime: $updatedDateTime, pillTakens: $pillTakens)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PillImpl &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.takenCount, takenCount) || other.takenCount == takenCount) &&
            (identical(other.createdDateTime, createdDateTime) || other.createdDateTime == createdDateTime) &&
            (identical(other.updatedDateTime, updatedDateTime) || other.updatedDateTime == updatedDateTime) &&
            const DeepCollectionEquality().equals(other._pillTakens, _pillTakens));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, index, takenCount, createdDateTime, updatedDateTime, const DeepCollectionEquality().hash(_pillTakens));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PillImplCopyWith<_$PillImpl> get copyWith => __$$PillImplCopyWithImpl<_$PillImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PillImplToJson(
      this,
    );
  }
}

abstract class _Pill extends Pill {
  const factory _Pill(
      {required final int index,
      required final int takenCount,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      required final DateTime createdDateTime,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      required final DateTime updatedDateTime,
      required final List<PillTaken> pillTakens}) = _$PillImpl;
  const _Pill._() : super._();

  factory _Pill.fromJson(Map<String, dynamic> json) = _$PillImpl.fromJson;

  @override

  /// ピルシート内のインデックス（0始まり）
  int get index;
  @override

  /// このピルで服用すべき回数
  /// 1日2錠の場合は2、1日1錠の場合は1
  int get takenCount;
  @override

  /// レコード作成日時
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdDateTime;
  @override

  /// レコード更新日時
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get updatedDateTime;
  @override

  /// 服用記録のリスト
  /// 2錠飲みの場合は2つのPillTakenが入る
  List<PillTaken> get pillTakens;
  @override
  @JsonKey(ignore: true)
  _$$PillImplCopyWith<_$PillImpl> get copyWith => throw _privateConstructorUsedError;
}
