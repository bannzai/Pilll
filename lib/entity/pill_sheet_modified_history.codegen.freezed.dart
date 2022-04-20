// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'pill_sheet_modified_history.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PillSheetModifiedHistory _$PillSheetModifiedHistoryFromJson(
    Map<String, dynamic> json) {
  return _PillSheetModifiedHistory.fromJson(json);
}

/// @nodoc
class _$PillSheetModifiedHistoryTearOff {
  const _$PillSheetModifiedHistoryTearOff();

  _PillSheetModifiedHistory call(
      {@JsonKey(includeIfNull: false, toJson: toNull)
          required String? id,
      required String actionType,
      required PillSheetModifiedHistoryValue value,
      required String? pillSheetID,
      required String? pillSheetGroupID,
      required String? beforePillSheetID,
      required String? afterPillSheetID,
      required PillSheet? before,
      required PillSheet? after,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime estimatedEventCausingDate,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime createdAt}) {
    return _PillSheetModifiedHistory(
      id: id,
      actionType: actionType,
      value: value,
      pillSheetID: pillSheetID,
      pillSheetGroupID: pillSheetGroupID,
      beforePillSheetID: beforePillSheetID,
      afterPillSheetID: afterPillSheetID,
      before: before,
      after: after,
      estimatedEventCausingDate: estimatedEventCausingDate,
      createdAt: createdAt,
    );
  }

  PillSheetModifiedHistory fromJson(Map<String, Object?> json) {
    return PillSheetModifiedHistory.fromJson(json);
  }
}

/// @nodoc
const $PillSheetModifiedHistory = _$PillSheetModifiedHistoryTearOff();

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
      _$PillSheetModifiedHistoryCopyWithImpl<$Res>;
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
class _$PillSheetModifiedHistoryCopyWithImpl<$Res>
    implements $PillSheetModifiedHistoryCopyWith<$Res> {
  _$PillSheetModifiedHistoryCopyWithImpl(this._value, this._then);

  final PillSheetModifiedHistory _value;
  // ignore: unused_field
  final $Res Function(PillSheetModifiedHistory) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? actionType = freezed,
    Object? value = freezed,
    Object? pillSheetID = freezed,
    Object? pillSheetGroupID = freezed,
    Object? beforePillSheetID = freezed,
    Object? afterPillSheetID = freezed,
    Object? before = freezed,
    Object? after = freezed,
    Object? estimatedEventCausingDate = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      actionType: actionType == freezed
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      value: value == freezed
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as PillSheetModifiedHistoryValue,
      pillSheetID: pillSheetID == freezed
          ? _value.pillSheetID
          : pillSheetID // ignore: cast_nullable_to_non_nullable
              as String?,
      pillSheetGroupID: pillSheetGroupID == freezed
          ? _value.pillSheetGroupID
          : pillSheetGroupID // ignore: cast_nullable_to_non_nullable
              as String?,
      beforePillSheetID: beforePillSheetID == freezed
          ? _value.beforePillSheetID
          : beforePillSheetID // ignore: cast_nullable_to_non_nullable
              as String?,
      afterPillSheetID: afterPillSheetID == freezed
          ? _value.afterPillSheetID
          : afterPillSheetID // ignore: cast_nullable_to_non_nullable
              as String?,
      before: before == freezed
          ? _value.before
          : before // ignore: cast_nullable_to_non_nullable
              as PillSheet?,
      after: after == freezed
          ? _value.after
          : after // ignore: cast_nullable_to_non_nullable
              as PillSheet?,
      estimatedEventCausingDate: estimatedEventCausingDate == freezed
          ? _value.estimatedEventCausingDate
          : estimatedEventCausingDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }

  @override
  $PillSheetModifiedHistoryValueCopyWith<$Res> get value {
    return $PillSheetModifiedHistoryValueCopyWith<$Res>(_value.value, (value) {
      return _then(_value.copyWith(value: value));
    });
  }

  @override
  $PillSheetCopyWith<$Res>? get before {
    if (_value.before == null) {
      return null;
    }

    return $PillSheetCopyWith<$Res>(_value.before!, (value) {
      return _then(_value.copyWith(before: value));
    });
  }

  @override
  $PillSheetCopyWith<$Res>? get after {
    if (_value.after == null) {
      return null;
    }

    return $PillSheetCopyWith<$Res>(_value.after!, (value) {
      return _then(_value.copyWith(after: value));
    });
  }
}

