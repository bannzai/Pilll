// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'menstruation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$MenstruationStateTearOff {
  const _$MenstruationStateTearOff();

  _MenstruationState call(
      {bool isNotYetLoaded = true,
      int currentCalendarIndex = 0,
      List<Diary> diariesForMonth = const [],
      List<Menstruation> entities = const [],
      bool isPremium = false,
      bool isTrial = false,
      DateTime? trialDeadlineDate,
      Setting? setting,
      PillSheetGroup? latestPillSheetGroup,
      Object? exception}) {
    return _MenstruationState(
      isNotYetLoaded: isNotYetLoaded,
      currentCalendarIndex: currentCalendarIndex,
      diariesForMonth: diariesForMonth,
      entities: entities,
      isPremium: isPremium,
      isTrial: isTrial,
      trialDeadlineDate: trialDeadlineDate,
      setting: setting,
      latestPillSheetGroup: latestPillSheetGroup,
      exception: exception,
    );
  }
}

/// @nodoc
const $MenstruationState = _$MenstruationStateTearOff();

/// @nodoc
mixin _$MenstruationState {
  bool get isNotYetLoaded => throw _privateConstructorUsedError;
  int get currentCalendarIndex => throw _privateConstructorUsedError;
  List<Diary> get diariesForMonth => throw _privateConstructorUsedError;
  List<Menstruation> get entities => throw _privateConstructorUsedError;
  bool get isPremium => throw _privateConstructorUsedError;
  bool get isTrial => throw _privateConstructorUsedError;
  DateTime? get trialDeadlineDate => throw _privateConstructorUsedError;
  Setting? get setting => throw _privateConstructorUsedError;
  PillSheetGroup? get latestPillSheetGroup =>
      throw _privateConstructorUsedError;
  Object? get exception => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MenstruationStateCopyWith<MenstruationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MenstruationStateCopyWith<$Res> {
  factory $MenstruationStateCopyWith(
          MenstruationState value, $Res Function(MenstruationState) then) =
      _$MenstruationStateCopyWithImpl<$Res>;
  $Res call(
      {bool isNotYetLoaded,
      int currentCalendarIndex,
      List<Diary> diariesForMonth,
      List<Menstruation> entities,
      bool isPremium,
      bool isTrial,
      DateTime? trialDeadlineDate,
      Setting? setting,
      PillSheetGroup? latestPillSheetGroup,
      Object? exception});

  $SettingCopyWith<$Res>? get setting;
  $PillSheetGroupCopyWith<$Res>? get latestPillSheetGroup;
}

/// @nodoc
class _$MenstruationStateCopyWithImpl<$Res>
    implements $MenstruationStateCopyWith<$Res> {
  _$MenstruationStateCopyWithImpl(this._value, this._then);

  final MenstruationState _value;
  // ignore: unused_field
  final $Res Function(MenstruationState) _then;

  @override
  $Res call({
    Object? isNotYetLoaded = freezed,
    Object? currentCalendarIndex = freezed,
    Object? diariesForMonth = freezed,
    Object? entities = freezed,
    Object? isPremium = freezed,
    Object? isTrial = freezed,
    Object? trialDeadlineDate = freezed,
    Object? setting = freezed,
    Object? latestPillSheetGroup = freezed,
    Object? exception = freezed,
  }) {
    return _then(_value.copyWith(
      isNotYetLoaded: isNotYetLoaded == freezed
          ? _value.isNotYetLoaded
          : isNotYetLoaded // ignore: cast_nullable_to_non_nullable
              as bool,
      currentCalendarIndex: currentCalendarIndex == freezed
          ? _value.currentCalendarIndex
          : currentCalendarIndex // ignore: cast_nullable_to_non_nullable
              as int,
      diariesForMonth: diariesForMonth == freezed
          ? _value.diariesForMonth
          : diariesForMonth // ignore: cast_nullable_to_non_nullable
              as List<Diary>,
      entities: entities == freezed
          ? _value.entities
          : entities // ignore: cast_nullable_to_non_nullable
              as List<Menstruation>,
      isPremium: isPremium == freezed
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      isTrial: isTrial == freezed
          ? _value.isTrial
          : isTrial // ignore: cast_nullable_to_non_nullable
              as bool,
      trialDeadlineDate: trialDeadlineDate == freezed
          ? _value.trialDeadlineDate
          : trialDeadlineDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      setting: setting == freezed
          ? _value.setting
          : setting // ignore: cast_nullable_to_non_nullable
              as Setting?,
      latestPillSheetGroup: latestPillSheetGroup == freezed
          ? _value.latestPillSheetGroup
          : latestPillSheetGroup // ignore: cast_nullable_to_non_nullable
              as PillSheetGroup?,
      exception: exception == freezed ? _value.exception : exception,
    ));
  }

  @override
  $SettingCopyWith<$Res>? get setting {
    if (_value.setting == null) {
      return null;
    }

    return $SettingCopyWith<$Res>(_value.setting!, (value) {
      return _then(_value.copyWith(setting: value));
    });
  }

  @override
  $PillSheetGroupCopyWith<$Res>? get latestPillSheetGroup {
    if (_value.latestPillSheetGroup == null) {
      return null;
    }

    return $PillSheetGroupCopyWith<$Res>(_value.latestPillSheetGroup!, (value) {
      return _then(_value.copyWith(latestPillSheetGroup: value));
    });
  }
}

/// @nodoc
abstract class _$MenstruationStateCopyWith<$Res>
    implements $MenstruationStateCopyWith<$Res> {
  factory _$MenstruationStateCopyWith(
          _MenstruationState value, $Res Function(_MenstruationState) then) =
      __$MenstruationStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {bool isNotYetLoaded,
      int currentCalendarIndex,
      List<Diary> diariesForMonth,
      List<Menstruation> entities,
      bool isPremium,
      bool isTrial,
      DateTime? trialDeadlineDate,
      Setting? setting,
      PillSheetGroup? latestPillSheetGroup,
      Object? exception});

  @override
  $SettingCopyWith<$Res>? get setting;
  @override
  $PillSheetGroupCopyWith<$Res>? get latestPillSheetGroup;
}

