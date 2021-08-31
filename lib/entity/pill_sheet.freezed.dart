// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'pill_sheet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PillSheetTypeInfo _$PillSheetTypeInfoFromJson(Map<String, dynamic> json) {
  return _PillSheetTypeInfo.fromJson(json);
}

/// @nodoc
class _$PillSheetTypeInfoTearOff {
  const _$PillSheetTypeInfoTearOff();

  _PillSheetTypeInfo call(
      {required String pillSheetTypeReferencePath,
      required String name,
      required int totalCount,
      required int dosingPeriod}) {
    return _PillSheetTypeInfo(
      pillSheetTypeReferencePath: pillSheetTypeReferencePath,
      name: name,
      totalCount: totalCount,
      dosingPeriod: dosingPeriod,
    );
  }

  PillSheetTypeInfo fromJson(Map<String, Object> json) {
    return PillSheetTypeInfo.fromJson(json);
  }
}

/// @nodoc
const $PillSheetTypeInfo = _$PillSheetTypeInfoTearOff();

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
      _$PillSheetTypeInfoCopyWithImpl<$Res>;
  $Res call(
      {String pillSheetTypeReferencePath,
      String name,
      int totalCount,
      int dosingPeriod});
}

/// @nodoc
class _$PillSheetTypeInfoCopyWithImpl<$Res>
    implements $PillSheetTypeInfoCopyWith<$Res> {
  _$PillSheetTypeInfoCopyWithImpl(this._value, this._then);

  final PillSheetTypeInfo _value;
  // ignore: unused_field
  final $Res Function(PillSheetTypeInfo) _then;

  @override
  $Res call({
    Object? pillSheetTypeReferencePath = freezed,
    Object? name = freezed,
    Object? totalCount = freezed,
    Object? dosingPeriod = freezed,
  }) {
    return _then(_value.copyWith(
      pillSheetTypeReferencePath: pillSheetTypeReferencePath == freezed
          ? _value.pillSheetTypeReferencePath
          : pillSheetTypeReferencePath // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      totalCount: totalCount == freezed
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      dosingPeriod: dosingPeriod == freezed
          ? _value.dosingPeriod
          : dosingPeriod // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$PillSheetTypeInfoCopyWith<$Res>
    implements $PillSheetTypeInfoCopyWith<$Res> {
  factory _$PillSheetTypeInfoCopyWith(
          _PillSheetTypeInfo value, $Res Function(_PillSheetTypeInfo) then) =
      __$PillSheetTypeInfoCopyWithImpl<$Res>;
  @override
  $Res call(
      {String pillSheetTypeReferencePath,
      String name,
      int totalCount,
      int dosingPeriod});
}

/// @nodoc
class __$PillSheetTypeInfoCopyWithImpl<$Res>
    extends _$PillSheetTypeInfoCopyWithImpl<$Res>
    implements _$PillSheetTypeInfoCopyWith<$Res> {
  __$PillSheetTypeInfoCopyWithImpl(
      _PillSheetTypeInfo _value, $Res Function(_PillSheetTypeInfo) _then)
      : super(_value, (v) => _then(v as _PillSheetTypeInfo));

  @override
  _PillSheetTypeInfo get _value => super._value as _PillSheetTypeInfo;

  @override
  $Res call({
    Object? pillSheetTypeReferencePath = freezed,
    Object? name = freezed,
    Object? totalCount = freezed,
    Object? dosingPeriod = freezed,
  }) {
    return _then(_PillSheetTypeInfo(
      pillSheetTypeReferencePath: pillSheetTypeReferencePath == freezed
          ? _value.pillSheetTypeReferencePath
          : pillSheetTypeReferencePath // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      totalCount: totalCount == freezed
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      dosingPeriod: dosingPeriod == freezed
          ? _value.dosingPeriod
          : dosingPeriod // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_PillSheetTypeInfo implements _PillSheetTypeInfo {
  _$_PillSheetTypeInfo(
      {required this.pillSheetTypeReferencePath,
      required this.name,
      required this.totalCount,
      required this.dosingPeriod});

  factory _$_PillSheetTypeInfo.fromJson(Map<String, dynamic> json) =>
      _$_$_PillSheetTypeInfoFromJson(json);

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
        (other is _PillSheetTypeInfo &&
            (identical(other.pillSheetTypeReferencePath,
                    pillSheetTypeReferencePath) ||
                const DeepCollectionEquality().equals(
                    other.pillSheetTypeReferencePath,
                    pillSheetTypeReferencePath)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.totalCount, totalCount) ||
                const DeepCollectionEquality()
                    .equals(other.totalCount, totalCount)) &&
            (identical(other.dosingPeriod, dosingPeriod) ||
                const DeepCollectionEquality()
                    .equals(other.dosingPeriod, dosingPeriod)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(pillSheetTypeReferencePath) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(totalCount) ^
      const DeepCollectionEquality().hash(dosingPeriod);

  @JsonKey(ignore: true)
  @override
  _$PillSheetTypeInfoCopyWith<_PillSheetTypeInfo> get copyWith =>
      __$PillSheetTypeInfoCopyWithImpl<_PillSheetTypeInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_PillSheetTypeInfoToJson(this);
  }
}

abstract class _PillSheetTypeInfo implements PillSheetTypeInfo {
  factory _PillSheetTypeInfo(
      {required String pillSheetTypeReferencePath,
      required String name,
      required int totalCount,
      required int dosingPeriod}) = _$_PillSheetTypeInfo;

  factory _PillSheetTypeInfo.fromJson(Map<String, dynamic> json) =
      _$_PillSheetTypeInfo.fromJson;

  @override
  String get pillSheetTypeReferencePath => throw _privateConstructorUsedError;
  @override
  String get name => throw _privateConstructorUsedError;
  @override
  int get totalCount => throw _privateConstructorUsedError;
  @override
  int get dosingPeriod => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$PillSheetTypeInfoCopyWith<_PillSheetTypeInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

PillSheet _$PillSheetFromJson(Map<String, dynamic> json) {
  return _PillSheet.fromJson(json);
}

/// @nodoc
class _$PillSheetTearOff {
  const _$PillSheetTearOff();

  _PillSheet call(
      {@JsonKey(includeIfNull: false, toJson: toNull)
          String? id,
      @JsonKey()
          required PillSheetTypeInfo typeInfo,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime beginingDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? lastTakenDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? createdAt,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? deletedAt,
      int? gropuIndex}) {
    return _PillSheet(
      id: id,
      typeInfo: typeInfo,
      beginingDate: beginingDate,
      lastTakenDate: lastTakenDate,
      createdAt: createdAt,
      deletedAt: deletedAt,
      gropuIndex: gropuIndex,
    );
  }

  PillSheet fromJson(Map<String, Object> json) {
    return PillSheet.fromJson(json);
  }
}

/// @nodoc
const $PillSheet = _$PillSheetTearOff();

/// @nodoc
mixin _$PillSheet {
  @JsonKey(includeIfNull: false, toJson: toNull)
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
  int? get gropuIndex => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PillSheetCopyWith<PillSheet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PillSheetCopyWith<$Res> {
  factory $PillSheetCopyWith(PillSheet value, $Res Function(PillSheet) then) =
      _$PillSheetCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(includeIfNull: false, toJson: toNull)
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
      int? gropuIndex});

  $PillSheetTypeInfoCopyWith<$Res> get typeInfo;
}

/// @nodoc
class _$PillSheetCopyWithImpl<$Res> implements $PillSheetCopyWith<$Res> {
  _$PillSheetCopyWithImpl(this._value, this._then);

  final PillSheet _value;
  // ignore: unused_field
  final $Res Function(PillSheet) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? typeInfo = freezed,
    Object? beginingDate = freezed,
    Object? lastTakenDate = freezed,
    Object? createdAt = freezed,
    Object? deletedAt = freezed,
    Object? gropuIndex = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      typeInfo: typeInfo == freezed
          ? _value.typeInfo
          : typeInfo // ignore: cast_nullable_to_non_nullable
              as PillSheetTypeInfo,
      beginingDate: beginingDate == freezed
          ? _value.beginingDate
          : beginingDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastTakenDate: lastTakenDate == freezed
          ? _value.lastTakenDate
          : lastTakenDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: deletedAt == freezed
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      gropuIndex: gropuIndex == freezed
          ? _value.gropuIndex
          : gropuIndex // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  @override
  $PillSheetTypeInfoCopyWith<$Res> get typeInfo {
    return $PillSheetTypeInfoCopyWith<$Res>(_value.typeInfo, (value) {
      return _then(_value.copyWith(typeInfo: value));
    });
  }
}

/// @nodoc
abstract class _$PillSheetCopyWith<$Res> implements $PillSheetCopyWith<$Res> {
  factory _$PillSheetCopyWith(
          _PillSheet value, $Res Function(_PillSheet) then) =
      __$PillSheetCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(includeIfNull: false, toJson: toNull)
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
      int? gropuIndex});

  @override
  $PillSheetTypeInfoCopyWith<$Res> get typeInfo;
}

/// @nodoc
class __$PillSheetCopyWithImpl<$Res> extends _$PillSheetCopyWithImpl<$Res>
    implements _$PillSheetCopyWith<$Res> {
  __$PillSheetCopyWithImpl(_PillSheet _value, $Res Function(_PillSheet) _then)
      : super(_value, (v) => _then(v as _PillSheet));

  @override
  _PillSheet get _value => super._value as _PillSheet;

  @override
  $Res call({
    Object? id = freezed,
    Object? typeInfo = freezed,
    Object? beginingDate = freezed,
    Object? lastTakenDate = freezed,
    Object? createdAt = freezed,
    Object? deletedAt = freezed,
    Object? gropuIndex = freezed,
  }) {
    return _then(_PillSheet(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      typeInfo: typeInfo == freezed
          ? _value.typeInfo
          : typeInfo // ignore: cast_nullable_to_non_nullable
              as PillSheetTypeInfo,
      beginingDate: beginingDate == freezed
          ? _value.beginingDate
          : beginingDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastTakenDate: lastTakenDate == freezed
          ? _value.lastTakenDate
          : lastTakenDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: deletedAt == freezed
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      gropuIndex: gropuIndex == freezed
          ? _value.gropuIndex
          : gropuIndex // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_PillSheet extends _PillSheet {
  _$_PillSheet(
      {@JsonKey(includeIfNull: false, toJson: toNull)
          this.id,
      @JsonKey()
          required this.typeInfo,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.beginingDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          this.lastTakenDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          this.createdAt,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          this.deletedAt,
      this.gropuIndex})
      : super._();

  factory _$_PillSheet.fromJson(Map<String, dynamic> json) =>
      _$_$_PillSheetFromJson(json);

  @override
  @JsonKey(includeIfNull: false, toJson: toNull)
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
  final int? gropuIndex;

  @override
  String toString() {
    return 'PillSheet(id: $id, typeInfo: $typeInfo, beginingDate: $beginingDate, lastTakenDate: $lastTakenDate, createdAt: $createdAt, deletedAt: $deletedAt, gropuIndex: $gropuIndex)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _PillSheet &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.typeInfo, typeInfo) ||
                const DeepCollectionEquality()
                    .equals(other.typeInfo, typeInfo)) &&
            (identical(other.beginingDate, beginingDate) ||
                const DeepCollectionEquality()
                    .equals(other.beginingDate, beginingDate)) &&
            (identical(other.lastTakenDate, lastTakenDate) ||
                const DeepCollectionEquality()
                    .equals(other.lastTakenDate, lastTakenDate)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.deletedAt, deletedAt) ||
                const DeepCollectionEquality()
                    .equals(other.deletedAt, deletedAt)) &&
            (identical(other.gropuIndex, gropuIndex) ||
                const DeepCollectionEquality()
                    .equals(other.gropuIndex, gropuIndex)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(typeInfo) ^
      const DeepCollectionEquality().hash(beginingDate) ^
      const DeepCollectionEquality().hash(lastTakenDate) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(deletedAt) ^
      const DeepCollectionEquality().hash(gropuIndex);

  @JsonKey(ignore: true)
  @override
  _$PillSheetCopyWith<_PillSheet> get copyWith =>
      __$PillSheetCopyWithImpl<_PillSheet>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_PillSheetToJson(this);
  }
}

abstract class _PillSheet extends PillSheet {
  factory _PillSheet(
      {@JsonKey(includeIfNull: false, toJson: toNull)
          String? id,
      @JsonKey()
          required PillSheetTypeInfo typeInfo,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime beginingDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? lastTakenDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? createdAt,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? deletedAt,
      int? gropuIndex}) = _$_PillSheet;
  _PillSheet._() : super._();

  factory _PillSheet.fromJson(Map<String, dynamic> json) =
      _$_PillSheet.fromJson;

  @override
  @JsonKey(includeIfNull: false, toJson: toNull)
  String? get id => throw _privateConstructorUsedError;
  @override
  @JsonKey()
  PillSheetTypeInfo get typeInfo => throw _privateConstructorUsedError;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get beginingDate => throw _privateConstructorUsedError;
  @override
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get lastTakenDate => throw _privateConstructorUsedError;
  @override
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @override
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  @override
  int? get gropuIndex => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$PillSheetCopyWith<_PillSheet> get copyWith =>
      throw _privateConstructorUsedError;
}