/// @nodoc
abstract class _$PillSheetModifiedHistoryCopyWith<$Res>
    implements $PillSheetModifiedHistoryCopyWith<$Res> {
  factory _$PillSheetModifiedHistoryCopyWith(_PillSheetModifiedHistory value,
          $Res Function(_PillSheetModifiedHistory) then) =
      __$PillSheetModifiedHistoryCopyWithImpl<$Res>;
  @override
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
class __$PillSheetModifiedHistoryCopyWithImpl<$Res>
    extends _$PillSheetModifiedHistoryCopyWithImpl<$Res>
    implements _$PillSheetModifiedHistoryCopyWith<$Res> {
  __$PillSheetModifiedHistoryCopyWithImpl(_PillSheetModifiedHistory _value,
      $Res Function(_PillSheetModifiedHistory) _then)
      : super(_value, (v) => _then(v as _PillSheetModifiedHistory));

  @override
  _PillSheetModifiedHistory get _value =>
      super._value as _PillSheetModifiedHistory;

  @override
  $Res call({
    Object? id = freezed,
    Object? actionType = freezed,
    Object? value = freezed,
    Object? pillSheetID = freezed,
    Object? pillSheetGroupID = freezed,
    Object? beforePillSheetID = freezed,
    Object? afterPillSheetID = freezed,
    Object? before = freezed,
    Object? after = freezed,
    Object? estimatedEventCausingDate = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_PillSheetModifiedHistory(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      actionType: actionType == freezed
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      value: value == freezed
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as PillSheetModifiedHistoryValue,
      pillSheetID: pillSheetID == freezed
          ? _value.pillSheetID
          : pillSheetID // ignore: cast_nullable_to_non_nullable
              as String?,
      pillSheetGroupID: pillSheetGroupID == freezed
          ? _value.pillSheetGroupID
          : pillSheetGroupID // ignore: cast_nullable_to_non_nullable
              as String?,
      beforePillSheetID: beforePillSheetID == freezed
          ? _value.beforePillSheetID
          : beforePillSheetID // ignore: cast_nullable_to_non_nullable
              as String?,
      afterPillSheetID: afterPillSheetID == freezed
          ? _value.afterPillSheetID
          : afterPillSheetID // ignore: cast_nullable_to_non_nullable
              as String?,
      before: before == freezed
          ? _value.before
          : before // ignore: cast_nullable_to_non_nullable
              as PillSheet?,
      after: after == freezed
          ? _value.after
          : after // ignore: cast_nullable_to_non_nullable
              as PillSheet?,
      estimatedEventCausingDate: estimatedEventCausingDate == freezed
          ? _value.estimatedEventCausingDate
          : estimatedEventCausingDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: createdAt == freezed
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
  @override // This is deprecated property.
// Instead of beforePillSheetID and afterPillSheetID
  final String? pillSheetID;
  @override // There are new properties for pill_sheet grouping. So it's all optional
  final String? pillSheetGroupID;
  @override
  final String? beforePillSheetID;
  @override
  final String? afterPillSheetID;
  @override // before and after is nullable
// Because, actions for createdPillSheet and deletedPillSheet are not exists target single pill sheet
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
            other is _PillSheetModifiedHistory &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality()
                .equals(other.actionType, actionType) &&
            const DeepCollectionEquality().equals(other.value, value) &&
            const DeepCollectionEquality()
                .equals(other.pillSheetID, pillSheetID) &&
            const DeepCollectionEquality()
                .equals(other.pillSheetGroupID, pillSheetGroupID) &&
            const DeepCollectionEquality()
                .equals(other.beforePillSheetID, beforePillSheetID) &&
            const DeepCollectionEquality()
                .equals(other.afterPillSheetID, afterPillSheetID) &&
            const DeepCollectionEquality().equals(other.before, before) &&
            const DeepCollectionEquality().equals(other.after, after) &&
            const DeepCollectionEquality().equals(
                other.estimatedEventCausingDate, estimatedEventCausingDate) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(actionType),
      const DeepCollectionEquality().hash(value),
      const DeepCollectionEquality().hash(pillSheetID),
      const DeepCollectionEquality().hash(pillSheetGroupID),
      const DeepCollectionEquality().hash(beforePillSheetID),
      const DeepCollectionEquality().hash(afterPillSheetID),
      const DeepCollectionEquality().hash(before),
      const DeepCollectionEquality().hash(after),
      const DeepCollectionEquality().hash(estimatedEventCausingDate),
      const DeepCollectionEquality().hash(createdAt));

  @JsonKey(ignore: true)
  @override
  _$PillSheetModifiedHistoryCopyWith<_PillSheetModifiedHistory> get copyWith =>
      __$PillSheetModifiedHistoryCopyWithImpl<_PillSheetModifiedHistory>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PillSheetModifiedHistoryToJson(this);
  }
}

abstract class _PillSheetModifiedHistory extends PillSheetModifiedHistory {
  const factory _PillSheetModifiedHistory(
      {@JsonKey(includeIfNull: false, toJson: toNull)
          required String? id,
      required String actionType,
      required PillSheetModifiedHistoryValue value,
      required String? pillSheetID,
      required String? pillSheetGroupID,
      required String? beforePillSheetID,
      required String? afterPillSheetID,
      required PillSheet? before,
      required PillSheet? after,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime estimatedEventCausingDate,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime createdAt}) = _$_PillSheetModifiedHistory;
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
  _$PillSheetModifiedHistoryCopyWith<_PillSheetModifiedHistory> get copyWith =>
      throw _privateConstructorUsedError;
}