/// @nodoc
class __$MenstruationStateCopyWithImpl<$Res>
    extends _$MenstruationStateCopyWithImpl<$Res>
    implements _$MenstruationStateCopyWith<$Res> {
  __$MenstruationStateCopyWithImpl(
      _MenstruationState _value, $Res Function(_MenstruationState) _then)
      : super(_value, (v) => _then(v as _MenstruationState));

  @override
  _MenstruationState get _value => super._value as _MenstruationState;

  @override
  $Res call({
    Object? isNotYetLoaded = freezed,
    Object? currentCalendarIndex = freezed,
    Object? diariesForMonth = freezed,
    Object? entities = freezed,
    Object? isPremium = freezed,
    Object? isTrial = freezed,
    Object? trialDeadlineDate = freezed,
    Object? setting = freezed,
    Object? latestPillSheetGroup = freezed,
    Object? exception = freezed,
  }) {
    return _then(_MenstruationState(
      isNotYetLoaded: isNotYetLoaded == freezed
          ? _value.isNotYetLoaded
          : isNotYetLoaded // ignore: cast_nullable_to_non_nullable
              as bool,
      currentCalendarIndex: currentCalendarIndex == freezed
          ? _value.currentCalendarIndex
          : currentCalendarIndex // ignore: cast_nullable_to_non_nullable
              as int,
      diariesForMonth: diariesForMonth == freezed
          ? _value.diariesForMonth
          : diariesForMonth // ignore: cast_nullable_to_non_nullable
              as List<Diary>,
      entities: entities == freezed
          ? _value.entities
          : entities // ignore: cast_nullable_to_non_nullable
              as List<Menstruation>,
      isPremium: isPremium == freezed
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      isTrial: isTrial == freezed
          ? _value.isTrial
          : isTrial // ignore: cast_nullable_to_non_nullable
              as bool,
      trialDeadlineDate: trialDeadlineDate == freezed
          ? _value.trialDeadlineDate
          : trialDeadlineDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      setting: setting == freezed
          ? _value.setting
          : setting // ignore: cast_nullable_to_non_nullable
              as Setting?,
      latestPillSheetGroup: latestPillSheetGroup == freezed
          ? _value.latestPillSheetGroup
          : latestPillSheetGroup // ignore: cast_nullable_to_non_nullable
              as PillSheetGroup?,
      exception: exception == freezed ? _value.exception : exception,
    ));
  }
}

