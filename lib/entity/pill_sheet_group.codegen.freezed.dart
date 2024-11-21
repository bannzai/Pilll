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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PillSheetGroup _$PillSheetGroupFromJson(Map<String, dynamic> json) {
  return _PillSheetGroup.fromJson(json);
}

/// @nodoc
mixin _$PillSheetGroup {
  @JsonKey(includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  List<String> get pillSheetIDs => throw _privateConstructorUsedError;
  List<PillSheet> get pillSheets => throw _privateConstructorUsedError;
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get deletedAt => throw _privateConstructorUsedError; // NOTE: [SyncData:Widget] このプロパティはWidgetに同期されてる
  PillSheetGroupDisplayNumberSetting? get displayNumberSetting => throw _privateConstructorUsedError;
  PillSheetAppearanceMode get pillSheetAppearanceMode => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PillSheetGroupCopyWith<PillSheetGroup> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PillSheetGroupCopyWith<$Res> {
  factory $PillSheetGroupCopyWith(PillSheetGroup value, $Res Function(PillSheetGroup) then) = _$PillSheetGroupCopyWithImpl<$Res, PillSheetGroup>;
  @useResult
  $Res call(
      {@JsonKey(includeIfNull: false) String? id,
      List<String> pillSheetIDs,
      List<PillSheet> pillSheets,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime createdAt,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? deletedAt,
      PillSheetGroupDisplayNumberSetting? displayNumberSetting,
      PillSheetAppearanceMode pillSheetAppearanceMode});

  $PillSheetGroupDisplayNumberSettingCopyWith<$Res>? get displayNumberSetting;
}

/// @nodoc
class _$PillSheetGroupCopyWithImpl<$Res, $Val extends PillSheetGroup> implements $PillSheetGroupCopyWith<$Res> {
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
    Object? pillSheetAppearanceMode = null,
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
      pillSheetAppearanceMode: null == pillSheetAppearanceMode
          ? _value.pillSheetAppearanceMode
          : pillSheetAppearanceMode // ignore: cast_nullable_to_non_nullable
              as PillSheetAppearanceMode,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PillSheetGroupDisplayNumberSettingCopyWith<$Res>? get displayNumberSetting {
    if (_value.displayNumberSetting == null) {
      return null;
    }

    return $PillSheetGroupDisplayNumberSettingCopyWith<$Res>(_value.displayNumberSetting!, (value) {
      return _then(_value.copyWith(displayNumberSetting: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PillSheetGroupImplCopyWith<$Res> implements $PillSheetGroupCopyWith<$Res> {
  factory _$$PillSheetGroupImplCopyWith(_$PillSheetGroupImpl value, $Res Function(_$PillSheetGroupImpl) then) =
      __$$PillSheetGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(includeIfNull: false) String? id,
      List<String> pillSheetIDs,
      List<PillSheet> pillSheets,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime createdAt,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? deletedAt,
      PillSheetGroupDisplayNumberSetting? displayNumberSetting,
      PillSheetAppearanceMode pillSheetAppearanceMode});

  @override
  $PillSheetGroupDisplayNumberSettingCopyWith<$Res>? get displayNumberSetting;
}

/// @nodoc
class __$$PillSheetGroupImplCopyWithImpl<$Res> extends _$PillSheetGroupCopyWithImpl<$Res, _$PillSheetGroupImpl>
    implements _$$PillSheetGroupImplCopyWith<$Res> {
  __$$PillSheetGroupImplCopyWithImpl(_$PillSheetGroupImpl _value, $Res Function(_$PillSheetGroupImpl) _then) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? pillSheetIDs = null,
    Object? pillSheets = null,
    Object? createdAt = null,
    Object? deletedAt = freezed,
    Object? displayNumberSetting = freezed,
    Object? pillSheetAppearanceMode = null,
  }) {
    return _then(_$PillSheetGroupImpl(
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
      pillSheetAppearanceMode: null == pillSheetAppearanceMode
          ? _value.pillSheetAppearanceMode
          : pillSheetAppearanceMode // ignore: cast_nullable_to_non_nullable
              as PillSheetAppearanceMode,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$PillSheetGroupImpl extends _PillSheetGroup {
  _$PillSheetGroupImpl(
      {@JsonKey(includeIfNull: false) this.id,
      required final List<String> pillSheetIDs,
      required final List<PillSheet> pillSheets,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      required this.createdAt,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) this.deletedAt,
      this.displayNumberSetting,
      this.pillSheetAppearanceMode = PillSheetAppearanceMode.number})
      : _pillSheetIDs = pillSheetIDs,
        _pillSheets = pillSheets,
        super._();

  factory _$PillSheetGroupImpl.fromJson(Map<String, dynamic> json) => _$$PillSheetGroupImplFromJson(json);

  @override
  @JsonKey(includeIfNull: false)
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
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime createdAt;
  @override
  @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
  final DateTime? deletedAt;
// NOTE: [SyncData:Widget] このプロパティはWidgetに同期されてる
  @override
  final PillSheetGroupDisplayNumberSetting? displayNumberSetting;
  @override
  @JsonKey()
  final PillSheetAppearanceMode pillSheetAppearanceMode;

  @override
  String toString() {
    return 'PillSheetGroup(id: $id, pillSheetIDs: $pillSheetIDs, pillSheets: $pillSheets, createdAt: $createdAt, deletedAt: $deletedAt, displayNumberSetting: $displayNumberSetting, pillSheetAppearanceMode: $pillSheetAppearanceMode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PillSheetGroupImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._pillSheetIDs, _pillSheetIDs) &&
            const DeepCollectionEquality().equals(other._pillSheets, _pillSheets) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt) &&
            (identical(other.displayNumberSetting, displayNumberSetting) || other.displayNumberSetting == displayNumberSetting) &&
            (identical(other.pillSheetAppearanceMode, pillSheetAppearanceMode) || other.pillSheetAppearanceMode == pillSheetAppearanceMode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, const DeepCollectionEquality().hash(_pillSheetIDs),
      const DeepCollectionEquality().hash(_pillSheets), createdAt, deletedAt, displayNumberSetting, pillSheetAppearanceMode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PillSheetGroupImplCopyWith<_$PillSheetGroupImpl> get copyWith => __$$PillSheetGroupImplCopyWithImpl<_$PillSheetGroupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PillSheetGroupImplToJson(
      this,
    );
  }
}

abstract class _PillSheetGroup extends PillSheetGroup {
  factory _PillSheetGroup(
      {@JsonKey(includeIfNull: false) final String? id,
      required final List<String> pillSheetIDs,
      required final List<PillSheet> pillSheets,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      required final DateTime createdAt,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) final DateTime? deletedAt,
      final PillSheetGroupDisplayNumberSetting? displayNumberSetting,
      final PillSheetAppearanceMode pillSheetAppearanceMode}) = _$PillSheetGroupImpl;
  _PillSheetGroup._() : super._();

  factory _PillSheetGroup.fromJson(Map<String, dynamic> json) = _$PillSheetGroupImpl.fromJson;

  @override
  @JsonKey(includeIfNull: false)
  String? get id;
  @override
  List<String> get pillSheetIDs;
  @override
  List<PillSheet> get pillSheets;
  @override
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdAt;
  @override
  @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get deletedAt;
  @override // NOTE: [SyncData:Widget] このプロパティはWidgetに同期されてる
  PillSheetGroupDisplayNumberSetting? get displayNumberSetting;
  @override
  PillSheetAppearanceMode get pillSheetAppearanceMode;
  @override
  @JsonKey(ignore: true)
  _$$PillSheetGroupImplCopyWith<_$PillSheetGroupImpl> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PillSheetGroupPillNumberDomainPillMarkValue {
  PillSheet get pillSheet => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  int get number => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PillSheetGroupPillNumberDomainPillMarkValueCopyWith<PillSheetGroupPillNumberDomainPillMarkValue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PillSheetGroupPillNumberDomainPillMarkValueCopyWith<$Res> {
  factory $PillSheetGroupPillNumberDomainPillMarkValueCopyWith(
          PillSheetGroupPillNumberDomainPillMarkValue value, $Res Function(PillSheetGroupPillNumberDomainPillMarkValue) then) =
      _$PillSheetGroupPillNumberDomainPillMarkValueCopyWithImpl<$Res, PillSheetGroupPillNumberDomainPillMarkValue>;
  @useResult
  $Res call({PillSheet pillSheet, DateTime date, int number});

  $PillSheetCopyWith<$Res> get pillSheet;
}

/// @nodoc
class _$PillSheetGroupPillNumberDomainPillMarkValueCopyWithImpl<$Res, $Val extends PillSheetGroupPillNumberDomainPillMarkValue>
    implements $PillSheetGroupPillNumberDomainPillMarkValueCopyWith<$Res> {
  _$PillSheetGroupPillNumberDomainPillMarkValueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pillSheet = null,
    Object? date = null,
    Object? number = null,
  }) {
    return _then(_value.copyWith(
      pillSheet: null == pillSheet
          ? _value.pillSheet
          : pillSheet // ignore: cast_nullable_to_non_nullable
              as PillSheet,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      number: null == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PillSheetCopyWith<$Res> get pillSheet {
    return $PillSheetCopyWith<$Res>(_value.pillSheet, (value) {
      return _then(_value.copyWith(pillSheet: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PillSheetGroupPillNumberDomainPillMarkValueImplCopyWith<$Res>
    implements $PillSheetGroupPillNumberDomainPillMarkValueCopyWith<$Res> {
  factory _$$PillSheetGroupPillNumberDomainPillMarkValueImplCopyWith(
          _$PillSheetGroupPillNumberDomainPillMarkValueImpl value, $Res Function(_$PillSheetGroupPillNumberDomainPillMarkValueImpl) then) =
      __$$PillSheetGroupPillNumberDomainPillMarkValueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({PillSheet pillSheet, DateTime date, int number});

  @override
  $PillSheetCopyWith<$Res> get pillSheet;
}

/// @nodoc
class __$$PillSheetGroupPillNumberDomainPillMarkValueImplCopyWithImpl<$Res>
    extends _$PillSheetGroupPillNumberDomainPillMarkValueCopyWithImpl<$Res, _$PillSheetGroupPillNumberDomainPillMarkValueImpl>
    implements _$$PillSheetGroupPillNumberDomainPillMarkValueImplCopyWith<$Res> {
  __$$PillSheetGroupPillNumberDomainPillMarkValueImplCopyWithImpl(
      _$PillSheetGroupPillNumberDomainPillMarkValueImpl _value, $Res Function(_$PillSheetGroupPillNumberDomainPillMarkValueImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pillSheet = null,
    Object? date = null,
    Object? number = null,
  }) {
    return _then(_$PillSheetGroupPillNumberDomainPillMarkValueImpl(
      pillSheet: null == pillSheet
          ? _value.pillSheet
          : pillSheet // ignore: cast_nullable_to_non_nullable
              as PillSheet,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      number: null == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$PillSheetGroupPillNumberDomainPillMarkValueImpl implements _PillSheetGroupPillNumberDomainPillMarkValue {
  const _$PillSheetGroupPillNumberDomainPillMarkValueImpl({required this.pillSheet, required this.date, required this.number});

  @override
  final PillSheet pillSheet;
  @override
  final DateTime date;
  @override
  final int number;

  @override
  String toString() {
    return 'PillSheetGroupPillNumberDomainPillMarkValue(pillSheet: $pillSheet, date: $date, number: $number)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PillSheetGroupPillNumberDomainPillMarkValueImpl &&
            (identical(other.pillSheet, pillSheet) || other.pillSheet == pillSheet) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.number, number) || other.number == number));
  }

  @override
  int get hashCode => Object.hash(runtimeType, pillSheet, date, number);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PillSheetGroupPillNumberDomainPillMarkValueImplCopyWith<_$PillSheetGroupPillNumberDomainPillMarkValueImpl> get copyWith =>
      __$$PillSheetGroupPillNumberDomainPillMarkValueImplCopyWithImpl<_$PillSheetGroupPillNumberDomainPillMarkValueImpl>(this, _$identity);
}

abstract class _PillSheetGroupPillNumberDomainPillMarkValue implements PillSheetGroupPillNumberDomainPillMarkValue {
  const factory _PillSheetGroupPillNumberDomainPillMarkValue(
      {required final PillSheet pillSheet,
      required final DateTime date,
      required final int number}) = _$PillSheetGroupPillNumberDomainPillMarkValueImpl;

  @override
  PillSheet get pillSheet;
  @override
  DateTime get date;
  @override
  int get number;
  @override
  @JsonKey(ignore: true)
  _$$PillSheetGroupPillNumberDomainPillMarkValueImplCopyWith<_$PillSheetGroupPillNumberDomainPillMarkValueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PillSheetGroupDisplayNumberSetting _$PillSheetGroupDisplayNumberSettingFromJson(Map<String, dynamic> json) {
  return _PillSheetGroupDisplayNumberSetting.fromJson(json);
}

/// @nodoc
mixin _$PillSheetGroupDisplayNumberSetting {
  int? get beginPillNumber => throw _privateConstructorUsedError;
  int? get endPillNumber => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PillSheetGroupDisplayNumberSettingCopyWith<PillSheetGroupDisplayNumberSetting> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PillSheetGroupDisplayNumberSettingCopyWith<$Res> {
  factory $PillSheetGroupDisplayNumberSettingCopyWith(
          PillSheetGroupDisplayNumberSetting value, $Res Function(PillSheetGroupDisplayNumberSetting) then) =
      _$PillSheetGroupDisplayNumberSettingCopyWithImpl<$Res, PillSheetGroupDisplayNumberSetting>;
  @useResult
  $Res call({int? beginPillNumber, int? endPillNumber});
}

/// @nodoc
class _$PillSheetGroupDisplayNumberSettingCopyWithImpl<$Res, $Val extends PillSheetGroupDisplayNumberSetting>
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
abstract class _$$PillSheetGroupDisplayNumberSettingImplCopyWith<$Res> implements $PillSheetGroupDisplayNumberSettingCopyWith<$Res> {
  factory _$$PillSheetGroupDisplayNumberSettingImplCopyWith(
          _$PillSheetGroupDisplayNumberSettingImpl value, $Res Function(_$PillSheetGroupDisplayNumberSettingImpl) then) =
      __$$PillSheetGroupDisplayNumberSettingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? beginPillNumber, int? endPillNumber});
}

/// @nodoc
class __$$PillSheetGroupDisplayNumberSettingImplCopyWithImpl<$Res>
    extends _$PillSheetGroupDisplayNumberSettingCopyWithImpl<$Res, _$PillSheetGroupDisplayNumberSettingImpl>
    implements _$$PillSheetGroupDisplayNumberSettingImplCopyWith<$Res> {
  __$$PillSheetGroupDisplayNumberSettingImplCopyWithImpl(
      _$PillSheetGroupDisplayNumberSettingImpl _value, $Res Function(_$PillSheetGroupDisplayNumberSettingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? beginPillNumber = freezed,
    Object? endPillNumber = freezed,
  }) {
    return _then(_$PillSheetGroupDisplayNumberSettingImpl(
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
class _$PillSheetGroupDisplayNumberSettingImpl implements _PillSheetGroupDisplayNumberSetting {
  const _$PillSheetGroupDisplayNumberSettingImpl({this.beginPillNumber, this.endPillNumber});

  factory _$PillSheetGroupDisplayNumberSettingImpl.fromJson(Map<String, dynamic> json) => _$$PillSheetGroupDisplayNumberSettingImplFromJson(json);

  @override
  final int? beginPillNumber;
  @override
  final int? endPillNumber;

  @override
  String toString() {
    return 'PillSheetGroupDisplayNumberSetting(beginPillNumber: $beginPillNumber, endPillNumber: $endPillNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PillSheetGroupDisplayNumberSettingImpl &&
            (identical(other.beginPillNumber, beginPillNumber) || other.beginPillNumber == beginPillNumber) &&
            (identical(other.endPillNumber, endPillNumber) || other.endPillNumber == endPillNumber));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, beginPillNumber, endPillNumber);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PillSheetGroupDisplayNumberSettingImplCopyWith<_$PillSheetGroupDisplayNumberSettingImpl> get copyWith =>
      __$$PillSheetGroupDisplayNumberSettingImplCopyWithImpl<_$PillSheetGroupDisplayNumberSettingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PillSheetGroupDisplayNumberSettingImplToJson(
      this,
    );
  }
}

abstract class _PillSheetGroupDisplayNumberSetting implements PillSheetGroupDisplayNumberSetting {
  const factory _PillSheetGroupDisplayNumberSetting({final int? beginPillNumber, final int? endPillNumber}) =
      _$PillSheetGroupDisplayNumberSettingImpl;

  factory _PillSheetGroupDisplayNumberSetting.fromJson(Map<String, dynamic> json) = _$PillSheetGroupDisplayNumberSettingImpl.fromJson;

  @override
  int? get beginPillNumber;
  @override
  int? get endPillNumber;
  @override
  @JsonKey(ignore: true)
  _$$PillSheetGroupDisplayNumberSettingImplCopyWith<_$PillSheetGroupDisplayNumberSettingImpl> get copyWith => throw _privateConstructorUsedError;
}
