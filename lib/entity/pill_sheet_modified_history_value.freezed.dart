// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'pill_sheet_modified_history_value.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PillSheetModifiedHistoryValue _$PillSheetModifiedHistoryValueFromJson(
    Map<String, dynamic> json) {
  return _PillSheetModifiedHistoryValue.fromJson(json);
}

/// @nodoc
class _$PillSheetModifiedHistoryValueTearOff {
  const _$PillSheetModifiedHistoryValueTearOff();

  _PillSheetModifiedHistoryValue call(
      {DateTime? beginTrialDate,
      CreatedPillSheetValue? createdPillSheet = null,
      AutomaticallyRecordedLastTakenDateValue?
          automaticallyRecordedLastTakenDateValue = null,
      DeletedPillSheetValue? deletedPillSheetValue = null,
      TakenPillValue? takenPillValue = null,
      RevertTakenPillValue? revertTakenPill = null}) {
    return _PillSheetModifiedHistoryValue(
      beginTrialDate: beginTrialDate,
      createdPillSheet: createdPillSheet,
      automaticallyRecordedLastTakenDateValue:
          automaticallyRecordedLastTakenDateValue,
      deletedPillSheetValue: deletedPillSheetValue,
      takenPillValue: takenPillValue,
      revertTakenPill: revertTakenPill,
    );
  }

  PillSheetModifiedHistoryValue fromJson(Map<String, Object> json) {
    return PillSheetModifiedHistoryValue.fromJson(json);
  }
}

/// @nodoc
const $PillSheetModifiedHistoryValue = _$PillSheetModifiedHistoryValueTearOff();

