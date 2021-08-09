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
      CreatedPillSheetValue createdPillSheet = null}) {
    return _PillSheetModifiedHistoryValue(
      beginTrialDate: beginTrialDate,
      createdPillSheet: createdPillSheet,
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
  CreatedPillSheetValue get createdPillSheet =>
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
  $Res call({DateTime? beginTrialDate, CreatedPillSheetValue createdPillSheet});

  $CreatedPillSheetValueCopyWith<$Res> get createdPillSheet;
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
  }) {
    return _then(_value.copyWith(
      beginTrialDate: beginTrialDate == freezed
          ? _value.beginTrialDate
          : beginTrialDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdPillSheet: createdPillSheet == freezed
          ? _value.createdPillSheet
          : createdPillSheet // ignore: cast_nullable_to_non_nullable
              as CreatedPillSheetValue,
    ));
  }

  @override
  $CreatedPillSheetValueCopyWith<$Res> get createdPillSheet {
    return $CreatedPillSheetValueCopyWith<$Res>(_value.createdPillSheet,
        (value) {
      return _then(_value.copyWith(createdPillSheet: value));
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
  $Res call({DateTime? beginTrialDate, CreatedPillSheetValue createdPillSheet});

  @override
  $CreatedPillSheetValueCopyWith<$Res> get createdPillSheet;
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
  }) {
    return _then(_PillSheetModifiedHistoryValue(
      beginTrialDate: beginTrialDate == freezed
          ? _value.beginTrialDate
          : beginTrialDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdPillSheet: createdPillSheet == freezed
          ? _value.createdPillSheet
          : createdPillSheet // ignore: cast_nullable_to_non_nullable
              as CreatedPillSheetValue,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_PillSheetModifiedHistoryValue extends _PillSheetModifiedHistoryValue {
  _$_PillSheetModifiedHistoryValue(
      {this.beginTrialDate, this.createdPillSheet = null})
      : super._();

  factory _$_PillSheetModifiedHistoryValue.fromJson(
          Map<String, dynamic> json) =>
      _$_$_PillSheetModifiedHistoryValueFromJson(json);

  @override
  final DateTime? beginTrialDate;
  @JsonKey(defaultValue: null)
  @override
  final CreatedPillSheetValue createdPillSheet;

  @override
  String toString() {
    return 'PillSheetModifiedHistoryValue(beginTrialDate: $beginTrialDate, createdPillSheet: $createdPillSheet)';
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
                    .equals(other.createdPillSheet, createdPillSheet)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(beginTrialDate) ^
      const DeepCollectionEquality().hash(createdPillSheet);

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
          {DateTime? beginTrialDate, CreatedPillSheetValue createdPillSheet}) =
      _$_PillSheetModifiedHistoryValue;
  _PillSheetModifiedHistoryValue._() : super._();

  factory _PillSheetModifiedHistoryValue.fromJson(Map<String, dynamic> json) =
      _$_PillSheetModifiedHistoryValue.fromJson;

  @override
  DateTime? get beginTrialDate => throw _privateConstructorUsedError;
  @override
  CreatedPillSheetValue get createdPillSheet =>
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
      {DateTime? beginTrialDate,
      bool isTrial = false,
      bool isPremium = false,
      bool isLoading = false,
      bool isFirstLoadEnded = false,
      Object? exception}) {
    return _CreatedPillSheetValue(
      beginTrialDate: beginTrialDate,
      isTrial: isTrial,
      isPremium: isPremium,
      isLoading: isLoading,
      isFirstLoadEnded: isFirstLoadEnded,
      exception: exception,
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
  DateTime? get beginTrialDate => throw _privateConstructorUsedError;
  bool get isTrial => throw _privateConstructorUsedError;
  bool get isPremium => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isFirstLoadEnded => throw _privateConstructorUsedError;
  Object? get exception => throw _privateConstructorUsedError;

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
      {DateTime? beginTrialDate,
      bool isTrial,
      bool isPremium,
      bool isLoading,
      bool isFirstLoadEnded,
      Object? exception});
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
    Object? beginTrialDate = freezed,
    Object? isTrial = freezed,
    Object? isPremium = freezed,
    Object? isLoading = freezed,
    Object? isFirstLoadEnded = freezed,
    Object? exception = freezed,
  }) {
    return _then(_value.copyWith(
      beginTrialDate: beginTrialDate == freezed
          ? _value.beginTrialDate
          : beginTrialDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isTrial: isTrial == freezed
          ? _value.isTrial
          : isTrial // ignore: cast_nullable_to_non_nullable
              as bool,
      isPremium: isPremium == freezed
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: isLoading == freezed
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isFirstLoadEnded: isFirstLoadEnded == freezed
          ? _value.isFirstLoadEnded
          : isFirstLoadEnded // ignore: cast_nullable_to_non_nullable
              as bool,
      exception: exception == freezed ? _value.exception : exception,
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
      {DateTime? beginTrialDate,
      bool isTrial,
      bool isPremium,
      bool isLoading,
      bool isFirstLoadEnded,
      Object? exception});
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
    Object? beginTrialDate = freezed,
    Object? isTrial = freezed,
    Object? isPremium = freezed,
    Object? isLoading = freezed,
    Object? isFirstLoadEnded = freezed,
    Object? exception = freezed,
  }) {
    return _then(_CreatedPillSheetValue(
      beginTrialDate: beginTrialDate == freezed
          ? _value.beginTrialDate
          : beginTrialDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isTrial: isTrial == freezed
          ? _value.isTrial
          : isTrial // ignore: cast_nullable_to_non_nullable
              as bool,
      isPremium: isPremium == freezed
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: isLoading == freezed
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isFirstLoadEnded: isFirstLoadEnded == freezed
          ? _value.isFirstLoadEnded
          : isFirstLoadEnded // ignore: cast_nullable_to_non_nullable
              as bool,
      exception: exception == freezed ? _value.exception : exception,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_CreatedPillSheetValue extends _CreatedPillSheetValue {
  _$_CreatedPillSheetValue(
      {this.beginTrialDate,
      this.isTrial = false,
      this.isPremium = false,
      this.isLoading = false,
      this.isFirstLoadEnded = false,
      this.exception})
      : super._();

  factory _$_CreatedPillSheetValue.fromJson(Map<String, dynamic> json) =>
      _$_$_CreatedPillSheetValueFromJson(json);

  @override
  final DateTime? beginTrialDate;
  @JsonKey(defaultValue: false)
  @override
  final bool isTrial;
  @JsonKey(defaultValue: false)
  @override
  final bool isPremium;
  @JsonKey(defaultValue: false)
  @override
  final bool isLoading;
  @JsonKey(defaultValue: false)
  @override
  final bool isFirstLoadEnded;
  @override
  final Object? exception;

  @override
  String toString() {
    return 'CreatedPillSheetValue(beginTrialDate: $beginTrialDate, isTrial: $isTrial, isPremium: $isPremium, isLoading: $isLoading, isFirstLoadEnded: $isFirstLoadEnded, exception: $exception)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _CreatedPillSheetValue &&
            (identical(other.beginTrialDate, beginTrialDate) ||
                const DeepCollectionEquality()
                    .equals(other.beginTrialDate, beginTrialDate)) &&
            (identical(other.isTrial, isTrial) ||
                const DeepCollectionEquality()
                    .equals(other.isTrial, isTrial)) &&
            (identical(other.isPremium, isPremium) ||
                const DeepCollectionEquality()
                    .equals(other.isPremium, isPremium)) &&
            (identical(other.isLoading, isLoading) ||
                const DeepCollectionEquality()
                    .equals(other.isLoading, isLoading)) &&
            (identical(other.isFirstLoadEnded, isFirstLoadEnded) ||
                const DeepCollectionEquality()
                    .equals(other.isFirstLoadEnded, isFirstLoadEnded)) &&
            (identical(other.exception, exception) ||
                const DeepCollectionEquality()
                    .equals(other.exception, exception)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(beginTrialDate) ^
      const DeepCollectionEquality().hash(isTrial) ^
      const DeepCollectionEquality().hash(isPremium) ^
      const DeepCollectionEquality().hash(isLoading) ^
      const DeepCollectionEquality().hash(isFirstLoadEnded) ^
      const DeepCollectionEquality().hash(exception);

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
      {DateTime? beginTrialDate,
      bool isTrial,
      bool isPremium,
      bool isLoading,
      bool isFirstLoadEnded,
      Object? exception}) = _$_CreatedPillSheetValue;
  _CreatedPillSheetValue._() : super._();

  factory _CreatedPillSheetValue.fromJson(Map<String, dynamic> json) =
      _$_CreatedPillSheetValue.fromJson;

  @override
  DateTime? get beginTrialDate => throw _privateConstructorUsedError;
  @override
  bool get isTrial => throw _privateConstructorUsedError;
  @override
  bool get isPremium => throw _privateConstructorUsedError;
  @override
  bool get isLoading => throw _privateConstructorUsedError;
  @override
  bool get isFirstLoadEnded => throw _privateConstructorUsedError;
  @override
  Object? get exception => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$CreatedPillSheetValueCopyWith<_CreatedPillSheetValue> get copyWith =>
      throw _privateConstructorUsedError;
}
