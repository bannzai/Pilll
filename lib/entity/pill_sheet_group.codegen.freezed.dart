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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PillSheetGroup _$PillSheetGroupFromJson(Map<String, dynamic> json) {
  return _PillSheetGroup.fromJson(json);
}

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
      _$PillSheetGroupCopyWithImpl<$Res, PillSheetGroup>;
  @useResult
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
class _$PillSheetGroupCopyWithImpl<$Res, $Val extends PillSheetGroup>
    implements $PillSheetGroupCopyWith<$Res> {
  _$PillSheetGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? pillSheetIDs = null,
    Object? pillSheets = null,
    Object? createdAt = null,
    Object? deletedAt = freezed,
    Object? displayNumberSetting = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      pillSheetIDs: null == pillSheetIDs
          ? _value.pillSheetIDs
          : pillSheetIDs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pillSheets: null == pillSheets
          ? _value.pillSheets
          : pillSheets // ignore: cast_nullable_to_non_nullable
              as List<PillSheet>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      displayNumberSetting: freezed == displayNumberSetting
          ? _value.displayNumberSetting
          : displayNumberSetting // ignore: cast_nullable_to_non_nullable
              as DisplayNumberSetting?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DisplayNumberSettingCopyWith<$Res>? get displayNumberSetting {
    if (_value.displayNumberSetting == null) {
      return null;
    }

    return $DisplayNumberSettingCopyWith<$Res>(_value.displayNumberSetting!,
        (value) {
      return _then(_value.copyWith(displayNumberSetting: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_PillSheetGroupCopyWith<$Res>
    implements $PillSheetGroupCopyWith<$Res> {
  factory _$$_PillSheetGroupCopyWith(
          _$_PillSheetGroup value, $Res Function(_$_PillSheetGroup) then) =
      __$$_PillSheetGroupCopyWithImpl<$Res>;
  @override
  @useResult
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
class __$$_PillSheetGroupCopyWithImpl<$Res>
    extends _$PillSheetGroupCopyWithImpl<$Res, _$_PillSheetGroup>
    implements _$$_PillSheetGroupCopyWith<$Res> {
  __$$_PillSheetGroupCopyWithImpl(
      _$_PillSheetGroup _value, $Res Function(_$_PillSheetGroup) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? pillSheetIDs = null,
    Object? pillSheets = null,
    Object? createdAt = null,
    Object? deletedAt = freezed,
    Object? displayNumberSetting = freezed,
  }) {
    return _then(_$_PillSheetGroup(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      pillSheetIDs: null == pillSheetIDs
          ? _value._pillSheetIDs
          : pillSheetIDs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pillSheets: null == pillSheets
          ? _value._pillSheets
          : pillSheets // ignore: cast_nullable_to_non_nullable
              as List<PillSheet>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      displayNumberSetting: freezed == displayNumberSetting
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
      required final List<String> pillSheetIDs,
      required final List<PillSheet> pillSheets,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.createdAt,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          this.deletedAt,
      this.displayNumberSetting})
      : _pillSheetIDs = pillSheetIDs,
        _pillSheets = pillSheets,
        super._();

  factory _$_PillSheetGroup.fromJson(Map<String, dynamic> json) =>
      _$$_PillSheetGroupFromJson(json);

  @override
  @JsonKey(includeIfNull: false, toJson: toNull)
  final String? id;
  final List<String> _pillSheetIDs;
  @override
  List<String> get pillSheetIDs {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pillSheetIDs);
  }

  final List<PillSheet> _pillSheets;
  @override
  List<PillSheet> get pillSheets {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pillSheets);
  }

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
            other is _$_PillSheetGroup &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality()
                .equals(other._pillSheetIDs, _pillSheetIDs) &&
            const DeepCollectionEquality()
                .equals(other._pillSheets, _pillSheets) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.displayNumberSetting, displayNumberSetting) ||
                other.displayNumberSetting == displayNumberSetting));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      const DeepCollectionEquality().hash(_pillSheetIDs),
      const DeepCollectionEquality().hash(_pillSheets),
      createdAt,
      deletedAt,
      displayNumberSetting);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PillSheetGroupCopyWith<_$_PillSheetGroup> get copyWith =>
      __$$_PillSheetGroupCopyWithImpl<_$_PillSheetGroup>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PillSheetGroupToJson(
      this,
    );
  }
}