/// @nodoc
mixin _$PillSheetModifiedHistoryValue {
  DateTime? get beginTrialDate => throw _privateConstructorUsedError;
  CreatedPillSheetValue? get createdPillSheet =>
      throw _privateConstructorUsedError;
  AutomaticallyRecordedLastTakenDateValue?
      get automaticallyRecordedLastTakenDateValue =>
          throw _privateConstructorUsedError;
  DeletedPillSheetValue? get deletedPillSheetValue =>
      throw _privateConstructorUsedError;
  TakenPillValue? get takenPillValue => throw _privateConstructorUsedError;
  RevertTakenPillValue? get revertTakenPill =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PillSheetModifiedHistoryValueCopyWith<PillSheetModifiedHistoryValue>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PillSheetModifiedHistoryValueCopyWith<$Res> {
  factory $PillSheetModifiedHistoryValueCopyWith(
          PillSheetModifiedHistoryValue value,
          $Res Function(PillSheetModifiedHistoryValue) then) =
      _$PillSheetModifiedHistoryValueCopyWithImpl<$Res>;
  $Res call(
      {DateTime? beginTrialDate,
      CreatedPillSheetValue? createdPillSheet,
      AutomaticallyRecordedLastTakenDateValue?
          automaticallyRecordedLastTakenDateValue,
      DeletedPillSheetValue? deletedPillSheetValue,
      TakenPillValue? takenPillValue,
      RevertTakenPillValue? revertTakenPill});

  $CreatedPillSheetValueCopyWith<$Res>? get createdPillSheet;
  $AutomaticallyRecordedLastTakenDateValueCopyWith<$Res>?
      get automaticallyRecordedLastTakenDateValue;
  $DeletedPillSheetValueCopyWith<$Res>? get deletedPillSheetValue;
  $TakenPillValueCopyWith<$Res>? get takenPillValue;
  $RevertTakenPillValueCopyWith<$Res>? get revertTakenPill;
}

/// @nodoc
class _$PillSheetModifiedHistoryValueCopyWithImpl<$Res>
    implements $PillSheetModifiedHistoryValueCopyWith<$Res> {
  _$PillSheetModifiedHistoryValueCopyWithImpl(this._value, this._then);

  final PillSheetModifiedHistoryValue _value;
  // ignore: unused_field
  final $Res Function(PillSheetModifiedHistoryValue) _then;

  @override
  $Res call({
    Object? beginTrialDate = freezed,
    Object? createdPillSheet = freezed,
    Object? automaticallyRecordedLastTakenDateValue = freezed,
    Object? deletedPillSheetValue = freezed,
    Object? takenPillValue = freezed,
    Object? revertTakenPill = freezed,
  }) {
    return _then(_value.copyWith(
      beginTrialDate: beginTrialDate == freezed
          ? _value.beginTrialDate
          : beginTrialDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdPillSheet: createdPillSheet == freezed
          ? _value.createdPillSheet
          : createdPillSheet // ignore: cast_nullable_to_non_nullable
              as CreatedPillSheetValue?,
      automaticallyRecordedLastTakenDateValue:
          automaticallyRecordedLastTakenDateValue == freezed
              ? _value.automaticallyRecordedLastTakenDateValue
              : automaticallyRecordedLastTakenDateValue // ignore: cast_nullable_to_non_nullable
                  as AutomaticallyRecordedLastTakenDateValue?,
      deletedPillSheetValue: deletedPillSheetValue == freezed
          ? _value.deletedPillSheetValue
          : deletedPillSheetValue // ignore: cast_nullable_to_non_nullable
              as DeletedPillSheetValue?,
      takenPillValue: takenPillValue == freezed
          ? _value.takenPillValue
          : takenPillValue // ignore: cast_nullable_to_non_nullable
              as TakenPillValue?,
      revertTakenPill: revertTakenPill == freezed
          ? _value.revertTakenPill
          : revertTakenPill // ignore: cast_nullable_to_non_nullable
              as RevertTakenPillValue?,
    ));
  }

  @override
  $CreatedPillSheetValueCopyWith<$Res>? get createdPillSheet {
    if (_value.createdPillSheet == null) {
      return null;
    }

    return $CreatedPillSheetValueCopyWith<$Res>(_value.createdPillSheet!,
        (value) {
      return _then(_value.copyWith(createdPillSheet: value));
    });
  }

  @override
  $AutomaticallyRecordedLastTakenDateValueCopyWith<$Res>?
      get automaticallyRecordedLastTakenDateValue {
    if (_value.automaticallyRecordedLastTakenDateValue == null) {
      return null;
    }

    return $AutomaticallyRecordedLastTakenDateValueCopyWith<$Res>(
        _value.automaticallyRecordedLastTakenDateValue!, (value) {
      return _then(
          _value.copyWith(automaticallyRecordedLastTakenDateValue: value));
    });
  }

  @override
  $DeletedPillSheetValueCopyWith<$Res>? get deletedPillSheetValue {
    if (_value.deletedPillSheetValue == null) {
      return null;
    }

    return $DeletedPillSheetValueCopyWith<$Res>(_value.deletedPillSheetValue!,
        (value) {
      return _then(_value.copyWith(deletedPillSheetValue: value));
    });
  }

  @override
  $TakenPillValueCopyWith<$Res>? get takenPillValue {
    if (_value.takenPillValue == null) {
      return null;
    }

    return $TakenPillValueCopyWith<$Res>(_value.takenPillValue!, (value) {
      return _then(_value.copyWith(takenPillValue: value));
    });
  }

  @override
  $RevertTakenPillValueCopyWith<$Res>? get revertTakenPill {
    if (_value.revertTakenPill == null) {
      return null;
    }

    return $RevertTakenPillValueCopyWith<$Res>(_value.revertTakenPill!,
        (value) {
      return _then(_value.copyWith(revertTakenPill: value));
    });
  }
}

/// @nodoc
abstract class _$PillSheetModifiedHistoryValueCopyWith<$Res>
    implements $PillSheetModifiedHistoryValueCopyWith<$Res> {
  factory _$PillSheetModifiedHistoryValueCopyWith(
          _PillSheetModifiedHistoryValue value,
          $Res Function(_PillSheetModifiedHistoryValue) then) =
      __$PillSheetModifiedHistoryValueCopyWithImpl<$Res>;
  @override
  $Res call(
      {DateTime? beginTrialDate,
      CreatedPillSheetValue? createdPillSheet,
      AutomaticallyRecordedLastTakenDateValue?
          automaticallyRecordedLastTakenDateValue,
      DeletedPillSheetValue? deletedPillSheetValue,
      TakenPillValue? takenPillValue,
      RevertTakenPillValue? revertTakenPill});

  @override
  $CreatedPillSheetValueCopyWith<$Res>? get createdPillSheet;
  @override
  $AutomaticallyRecordedLastTakenDateValueCopyWith<$Res>?
      get automaticallyRecordedLastTakenDateValue;
  @override
  $DeletedPillSheetValueCopyWith<$Res>? get deletedPillSheetValue;
  @override
  $TakenPillValueCopyWith<$Res>? get takenPillValue;
  @override
  $RevertTakenPillValueCopyWith<$Res>? get revertTakenPill;
}

/// @nodoc
class __$PillSheetModifiedHistoryValueCopyWithImpl<$Res>
    extends _$PillSheetModifiedHistoryValueCopyWithImpl<$Res>
    implements _$PillSheetModifiedHistoryValueCopyWith<$Res> {
  __$PillSheetModifiedHistoryValueCopyWithImpl(
      _PillSheetModifiedHistoryValue _value,
      $Res Function(_PillSheetModifiedHistoryValue) _then)
      : super(_value, (v) => _then(v as _PillSheetModifiedHistoryValue));

  @override
  _PillSheetModifiedHistoryValue get _value =>
      super._value as _PillSheetModifiedHistoryValue;

  @override
  $Res call({
    Object? beginTrialDate = freezed,
    Object? createdPillSheet = freezed,
    Object? automaticallyRecordedLastTakenDateValue = freezed,
    Object? deletedPillSheetValue = freezed,
    Object? takenPillValue = freezed,
    Object? revertTakenPill = freezed,
  }) {
    return _then(_PillSheetModifiedHistoryValue(
      beginTrialDate: beginTrialDate == freezed
          ? _value.beginTrialDate
          : beginTrialDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdPillSheet: createdPillSheet == freezed
          ? _value.createdPillSheet
          : createdPillSheet // ignore: cast_nullable_to_non_nullable
              as CreatedPillSheetValue?,
      automaticallyRecordedLastTakenDateValue:
          automaticallyRecordedLastTakenDateValue == freezed
              ? _value.automaticallyRecordedLastTakenDateValue
              : automaticallyRecordedLastTakenDateValue // ignore: cast_nullable_to_non_nullable
                  as AutomaticallyRecordedLastTakenDateValue?,
      deletedPillSheetValue: deletedPillSheetValue == freezed
          ? _value.deletedPillSheetValue
          : deletedPillSheetValue // ignore: cast_nullable_to_non_nullable
              as DeletedPillSheetValue?,
      takenPillValue: takenPillValue == freezed
          ? _value.takenPillValue
          : takenPillValue // ignore: cast_nullable_to_non_nullable
              as TakenPillValue?,
      revertTakenPill: revertTakenPill == freezed
          ? _value.revertTakenPill
          : revertTakenPill // ignore: cast_nullable_to_non_nullable
              as RevertTakenPillValue?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_PillSheetModifiedHistoryValue extends _PillSheetModifiedHistoryValue {
  _$_PillSheetModifiedHistoryValue(
      {this.beginTrialDate,
      this.createdPillSheet = null,
      this.automaticallyRecordedLastTakenDateValue = null,
      this.deletedPillSheetValue = null,
      this.takenPillValue = null,
      this.revertTakenPill = null})
      : super._();

  factory _$_PillSheetModifiedHistoryValue.fromJson(
          Map<String, dynamic> json) =>
      _$_$_PillSheetModifiedHistoryValueFromJson(json);

  @override
  final DateTime? beginTrialDate;
  @JsonKey(defaultValue: null)
  @override
  final CreatedPillSheetValue? createdPillSheet;
  @JsonKey(defaultValue: null)
  @override
  final AutomaticallyRecordedLastTakenDateValue?
      automaticallyRecordedLastTakenDateValue;
  @JsonKey(defaultValue: null)
  @override
  final DeletedPillSheetValue? deletedPillSheetValue;
  @JsonKey(defaultValue: null)
  @override
  final TakenPillValue? takenPillValue;
  @JsonKey(defaultValue: null)
  @override
  final RevertTakenPillValue? revertTakenPill;

  @override
  String toString() {
    return 'PillSheetModifiedHistoryValue(beginTrialDate: $beginTrialDate, createdPillSheet: $createdPillSheet, automaticallyRecordedLastTakenDateValue: $automaticallyRecordedLastTakenDateValue, deletedPillSheetValue: $deletedPillSheetValue, takenPillValue: $takenPillValue, revertTakenPill: $revertTakenPill)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _PillSheetModifiedHistoryValue &&
            (identical(other.beginTrialDate, beginTrialDate) ||
                const DeepCollectionEquality()
                    .equals(other.beginTrialDate, beginTrialDate)) &&
            (identical(other.createdPillSheet, createdPillSheet) ||
                const DeepCollectionEquality()
                    .equals(other.createdPillSheet, createdPillSheet)) &&
            (identical(other.automaticallyRecordedLastTakenDateValue,
                    automaticallyRecordedLastTakenDateValue) ||
                const DeepCollectionEquality().equals(
                    other.automaticallyRecordedLastTakenDateValue,
                    automaticallyRecordedLastTakenDateValue)) &&
            (identical(other.deletedPillSheetValue, deletedPillSheetValue) ||
                const DeepCollectionEquality().equals(
                    other.deletedPillSheetValue, deletedPillSheetValue)) &&
            (identical(other.takenPillValue, takenPillValue) ||
                const DeepCollectionEquality()
                    .equals(other.takenPillValue, takenPillValue)) &&
            (identical(other.revertTakenPill, revertTakenPill) ||
                const DeepCollectionEquality()
                    .equals(other.revertTakenPill, revertTakenPill)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(beginTrialDate) ^
      const DeepCollectionEquality().hash(createdPillSheet) ^
      const DeepCollectionEquality()
          .hash(automaticallyRecordedLastTakenDateValue) ^
      const DeepCollectionEquality().hash(deletedPillSheetValue) ^
      const DeepCollectionEquality().hash(takenPillValue) ^
      const DeepCollectionEquality().hash(revertTakenPill);

  @JsonKey(ignore: true)
  @override
  _$PillSheetModifiedHistoryValueCopyWith<_PillSheetModifiedHistoryValue>
      get copyWith => __$PillSheetModifiedHistoryValueCopyWithImpl<
          _PillSheetModifiedHistoryValue>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_PillSheetModifiedHistoryValueToJson(this);
  }
}

abstract class _PillSheetModifiedHistoryValue
    extends PillSheetModifiedHistoryValue {
  factory _PillSheetModifiedHistoryValue(
          {DateTime? beginTrialDate,
          CreatedPillSheetValue? createdPillSheet,
          AutomaticallyRecordedLastTakenDateValue?
              automaticallyRecordedLastTakenDateValue,
          DeletedPillSheetValue? deletedPillSheetValue,
          TakenPillValue? takenPillValue,
          RevertTakenPillValue? revertTakenPill}) =
      _$_PillSheetModifiedHistoryValue;
  _PillSheetModifiedHistoryValue._() : super._();

  factory _PillSheetModifiedHistoryValue.fromJson(Map<String, dynamic> json) =
      _$_PillSheetModifiedHistoryValue.fromJson;

  @override
  DateTime? get beginTrialDate => throw _privateConstructorUsedError;
  @override
  CreatedPillSheetValue? get createdPillSheet =>
      throw _privateConstructorUsedError;
  @override
  AutomaticallyRecordedLastTakenDateValue?
      get automaticallyRecordedLastTakenDateValue =>
          throw _privateConstructorUsedError;
  @override
  DeletedPillSheetValue? get deletedPillSheetValue =>
      throw _privateConstructorUsedError;
  @override
  TakenPillValue? get takenPillValue => throw _privateConstructorUsedError;
  @override
  RevertTakenPillValue? get revertTakenPill =>
      throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$PillSheetModifiedHistoryValueCopyWith<_PillSheetModifiedHistoryValue>
      get copyWith => throw _privateConstructorUsedError;
}

CreatedPillSheetValue _$CreatedPillSheetValueFromJson(
    Map<String, dynamic> json) {
  return _CreatedPillSheetValue.fromJson(json);
}

/// @nodoc
class _$CreatedPillSheetValueTearOff {
  const _$CreatedPillSheetValueTearOff();

  _CreatedPillSheetValue call(
      {@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime pillSheetCreatedAt}) {
    return _CreatedPillSheetValue(
      pillSheetCreatedAt: pillSheetCreatedAt,
    );
  }

  CreatedPillSheetValue fromJson(Map<String, Object> json) {
    return CreatedPillSheetValue.fromJson(json);
  }
}

/// @nodoc
const $CreatedPillSheetValue = _$CreatedPillSheetValueTearOff();

/// @nodoc
mixin _$CreatedPillSheetValue {
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get pillSheetCreatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreatedPillSheetValueCopyWith<CreatedPillSheetValue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatedPillSheetValueCopyWith<$Res> {
  factory $CreatedPillSheetValueCopyWith(CreatedPillSheetValue value,
          $Res Function(CreatedPillSheetValue) then) =
      _$CreatedPillSheetValueCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime pillSheetCreatedAt});
}

/// @nodoc
class _$CreatedPillSheetValueCopyWithImpl<$Res>
    implements $CreatedPillSheetValueCopyWith<$Res> {
  _$CreatedPillSheetValueCopyWithImpl(this._value, this._then);

  final CreatedPillSheetValue _value;
  // ignore: unused_field
  final $Res Function(CreatedPillSheetValue) _then;

  @override
  $Res call({
    Object? pillSheetCreatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      pillSheetCreatedAt: pillSheetCreatedAt == freezed
          ? _value.pillSheetCreatedAt
          : pillSheetCreatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
abstract class _$CreatedPillSheetValueCopyWith<$Res>
    implements $CreatedPillSheetValueCopyWith<$Res> {
  factory _$CreatedPillSheetValueCopyWith(_CreatedPillSheetValue value,
          $Res Function(_CreatedPillSheetValue) then) =
      __$CreatedPillSheetValueCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime pillSheetCreatedAt});
}

/// @nodoc
class __$CreatedPillSheetValueCopyWithImpl<$Res>
    extends _$CreatedPillSheetValueCopyWithImpl<$Res>
    implements _$CreatedPillSheetValueCopyWith<$Res> {
  __$CreatedPillSheetValueCopyWithImpl(_CreatedPillSheetValue _value,
      $Res Function(_CreatedPillSheetValue) _then)
      : super(_value, (v) => _then(v as _CreatedPillSheetValue));

  @override
  _CreatedPillSheetValue get _value => super._value as _CreatedPillSheetValue;

  @override
  $Res call({
    Object? pillSheetCreatedAt = freezed,
  }) {
    return _then(_CreatedPillSheetValue(
      pillSheetCreatedAt: pillSheetCreatedAt == freezed
          ? _value.pillSheetCreatedAt
          : pillSheetCreatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_CreatedPillSheetValue extends _CreatedPillSheetValue {
  _$_CreatedPillSheetValue(
      {@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.pillSheetCreatedAt})
      : super._();

  factory _$_CreatedPillSheetValue.fromJson(Map<String, dynamic> json) =>
      _$_$_CreatedPillSheetValueFromJson(json);

  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime pillSheetCreatedAt;

  @override
  String toString() {
    return 'CreatedPillSheetValue(pillSheetCreatedAt: $pillSheetCreatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _CreatedPillSheetValue &&
            (identical(other.pillSheetCreatedAt, pillSheetCreatedAt) ||
                const DeepCollectionEquality()
                    .equals(other.pillSheetCreatedAt, pillSheetCreatedAt)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(pillSheetCreatedAt);

  @JsonKey(ignore: true)
  @override
  _$CreatedPillSheetValueCopyWith<_CreatedPillSheetValue> get copyWith =>
      __$CreatedPillSheetValueCopyWithImpl<_CreatedPillSheetValue>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_CreatedPillSheetValueToJson(this);
  }
}

abstract class _CreatedPillSheetValue extends CreatedPillSheetValue {
  factory _CreatedPillSheetValue(
      {@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime pillSheetCreatedAt}) = _$_CreatedPillSheetValue;
  _CreatedPillSheetValue._() : super._();

  factory _CreatedPillSheetValue.fromJson(Map<String, dynamic> json) =
      _$_CreatedPillSheetValue.fromJson;

  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get pillSheetCreatedAt => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$CreatedPillSheetValueCopyWith<_CreatedPillSheetValue> get copyWith =>
      throw _privateConstructorUsedError;
}

AutomaticallyRecordedLastTakenDateValue
    _$AutomaticallyRecordedLastTakenDateValueFromJson(
        Map<String, dynamic> json) {
  return _AutomaticallyRecordedLastTakenDateValue.fromJson(json);
}

/// @nodoc
class _$AutomaticallyRecordedLastTakenDateValueTearOff {
  const _$AutomaticallyRecordedLastTakenDateValueTearOff();

  _AutomaticallyRecordedLastTakenDateValue call(
      {required int beforeLastTakenPillNumber,
      required int afterLastTakenPillNumber}) {
    return _AutomaticallyRecordedLastTakenDateValue(
      beforeLastTakenPillNumber: beforeLastTakenPillNumber,
      afterLastTakenPillNumber: afterLastTakenPillNumber,
    );
  }

  AutomaticallyRecordedLastTakenDateValue fromJson(Map<String, Object> json) {
    return AutomaticallyRecordedLastTakenDateValue.fromJson(json);
  }
}

/// @nodoc
const $AutomaticallyRecordedLastTakenDateValue =
    _$AutomaticallyRecordedLastTakenDateValueTearOff();

/// @nodoc
mixin _$AutomaticallyRecordedLastTakenDateValue {
  int get beforeLastTakenPillNumber => throw _privateConstructorUsedError;
  int get afterLastTakenPillNumber => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AutomaticallyRecordedLastTakenDateValueCopyWith<
          AutomaticallyRecordedLastTakenDateValue>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AutomaticallyRecordedLastTakenDateValueCopyWith<$Res> {
  factory $AutomaticallyRecordedLastTakenDateValueCopyWith(
          AutomaticallyRecordedLastTakenDateValue value,
          $Res Function(AutomaticallyRecordedLastTakenDateValue) then) =
      _$AutomaticallyRecordedLastTakenDateValueCopyWithImpl<$Res>;
  $Res call({int beforeLastTakenPillNumber, int afterLastTakenPillNumber});
}

/// @nodoc
class _$AutomaticallyRecordedLastTakenDateValueCopyWithImpl<$Res>
    implements $AutomaticallyRecordedLastTakenDateValueCopyWith<$Res> {
  _$AutomaticallyRecordedLastTakenDateValueCopyWithImpl(
      this._value, this._then);

  final AutomaticallyRecordedLastTakenDateValue _value;
  // ignore: unused_field
  final $Res Function(AutomaticallyRecordedLastTakenDateValue) _then;

  @override
  $Res call({
    Object? beforeLastTakenPillNumber = freezed,
    Object? afterLastTakenPillNumber = freezed,
  }) {
    return _then(_value.copyWith(
      beforeLastTakenPillNumber: beforeLastTakenPillNumber == freezed
          ? _value.beforeLastTakenPillNumber
          : beforeLastTakenPillNumber // ignore: cast_nullable_to_non_nullable
              as int,
      afterLastTakenPillNumber: afterLastTakenPillNumber == freezed
          ? _value.afterLastTakenPillNumber
          : afterLastTakenPillNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$AutomaticallyRecordedLastTakenDateValueCopyWith<$Res>
    implements $AutomaticallyRecordedLastTakenDateValueCopyWith<$Res> {
  factory _$AutomaticallyRecordedLastTakenDateValueCopyWith(
          _AutomaticallyRecordedLastTakenDateValue value,
          $Res Function(_AutomaticallyRecordedLastTakenDateValue) then) =
      __$AutomaticallyRecordedLastTakenDateValueCopyWithImpl<$Res>;
  @override
  $Res call({int beforeLastTakenPillNumber, int afterLastTakenPillNumber});
}

/// @nodoc
class __$AutomaticallyRecordedLastTakenDateValueCopyWithImpl<$Res>
    extends _$AutomaticallyRecordedLastTakenDateValueCopyWithImpl<$Res>
    implements _$AutomaticallyRecordedLastTakenDateValueCopyWith<$Res> {
  __$AutomaticallyRecordedLastTakenDateValueCopyWithImpl(
      _AutomaticallyRecordedLastTakenDateValue _value,
      $Res Function(_AutomaticallyRecordedLastTakenDateValue) _then)
      : super(_value,
            (v) => _then(v as _AutomaticallyRecordedLastTakenDateValue));

  @override
  _AutomaticallyRecordedLastTakenDateValue get _value =>
      super._value as _AutomaticallyRecordedLastTakenDateValue;

  @override
  $Res call({
    Object? beforeLastTakenPillNumber = freezed,
    Object? afterLastTakenPillNumber = freezed,
  }) {
    return _then(_AutomaticallyRecordedLastTakenDateValue(
      beforeLastTakenPillNumber: beforeLastTakenPillNumber == freezed
          ? _value.beforeLastTakenPillNumber
          : beforeLastTakenPillNumber // ignore: cast_nullable_to_non_nullable
              as int,
      afterLastTakenPillNumber: afterLastTakenPillNumber == freezed
          ? _value.afterLastTakenPillNumber
          : afterLastTakenPillNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_AutomaticallyRecordedLastTakenDateValue
    extends _AutomaticallyRecordedLastTakenDateValue {
  _$_AutomaticallyRecordedLastTakenDateValue(
      {required this.beforeLastTakenPillNumber,
      required this.afterLastTakenPillNumber})
      : super._();

  factory _$_AutomaticallyRecordedLastTakenDateValue.fromJson(
          Map<String, dynamic> json) =>
      _$_$_AutomaticallyRecordedLastTakenDateValueFromJson(json);

  @override
  final int beforeLastTakenPillNumber;
  @override
  final int afterLastTakenPillNumber;

  @override
  String toString() {
    return 'AutomaticallyRecordedLastTakenDateValue(beforeLastTakenPillNumber: $beforeLastTakenPillNumber, afterLastTakenPillNumber: $afterLastTakenPillNumber)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _AutomaticallyRecordedLastTakenDateValue &&
            (identical(other.beforeLastTakenPillNumber,
                    beforeLastTakenPillNumber) ||
                const DeepCollectionEquality().equals(
                    other.beforeLastTakenPillNumber,
                    beforeLastTakenPillNumber)) &&
            (identical(
                    other.afterLastTakenPillNumber, afterLastTakenPillNumber) ||
                const DeepCollectionEquality().equals(
                    other.afterLastTakenPillNumber, afterLastTakenPillNumber)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(beforeLastTakenPillNumber) ^
      const DeepCollectionEquality().hash(afterLastTakenPillNumber);

  @JsonKey(ignore: true)
  @override
  _$AutomaticallyRecordedLastTakenDateValueCopyWith<
          _AutomaticallyRecordedLastTakenDateValue>
      get copyWith => __$AutomaticallyRecordedLastTakenDateValueCopyWithImpl<
          _AutomaticallyRecordedLastTakenDateValue>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_AutomaticallyRecordedLastTakenDateValueToJson(this);
  }
}

abstract class _AutomaticallyRecordedLastTakenDateValue
    extends AutomaticallyRecordedLastTakenDateValue {
  factory _AutomaticallyRecordedLastTakenDateValue(
          {required int beforeLastTakenPillNumber,
          required int afterLastTakenPillNumber}) =
      _$_AutomaticallyRecordedLastTakenDateValue;
  _AutomaticallyRecordedLastTakenDateValue._() : super._();

  factory _AutomaticallyRecordedLastTakenDateValue.fromJson(
          Map<String, dynamic> json) =
      _$_AutomaticallyRecordedLastTakenDateValue.fromJson;

  @override
  int get beforeLastTakenPillNumber => throw _privateConstructorUsedError;
  @override
  int get afterLastTakenPillNumber => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$AutomaticallyRecordedLastTakenDateValueCopyWith<
          _AutomaticallyRecordedLastTakenDateValue>
      get copyWith => throw _privateConstructorUsedError;
}

DeletedPillSheetValue _$DeletedPillSheetValueFromJson(
    Map<String, dynamic> json) {
  return _DeletedPillSheetValue.fromJson(json);
}

/// @nodoc
class _$DeletedPillSheetValueTearOff {
  const _$DeletedPillSheetValueTearOff();

  _DeletedPillSheetValue call(
      {@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime pillSheetDeletedAt}) {
    return _DeletedPillSheetValue(
      pillSheetDeletedAt: pillSheetDeletedAt,
    );
  }

  DeletedPillSheetValue fromJson(Map<String, Object> json) {
    return DeletedPillSheetValue.fromJson(json);
  }
}

/// @nodoc
const $DeletedPillSheetValue = _$DeletedPillSheetValueTearOff();

/// @nodoc
mixin _$DeletedPillSheetValue {
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get pillSheetDeletedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DeletedPillSheetValueCopyWith<DeletedPillSheetValue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeletedPillSheetValueCopyWith<$Res> {
  factory $DeletedPillSheetValueCopyWith(DeletedPillSheetValue value,
          $Res Function(DeletedPillSheetValue) then) =
      _$DeletedPillSheetValueCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime pillSheetDeletedAt});
}

/// @nodoc
class _$DeletedPillSheetValueCopyWithImpl<$Res>
    implements $DeletedPillSheetValueCopyWith<$Res> {
  _$DeletedPillSheetValueCopyWithImpl(this._value, this._then);

  final DeletedPillSheetValue _value;
  // ignore: unused_field
  final $Res Function(DeletedPillSheetValue) _then;

  @override
  $Res call({
    Object? pillSheetDeletedAt = freezed,
  }) {
    return _then(_value.copyWith(
      pillSheetDeletedAt: pillSheetDeletedAt == freezed
          ? _value.pillSheetDeletedAt
          : pillSheetDeletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
abstract class _$DeletedPillSheetValueCopyWith<$Res>
    implements $DeletedPillSheetValueCopyWith<$Res> {
  factory _$DeletedPillSheetValueCopyWith(_DeletedPillSheetValue value,
          $Res Function(_DeletedPillSheetValue) then) =
      __$DeletedPillSheetValueCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime pillSheetDeletedAt});
}

/// @nodoc
class __$DeletedPillSheetValueCopyWithImpl<$Res>
    extends _$DeletedPillSheetValueCopyWithImpl<$Res>
    implements _$DeletedPillSheetValueCopyWith<$Res> {
  __$DeletedPillSheetValueCopyWithImpl(_DeletedPillSheetValue _value,
      $Res Function(_DeletedPillSheetValue) _then)
      : super(_value, (v) => _then(v as _DeletedPillSheetValue));

  @override
  _DeletedPillSheetValue get _value => super._value as _DeletedPillSheetValue;

  @override
  $Res call({
    Object? pillSheetDeletedAt = freezed,
  }) {
    return _then(_DeletedPillSheetValue(
      pillSheetDeletedAt: pillSheetDeletedAt == freezed
          ? _value.pillSheetDeletedAt
          : pillSheetDeletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_DeletedPillSheetValue extends _DeletedPillSheetValue {
  _$_DeletedPillSheetValue(
      {@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.pillSheetDeletedAt})
      : super._();

  factory _$_DeletedPillSheetValue.fromJson(Map<String, dynamic> json) =>
      _$_$_DeletedPillSheetValueFromJson(json);

  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime pillSheetDeletedAt;

  @override
  String toString() {
    return 'DeletedPillSheetValue(pillSheetDeletedAt: $pillSheetDeletedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _DeletedPillSheetValue &&
            (identical(other.pillSheetDeletedAt, pillSheetDeletedAt) ||
                const DeepCollectionEquality()
                    .equals(other.pillSheetDeletedAt, pillSheetDeletedAt)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(pillSheetDeletedAt);

  @JsonKey(ignore: true)
  @override
  _$DeletedPillSheetValueCopyWith<_DeletedPillSheetValue> get copyWith =>
      __$DeletedPillSheetValueCopyWithImpl<_DeletedPillSheetValue>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_DeletedPillSheetValueToJson(this);
  }
}

abstract class _DeletedPillSheetValue extends DeletedPillSheetValue {
  factory _DeletedPillSheetValue(
      {@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime pillSheetDeletedAt}) = _$_DeletedPillSheetValue;
  _DeletedPillSheetValue._() : super._();

  factory _DeletedPillSheetValue.fromJson(Map<String, dynamic> json) =
      _$_DeletedPillSheetValue.fromJson;

  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get pillSheetDeletedAt => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$DeletedPillSheetValueCopyWith<_DeletedPillSheetValue> get copyWith =>
      throw _privateConstructorUsedError;
}

TakenPillValue _$TakenPillValueFromJson(Map<String, dynamic> json) {
  return _TakenPillValue.fromJson(json);
}

/// @nodoc
class _$TakenPillValueTearOff {
  const _$TakenPillValueTearOff();

  _TakenPillValue call(
      {@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? beforeLastTakenDate,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime afterLastTakenDate,
      int? beforeLastTakenPillNumber,
      required int afterLastTakenPillNumber}) {
    return _TakenPillValue(
      beforeLastTakenDate: beforeLastTakenDate,
      afterLastTakenDate: afterLastTakenDate,
      beforeLastTakenPillNumber: beforeLastTakenPillNumber,
      afterLastTakenPillNumber: afterLastTakenPillNumber,
    );
  }

  TakenPillValue fromJson(Map<String, Object> json) {
    return TakenPillValue.fromJson(json);
  }
}

/// @nodoc
const $TakenPillValue = _$TakenPillValueTearOff();

/// @nodoc
mixin _$TakenPillValue {
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get beforeLastTakenDate => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get afterLastTakenDate => throw _privateConstructorUsedError;
  int? get beforeLastTakenPillNumber => throw _privateConstructorUsedError;
  int get afterLastTakenPillNumber => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TakenPillValueCopyWith<TakenPillValue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TakenPillValueCopyWith<$Res> {
  factory $TakenPillValueCopyWith(
          TakenPillValue value, $Res Function(TakenPillValue) then) =
      _$TakenPillValueCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? beforeLastTakenDate,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime afterLastTakenDate,
      int? beforeLastTakenPillNumber,
      int afterLastTakenPillNumber});
}

/// @nodoc
class _$TakenPillValueCopyWithImpl<$Res>
    implements $TakenPillValueCopyWith<$Res> {
  _$TakenPillValueCopyWithImpl(this._value, this._then);

  final TakenPillValue _value;
  // ignore: unused_field
  final $Res Function(TakenPillValue) _then;

  @override
  $Res call({
    Object? beforeLastTakenDate = freezed,
    Object? afterLastTakenDate = freezed,
    Object? beforeLastTakenPillNumber = freezed,
    Object? afterLastTakenPillNumber = freezed,
  }) {
    return _then(_value.copyWith(
      beforeLastTakenDate: beforeLastTakenDate == freezed
          ? _value.beforeLastTakenDate
          : beforeLastTakenDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      afterLastTakenDate: afterLastTakenDate == freezed
          ? _value.afterLastTakenDate
          : afterLastTakenDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      beforeLastTakenPillNumber: beforeLastTakenPillNumber == freezed
          ? _value.beforeLastTakenPillNumber
          : beforeLastTakenPillNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      afterLastTakenPillNumber: afterLastTakenPillNumber == freezed
          ? _value.afterLastTakenPillNumber
          : afterLastTakenPillNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$TakenPillValueCopyWith<$Res>
    implements $TakenPillValueCopyWith<$Res> {
  factory _$TakenPillValueCopyWith(
          _TakenPillValue value, $Res Function(_TakenPillValue) then) =
      __$TakenPillValueCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? beforeLastTakenDate,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime afterLastTakenDate,
      int? beforeLastTakenPillNumber,
      int afterLastTakenPillNumber});
}

/// @nodoc
class __$TakenPillValueCopyWithImpl<$Res>
    extends _$TakenPillValueCopyWithImpl<$Res>
    implements _$TakenPillValueCopyWith<$Res> {
  __$TakenPillValueCopyWithImpl(
      _TakenPillValue _value, $Res Function(_TakenPillValue) _then)
      : super(_value, (v) => _then(v as _TakenPillValue));

  @override
  _TakenPillValue get _value => super._value as _TakenPillValue;

  @override
  $Res call({
    Object? beforeLastTakenDate = freezed,
    Object? afterLastTakenDate = freezed,
    Object? beforeLastTakenPillNumber = freezed,
    Object? afterLastTakenPillNumber = freezed,
  }) {
    return _then(_TakenPillValue(
      beforeLastTakenDate: beforeLastTakenDate == freezed
          ? _value.beforeLastTakenDate
          : beforeLastTakenDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      afterLastTakenDate: afterLastTakenDate == freezed
          ? _value.afterLastTakenDate
          : afterLastTakenDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      beforeLastTakenPillNumber: beforeLastTakenPillNumber == freezed
          ? _value.beforeLastTakenPillNumber
          : beforeLastTakenPillNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      afterLastTakenPillNumber: afterLastTakenPillNumber == freezed
          ? _value.afterLastTakenPillNumber
          : afterLastTakenPillNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_TakenPillValue extends _TakenPillValue {
  _$_TakenPillValue(
      {@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          this.beforeLastTakenDate,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.afterLastTakenDate,
      this.beforeLastTakenPillNumber,
      required this.afterLastTakenPillNumber})
      : super._();

  factory _$_TakenPillValue.fromJson(Map<String, dynamic> json) =>
      _$_$_TakenPillValueFromJson(json);

  @override
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  final DateTime? beforeLastTakenDate;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime afterLastTakenDate;
  @override
  final int? beforeLastTakenPillNumber;
  @override
  final int afterLastTakenPillNumber;

  @override
  String toString() {
    return 'TakenPillValue(beforeLastTakenDate: $beforeLastTakenDate, afterLastTakenDate: $afterLastTakenDate, beforeLastTakenPillNumber: $beforeLastTakenPillNumber, afterLastTakenPillNumber: $afterLastTakenPillNumber)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _TakenPillValue &&
            (identical(other.beforeLastTakenDate, beforeLastTakenDate) ||
                const DeepCollectionEquality()
                    .equals(other.beforeLastTakenDate, beforeLastTakenDate)) &&
            (identical(other.afterLastTakenDate, afterLastTakenDate) ||
                const DeepCollectionEquality()
                    .equals(other.afterLastTakenDate, afterLastTakenDate)) &&
            (identical(other.beforeLastTakenPillNumber,
                    beforeLastTakenPillNumber) ||
                const DeepCollectionEquality().equals(
                    other.beforeLastTakenPillNumber,
                    beforeLastTakenPillNumber)) &&
            (identical(
                    other.afterLastTakenPillNumber, afterLastTakenPillNumber) ||
                const DeepCollectionEquality().equals(
                    other.afterLastTakenPillNumber, afterLastTakenPillNumber)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(beforeLastTakenDate) ^
      const DeepCollectionEquality().hash(afterLastTakenDate) ^
      const DeepCollectionEquality().hash(beforeLastTakenPillNumber) ^
      const DeepCollectionEquality().hash(afterLastTakenPillNumber);

  @JsonKey(ignore: true)
  @override
  _$TakenPillValueCopyWith<_TakenPillValue> get copyWith =>
      __$TakenPillValueCopyWithImpl<_TakenPillValue>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_TakenPillValueToJson(this);
  }
}

abstract class _TakenPillValue extends TakenPillValue {
  factory _TakenPillValue(
      {@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? beforeLastTakenDate,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime afterLastTakenDate,
      int? beforeLastTakenPillNumber,
      required int afterLastTakenPillNumber}) = _$_TakenPillValue;
  _TakenPillValue._() : super._();

  factory _TakenPillValue.fromJson(Map<String, dynamic> json) =
      _$_TakenPillValue.fromJson;

  @override
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get beforeLastTakenDate => throw _privateConstructorUsedError;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get afterLastTakenDate => throw _privateConstructorUsedError;
  @override
  int? get beforeLastTakenPillNumber => throw _privateConstructorUsedError;
  @override
  int get afterLastTakenPillNumber => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$TakenPillValueCopyWith<_TakenPillValue> get copyWith =>
      throw _privateConstructorUsedError;
}

RevertTakenPillValue _$RevertTakenPillValueFromJson(Map<String, dynamic> json) {
  return _RevertTakenPillValue.fromJson(json);
}

/// @nodoc
class _$RevertTakenPillValueTearOff {
  const _$RevertTakenPillValueTearOff();

  _RevertTakenPillValue call(
      {required int beforeLastTakenPillNumber,
      required int afterLastTakenPillNumber}) {
    return _RevertTakenPillValue(
      beforeLastTakenPillNumber: beforeLastTakenPillNumber,
      afterLastTakenPillNumber: afterLastTakenPillNumber,
    );
  }

  RevertTakenPillValue fromJson(Map<String, Object> json) {
    return RevertTakenPillValue.fromJson(json);
  }
}

/// @nodoc
const $RevertTakenPillValue = _$RevertTakenPillValueTearOff();

/// @nodoc
mixin _$RevertTakenPillValue {
  int get beforeLastTakenPillNumber => throw _privateConstructorUsedError;
  int get afterLastTakenPillNumber => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RevertTakenPillValueCopyWith<RevertTakenPillValue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RevertTakenPillValueCopyWith<$Res> {
  factory $RevertTakenPillValueCopyWith(RevertTakenPillValue value,
          $Res Function(RevertTakenPillValue) then) =
      _$RevertTakenPillValueCopyWithImpl<$Res>;
  $Res call({int beforeLastTakenPillNumber, int afterLastTakenPillNumber});
}

/// @nodoc
class _$RevertTakenPillValueCopyWithImpl<$Res>
    implements $RevertTakenPillValueCopyWith<$Res> {
  _$RevertTakenPillValueCopyWithImpl(this._value, this._then);

  final RevertTakenPillValue _value;
  // ignore: unused_field
  final $Res Function(RevertTakenPillValue) _then;

  @override
  $Res call({
    Object? beforeLastTakenPillNumber = freezed,
    Object? afterLastTakenPillNumber = freezed,
  }) {
    return _then(_value.copyWith(
      beforeLastTakenPillNumber: beforeLastTakenPillNumber == freezed
          ? _value.beforeLastTakenPillNumber
          : beforeLastTakenPillNumber // ignore: cast_nullable_to_non_nullable
              as int,
      afterLastTakenPillNumber: afterLastTakenPillNumber == freezed
          ? _value.afterLastTakenPillNumber
          : afterLastTakenPillNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$RevertTakenPillValueCopyWith<$Res>
    implements $RevertTakenPillValueCopyWith<$Res> {
  factory _$RevertTakenPillValueCopyWith(_RevertTakenPillValue value,
          $Res Function(_RevertTakenPillValue) then) =
      __$RevertTakenPillValueCopyWithImpl<$Res>;
  @override
  $Res call({int beforeLastTakenPillNumber, int afterLastTakenPillNumber});
}

/// @nodoc
class __$RevertTakenPillValueCopyWithImpl<$Res>
    extends _$RevertTakenPillValueCopyWithImpl<$Res>
    implements _$RevertTakenPillValueCopyWith<$Res> {
  __$RevertTakenPillValueCopyWithImpl(
      _RevertTakenPillValue _value, $Res Function(_RevertTakenPillValue) _then)
      : super(_value, (v) => _then(v as _RevertTakenPillValue));

  @override
  _RevertTakenPillValue get _value => super._value as _RevertTakenPillValue;

  @override
  $Res call({
    Object? beforeLastTakenPillNumber = freezed,
    Object? afterLastTakenPillNumber = freezed,
  }) {
    return _then(_RevertTakenPillValue(
      beforeLastTakenPillNumber: beforeLastTakenPillNumber == freezed
          ? _value.beforeLastTakenPillNumber
          : beforeLastTakenPillNumber // ignore: cast_nullable_to_non_nullable
              as int,
      afterLastTakenPillNumber: afterLastTakenPillNumber == freezed
          ? _value.afterLastTakenPillNumber
          : afterLastTakenPillNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_RevertTakenPillValue extends _RevertTakenPillValue {
  _$_RevertTakenPillValue(
      {required this.beforeLastTakenPillNumber,
      required this.afterLastTakenPillNumber})
      : super._();

  factory _$_RevertTakenPillValue.fromJson(Map<String, dynamic> json) =>
      _$_$_RevertTakenPillValueFromJson(json);

  @override
  final int beforeLastTakenPillNumber;
  @override
  final int afterLastTakenPillNumber;

  @override
  String toString() {
    return 'RevertTakenPillValue(beforeLastTakenPillNumber: $beforeLastTakenPillNumber, afterLastTakenPillNumber: $afterLastTakenPillNumber)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _RevertTakenPillValue &&
            (identical(other.beforeLastTakenPillNumber,
                    beforeLastTakenPillNumber) ||
                const DeepCollectionEquality().equals(
                    other.beforeLastTakenPillNumber,
                    beforeLastTakenPillNumber)) &&
            (identical(
                    other.afterLastTakenPillNumber, afterLastTakenPillNumber) ||
                const DeepCollectionEquality().equals(
                    other.afterLastTakenPillNumber, afterLastTakenPillNumber)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(beforeLastTakenPillNumber) ^
      const DeepCollectionEquality().hash(afterLastTakenPillNumber);

  @JsonKey(ignore: true)
  @override
  _$RevertTakenPillValueCopyWith<_RevertTakenPillValue> get copyWith =>
      __$RevertTakenPillValueCopyWithImpl<_RevertTakenPillValue>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_RevertTakenPillValueToJson(this);
  }
}

abstract class _RevertTakenPillValue extends RevertTakenPillValue {
  factory _RevertTakenPillValue(
      {required int beforeLastTakenPillNumber,
      required int afterLastTakenPillNumber}) = _$_RevertTakenPillValue;
  _RevertTakenPillValue._() : super._();

  factory _RevertTakenPillValue.fromJson(Map<String, dynamic> json) =
      _$_RevertTakenPillValue.fromJson;

  @override
  int get beforeLastTakenPillNumber => throw _privateConstructorUsedError;
  @override
  int get afterLastTakenPillNumber => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$RevertTakenPillValueCopyWith<_RevertTakenPillValue> get copyWith =>
      throw _privateConstructorUsedError;
}
