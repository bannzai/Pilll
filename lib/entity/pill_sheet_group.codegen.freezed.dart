// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'pill_sheet_group.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PillSheetGroup _$PillSheetGroupFromJson(Map<String, dynamic> json) {
  return _PillSheetGroup.fromJson(json);
}

/// @nodoc
class _$PillSheetGroupTearOff {
  const _$PillSheetGroupTearOff();

  _PillSheetGroup call(
      {@JsonKey(includeIfNull: false, toJson: toNull)
          String? id,
      required List<String> pillSheetIDs,
      required List<PillSheet> pillSheets,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime createdAt,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? deletedAt,
      OffsetPillNumber? offsetPillNumber}) {
    return _PillSheetGroup(
      id: id,
      pillSheetIDs: pillSheetIDs,
      pillSheets: pillSheets,
      createdAt: createdAt,
      deletedAt: deletedAt,
      offsetPillNumber: offsetPillNumber,
    );
  }

  PillSheetGroup fromJson(Map<String, Object?> json) {
    return PillSheetGroup.fromJson(json);
  }
}

/// @nodoc
const $PillSheetGroup = _$PillSheetGroupTearOff();

/// @nodoc
mixin _$PillSheetGroup {
  @JsonKey(includeIfNull: false, toJson: toNull)
  String? get id => throw _privateConstructorUsedError;
  List<String> get pillSheetIDs => throw _privateConstructorUsedError;
  List<PillSheet> get pillSheets => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  OffsetPillNumber? get offsetPillNumber => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PillSheetGroupCopyWith<PillSheetGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PillSheetGroupCopyWith<$Res> {
  factory $PillSheetGroupCopyWith(
          PillSheetGroup value, $Res Function(PillSheetGroup) then) =
      _$PillSheetGroupCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(includeIfNull: false, toJson: toNull)
          String? id,
      List<String> pillSheetIDs,
      List<PillSheet> pillSheets,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime createdAt,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? deletedAt,
      OffsetPillNumber? offsetPillNumber});

  $OffsetPillNumberCopyWith<$Res>? get offsetPillNumber;
}

/// @nodoc
class _$PillSheetGroupCopyWithImpl<$Res>
    implements $PillSheetGroupCopyWith<$Res> {
  _$PillSheetGroupCopyWithImpl(this._value, this._then);

  final PillSheetGroup _value;
  // ignore: unused_field
  final $Res Function(PillSheetGroup) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? pillSheetIDs = freezed,
    Object? pillSheets = freezed,
    Object? createdAt = freezed,
    Object? deletedAt = freezed,
    Object? offsetPillNumber = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      pillSheetIDs: pillSheetIDs == freezed
          ? _value.pillSheetIDs
          : pillSheetIDs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pillSheets: pillSheets == freezed
          ? _value.pillSheets
          : pillSheets // ignore: cast_nullable_to_non_nullable
              as List<PillSheet>,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deletedAt: deletedAt == freezed
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      offsetPillNumber: offsetPillNumber == freezed
          ? _value.offsetPillNumber
          : offsetPillNumber // ignore: cast_nullable_to_non_nullable
              as OffsetPillNumber?,
    ));
  }

  @override
  $OffsetPillNumberCopyWith<$Res>? get offsetPillNumber {
    if (_value.offsetPillNumber == null) {
      return null;
    }

    return $OffsetPillNumberCopyWith<$Res>(_value.offsetPillNumber!, (value) {
      return _then(_value.copyWith(offsetPillNumber: value));
    });
  }
}

/// @nodoc
abstract class _$PillSheetGroupCopyWith<$Res>
    implements $PillSheetGroupCopyWith<$Res> {
  factory _$PillSheetGroupCopyWith(
          _PillSheetGroup value, $Res Function(_PillSheetGroup) then) =
      __$PillSheetGroupCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(includeIfNull: false, toJson: toNull)
          String? id,
      List<String> pillSheetIDs,
      List<PillSheet> pillSheets,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime createdAt,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? deletedAt,
      OffsetPillNumber? offsetPillNumber});

  @override
  $OffsetPillNumberCopyWith<$Res>? get offsetPillNumber;
}