abstract class _PillSheetGroup extends PillSheetGroup {
  const factory _PillSheetGroup(
      {@JsonKey(includeIfNull: false, toJson: toNull)
          final String? id,
      required final List<String> pillSheetIDs,
      required final List<PillSheet> pillSheets,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required final DateTime createdAt,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          final DateTime? deletedAt,
      final DisplayNumberSetting? displayNumberSetting}) = _$_PillSheetGroup;
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
  _$$_PillSheetGroupCopyWith<_$_PillSheetGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

DisplayNumberSetting _$DisplayNumberSettingFromJson(Map<String, dynamic> json) {
  return _DisplayNumberSetting.fromJson(json);
}

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
      _$DisplayNumberSettingCopyWithImpl<$Res, DisplayNumberSetting>;
  @useResult
  $Res call({int? beginPillNumber, int? endPillNumber});
}

/// @nodoc
class _$DisplayNumberSettingCopyWithImpl<$Res,
        $Val extends DisplayNumberSetting>
    implements $DisplayNumberSettingCopyWith<$Res> {
  _$DisplayNumberSettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? beginPillNumber = freezed,
    Object? endPillNumber = freezed,
  }) {
    return _then(_value.copyWith(
      beginPillNumber: freezed == beginPillNumber
          ? _value.beginPillNumber
          : beginPillNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      endPillNumber: freezed == endPillNumber
          ? _value.endPillNumber
          : endPillNumber // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_DisplayNumberSettingCopyWith<$Res>
    implements $DisplayNumberSettingCopyWith<$Res> {
  factory _$$_DisplayNumberSettingCopyWith(_$_DisplayNumberSetting value,
          $Res Function(_$_DisplayNumberSetting) then) =
      __$$_DisplayNumberSettingCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? beginPillNumber, int? endPillNumber});
}

/// @nodoc
class __$$_DisplayNumberSettingCopyWithImpl<$Res>
    extends _$DisplayNumberSettingCopyWithImpl<$Res, _$_DisplayNumberSetting>
    implements _$$_DisplayNumberSettingCopyWith<$Res> {
  __$$_DisplayNumberSettingCopyWithImpl(_$_DisplayNumberSetting _value,
      $Res Function(_$_DisplayNumberSetting) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? beginPillNumber = freezed,
    Object? endPillNumber = freezed,
  }) {
    return _then(_$_DisplayNumberSetting(
      beginPillNumber: freezed == beginPillNumber
          ? _value.beginPillNumber
          : beginPillNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      endPillNumber: freezed == endPillNumber
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
            other is _$_DisplayNumberSetting &&
            (identical(other.beginPillNumber, beginPillNumber) ||
                other.beginPillNumber == beginPillNumber) &&
            (identical(other.endPillNumber, endPillNumber) ||
                other.endPillNumber == endPillNumber));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, beginPillNumber, endPillNumber);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_DisplayNumberSettingCopyWith<_$_DisplayNumberSetting> get copyWith =>
      __$$_DisplayNumberSettingCopyWithImpl<_$_DisplayNumberSetting>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_DisplayNumberSettingToJson(
      this,
    );
  }
}

abstract class _DisplayNumberSetting implements DisplayNumberSetting {
  const factory _DisplayNumberSetting(
      {final int? beginPillNumber,
      final int? endPillNumber}) = _$_DisplayNumberSetting;

  factory _DisplayNumberSetting.fromJson(Map<String, dynamic> json) =
      _$_DisplayNumberSetting.fromJson;

  @override
  int? get beginPillNumber;
  @override
  int? get endPillNumber;
  @override
  @JsonKey(ignore: true)
  _$$_DisplayNumberSettingCopyWith<_$_DisplayNumberSetting> get copyWith =>
      throw _privateConstructorUsedError;
}
