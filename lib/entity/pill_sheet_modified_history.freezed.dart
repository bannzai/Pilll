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
      {required String actionType,
      required String userID,
      required PillSheetModifiedHistoryValue value,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime createdAt}) {
    return _PillSheetModifiedHistory(
      actionType: actionType,
      userID: userID,
      value: value,
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
  String get actionType => throw _privateConstructorUsedError;
  String get userID => throw _privateConstructorUsedError;
  PillSheetModifiedHistoryValue get value => throw _privateConstructorUsedError;
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
      {String actionType,
      String userID,
      PillSheetModifiedHistoryValue value,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime createdAt});

  $PillSheetModifiedHistoryValueCopyWith<$Res> get value;
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
    Object? actionType = freezed,
    Object? userID = freezed,
    Object? value = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
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
}

/// @nodoc
abstract class _$PillSheetModifiedHistoryCopyWith<$Res>
    implements $PillSheetModifiedHistoryCopyWith<$Res> {
  factory _$PillSheetModifiedHistoryCopyWith(_PillSheetModifiedHistory value,
          $Res Function(_PillSheetModifiedHistory) then) =
      __$PillSheetModifiedHistoryCopyWithImpl<$Res>;
  @override
  $Res call(
      {String actionType,
      String userID,
      PillSheetModifiedHistoryValue value,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime createdAt});

  @override
  $PillSheetModifiedHistoryValueCopyWith<$Res> get value;
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
    Object? actionType = freezed,
    Object? userID = freezed,
    Object? value = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_PillSheetModifiedHistory(
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
      {required this.actionType,
      required this.userID,
      required this.value,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.createdAt})
      : super._();

  factory _$_PillSheetModifiedHistory.fromJson(Map<String, dynamic> json) =>
      _$_$_PillSheetModifiedHistoryFromJson(json);

  @override
  final String actionType;
  @override
  final String userID;
  @override
  final PillSheetModifiedHistoryValue value;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime createdAt;

  @override
  String toString() {
    return 'PillSheetModifiedHistory(actionType: $actionType, userID: $userID, value: $value, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _PillSheetModifiedHistory &&
            (identical(other.actionType, actionType) ||
                const DeepCollectionEquality()
                    .equals(other.actionType, actionType)) &&
            (identical(other.userID, userID) ||
                const DeepCollectionEquality().equals(other.userID, userID)) &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(actionType) ^
      const DeepCollectionEquality().hash(userID) ^
      const DeepCollectionEquality().hash(value) ^
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
      {required String actionType,
      required String userID,
      required PillSheetModifiedHistoryValue value,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime createdAt}) = _$_PillSheetModifiedHistory;
  _PillSheetModifiedHistory._() : super._();

  factory _PillSheetModifiedHistory.fromJson(Map<String, dynamic> json) =
      _$_PillSheetModifiedHistory.fromJson;

  @override
  String get actionType => throw _privateConstructorUsedError;
  @override
  String get userID => throw _privateConstructorUsedError;
  @override
  PillSheetModifiedHistoryValue get value => throw _privateConstructorUsedError;
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
