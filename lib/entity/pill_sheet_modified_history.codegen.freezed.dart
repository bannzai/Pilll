// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pill_sheet_modified_history.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PillSheetModifiedHistory _$PillSheetModifiedHistoryFromJson(
    Map<String, dynamic> json) {
  return _PillSheetModifiedHistory.fromJson(json);
}

/// @nodoc
mixin _$PillSheetModifiedHistory {
  @JsonKey(includeIfNull: false, toJson: toNull)
  String? get id => throw _privateConstructorUsedError;
  String get actionType => throw _privateConstructorUsedError;
  PillSheetModifiedHistoryValue get value =>
      throw _privateConstructorUsedError; // This is deprecated property.
// Instead of beforePillSheetID and afterPillSheetID
  String? get pillSheetID =>
      throw _privateConstructorUsedError; // There are new properties for pill_sheet grouping. So it's all optional
  String? get pillSheetGroupID => throw _privateConstructorUsedError;
  String? get beforePillSheetID => throw _privateConstructorUsedError;
  String? get afterPillSheetID =>
      throw _privateConstructorUsedError; // before and after is nullable
// Because, actions for createdPillSheet and deletedPillSheet are not exists target single pill sheet
  PillSheet? get before => throw _privateConstructorUsedError;
  PillSheet? get after => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get estimatedEventCausingDate => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PillSheetModifiedHistoryCopyWith<PillSheetModifiedHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PillSheetModifiedHistoryCopyWith<$Res> {
  factory $PillSheetModifiedHistoryCopyWith(PillSheetModifiedHistory value,
          $Res Function(PillSheetModifiedHistory) then) =
      _$PillSheetModifiedHistoryCopyWithImpl<$Res, PillSheetModifiedHistory>;
  @useResult
  $Res call(
      {@JsonKey(includeIfNull: false, toJson: toNull)
          String? id,
      String actionType,
      PillSheetModifiedHistoryValue value,
      String? pillSheetID,
      String? pillSheetGroupID,
      String? beforePillSheetID,
      String? afterPillSheetID,
      PillSheet? before,
      PillSheet? after,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime estimatedEventCausingDate,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime createdAt});

  $PillSheetModifiedHistoryValueCopyWith<$Res> get value;
  $PillSheetCopyWith<$Res>? get before;
  $PillSheetCopyWith<$Res>? get after;
}

/// @nodoc
class _$PillSheetModifiedHistoryCopyWithImpl<$Res,
        $Val extends PillSheetModifiedHistory>
    implements $PillSheetModifiedHistoryCopyWith<$Res> {
  _$PillSheetModifiedHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? actionType = null,
    Object? value = null,
    Object? pillSheetID = freezed,
    Object? pillSheetGroupID = freezed,
    Object? beforePillSheetID = freezed,
    Object? afterPillSheetID = freezed,
    Object? before = freezed,
    Object? after = freezed,
    Object? estimatedEventCausingDate = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as PillSheetModifiedHistoryValue,
      pillSheetID: freezed == pillSheetID
          ? _value.pillSheetID
          : pillSheetID // ignore: cast_nullable_to_non_nullable
              as String?,
      pillSheetGroupID: freezed == pillSheetGroupID
          ? _value.pillSheetGroupID
          : pillSheetGroupID // ignore: cast_nullable_to_non_nullable
              as String?,
      beforePillSheetID: freezed == beforePillSheetID
          ? _value.beforePillSheetID
          : beforePillSheetID // ignore: cast_nullable_to_non_nullable
              as String?,
      afterPillSheetID: freezed == afterPillSheetID
          ? _value.afterPillSheetID
          : afterPillSheetID // ignore: cast_nullable_to_non_nullable
              as String?,
      before: freezed == before
          ? _value.before
          : before // ignore: cast_nullable_to_non_nullable
              as PillSheet?,
      after: freezed == after
          ? _value.after
          : after // ignore: cast_nullable_to_non_nullable
              as PillSheet?,
      estimatedEventCausingDate: null == estimatedEventCausingDate
          ? _value.estimatedEventCausingDate
          : estimatedEventCausingDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PillSheetModifiedHistoryValueCopyWith<$Res> get value {
    return $PillSheetModifiedHistoryValueCopyWith<$Res>(_value.value, (value) {
      return _then(_value.copyWith(value: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PillSheetCopyWith<$Res>? get before {
    if (_value.before == null) {
      return null;
    }

    return $PillSheetCopyWith<$Res>(_value.before!, (value) {
      return _then(_value.copyWith(before: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PillSheetCopyWith<$Res>? get after {
    if (_value.after == null) {
      return null;
    }

    return $PillSheetCopyWith<$Res>(_value.after!, (value) {
      return _then(_value.copyWith(after: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_PillSheetModifiedHistoryCopyWith<$Res>
    implements $PillSheetModifiedHistoryCopyWith<$Res> {
  factory _$$_PillSheetModifiedHistoryCopyWith(
          _$_PillSheetModifiedHistory value,
          $Res Function(_$_PillSheetModifiedHistory) then) =
      __$$_PillSheetModifiedHistoryCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(includeIfNull: false, toJson: toNull)
          String? id,
      String actionType,
      PillSheetModifiedHistoryValue value,
      String? pillSheetID,
      String? pillSheetGroupID,
      String? beforePillSheetID,
      String? afterPillSheetID,
      PillSheet? before,
      PillSheet? after,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime estimatedEventCausingDate,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime createdAt});

  @override
  $PillSheetModifiedHistoryValueCopyWith<$Res> get value;
  @override
  $PillSheetCopyWith<$Res>? get before;
  @override
  $PillSheetCopyWith<$Res>? get after;
}

/// @nodoc
class __$$_PillSheetModifiedHistoryCopyWithImpl<$Res>
    extends _$PillSheetModifiedHistoryCopyWithImpl<$Res,
        _$_PillSheetModifiedHistory>
    implements _$$_PillSheetModifiedHistoryCopyWith<$Res> {
  __$$_PillSheetModifiedHistoryCopyWithImpl(_$_PillSheetModifiedHistory _value,
      $Res Function(_$_PillSheetModifiedHistory) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? actionType = null,
    Object? value = null,
    Object? pillSheetID = freezed,
    Object? pillSheetGroupID = freezed,
    Object? beforePillSheetID = freezed,
    Object? afterPillSheetID = freezed,
    Object? before = freezed,
    Object? after = freezed,
    Object? estimatedEventCausingDate = null,
    Object? createdAt = null,
  }) {
    return _then(_$_PillSheetModifiedHistory(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as PillSheetModifiedHistoryValue,
      pillSheetID: freezed == pillSheetID
          ? _value.pillSheetID
          : pillSheetID // ignore: cast_nullable_to_non_nullable
              as String?,
      pillSheetGroupID: freezed == pillSheetGroupID
          ? _value.pillSheetGroupID
          : pillSheetGroupID // ignore: cast_nullable_to_non_nullable
              as String?,
      beforePillSheetID: freezed == beforePillSheetID
          ? _value.beforePillSheetID
          : beforePillSheetID // ignore: cast_nullable_to_non_nullable
              as String?,
      afterPillSheetID: freezed == afterPillSheetID
          ? _value.afterPillSheetID
          : afterPillSheetID // ignore: cast_nullable_to_non_nullable
              as String?,
      before: freezed == before
          ? _value.before
          : before // ignore: cast_nullable_to_non_nullable
              as PillSheet?,
      after: freezed == after
          ? _value.after
          : after // ignore: cast_nullable_to_non_nullable
              as PillSheet?,
      estimatedEventCausingDate: null == estimatedEventCausingDate
          ? _value.estimatedEventCausingDate
          : estimatedEventCausingDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_PillSheetModifiedHistory extends _PillSheetModifiedHistory {
  const _$_PillSheetModifiedHistory(
      {@JsonKey(includeIfNull: false, toJson: toNull)
          required this.id,
      required this.actionType,
      required this.value,
      required this.pillSheetID,
      required this.pillSheetGroupID,
      required this.beforePillSheetID,
      required this.afterPillSheetID,
      required this.before,
      required this.after,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.estimatedEventCausingDate,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.createdAt})
      : super._();

  factory _$_PillSheetModifiedHistory.fromJson(Map<String, dynamic> json) =>
      _$$_PillSheetModifiedHistoryFromJson(json);

  @override
  @JsonKey(includeIfNull: false, toJson: toNull)
  final String? id;
  @override
  final String actionType;
  @override
  final PillSheetModifiedHistoryValue value;
// This is deprecated property.
// Instead of beforePillSheetID and afterPillSheetID
  @override
  final String? pillSheetID;
// There are new properties for pill_sheet grouping. So it's all optional
  @override
  final String? pillSheetGroupID;
  @override
  final String? beforePillSheetID;
  @override
  final String? afterPillSheetID;
// before and after is nullable
// Because, actions for createdPillSheet and deletedPillSheet are not exists target single pill sheet
  @override
  final PillSheet? before;
  @override
  final PillSheet? after;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime estimatedEventCausingDate;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime createdAt;

  @override
  String toString() {
    return 'PillSheetModifiedHistory(id: $id, actionType: $actionType, value: $value, pillSheetID: $pillSheetID, pillSheetGroupID: $pillSheetGroupID, beforePillSheetID: $beforePillSheetID, afterPillSheetID: $afterPillSheetID, before: $before, after: $after, estimatedEventCausingDate: $estimatedEventCausingDate, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PillSheetModifiedHistory &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.actionType, actionType) ||
                other.actionType == actionType) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.pillSheetID, pillSheetID) ||
                other.pillSheetID == pillSheetID) &&
            (identical(other.pillSheetGroupID, pillSheetGroupID) ||
                other.pillSheetGroupID == pillSheetGroupID) &&
            (identical(other.beforePillSheetID, beforePillSheetID) ||
                other.beforePillSheetID == beforePillSheetID) &&
            (identical(other.afterPillSheetID, afterPillSheetID) ||
                other.afterPillSheetID == afterPillSheetID) &&
            (identical(other.before, before) || other.before == before) &&
            (identical(other.after, after) || other.after == after) &&
            (identical(other.estimatedEventCausingDate,
                    estimatedEventCausingDate) ||
                other.estimatedEventCausingDate == estimatedEventCausingDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      actionType,
      value,
      pillSheetID,
      pillSheetGroupID,
      beforePillSheetID,
      afterPillSheetID,
      before,
      after,
      estimatedEventCausingDate,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PillSheetModifiedHistoryCopyWith<_$_PillSheetModifiedHistory>
      get copyWith => __$$_PillSheetModifiedHistoryCopyWithImpl<
          _$_PillSheetModifiedHistory>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PillSheetModifiedHistoryToJson(
      this,
    );
  }
}

abstract class _PillSheetModifiedHistory extends PillSheetModifiedHistory {
  const factory _PillSheetModifiedHistory(
      {@JsonKey(includeIfNull: false, toJson: toNull)
          required final String? id,
      required final String actionType,
      required final PillSheetModifiedHistoryValue value,
      required final String? pillSheetID,
      required final String? pillSheetGroupID,
      required final String? beforePillSheetID,
      required final String? afterPillSheetID,
      required final PillSheet? before,
      required final PillSheet? after,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required final DateTime estimatedEventCausingDate,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required final DateTime createdAt}) = _$_PillSheetModifiedHistory;
  const _PillSheetModifiedHistory._() : super._();

  factory _PillSheetModifiedHistory.fromJson(Map<String, dynamic> json) =
      _$_PillSheetModifiedHistory.fromJson;

  @override
  @JsonKey(includeIfNull: false, toJson: toNull)
  String? get id;
  @override
  String get actionType;
  @override
  PillSheetModifiedHistoryValue get value;
  @override // This is deprecated property.
// Instead of beforePillSheetID and afterPillSheetID
  String? get pillSheetID;
  @override // There are new properties for pill_sheet grouping. So it's all optional
  String? get pillSheetGroupID;
  @override
  String? get beforePillSheetID;
  @override
  String? get afterPillSheetID;
  @override // before and after is nullable
// Because, actions for createdPillSheet and deletedPillSheet are not exists target single pill sheet
  PillSheet? get before;
  @override
  PillSheet? get after;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get estimatedEventCausingDate;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$_PillSheetModifiedHistoryCopyWith<_$_PillSheetModifiedHistory>
      get copyWith => throw _privateConstructorUsedError;
}
