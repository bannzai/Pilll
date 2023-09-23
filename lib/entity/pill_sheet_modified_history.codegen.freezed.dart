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
// Added since 2023-08-01
  dynamic get version =>
      throw _privateConstructorUsedError; // ============ BEGIN: Added since v1 ============
  @JsonKey(includeIfNull: false, toJson: toNull)
  String? get id => throw _privateConstructorUsedError;
  String get actionType => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get estimatedEventCausingDate => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdAt =>
      throw _privateConstructorUsedError; // ============ END: Added since v1 ============
// ============ BEGIN: Added since v2 ============
// beforePillSheetGroup and afterPillSheetGroup is nullable
// Because, actions for createdPillSheet and deletedPillSheet are not exists target single pill sheet
  PillSheetGroup? get beforePillSheetGroup =>
      throw _privateConstructorUsedError;
  PillSheetGroup? get afterPillSheetGroup => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get ttlExpiresDateTime =>
      throw _privateConstructorUsedError; // 古いPillSheetModifiedHistoryのisArchivedにインデックスが貼られないため、TTLの期間内のデータが残っている間はこのフィールドが使えない
// null含めて値を入れないとクエリの条件に合致しないので、2024-04まではarchivedDateTime,isArchivedのデータが必ず存在するPillSheetModifiedHistoryの準備機関とする
// バッチを書いても良いが件数が多いのでこの方法をとっている
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get archivedDateTime =>
      throw _privateConstructorUsedError; // archivedDateTime isNull: false の条件だと、下記のエラーの条件に引っ掛かるため、archivedDateTime以外にもisArchivedを用意している。isArchived == true | isArchived == false の用途で使う
// You can combine constraints with a logical AND by chaining multiple equality operators (== or array-contains). However, you must create a composite index to combine equality operators with the inequality operators, <, <=, >, and !=.
  bool get isArchived =>
      throw _privateConstructorUsedError; // ============ END: Added since v2 ============
// The below properties are deprecated and added since v1.
// This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-04-01
// Instead of calculating from beforePillSheetGroup and afterPillSheetGroup
  PillSheetModifiedHistoryValue get value =>
      throw _privateConstructorUsedError; // This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-04-01
// Instead of beforePillSheetID and afterPillSheetID
  String? get pillSheetID =>
      throw _privateConstructorUsedError; // This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-04-01
// There are new properties for pill_sheet grouping. So it's all optional
  String? get pillSheetGroupID => throw _privateConstructorUsedError;
  String? get beforePillSheetID => throw _privateConstructorUsedError;
  String? get afterPillSheetID =>
      throw _privateConstructorUsedError; // This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-04-01