/// @nodoc
class __$PillSheetGroupCopyWithImpl<$Res>
    extends _$PillSheetGroupCopyWithImpl<$Res>
    implements _$PillSheetGroupCopyWith<$Res> {
  __$PillSheetGroupCopyWithImpl(
      _PillSheetGroup _value, $Res Function(_PillSheetGroup) _then)
      : super(_value, (v) => _then(v as _PillSheetGroup));

  @override
  _PillSheetGroup get _value => super._value as _PillSheetGroup;

  @override
  $Res call({
    Object? id = freezed,
    Object? pillSheetIDs = freezed,
    Object? pillSheets = freezed,
    Object? createdAt = freezed,
    Object? deletedAt = freezed,
    Object? offsetPillNumber = freezed,
  }) {
    return _then(_PillSheetGroup(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      pillSheetIDs: pillSheetIDs == freezed
          ? _value.pillSheetIDs
          : pillSheetIDs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pillSheets: pillSheets == freezed
          ? _value.pillSheets
          : pillSheets // ignore: cast_nullable_to_non_nullable
              as List<PillSheet>,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deletedAt: deletedAt == freezed
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      offsetPillNumber: offsetPillNumber == freezed
          ? _value.offsetPillNumber
          : offsetPillNumber // ignore: cast_nullable_to_non_nullable
              as OffsetPillNumber?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_PillSheetGroup extends _PillSheetGroup {
  const _$_PillSheetGroup(
      {@JsonKey(includeIfNull: false, toJson: toNull)
          this.id,
      required this.pillSheetIDs,
      required this.pillSheets,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.createdAt,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          this.deletedAt,
      this.offsetPillNumber})
      : super._();

  factory _$_PillSheetGroup.fromJson(Map<String, dynamic> json) =>
      _$$_PillSheetGroupFromJson(json);

  @override
  @JsonKey(includeIfNull: false, toJson: toNull)
  final String? id;
  @override
  final List<String> pillSheetIDs;
  @override
  final List<PillSheet> pillSheets;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime createdAt;
  @override
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  final DateTime? deletedAt;
  @override
  final OffsetPillNumber? offsetPillNumber;

  @override
  String toString() {
    return 'PillSheetGroup(id: $id, pillSheetIDs: $pillSheetIDs, pillSheets: $pillSheets, createdAt: $createdAt, deletedAt: $deletedAt, offsetPillNumber: $offsetPillNumber)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PillSheetGroup &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality()
                .equals(other.pillSheetIDs, pillSheetIDs) &&
            const DeepCollectionEquality()
                .equals(other.pillSheets, pillSheets) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality().equals(other.deletedAt, deletedAt) &&
            const DeepCollectionEquality()
                .equals(other.offsetPillNumber, offsetPillNumber));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(pillSheetIDs),
      const DeepCollectionEquality().hash(pillSheets),
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(deletedAt),
      const DeepCollectionEquality().hash(offsetPillNumber));

  @JsonKey(ignore: true)
  @override
  _$PillSheetGroupCopyWith<_PillSheetGroup> get copyWith =>
      __$PillSheetGroupCopyWithImpl<_PillSheetGroup>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PillSheetGroupToJson(this);
  }
}

abstract class _PillSheetGroup extends PillSheetGroup {
  const factory _PillSheetGroup(
      {@JsonKey(includeIfNull: false, toJson: toNull)
          String? id,
      required List<String> pillSheetIDs,
      required List<PillSheet> pillSheets,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime createdAt,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? deletedAt,
      OffsetPillNumber? offsetPillNumber}) = _$_PillSheetGroup;
  const _PillSheetGroup._() : super._();

  factory _PillSheetGroup.fromJson(Map<String, dynamic> json) =
      _$_PillSheetGroup.fromJson;

  @override
  @JsonKey(includeIfNull: false, toJson: toNull)
  String? get id;
  @override
  List<String> get pillSheetIDs;
  @override
  List<PillSheet> get pillSheets;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdAt;
  @override
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get deletedAt;
  @override
  OffsetPillNumber? get offsetPillNumber;
  @override
  @JsonKey(ignore: true)
  _$PillSheetGroupCopyWith<_PillSheetGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

OffsetPillNumber _$OffsetPillNumberFromJson(Map<String, dynamic> json) {
  return _OffsetPillNumber.fromJson(json);
}

/// @nodoc
class _$OffsetPillNumberTearOff {
  const _$OffsetPillNumberTearOff();

  _OffsetPillNumber call({int? beginPillNumber, int? endPillNumber}) {
    return _OffsetPillNumber(
      beginPillNumber: beginPillNumber,
      endPillNumber: endPillNumber,
    );
  }

  OffsetPillNumber fromJson(Map<String, Object?> json) {
    return OffsetPillNumber.fromJson(json);
  }
}

/// @nodoc
const $OffsetPillNumber = _$OffsetPillNumberTearOff();

/// @nodoc
mixin _$OffsetPillNumber {
  int? get beginPillNumber => throw _privateConstructorUsedError;
  int? get endPillNumber => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OffsetPillNumberCopyWith<OffsetPillNumber> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OffsetPillNumberCopyWith<$Res> {
  factory $OffsetPillNumberCopyWith(
          OffsetPillNumber value, $Res Function(OffsetPillNumber) then) =
      _$OffsetPillNumberCopyWithImpl<$Res>;
  $Res call({int? beginPillNumber, int? endPillNumber});
}

/// @nodoc
class _$OffsetPillNumberCopyWithImpl<$Res>
    implements $OffsetPillNumberCopyWith<$Res> {
  _$OffsetPillNumberCopyWithImpl(this._value, this._then);

  final OffsetPillNumber _value;
  // ignore: unused_field
  final $Res Function(OffsetPillNumber) _then;

  @override
  $Res call({
    Object? beginPillNumber = freezed,
    Object? endPillNumber = freezed,
  }) {
    return _then(_value.copyWith(
      beginPillNumber: beginPillNumber == freezed
          ? _value.beginPillNumber
          : beginPillNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      endPillNumber: endPillNumber == freezed
          ? _value.endPillNumber
          : endPillNumber // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
abstract class _$OffsetPillNumberCopyWith<$Res>
    implements $OffsetPillNumberCopyWith<$Res> {
  factory _$OffsetPillNumberCopyWith(
          _OffsetPillNumber value, $Res Function(_OffsetPillNumber) then) =
      __$OffsetPillNumberCopyWithImpl<$Res>;
  @override
  $Res call({int? beginPillNumber, int? endPillNumber});
}

/// @nodoc
class __$OffsetPillNumberCopyWithImpl<$Res>
    extends _$OffsetPillNumberCopyWithImpl<$Res>
    implements _$OffsetPillNumberCopyWith<$Res> {
  __$OffsetPillNumberCopyWithImpl(
      _OffsetPillNumber _value, $Res Function(_OffsetPillNumber) _then)
      : super(_value, (v) => _then(v as _OffsetPillNumber));

  @override
  _OffsetPillNumber get _value => super._value as _OffsetPillNumber;

  @override
  $Res call({
    Object? beginPillNumber = freezed,
    Object? endPillNumber = freezed,
  }) {
    return _then(_OffsetPillNumber(
      beginPillNumber: beginPillNumber == freezed
          ? _value.beginPillNumber
          : beginPillNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      endPillNumber: endPillNumber == freezed
          ? _value.endPillNumber
          : endPillNumber // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_OffsetPillNumber implements _OffsetPillNumber {
  const _$_OffsetPillNumber({this.beginPillNumber, this.endPillNumber});

  factory _$_OffsetPillNumber.fromJson(Map<String, dynamic> json) =>
      _$$_OffsetPillNumberFromJson(json);

  @override
  final int? beginPillNumber;
  @override
  final int? endPillNumber;

  @override
  String toString() {
    return 'OffsetPillNumber(beginPillNumber: $beginPillNumber, endPillNumber: $endPillNumber)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OffsetPillNumber &&
            const DeepCollectionEquality()
                .equals(other.beginPillNumber, beginPillNumber) &&
            const DeepCollectionEquality()
                .equals(other.endPillNumber, endPillNumber));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(beginPillNumber),
      const DeepCollectionEquality().hash(endPillNumber));

  @JsonKey(ignore: true)
  @override
  _$OffsetPillNumberCopyWith<_OffsetPillNumber> get copyWith =>
      __$OffsetPillNumberCopyWithImpl<_OffsetPillNumber>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_OffsetPillNumberToJson(this);
  }
}

abstract class _OffsetPillNumber implements OffsetPillNumber {
  const factory _OffsetPillNumber({int? beginPillNumber, int? endPillNumber}) =
      _$_OffsetPillNumber;

  factory _OffsetPillNumber.fromJson(Map<String, dynamic> json) =
      _$_OffsetPillNumber.fromJson;

  @override
  int? get beginPillNumber;
  @override
  int? get endPillNumber;
  @override
  @JsonKey(ignore: true)
  _$OffsetPillNumberCopyWith<_OffsetPillNumber> get copyWith =>
      throw _privateConstructorUsedError;
}
