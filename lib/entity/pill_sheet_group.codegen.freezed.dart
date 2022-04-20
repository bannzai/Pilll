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
      DisplayNumberSetting? displayNumberSetting}) {
    return _PillSheetGroup(
      id: id,
      pillSheetIDs: pillSheetIDs,
      pillSheets: pillSheets,
      createdAt: createdAt,
      deletedAt: deletedAt,
      displayNumberSetting: displayNumberSetting,
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
  DisplayNumberSetting? get displayNumberSetting =>
      throw _privateConstructorUsedError;

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
      DisplayNumberSetting? displayNumberSetting});

  $DisplayNumberSettingCopyWith<$Res>? get displayNumberSetting;
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
    Object? displayNumberSetting = freezed,
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
      displayNumberSetting: displayNumberSetting == freezed
          ? _value.displayNumberSetting
          : displayNumberSetting // ignore: cast_nullable_to_non_nullable
              as DisplayNumberSetting?,
    ));
  }

  @override
  $DisplayNumberSettingCopyWith<$Res>? get displayNumberSetting {
    if (_value.displayNumberSetting == null) {
      return null;
    }

    return $DisplayNumberSettingCopyWith<$Res>(_value.displayNumberSetting!,
        (value) {
      return _then(_value.copyWith(displayNumberSetting: value));
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
      DisplayNumberSetting? displayNumberSetting});

  @override
  $DisplayNumberSettingCopyWith<$Res>? get displayNumberSetting;
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
    Object? displayNumberSetting = freezed,
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
      displayNumberSetting: displayNumberSetting == freezed
          ? _value.displayNumberSetting
          : displayNumberSetting // ignore: cast_nullable_to_non_nullable
              as DisplayNumberSetting?,
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
      this.displayNumberSetting})
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
  final DisplayNumberSetting? displayNumberSetting;

  @override
  String toString() {
    return 'PillSheetGroup(id: $id, pillSheetIDs: $pillSheetIDs, pillSheets: $pillSheets, createdAt: $createdAt, deletedAt: $deletedAt, displayNumberSetting: $displayNumberSetting)';
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
                .equals(other.displayNumberSetting, displayNumberSetting));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(pillSheetIDs),
      const DeepCollectionEquality().hash(pillSheets),
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(deletedAt),
      const DeepCollectionEquality().hash(displayNumberSetting));

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
      DisplayNumberSetting? displayNumberSetting}) = _$_PillSheetGroup;
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
  DisplayNumberSetting? get displayNumberSetting;
  @override
  @JsonKey(ignore: true)
  _$PillSheetGroupCopyWith<_PillSheetGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

DisplayNumberSetting _$DisplayNumberSettingFromJson(Map<String, dynamic> json) {
  return _DisplayNumberSetting.fromJson(json);
}

/// @nodoc
class _$DisplayNumberSettingTearOff {
  const _$DisplayNumberSettingTearOff();

  _DisplayNumberSetting call({int? beginPillNumber, int? endPillNumber}) {
    return _DisplayNumberSetting(
      beginPillNumber: beginPillNumber,
      endPillNumber: endPillNumber,
    );
  }

  DisplayNumberSetting fromJson(Map<String, Object?> json) {
    return DisplayNumberSetting.fromJson(json);
  }
}

/// @nodoc
const $DisplayNumberSetting = _$DisplayNumberSettingTearOff();

/// @nodoc
mixin _$DisplayNumberSetting {
  int? get beginPillNumber => throw _privateConstructorUsedError;
  int? get endPillNumber => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DisplayNumberSettingCopyWith<DisplayNumberSetting> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DisplayNumberSettingCopyWith<$Res> {
  factory $DisplayNumberSettingCopyWith(DisplayNumberSetting value,
          $Res Function(DisplayNumberSetting) then) =
      _$DisplayNumberSettingCopyWithImpl<$Res>;
  $Res call({int? beginPillNumber, int? endPillNumber});
}

/// @nodoc
class _$DisplayNumberSettingCopyWithImpl<$Res>
    implements $DisplayNumberSettingCopyWith<$Res> {
  _$DisplayNumberSettingCopyWithImpl(this._value, this._then);

  final DisplayNumberSetting _value;
  // ignore: unused_field
  final $Res Function(DisplayNumberSetting) _then;

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
abstract class _$DisplayNumberSettingCopyWith<$Res>
    implements $DisplayNumberSettingCopyWith<$Res> {
  factory _$DisplayNumberSettingCopyWith(_DisplayNumberSetting value,
          $Res Function(_DisplayNumberSetting) then) =
      __$DisplayNumberSettingCopyWithImpl<$Res>;
  @override
  $Res call({int? beginPillNumber, int? endPillNumber});
}

/// @nodoc
class __$DisplayNumberSettingCopyWithImpl<$Res>
    extends _$DisplayNumberSettingCopyWithImpl<$Res>
    implements _$DisplayNumberSettingCopyWith<$Res> {
  __$DisplayNumberSettingCopyWithImpl(
      _DisplayNumberSetting _value, $Res Function(_DisplayNumberSetting) _then)
      : super(_value, (v) => _then(v as _DisplayNumberSetting));

  @override
  _DisplayNumberSetting get _value => super._value as _DisplayNumberSetting;

  @override
  $Res call({
    Object? beginPillNumber = freezed,
    Object? endPillNumber = freezed,
  }) {
    return _then(_DisplayNumberSetting(
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
class _$_DisplayNumberSetting implements _DisplayNumberSetting {
  const _$_DisplayNumberSetting({this.beginPillNumber, this.endPillNumber});

  factory _$_DisplayNumberSetting.fromJson(Map<String, dynamic> json) =>
      _$$_DisplayNumberSettingFromJson(json);

  @override
  final int? beginPillNumber;
  @override
  final int? endPillNumber;

  @override
  String toString() {
    return 'DisplayNumberSetting(beginPillNumber: $beginPillNumber, endPillNumber: $endPillNumber)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DisplayNumberSetting &&
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
  _$DisplayNumberSettingCopyWith<_DisplayNumberSetting> get copyWith =>
      __$DisplayNumberSettingCopyWithImpl<_DisplayNumberSetting>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_DisplayNumberSettingToJson(this);
  }
}

abstract class _DisplayNumberSetting implements DisplayNumberSetting {
  const factory _DisplayNumberSetting(
      {int? beginPillNumber, int? endPillNumber}) = _$_DisplayNumberSetting;

  factory _DisplayNumberSetting.fromJson(Map<String, dynamic> json) =
      _$_DisplayNumberSetting.fromJson;

  @override
  int? get beginPillNumber;
  @override
  int? get endPillNumber;
  @override
  @JsonKey(ignore: true)
  _$DisplayNumberSettingCopyWith<_DisplayNumberSetting> get copyWith =>
      throw _privateConstructorUsedError;
}
