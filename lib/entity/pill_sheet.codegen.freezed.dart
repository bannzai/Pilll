// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'pill_sheet.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PillSheetTypeInfo _$PillSheetTypeInfoFromJson(Map<String, dynamic> json) {
  return _PillSheetTypeInfo.fromJson(json);
}

/// @nodoc
mixin _$PillSheetTypeInfo {
  String get pillSheetTypeReferencePath => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  int get dosingPeriod => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PillSheetTypeInfoCopyWith<PillSheetTypeInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PillSheetTypeInfoCopyWith<$Res> {
  factory $PillSheetTypeInfoCopyWith(
          PillSheetTypeInfo value, $Res Function(PillSheetTypeInfo) then) =
      _$PillSheetTypeInfoCopyWithImpl<$Res, PillSheetTypeInfo>;
  @useResult
  $Res call(
      {String pillSheetTypeReferencePath,
      String name,
      int totalCount,
      int dosingPeriod});
}

/// @nodoc
class _$PillSheetTypeInfoCopyWithImpl<$Res, $Val extends PillSheetTypeInfo>
    implements $PillSheetTypeInfoCopyWith<$Res> {
  _$PillSheetTypeInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pillSheetTypeReferencePath = null,
    Object? name = null,
    Object? totalCount = null,
    Object? dosingPeriod = null,
  }) {
    return _then(_value.copyWith(
      pillSheetTypeReferencePath: null == pillSheetTypeReferencePath
          ? _value.pillSheetTypeReferencePath
          : pillSheetTypeReferencePath // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      dosingPeriod: null == dosingPeriod
          ? _value.dosingPeriod
          : dosingPeriod // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PillSheetTypeInfoCopyWith<$Res>
    implements $PillSheetTypeInfoCopyWith<$Res> {
  factory _$$_PillSheetTypeInfoCopyWith(_$_PillSheetTypeInfo value,
          $Res Function(_$_PillSheetTypeInfo) then) =
      __$$_PillSheetTypeInfoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String pillSheetTypeReferencePath,
      String name,
      int totalCount,
      int dosingPeriod});
}

/// @nodoc
class __$$_PillSheetTypeInfoCopyWithImpl<$Res>
    extends _$PillSheetTypeInfoCopyWithImpl<$Res, _$_PillSheetTypeInfo>
    implements _$$_PillSheetTypeInfoCopyWith<$Res> {
  __$$_PillSheetTypeInfoCopyWithImpl(
      _$_PillSheetTypeInfo _value, $Res Function(_$_PillSheetTypeInfo) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pillSheetTypeReferencePath = null,
    Object? name = null,
    Object? totalCount = null,
    Object? dosingPeriod = null,
  }) {
    return _then(_$_PillSheetTypeInfo(
      pillSheetTypeReferencePath: null == pillSheetTypeReferencePath
          ? _value.pillSheetTypeReferencePath
          : pillSheetTypeReferencePath // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      dosingPeriod: null == dosingPeriod
          ? _value.dosingPeriod
          : dosingPeriod // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_PillSheetTypeInfo implements _PillSheetTypeInfo {
  const _$_PillSheetTypeInfo(
      {required this.pillSheetTypeReferencePath,
      required this.name,
      required this.totalCount,
      required this.dosingPeriod});

  factory _$_PillSheetTypeInfo.fromJson(Map<String, dynamic> json) =>
      _$$_PillSheetTypeInfoFromJson(json);

  @override
  final String pillSheetTypeReferencePath;
  @override
  final String name;
  @override
  final int totalCount;
  @override
  final int dosingPeriod;

  @override
  String toString() {
    return 'PillSheetTypeInfo(pillSheetTypeReferencePath: $pillSheetTypeReferencePath, name: $name, totalCount: $totalCount, dosingPeriod: $dosingPeriod)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PillSheetTypeInfo &&
            (identical(other.pillSheetTypeReferencePath,
                    pillSheetTypeReferencePath) ||
                other.pillSheetTypeReferencePath ==
                    pillSheetTypeReferencePath) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.dosingPeriod, dosingPeriod) ||
                other.dosingPeriod == dosingPeriod));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, pillSheetTypeReferencePath, name, totalCount, dosingPeriod);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PillSheetTypeInfoCopyWith<_$_PillSheetTypeInfo> get copyWith =>
      __$$_PillSheetTypeInfoCopyWithImpl<_$_PillSheetTypeInfo>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PillSheetTypeInfoToJson(
      this,
    );
  }
}

