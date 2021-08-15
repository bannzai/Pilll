// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'pill_sheet_modified_history.dart';

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
          required String id,
      required String actionType,
      required String userID,
      required PillSheetModifiedHistoryValue value,
      String? beforeID = null,
      PillSheet? before = null,
      required String afterID,
      required PillSheet after,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime estimatedEventCausingDate,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime createdAt}) {
    return _PillSheetModifiedHistory(
      id: id,
      actionType: actionType,
      userID: userID,
      value: value,
      beforeID: beforeID,
      before: before,
      afterID: afterID,
      after: after,
      estimatedEventCausingDate: estimatedEventCausingDate,
      createdAt: createdAt,
    );
  }

  PillSheetModifiedHistory fromJson(Map<String, Object> json) {
    return PillSheetModifiedHistory.fromJson(json);
  }
}

/// @nodoc
const $PillSheetModifiedHistory = _$PillSheetModifiedHistoryTearOff();

/// @nodoc
mixin _$PillSheetModifiedHistory {
  @JsonKey(includeIfNull: false, toJson: toNull)
  String get id => throw _privateConstructorUsedError;
  String get actionType => throw _privateConstructorUsedError;
  String get userID => throw _privateConstructorUsedError;
  PillSheetModifiedHistoryValue get value => throw _privateConstructorUsedError;
  String? get beforeID => throw _privateConstructorUsedError;
  PillSheet? get before => throw _privateConstructorUsedError;
  String get afterID => throw _privateConstructorUsedError;
  PillSheet get after => throw _privateConstructorUsedError;
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
          String id,
      String actionType,
      String userID,
      PillSheetModifiedHistoryValue value,
      String? beforeID,
      PillSheet? before,
      String afterID,
      PillSheet after,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime estimatedEventCausingDate,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime createdAt});

  $PillSheetModifiedHistoryValueCopyWith<$Res> get value;
  $PillSheetCopyWith<$Res>? get before;
  $PillSheetCopyWith<$Res> get after;
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
    Object? userID = freezed,
    Object? value = freezed,
    Object? beforeID = freezed,
    Object? before = freezed,
    Object? afterID = freezed,
    Object? after = freezed,
    Object? estimatedEventCausingDate = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      actionType: actionType == freezed
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      userID: userID == freezed
          ? _value.userID
          : userID // ignore: cast_nullable_to_non_nullable
              as String,
      value: value == freezed
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as PillSheetModifiedHistoryValue,
      beforeID: beforeID == freezed
          ? _value.beforeID
          : beforeID // ignore: cast_nullable_to_non_nullable
              as String?,
      before: before == freezed
          ? _value.before
          : before // ignore: cast_nullable_to_non_nullable
              as PillSheet?,
      afterID: afterID == freezed
          ? _value.afterID
          : afterID // ignore: cast_nullable_to_non_nullable
              as String,
      after: after == freezed
          ? _value.after
          : after // ignore: cast_nullable_to_non_nullable
              as PillSheet,
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
  $PillSheetCopyWith<$Res> get after {
    return $PillSheetCopyWith<$Res>(_value.after, (value) {
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
          String id,
      String actionType,
      String userID,
      PillSheetModifiedHistoryValue value,
      String? beforeID,
      PillSheet? before,
      String afterID,
      PillSheet after,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime estimatedEventCausingDate,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime createdAt});

  @override
  $PillSheetModifiedHistoryValueCopyWith<$Res> get value;
  @override
  $PillSheetCopyWith<$Res>? get before;
  @override
  $PillSheetCopyWith<$Res> get after;
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
    Object? userID = freezed,
    Object? value = freezed,
    Object? beforeID = freezed,
    Object? before = freezed,
    Object? afterID = freezed,
    Object? after = freezed,
    Object? estimatedEventCausingDate = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_PillSheetModifiedHistory(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      actionType: actionType == freezed
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      userID: userID == freezed
          ? _value.userID
          : userID // ignore: cast_nullable_to_non_nullable
              as String,
      value: value == freezed
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as PillSheetModifiedHistoryValue,
      beforeID: beforeID == freezed
          ? _value.beforeID
          : beforeID // ignore: cast_nullable_to_non_nullable
              as String?,
      before: before == freezed
          ? _value.before
          : before // ignore: cast_nullable_to_non_nullable
              as PillSheet?,
      afterID: afterID == freezed
          ? _value.afterID
          : afterID // ignore: cast_nullable_to_non_nullable
              as String,
      after: after == freezed
          ? _value.after
          : after // ignore: cast_nullable_to_non_nullable
              as PillSheet,
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
  _$_PillSheetModifiedHistory(
      {@JsonKey(includeIfNull: false, toJson: toNull)
          required this.id,
      required this.actionType,
      required this.userID,
      required this.value,
      this.beforeID = null,
      this.before = null,
      required this.afterID,
      required this.after,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.estimatedEventCausingDate,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.createdAt})
      : super._();

  factory _$_PillSheetModifiedHistory.fromJson(Map<String, dynamic> json) =>
      _$_$_PillSheetModifiedHistoryFromJson(json);

  @override
  @JsonKey(includeIfNull: false, toJson: toNull)
  final String id;
  @override
  final String actionType;
  @override
  final String userID;
  @override
  final PillSheetModifiedHistoryValue value;
  @JsonKey(defaultValue: null)
  @override
  final String? beforeID;
  @JsonKey(defaultValue: null)
  @override
  final PillSheet? before;
  @override
  final String afterID;
  @override
  final PillSheet after;
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
    return 'PillSheetModifiedHistory(id: $id, actionType: $actionType, userID: $userID, value: $value, beforeID: $beforeID, before: $before, afterID: $afterID, after: $after, estimatedEventCausingDate: $estimatedEventCausingDate, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _PillSheetModifiedHistory &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.actionType, actionType) ||
                const DeepCollectionEquality()
                    .equals(other.actionType, actionType)) &&
            (identical(other.userID, userID) ||
                const DeepCollectionEquality().equals(other.userID, userID)) &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)) &&
            (identical(other.beforeID, beforeID) ||
                const DeepCollectionEquality()
                    .equals(other.beforeID, beforeID)) &&
            (identical(other.before, before) ||
                const DeepCollectionEquality().equals(other.before, before)) &&
            (identical(other.afterID, afterID) ||
                const DeepCollectionEquality()
                    .equals(other.afterID, afterID)) &&
            (identical(other.after, after) ||
                const DeepCollectionEquality().equals(other.after, after)) &&
            (identical(other.estimatedEventCausingDate,
                    estimatedEventCausingDate) ||
                const DeepCollectionEquality().equals(
                    other.estimatedEventCausingDate,
                    estimatedEventCausingDate)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(actionType) ^
      const DeepCollectionEquality().hash(userID) ^
      const DeepCollectionEquality().hash(value) ^
      const DeepCollectionEquality().hash(beforeID) ^
      const DeepCollectionEquality().hash(before) ^
      const DeepCollectionEquality().hash(afterID) ^
      const DeepCollectionEquality().hash(after) ^
      const DeepCollectionEquality().hash(estimatedEventCausingDate) ^
      const DeepCollectionEquality().hash(createdAt);

  @JsonKey(ignore: true)
  @override
  _$PillSheetModifiedHistoryCopyWith<_PillSheetModifiedHistory> get copyWith =>
      __$PillSheetModifiedHistoryCopyWithImpl<_PillSheetModifiedHistory>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_PillSheetModifiedHistoryToJson(this);
  }
}