/// @nodoc

class _$_MenstruationState extends _MenstruationState {
  _$_MenstruationState(
      {this.isNotYetLoaded = true,
      this.currentCalendarIndex = 0,
      this.diariesForMonth = const [],
      this.entities = const [],
      this.isPremium = false,
      this.isTrial = false,
      this.trialDeadlineDate,
      this.setting,
      this.latestPillSheetGroup,
      this.exception})
      : super._();

  @JsonKey()
  @override
  final bool isNotYetLoaded;
  @JsonKey()
  @override
  final int currentCalendarIndex;
  @JsonKey()
  @override
  final List<Diary> diariesForMonth;
  @JsonKey()
  @override
  final List<Menstruation> entities;
  @JsonKey()
  @override
  final bool isPremium;
  @JsonKey()
  @override
  final bool isTrial;
  @override
  final DateTime? trialDeadlineDate;
  @override
  final Setting? setting;
  @override
  final PillSheetGroup? latestPillSheetGroup;
  @override
  final Object? exception;

  @override
  String toString() {
    return 'MenstruationState(isNotYetLoaded: $isNotYetLoaded, currentCalendarIndex: $currentCalendarIndex, diariesForMonth: $diariesForMonth, entities: $entities, isPremium: $isPremium, isTrial: $isTrial, trialDeadlineDate: $trialDeadlineDate, setting: $setting, latestPillSheetGroup: $latestPillSheetGroup, exception: $exception)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MenstruationState &&
            const DeepCollectionEquality()
                .equals(other.isNotYetLoaded, isNotYetLoaded) &&
            const DeepCollectionEquality()
                .equals(other.currentCalendarIndex, currentCalendarIndex) &&
            const DeepCollectionEquality()
                .equals(other.diariesForMonth, diariesForMonth) &&
            const DeepCollectionEquality().equals(other.entities, entities) &&
            const DeepCollectionEquality().equals(other.isPremium, isPremium) &&
            const DeepCollectionEquality().equals(other.isTrial, isTrial) &&
            const DeepCollectionEquality()
                .equals(other.trialDeadlineDate, trialDeadlineDate) &&
            const DeepCollectionEquality().equals(other.setting, setting) &&
            const DeepCollectionEquality()
                .equals(other.latestPillSheetGroup, latestPillSheetGroup) &&
            const DeepCollectionEquality().equals(other.exception, exception));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(isNotYetLoaded),
      const DeepCollectionEquality().hash(currentCalendarIndex),
      const DeepCollectionEquality().hash(diariesForMonth),
      const DeepCollectionEquality().hash(entities),
      const DeepCollectionEquality().hash(isPremium),
      const DeepCollectionEquality().hash(isTrial),
      const DeepCollectionEquality().hash(trialDeadlineDate),
      const DeepCollectionEquality().hash(setting),
      const DeepCollectionEquality().hash(latestPillSheetGroup),
      const DeepCollectionEquality().hash(exception));

  @JsonKey(ignore: true)
  @override
  _$MenstruationStateCopyWith<_MenstruationState> get copyWith =>
      __$MenstruationStateCopyWithImpl<_MenstruationState>(this, _$identity);
}

abstract class _MenstruationState extends MenstruationState {
  factory _MenstruationState(
      {bool isNotYetLoaded,
      int currentCalendarIndex,
      List<Diary> diariesForMonth,
      List<Menstruation> entities,
      bool isPremium,
      bool isTrial,
      DateTime? trialDeadlineDate,
      Setting? setting,
      PillSheetGroup? latestPillSheetGroup,
      Object? exception}) = _$_MenstruationState;
  _MenstruationState._() : super._();

  @override
  bool get isNotYetLoaded;
  @override
  int get currentCalendarIndex;
  @override
  List<Diary> get diariesForMonth;
  @override
  List<Menstruation> get entities;
  @override
  bool get isPremium;
  @override
  bool get isTrial;
  @override
  DateTime? get trialDeadlineDate;
  @override
  Setting? get setting;
  @override
  PillSheetGroup? get latestPillSheetGroup;
  @override
  Object? get exception;
  @override
  @JsonKey(ignore: true)
  _$MenstruationStateCopyWith<_MenstruationState> get copyWith =>
      throw _privateConstructorUsedError;
}