abstract class _PillSheetTypeInfo implements PillSheetTypeInfo {
  const factory _PillSheetTypeInfo(
      {required final String pillSheetTypeReferencePath,
      required final String name,
      required final int totalCount,
      required final int dosingPeriod}) = _$_PillSheetTypeInfo;

  factory _PillSheetTypeInfo.fromJson(Map<String, dynamic> json) =
      _$_PillSheetTypeInfo.fromJson;

  @override
  String get pillSheetTypeReferencePath;
  @override
  String get name;
  @override
  int get totalCount;
  @override
  int get dosingPeriod;
  @override
  @JsonKey(ignore: true)
  _$$_PillSheetTypeInfoCopyWith<_$_PillSheetTypeInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

RestDuration _$RestDurationFromJson(Map<String, dynamic> json) {
  return _RestDuration.fromJson(json);
}

/// @nodoc
mixin _$RestDuration {
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get beginDate => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get endDate => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RestDurationCopyWith<RestDuration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RestDurationCopyWith<$Res> {
  factory $RestDurationCopyWith(
          RestDuration value, $Res Function(RestDuration) then) =
      _$RestDurationCopyWithImpl<$Res, RestDuration>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime beginDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? endDate,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime createdDate});
}

/// @nodoc
class _$RestDurationCopyWithImpl<$Res, $Val extends RestDuration>
    implements $RestDurationCopyWith<$Res> {
  _$RestDurationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? beginDate = null,
    Object? endDate = freezed,
    Object? createdDate = null,
  }) {
    return _then(_value.copyWith(
      beginDate: null == beginDate
          ? _value.beginDate
          : beginDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdDate: null == createdDate
          ? _value.createdDate
          : createdDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_RestDurationCopyWith<$Res>
    implements $RestDurationCopyWith<$Res> {
  factory _$$_RestDurationCopyWith(
          _$_RestDuration value, $Res Function(_$_RestDuration) then) =
      __$$_RestDurationCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime beginDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? endDate,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime createdDate});
}

/// @nodoc
class __$$_RestDurationCopyWithImpl<$Res>
    extends _$RestDurationCopyWithImpl<$Res, _$_RestDuration>
    implements _$$_RestDurationCopyWith<$Res> {
  __$$_RestDurationCopyWithImpl(
      _$_RestDuration _value, $Res Function(_$_RestDuration) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? beginDate = null,
    Object? endDate = freezed,
    Object? createdDate = null,
  }) {
    return _then(_$_RestDuration(
      beginDate: null == beginDate
          ? _value.beginDate
          : beginDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdDate: null == createdDate
          ? _value.createdDate
          : createdDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_RestDuration implements _RestDuration {
  const _$_RestDuration(
      {@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.beginDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          this.endDate,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.createdDate});

  factory _$_RestDuration.fromJson(Map<String, dynamic> json) =>
      _$$_RestDurationFromJson(json);

  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime beginDate;
  @override
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  final DateTime? endDate;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime createdDate;

  @override
  String toString() {
    return 'RestDuration(beginDate: $beginDate, endDate: $endDate, createdDate: $createdDate)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RestDuration &&
            (identical(other.beginDate, beginDate) ||
                other.beginDate == beginDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.createdDate, createdDate) ||
                other.createdDate == createdDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, beginDate, endDate, createdDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_RestDurationCopyWith<_$_RestDuration> get copyWith =>
      __$$_RestDurationCopyWithImpl<_$_RestDuration>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_RestDurationToJson(
      this,
    );
  }
}

abstract class _RestDuration implements RestDuration {
  const factory _RestDuration(
      {@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required final DateTime beginDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          final DateTime? endDate,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required final DateTime createdDate}) = _$_RestDuration;

  factory _RestDuration.fromJson(Map<String, dynamic> json) =
      _$_RestDuration.fromJson;

  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get beginDate;
  @override
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get endDate;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdDate;
  @override
  @JsonKey(ignore: true)
  _$$_RestDurationCopyWith<_$_RestDuration> get copyWith =>
      throw _privateConstructorUsedError;
}

PillSheet _$PillSheetFromJson(Map<String, dynamic> json) {
  return _PillSheet.fromJson(json);
}

/// @nodoc
mixin _$PillSheet {
  @JsonKey(includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey()
  PillSheetTypeInfo get typeInfo => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get beginingDate => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get lastTakenDate => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  int get groupIndex => throw _privateConstructorUsedError;
  List<RestDuration> get restDurations => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PillSheetCopyWith<PillSheet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PillSheetCopyWith<$Res> {
  factory $PillSheetCopyWith(PillSheet value, $Res Function(PillSheet) then) =
      _$PillSheetCopyWithImpl<$Res, PillSheet>;
  @useResult
  $Res call(
      {@JsonKey(includeIfNull: false)
          String? id,
      @JsonKey()
          PillSheetTypeInfo typeInfo,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime beginingDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? lastTakenDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? createdAt,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? deletedAt,
      int groupIndex,
      List<RestDuration> restDurations});

  $PillSheetTypeInfoCopyWith<$Res> get typeInfo;
}

/// @nodoc
class _$PillSheetCopyWithImpl<$Res, $Val extends PillSheet>
    implements $PillSheetCopyWith<$Res> {
  _$PillSheetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? typeInfo = null,
    Object? beginingDate = null,
    Object? lastTakenDate = freezed,
    Object? createdAt = freezed,
    Object? deletedAt = freezed,
    Object? groupIndex = null,
    Object? restDurations = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      typeInfo: null == typeInfo
          ? _value.typeInfo
          : typeInfo // ignore: cast_nullable_to_non_nullable
              as PillSheetTypeInfo,
      beginingDate: null == beginingDate
          ? _value.beginingDate
          : beginingDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastTakenDate: freezed == lastTakenDate
          ? _value.lastTakenDate
          : lastTakenDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      groupIndex: null == groupIndex
          ? _value.groupIndex
          : groupIndex // ignore: cast_nullable_to_non_nullable
              as int,
      restDurations: null == restDurations
          ? _value.restDurations
          : restDurations // ignore: cast_nullable_to_non_nullable
              as List<RestDuration>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PillSheetTypeInfoCopyWith<$Res> get typeInfo {
    return $PillSheetTypeInfoCopyWith<$Res>(_value.typeInfo, (value) {
      return _then(_value.copyWith(typeInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_PillSheetCopyWith<$Res> implements $PillSheetCopyWith<$Res> {
  factory _$$_PillSheetCopyWith(
          _$_PillSheet value, $Res Function(_$_PillSheet) then) =
      __$$_PillSheetCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(includeIfNull: false)
          String? id,
      @JsonKey()
          PillSheetTypeInfo typeInfo,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime beginingDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? lastTakenDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? createdAt,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? deletedAt,
      int groupIndex,
      List<RestDuration> restDurations});

  @override
  $PillSheetTypeInfoCopyWith<$Res> get typeInfo;
}

/// @nodoc
class __$$_PillSheetCopyWithImpl<$Res>
    extends _$PillSheetCopyWithImpl<$Res, _$_PillSheet>
    implements _$$_PillSheetCopyWith<$Res> {
  __$$_PillSheetCopyWithImpl(
      _$_PillSheet _value, $Res Function(_$_PillSheet) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? typeInfo = null,
    Object? beginingDate = null,
    Object? lastTakenDate = freezed,
    Object? createdAt = freezed,
    Object? deletedAt = freezed,
    Object? groupIndex = null,
    Object? restDurations = null,
  }) {
    return _then(_$_PillSheet(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      typeInfo: null == typeInfo
          ? _value.typeInfo
          : typeInfo // ignore: cast_nullable_to_non_nullable
              as PillSheetTypeInfo,
      beginingDate: null == beginingDate
          ? _value.beginingDate
          : beginingDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastTakenDate: freezed == lastTakenDate
          ? _value.lastTakenDate
          : lastTakenDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      groupIndex: null == groupIndex
          ? _value.groupIndex
          : groupIndex // ignore: cast_nullable_to_non_nullable
              as int,
      restDurations: null == restDurations
          ? _value._restDurations
          : restDurations // ignore: cast_nullable_to_non_nullable
              as List<RestDuration>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_PillSheet extends _PillSheet {
  const _$_PillSheet(
      {@JsonKey(includeIfNull: false)
          required this.id,
      @JsonKey()
          required this.typeInfo,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.beginingDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          this.lastTakenDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          required this.createdAt,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          this.deletedAt,
      this.groupIndex = 0,
      final List<RestDuration> restDurations = const []})
      : _restDurations = restDurations,
        super._();

  factory _$_PillSheet.fromJson(Map<String, dynamic> json) =>
      _$$_PillSheetFromJson(json);

  @override
  @JsonKey(includeIfNull: false)
  final String? id;
  @override
  @JsonKey()
  final PillSheetTypeInfo typeInfo;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime beginingDate;
  @override
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  final DateTime? lastTakenDate;
  @override
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  final DateTime? createdAt;
  @override
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  final DateTime? deletedAt;
  @override
  @JsonKey()
  final int groupIndex;
  final List<RestDuration> _restDurations;
  @override
  @JsonKey()
  List<RestDuration> get restDurations {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_restDurations);
  }

  @override
  String toString() {
    return 'PillSheet(id: $id, typeInfo: $typeInfo, beginingDate: $beginingDate, lastTakenDate: $lastTakenDate, createdAt: $createdAt, deletedAt: $deletedAt, groupIndex: $groupIndex, restDurations: $restDurations)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PillSheet &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.typeInfo, typeInfo) ||
                other.typeInfo == typeInfo) &&
            (identical(other.beginingDate, beginingDate) ||
                other.beginingDate == beginingDate) &&
            (identical(other.lastTakenDate, lastTakenDate) ||
                other.lastTakenDate == lastTakenDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.groupIndex, groupIndex) ||
                other.groupIndex == groupIndex) &&
            const DeepCollectionEquality()
                .equals(other._restDurations, _restDurations));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      typeInfo,
      beginingDate,
      lastTakenDate,
      createdAt,
      deletedAt,
      groupIndex,
      const DeepCollectionEquality().hash(_restDurations));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PillSheetCopyWith<_$_PillSheet> get copyWith =>
      __$$_PillSheetCopyWithImpl<_$_PillSheet>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PillSheetToJson(
      this,
    );
  }
}

abstract class _PillSheet extends PillSheet {
  const factory _PillSheet(
      {@JsonKey(includeIfNull: false)
          required final String? id,
      @JsonKey()
          required final PillSheetTypeInfo typeInfo,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required final DateTime beginingDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          final DateTime? lastTakenDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          required final DateTime? createdAt,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          final DateTime? deletedAt,
      final int groupIndex,
      final List<RestDuration> restDurations}) = _$_PillSheet;
  const _PillSheet._() : super._();

  factory _PillSheet.fromJson(Map<String, dynamic> json) =
      _$_PillSheet.fromJson;

  @override
  @JsonKey(includeIfNull: false)
  String? get id;
  @override
  @JsonKey()
  PillSheetTypeInfo get typeInfo;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get beginingDate;
  @override
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get lastTakenDate;
  @override
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get createdAt;
  @override
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get deletedAt;
  @override
  int get groupIndex;
  @override
  List<RestDuration> get restDurations;
  @override
  @JsonKey(ignore: true)
  _$$_PillSheetCopyWith<_$_PillSheet> get copyWith =>
      throw _privateConstructorUsedError;
}