// Instead of beforePillSheetGroup and afterPillSheetGroup
// before and after is nullable
// Because, actions for createdPillSheet and deletedPillSheet are not exists target single pill sheet
  PillSheet? get before => throw _privateConstructorUsedError;
  PillSheet? get after => throw _privateConstructorUsedError;

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
      {dynamic version,
      @JsonKey(includeIfNull: false, toJson: toNull) String? id,
      String actionType,
      @JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      DateTime estimatedEventCausingDate,
      @JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      DateTime createdAt,
      PillSheetGroup? beforePillSheetGroup,
      PillSheetGroup? afterPillSheetGroup,
      @JsonKey(
          fromJson: TimestampConverter.timestampToDateTime,
          toJson: TimestampConverter.dateTimeToTimestamp)
      DateTime? ttlExpiresDateTime,
      @JsonKey(
          fromJson: TimestampConverter.timestampToDateTime,
          toJson: TimestampConverter.dateTimeToTimestamp)
      DateTime? archivedDateTime,
      bool isArchived,
      PillSheetModifiedHistoryValue value,
      String? pillSheetID,
      String? pillSheetGroupID,
      String? beforePillSheetID,
      String? afterPillSheetID,
      PillSheet? before,
      PillSheet? after});

  $PillSheetGroupCopyWith<$Res>? get beforePillSheetGroup;
  $PillSheetGroupCopyWith<$Res>? get afterPillSheetGroup;
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
    Object? version = freezed,
    Object? id = freezed,
    Object? actionType = null,
    Object? estimatedEventCausingDate = null,
    Object? createdAt = null,
    Object? beforePillSheetGroup = freezed,
    Object? afterPillSheetGroup = freezed,
    Object? ttlExpiresDateTime = freezed,
    Object? archivedDateTime = freezed,
    Object? isArchived = null,
    Object? value = null,
    Object? pillSheetID = freezed,
    Object? pillSheetGroupID = freezed,
    Object? beforePillSheetID = freezed,
    Object? afterPillSheetID = freezed,
    Object? before = freezed,
    Object? after = freezed,
  }) {
    return _then(_value.copyWith(
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as dynamic,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      estimatedEventCausingDate: null == estimatedEventCausingDate
          ? _value.estimatedEventCausingDate
          : estimatedEventCausingDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      beforePillSheetGroup: freezed == beforePillSheetGroup
          ? _value.beforePillSheetGroup
          : beforePillSheetGroup // ignore: cast_nullable_to_non_nullable
              as PillSheetGroup?,
      afterPillSheetGroup: freezed == afterPillSheetGroup
          ? _value.afterPillSheetGroup
          : afterPillSheetGroup // ignore: cast_nullable_to_non_nullable
              as PillSheetGroup?,
      ttlExpiresDateTime: freezed == ttlExpiresDateTime
          ? _value.ttlExpiresDateTime
          : ttlExpiresDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      archivedDateTime: freezed == archivedDateTime
          ? _value.archivedDateTime
          : archivedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
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
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PillSheetGroupCopyWith<$Res>? get beforePillSheetGroup {
    if (_value.beforePillSheetGroup == null) {
      return null;
    }

    return $PillSheetGroupCopyWith<$Res>(_value.beforePillSheetGroup!, (value) {
      return _then(_value.copyWith(beforePillSheetGroup: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PillSheetGroupCopyWith<$Res>? get afterPillSheetGroup {
    if (_value.afterPillSheetGroup == null) {
      return null;
    }

    return $PillSheetGroupCopyWith<$Res>(_value.afterPillSheetGroup!, (value) {
      return _then(_value.copyWith(afterPillSheetGroup: value) as $Val);
    });
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
      {dynamic version,
      @JsonKey(includeIfNull: false, toJson: toNull) String? id,
      String actionType,
      @JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      DateTime estimatedEventCausingDate,
      @JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      DateTime createdAt,
      PillSheetGroup? beforePillSheetGroup,
      PillSheetGroup? afterPillSheetGroup,
      @JsonKey(
          fromJson: TimestampConverter.timestampToDateTime,
          toJson: TimestampConverter.dateTimeToTimestamp)
      DateTime? ttlExpiresDateTime,
      @JsonKey(
          fromJson: TimestampConverter.timestampToDateTime,
          toJson: TimestampConverter.dateTimeToTimestamp)
      DateTime? archivedDateTime,
      bool isArchived,
      PillSheetModifiedHistoryValue value,
      String? pillSheetID,
      String? pillSheetGroupID,
      String? beforePillSheetID,
      String? afterPillSheetID,
      PillSheet? before,
      PillSheet? after});

  @override
  $PillSheetGroupCopyWith<$Res>? get beforePillSheetGroup;
  @override
  $PillSheetGroupCopyWith<$Res>? get afterPillSheetGroup;
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
    Object? version = freezed,
    Object? id = freezed,
    Object? actionType = null,
    Object? estimatedEventCausingDate = null,
    Object? createdAt = null,
    Object? beforePillSheetGroup = freezed,
    Object? afterPillSheetGroup = freezed,
    Object? ttlExpiresDateTime = freezed,
    Object? archivedDateTime = freezed,
    Object? isArchived = null,
    Object? value = null,
    Object? pillSheetID = freezed,
    Object? pillSheetGroupID = freezed,
    Object? beforePillSheetID = freezed,
    Object? afterPillSheetID = freezed,
    Object? before = freezed,
    Object? after = freezed,
  }) {
    return _then(_$_PillSheetModifiedHistory(
      version: freezed == version ? _value.version! : version,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      estimatedEventCausingDate: null == estimatedEventCausingDate
          ? _value.estimatedEventCausingDate
          : estimatedEventCausingDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      beforePillSheetGroup: freezed == beforePillSheetGroup
          ? _value.beforePillSheetGroup
          : beforePillSheetGroup // ignore: cast_nullable_to_non_nullable
              as PillSheetGroup?,
      afterPillSheetGroup: freezed == afterPillSheetGroup
          ? _value.afterPillSheetGroup
          : afterPillSheetGroup // ignore: cast_nullable_to_non_nullable
              as PillSheetGroup?,
      ttlExpiresDateTime: freezed == ttlExpiresDateTime
          ? _value.ttlExpiresDateTime
          : ttlExpiresDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      archivedDateTime: freezed == archivedDateTime
          ? _value.archivedDateTime
          : archivedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
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
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_PillSheetModifiedHistory extends _PillSheetModifiedHistory {
  const _$_PillSheetModifiedHistory(
      {this.version = "v1",
      @JsonKey(includeIfNull: false, toJson: toNull) required this.id,
      required this.actionType,
      @JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      required this.estimatedEventCausingDate,
      @JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      required this.createdAt,
      required this.beforePillSheetGroup,
      required this.afterPillSheetGroup,
      @JsonKey(
          fromJson: TimestampConverter.timestampToDateTime,
          toJson: TimestampConverter.dateTimeToTimestamp)
      this.ttlExpiresDateTime,
      @JsonKey(
          fromJson: TimestampConverter.timestampToDateTime,
          toJson: TimestampConverter.dateTimeToTimestamp)
      this.archivedDateTime,
      this.isArchived = false,
      required this.value,
      required this.pillSheetID,
      required this.pillSheetGroupID,
      required this.beforePillSheetID,
      required this.afterPillSheetID,
      required this.before,
      required this.after})
      : super._();

  factory _$_PillSheetModifiedHistory.fromJson(Map<String, dynamic> json) =>
      _$$_PillSheetModifiedHistoryFromJson(json);

// Added since 2023-08-01
  @override
  @JsonKey()
  final dynamic version;
// ============ BEGIN: Added since v1 ============
  @override
  @JsonKey(includeIfNull: false, toJson: toNull)
  final String? id;
  @override
  final String actionType;
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
// ============ END: Added since v1 ============
// ============ BEGIN: Added since v2 ============
// beforePillSheetGroup and afterPillSheetGroup is nullable
// Because, actions for createdPillSheet and deletedPillSheet are not exists target single pill sheet
  @override
  final PillSheetGroup? beforePillSheetGroup;
  @override
  final PillSheetGroup? afterPillSheetGroup;
  @override
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  final DateTime? ttlExpiresDateTime;
// 古いPillSheetModifiedHistoryのisArchivedにインデックスが貼られないため、TTLの期間内のデータが残っている間はこのフィールドが使えない
// null含めて値を入れないとクエリの条件に合致しないので、2024-04まではarchivedDateTime,isArchivedのデータが必ず存在するPillSheetModifiedHistoryの準備機関とする
// バッチを書いても良いが件数が多いのでこの方法をとっている
  @override
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  final DateTime? archivedDateTime;
// archivedDateTime isNull: false の条件だと、下記のエラーの条件に引っ掛かるため、archivedDateTime以外にもisArchivedを用意している。isArchived == true | isArchived == false の用途で使う
// You can combine constraints with a logical AND by chaining multiple equality operators (== or array-contains). However, you must create a composite index to combine equality operators with the inequality operators, <, <=, >, and !=.
  @override
  @JsonKey()
  final bool isArchived;
// ============ END: Added since v2 ============
// The below properties are deprecated and added since v1.
// This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-04-01
// Instead of calculating from beforePillSheetGroup and afterPillSheetGroup
  @override
  final PillSheetModifiedHistoryValue value;
// This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-04-01
// Instead of beforePillSheetID and afterPillSheetID
  @override
  final String? pillSheetID;
// This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-04-01
// There are new properties for pill_sheet grouping. So it's all optional
  @override
  final String? pillSheetGroupID;
  @override
  final String? beforePillSheetID;
  @override
  final String? afterPillSheetID;
// This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-04-01
// Instead of beforePillSheetGroup and afterPillSheetGroup
// before and after is nullable
// Because, actions for createdPillSheet and deletedPillSheet are not exists target single pill sheet
  @override
  final PillSheet? before;
  @override
  final PillSheet? after;

  @override
  String toString() {
    return 'PillSheetModifiedHistory(version: $version, id: $id, actionType: $actionType, estimatedEventCausingDate: $estimatedEventCausingDate, createdAt: $createdAt, beforePillSheetGroup: $beforePillSheetGroup, afterPillSheetGroup: $afterPillSheetGroup, ttlExpiresDateTime: $ttlExpiresDateTime, archivedDateTime: $archivedDateTime, isArchived: $isArchived, value: $value, pillSheetID: $pillSheetID, pillSheetGroupID: $pillSheetGroupID, beforePillSheetID: $beforePillSheetID, afterPillSheetID: $afterPillSheetID, before: $before, after: $after)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PillSheetModifiedHistory &&
            const DeepCollectionEquality().equals(other.version, version) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.actionType, actionType) ||
                other.actionType == actionType) &&
            (identical(other.estimatedEventCausingDate,
                    estimatedEventCausingDate) ||
                other.estimatedEventCausingDate == estimatedEventCausingDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.beforePillSheetGroup, beforePillSheetGroup) ||
                other.beforePillSheetGroup == beforePillSheetGroup) &&
            (identical(other.afterPillSheetGroup, afterPillSheetGroup) ||
                other.afterPillSheetGroup == afterPillSheetGroup) &&
            (identical(other.ttlExpiresDateTime, ttlExpiresDateTime) ||
                other.ttlExpiresDateTime == ttlExpiresDateTime) &&
            (identical(other.archivedDateTime, archivedDateTime) ||
                other.archivedDateTime == archivedDateTime) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
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
            (identical(other.after, after) || other.after == after));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(version),
      id,
      actionType,
      estimatedEventCausingDate,
      createdAt,
      beforePillSheetGroup,
      afterPillSheetGroup,
      ttlExpiresDateTime,
      archivedDateTime,
      isArchived,
      value,
      pillSheetID,
      pillSheetGroupID,
      beforePillSheetID,
      afterPillSheetID,
      before,
      after);

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
      {final dynamic version,
      @JsonKey(includeIfNull: false, toJson: toNull) required final String? id,
      required final String actionType,
      @JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      required final DateTime estimatedEventCausingDate,
      @JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      required final DateTime createdAt,
      required final PillSheetGroup? beforePillSheetGroup,
      required final PillSheetGroup? afterPillSheetGroup,
      @JsonKey(
          fromJson: TimestampConverter.timestampToDateTime,
          toJson: TimestampConverter.dateTimeToTimestamp)
      final DateTime? ttlExpiresDateTime,
      @JsonKey(
          fromJson: TimestampConverter.timestampToDateTime,
          toJson: TimestampConverter.dateTimeToTimestamp)
      final DateTime? archivedDateTime,
      final bool isArchived,
      required final PillSheetModifiedHistoryValue value,
      required final String? pillSheetID,
      required final String? pillSheetGroupID,
      required final String? beforePillSheetID,
      required final String? afterPillSheetID,
      required final PillSheet? before,
      required final PillSheet? after}) = _$_PillSheetModifiedHistory;
  const _PillSheetModifiedHistory._() : super._();

  factory _PillSheetModifiedHistory.fromJson(Map<String, dynamic> json) =
      _$_PillSheetModifiedHistory.fromJson;

  @override // Added since 2023-08-01
  dynamic get version;
  @override // ============ BEGIN: Added since v1 ============
  @JsonKey(includeIfNull: false, toJson: toNull)
  String? get id;
  @override
  String get actionType;
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
  @override // ============ END: Added since v1 ============
// ============ BEGIN: Added since v2 ============
// beforePillSheetGroup and afterPillSheetGroup is nullable
// Because, actions for createdPillSheet and deletedPillSheet are not exists target single pill sheet
  PillSheetGroup? get beforePillSheetGroup;
  @override
  PillSheetGroup? get afterPillSheetGroup;
  @override
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get ttlExpiresDateTime;
  @override // 古いPillSheetModifiedHistoryのisArchivedにインデックスが貼られないため、TTLの期間内のデータが残っている間はこのフィールドが使えない
// null含めて値を入れないとクエリの条件に合致しないので、2024-04まではarchivedDateTime,isArchivedのデータが必ず存在するPillSheetModifiedHistoryの準備機関とする
// バッチを書いても良いが件数が多いのでこの方法をとっている
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get archivedDateTime;
  @override // archivedDateTime isNull: false の条件だと、下記のエラーの条件に引っ掛かるため、archivedDateTime以外にもisArchivedを用意している。isArchived == true | isArchived == false の用途で使う
// You can combine constraints with a logical AND by chaining multiple equality operators (== or array-contains). However, you must create a composite index to combine equality operators with the inequality operators, <, <=, >, and !=.
  bool get isArchived;
  @override // ============ END: Added since v2 ============
// The below properties are deprecated and added since v1.
// This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-04-01
// Instead of calculating from beforePillSheetGroup and afterPillSheetGroup
  PillSheetModifiedHistoryValue get value;
  @override // This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-04-01
// Instead of beforePillSheetID and afterPillSheetID
  String? get pillSheetID;
  @override // This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-04-01
// There are new properties for pill_sheet grouping. So it's all optional
  String? get pillSheetGroupID;
  @override
  String? get beforePillSheetID;
  @override
  String? get afterPillSheetID;
  @override // This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-04-01
// Instead of beforePillSheetGroup and afterPillSheetGroup
// before and after is nullable
// Because, actions for createdPillSheet and deletedPillSheet are not exists target single pill sheet
  PillSheet? get before;
  @override
  PillSheet? get after;
  @override
  @JsonKey(ignore: true)
  _$$_PillSheetModifiedHistoryCopyWith<_$_PillSheetModifiedHistory>
      get copyWith => throw _privateConstructorUsedError;
}