abstract class _PillSheetModifiedHistory extends PillSheetModifiedHistory {
  factory _PillSheetModifiedHistory(
      {@JsonKey(includeIfNull: false, toJson: toNull)
          required String id,
      required String actionType,
      required String userID,
      required PillSheetModifiedHistoryValue value,
      String? beforeID,
      PillSheet? before,
      required String afterID,
      required PillSheet after,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime estimatedEventCausingDate,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime createdAt}) = _$_PillSheetModifiedHistory;
  _PillSheetModifiedHistory._() : super._();

  factory _PillSheetModifiedHistory.fromJson(Map<String, dynamic> json) =
      _$_PillSheetModifiedHistory.fromJson;

  @override
  @JsonKey(includeIfNull: false, toJson: toNull)
  String get id => throw _privateConstructorUsedError;
  @override
  String get actionType => throw _privateConstructorUsedError;
  @override
  String get userID => throw _privateConstructorUsedError;
  @override
  PillSheetModifiedHistoryValue get value => throw _privateConstructorUsedError;
  @override
  String? get beforeID => throw _privateConstructorUsedError;
  @override
  PillSheet? get before => throw _privateConstructorUsedError;
  @override
  String get afterID => throw _privateConstructorUsedError;
  @override
  PillSheet get after => throw _privateConstructorUsedError;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get estimatedEventCausingDate => throw _privateConstructorUsedError;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$PillSheetModifiedHistoryCopyWith<_PillSheetModifiedHistory> get copyWith =>
      throw _privateConstructorUsedError;
}
