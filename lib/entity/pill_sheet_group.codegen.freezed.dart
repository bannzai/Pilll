// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

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
  PillSheetGroupDisplayNumberSetting? get displayNumberSetting =>
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
      PillSheetGroupDisplayNumberSetting? displayNumberSetting});

  $PillSheetGroupDisplayNumberSettingCopyWith<$Res>? get displayNumberSetting;
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
              as PillSheetGroupDisplayNumberSetting?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PillSheetGroupDisplayNumberSettingCopyWith<$Res>? get displayNumberSetting {
    if (_value.displayNumberSetting == null) {
      return null;
    }

    return $PillSheetGroupDisplayNumberSettingCopyWith<$Res>(
        _value.displayNumberSetting!, (value) {
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
      PillSheetGroupDisplayNumberSetting? displayNumberSetting});

  @override
  $PillSheetGroupDisplayNumberSettingCopyWith<$Res>? get displayNumberSetting;
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
              as PillSheetGroupDisplayNumberSetting?,
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
    if (_pillSheetIDs is EqualUnmodifiableListView) return _pillSheetIDs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pillSheetIDs);
  }

  final List<PillSheet> _pillSheets;
  @override
  List<PillSheet> get pillSheets {
    if (_pillSheets is EqualUnmodifiableListView) return _pillSheets;
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
  final PillSheetGroupDisplayNumberSetting? displayNumberSetting;

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
      final PillSheetGroupDisplayNumberSetting? displayNumberSetting}) = _$_PillSheetGroup;
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
  PillSheetGroupDisplayNumberSetting? get displayNumberSetting;
  @override
  @JsonKey(ignore: true)
  _$$_PillSheetGroupCopyWith<_$_PillSheetGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

PillSheetGroupDisplayNumberSetting _$PillSheetGroupDisplayNumberSettingFromJson(
    Map<String, dynamic> json) {
  return _PillSheetGroupDisplayNumberSetting.fromJson(json);
}

/// @nodoc
mixin _$PillSheetGroupDisplayNumberSetting {
  int? get beginPillNumber => throw _privateConstructorUsedError;
  int? get endPillNumber => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PillSheetGroupDisplayNumberSettingCopyWith<
          PillSheetGroupDisplayNumberSetting>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PillSheetGroupDisplayNumberSettingCopyWith<$Res> {
  factory $PillSheetGroupDisplayNumberSettingCopyWith(
          PillSheetGroupDisplayNumberSetting value,
          $Res Function(PillSheetGroupDisplayNumberSetting) then) =
      _$PillSheetGroupDisplayNumberSettingCopyWithImpl<$Res,
          PillSheetGroupDisplayNumberSetting>;
  @useResult
  $Res call({int? beginPillNumber, int? endPillNumber});
}

/// @nodoc
class _$PillSheetGroupDisplayNumberSettingCopyWithImpl<$Res,
        $Val extends PillSheetGroupDisplayNumberSetting>
    implements $PillSheetGroupDisplayNumberSettingCopyWith<$Res> {
  _$PillSheetGroupDisplayNumberSettingCopyWithImpl(this._value, this._then);

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
abstract class _$$_PillSheetGroupDisplayNumberSettingCopyWith<$Res>
    implements $PillSheetGroupDisplayNumberSettingCopyWith<$Res> {
  factory _$$_PillSheetGroupDisplayNumberSettingCopyWith(
          _$_PillSheetGroupDisplayNumberSetting value,
          $Res Function(_$_PillSheetGroupDisplayNumberSetting) then) =
      __$$_PillSheetGroupDisplayNumberSettingCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? beginPillNumber, int? endPillNumber});
}

/// @nodoc
class __$$_PillSheetGroupDisplayNumberSettingCopyWithImpl<$Res>
    extends _$PillSheetGroupDisplayNumberSettingCopyWithImpl<$Res,
        _$_PillSheetGroupDisplayNumberSetting>
    implements _$$_PillSheetGroupDisplayNumberSettingCopyWith<$Res> {
  __$$_PillSheetGroupDisplayNumberSettingCopyWithImpl(
      _$_PillSheetGroupDisplayNumberSetting _value,
      $Res Function(_$_PillSheetGroupDisplayNumberSetting) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? beginPillNumber = freezed,
    Object? endPillNumber = freezed,
  }) {
    return _then(_$_PillSheetGroupDisplayNumberSetting(
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
class _$_PillSheetGroupDisplayNumberSetting
    implements _PillSheetGroupDisplayNumberSetting {
  const _$_PillSheetGroupDisplayNumberSetting(
      {this.beginPillNumber, this.endPillNumber});

  factory _$_PillSheetGroupDisplayNumberSetting.fromJson(
          Map<String, dynamic> json) =>
      _$$_PillSheetGroupDisplayNumberSettingFromJson(json);

  @override
  final int? beginPillNumber;
  @override
  final int? endPillNumber;

  @override
  String toString() {
    return 'PillSheetGroupDisplayNumberSetting(beginPillNumber: $beginPillNumber, endPillNumber: $endPillNumber)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PillSheetGroupDisplayNumberSetting &&
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
  _$$_PillSheetGroupDisplayNumberSettingCopyWith<
          _$_PillSheetGroupDisplayNumberSetting>
      get copyWith => __$$_PillSheetGroupDisplayNumberSettingCopyWithImpl<
          _$_PillSheetGroupDisplayNumberSetting>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PillSheetGroupDisplayNumberSettingToJson(
      this,
    );
  }
}

abstract class _PillSheetGroupDisplayNumberSetting
    implements PillSheetGroupDisplayNumberSetting {
  const factory _PillSheetGroupDisplayNumberSetting(
      {final int? beginPillNumber,
      final int? endPillNumber}) = _$_PillSheetGroupDisplayNumberSetting;

  factory _PillSheetGroupDisplayNumberSetting.fromJson(
          Map<String, dynamic> json) =
      _$_PillSheetGroupDisplayNumberSetting.fromJson;

  @override
  int? get beginPillNumber;
  @override
  int? get endPillNumber;
  @override
  @JsonKey(ignore: true)
  _$$_PillSheetGroupDisplayNumberSettingCopyWith<
          _$_PillSheetGroupDisplayNumberSetting>
      get copyWith => throw _privateConstructorUsedError;
}
