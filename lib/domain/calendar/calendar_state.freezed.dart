// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'calendar_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$CalendarPageStateTearOff {
  const _$CalendarPageStateTearOff();

  _CalendarPageState call(
      {int currentCalendarIndex = 0,
      bool isNotYetLoaded = true,
      List<Menstruation> menstruations = const [],
      Setting? setting,
      PillSheet? latestPillSheet,
      List<Diary> diariesForMonth = const [],
      List<PillSheetModifiedHistory> allPillSheetModifiedHistories = const [],
      bool isPremium = false,
      bool isTrial = false,
      DateTime? trialDeadlineDate}) {
    return _CalendarPageState(
      currentCalendarIndex: currentCalendarIndex,
      isNotYetLoaded: isNotYetLoaded,
      menstruations: menstruations,
      setting: setting,
      latestPillSheet: latestPillSheet,
      diariesForMonth: diariesForMonth,
      allPillSheetModifiedHistories: allPillSheetModifiedHistories,
      isPremium: isPremium,
      isTrial: isTrial,
      trialDeadlineDate: trialDeadlineDate,
    );
  }
}

/// @nodoc
const $CalendarPageState = _$CalendarPageStateTearOff();

/// @nodoc
mixin _$CalendarPageState {
  int get currentCalendarIndex => throw _privateConstructorUsedError;
  bool get isNotYetLoaded => throw _privateConstructorUsedError;
  List<Menstruation> get menstruations => throw _privateConstructorUsedError;
  Setting? get setting => throw _privateConstructorUsedError;
  PillSheet? get latestPillSheet => throw _privateConstructorUsedError;
  List<Diary> get diariesForMonth => throw _privateConstructorUsedError;
  List<PillSheetModifiedHistory> get allPillSheetModifiedHistories =>
      throw _privateConstructorUsedError;
  bool get isPremium => throw _privateConstructorUsedError;
  bool get isTrial => throw _privateConstructorUsedError;
  DateTime? get trialDeadlineDate => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CalendarPageStateCopyWith<CalendarPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalendarPageStateCopyWith<$Res> {
  factory $CalendarPageStateCopyWith(
          CalendarPageState value, $Res Function(CalendarPageState) then) =
      _$CalendarPageStateCopyWithImpl<$Res>;
  $Res call(
      {int currentCalendarIndex,
      bool isNotYetLoaded,
      List<Menstruation> menstruations,
      Setting? setting,
      PillSheet? latestPillSheet,
      List<Diary> diariesForMonth,
      List<PillSheetModifiedHistory> allPillSheetModifiedHistories,
      bool isPremium,
      bool isTrial,
      DateTime? trialDeadlineDate});

  $SettingCopyWith<$Res>? get setting;
  $PillSheetCopyWith<$Res>? get latestPillSheet;
}

/// @nodoc
class _$CalendarPageStateCopyWithImpl<$Res>
    implements $CalendarPageStateCopyWith<$Res> {
  _$CalendarPageStateCopyWithImpl(this._value, this._then);

  final CalendarPageState _value;
  // ignore: unused_field
  final $Res Function(CalendarPageState) _then;

  @override
  $Res call({
    Object? currentCalendarIndex = freezed,
    Object? isNotYetLoaded = freezed,
    Object? menstruations = freezed,
    Object? setting = freezed,
    Object? latestPillSheet = freezed,
    Object? diariesForMonth = freezed,
    Object? allPillSheetModifiedHistories = freezed,
    Object? isPremium = freezed,
    Object? isTrial = freezed,
    Object? trialDeadlineDate = freezed,
  }) {
    return _then(_value.copyWith(
      currentCalendarIndex: currentCalendarIndex == freezed
          ? _value.currentCalendarIndex
          : currentCalendarIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isNotYetLoaded: isNotYetLoaded == freezed
          ? _value.isNotYetLoaded
          : isNotYetLoaded // ignore: cast_nullable_to_non_nullable
              as bool,
      menstruations: menstruations == freezed
          ? _value.menstruations
          : menstruations // ignore: cast_nullable_to_non_nullable
              as List<Menstruation>,
      setting: setting == freezed
          ? _value.setting
          : setting // ignore: cast_nullable_to_non_nullable
              as Setting?,
      latestPillSheet: latestPillSheet == freezed
          ? _value.latestPillSheet
          : latestPillSheet // ignore: cast_nullable_to_non_nullable
              as PillSheet?,
      diariesForMonth: diariesForMonth == freezed
          ? _value.diariesForMonth
          : diariesForMonth // ignore: cast_nullable_to_non_nullable
              as List<Diary>,
      allPillSheetModifiedHistories: allPillSheetModifiedHistories == freezed
          ? _value.allPillSheetModifiedHistories
          : allPillSheetModifiedHistories // ignore: cast_nullable_to_non_nullable
              as List<PillSheetModifiedHistory>,
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
  $PillSheetCopyWith<$Res>? get latestPillSheet {
    if (_value.latestPillSheet == null) {
      return null;
    }

    return $PillSheetCopyWith<$Res>(_value.latestPillSheet!, (value) {
      return _then(_value.copyWith(latestPillSheet: value));
    });
  }
}

/// @nodoc
abstract class _$CalendarPageStateCopyWith<$Res>
    implements $CalendarPageStateCopyWith<$Res> {
  factory _$CalendarPageStateCopyWith(
          _CalendarPageState value, $Res Function(_CalendarPageState) then) =
      __$CalendarPageStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {int currentCalendarIndex,
      bool isNotYetLoaded,
      List<Menstruation> menstruations,
      Setting? setting,
      PillSheet? latestPillSheet,
      List<Diary> diariesForMonth,
      List<PillSheetModifiedHistory> allPillSheetModifiedHistories,
      bool isPremium,
      bool isTrial,
      DateTime? trialDeadlineDate});

  @override
  $SettingCopyWith<$Res>? get setting;
  @override
  $PillSheetCopyWith<$Res>? get latestPillSheet;
}

/// @nodoc
class __$CalendarPageStateCopyWithImpl<$Res>
    extends _$CalendarPageStateCopyWithImpl<$Res>
    implements _$CalendarPageStateCopyWith<$Res> {
  __$CalendarPageStateCopyWithImpl(
      _CalendarPageState _value, $Res Function(_CalendarPageState) _then)
      : super(_value, (v) => _then(v as _CalendarPageState));

  @override
  _CalendarPageState get _value => super._value as _CalendarPageState;

  @override
  $Res call({
    Object? currentCalendarIndex = freezed,
    Object? isNotYetLoaded = freezed,
    Object? menstruations = freezed,
    Object? setting = freezed,
    Object? latestPillSheet = freezed,
    Object? diariesForMonth = freezed,
    Object? allPillSheetModifiedHistories = freezed,
    Object? isPremium = freezed,
    Object? isTrial = freezed,
    Object? trialDeadlineDate = freezed,
  }) {
    return _then(_CalendarPageState(
      currentCalendarIndex: currentCalendarIndex == freezed
          ? _value.currentCalendarIndex
          : currentCalendarIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isNotYetLoaded: isNotYetLoaded == freezed
          ? _value.isNotYetLoaded
          : isNotYetLoaded // ignore: cast_nullable_to_non_nullable
              as bool,
      menstruations: menstruations == freezed
          ? _value.menstruations
          : menstruations // ignore: cast_nullable_to_non_nullable
              as List<Menstruation>,
      setting: setting == freezed
          ? _value.setting
          : setting // ignore: cast_nullable_to_non_nullable
              as Setting?,
      latestPillSheet: latestPillSheet == freezed
          ? _value.latestPillSheet
          : latestPillSheet // ignore: cast_nullable_to_non_nullable
              as PillSheet?,
      diariesForMonth: diariesForMonth == freezed
          ? _value.diariesForMonth
          : diariesForMonth // ignore: cast_nullable_to_non_nullable
              as List<Diary>,
      allPillSheetModifiedHistories: allPillSheetModifiedHistories == freezed
          ? _value.allPillSheetModifiedHistories
          : allPillSheetModifiedHistories // ignore: cast_nullable_to_non_nullable
              as List<PillSheetModifiedHistory>,
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
    ));
  }
}

/// @nodoc

class _$_CalendarPageState extends _CalendarPageState {
  _$_CalendarPageState(
      {this.currentCalendarIndex = 0,
      this.isNotYetLoaded = true,
      this.menstruations = const [],
      this.setting,
      this.latestPillSheet,
      this.diariesForMonth = const [],
      this.allPillSheetModifiedHistories = const [],
      this.isPremium = false,
      this.isTrial = false,
      this.trialDeadlineDate})
      : super._();

  @JsonKey(defaultValue: 0)
  @override
  final int currentCalendarIndex;
  @JsonKey(defaultValue: true)
  @override
  final bool isNotYetLoaded;
  @JsonKey(defaultValue: const [])
  @override
  final List<Menstruation> menstruations;
  @override
  final Setting? setting;
  @override
  final PillSheet? latestPillSheet;
  @JsonKey(defaultValue: const [])
  @override
  final List<Diary> diariesForMonth;
  @JsonKey(defaultValue: const [])
  @override
  final List<PillSheetModifiedHistory> allPillSheetModifiedHistories;
  @JsonKey(defaultValue: false)
  @override
  final bool isPremium;
  @JsonKey(defaultValue: false)
  @override
  final bool isTrial;
  @override
  final DateTime? trialDeadlineDate;

  @override
  String toString() {
    return 'CalendarPageState(currentCalendarIndex: $currentCalendarIndex, isNotYetLoaded: $isNotYetLoaded, menstruations: $menstruations, setting: $setting, latestPillSheet: $latestPillSheet, diariesForMonth: $diariesForMonth, allPillSheetModifiedHistories: $allPillSheetModifiedHistories, isPremium: $isPremium, isTrial: $isTrial, trialDeadlineDate: $trialDeadlineDate)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _CalendarPageState &&
            (identical(other.currentCalendarIndex, currentCalendarIndex) ||
                const DeepCollectionEquality().equals(
                    other.currentCalendarIndex, currentCalendarIndex)) &&
            (identical(other.isNotYetLoaded, isNotYetLoaded) ||
                const DeepCollectionEquality()
                    .equals(other.isNotYetLoaded, isNotYetLoaded)) &&
            (identical(other.menstruations, menstruations) ||
                const DeepCollectionEquality()
                    .equals(other.menstruations, menstruations)) &&
            (identical(other.setting, setting) ||
                const DeepCollectionEquality()
                    .equals(other.setting, setting)) &&
            (identical(other.latestPillSheet, latestPillSheet) ||
                const DeepCollectionEquality()
                    .equals(other.latestPillSheet, latestPillSheet)) &&
            (identical(other.diariesForMonth, diariesForMonth) ||
                const DeepCollectionEquality()
                    .equals(other.diariesForMonth, diariesForMonth)) &&
            (identical(other.allPillSheetModifiedHistories,
                    allPillSheetModifiedHistories) ||
                const DeepCollectionEquality().equals(
                    other.allPillSheetModifiedHistories,
                    allPillSheetModifiedHistories)) &&
            (identical(other.isPremium, isPremium) ||
                const DeepCollectionEquality()
                    .equals(other.isPremium, isPremium)) &&
            (identical(other.isTrial, isTrial) ||
                const DeepCollectionEquality()
                    .equals(other.isTrial, isTrial)) &&
            (identical(other.trialDeadlineDate, trialDeadlineDate) ||
                const DeepCollectionEquality()
                    .equals(other.trialDeadlineDate, trialDeadlineDate)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(currentCalendarIndex) ^
      const DeepCollectionEquality().hash(isNotYetLoaded) ^
      const DeepCollectionEquality().hash(menstruations) ^
      const DeepCollectionEquality().hash(setting) ^
      const DeepCollectionEquality().hash(latestPillSheet) ^
      const DeepCollectionEquality().hash(diariesForMonth) ^
      const DeepCollectionEquality().hash(allPillSheetModifiedHistories) ^
      const DeepCollectionEquality().hash(isPremium) ^
      const DeepCollectionEquality().hash(isTrial) ^
      const DeepCollectionEquality().hash(trialDeadlineDate);

  @JsonKey(ignore: true)
  @override
  _$CalendarPageStateCopyWith<_CalendarPageState> get copyWith =>
      __$CalendarPageStateCopyWithImpl<_CalendarPageState>(this, _$identity);
}

abstract class _CalendarPageState extends CalendarPageState {
  factory _CalendarPageState(
      {int currentCalendarIndex,
      bool isNotYetLoaded,
      List<Menstruation> menstruations,
      Setting? setting,
      PillSheet? latestPillSheet,
      List<Diary> diariesForMonth,
      List<PillSheetModifiedHistory> allPillSheetModifiedHistories,
      bool isPremium,
      bool isTrial,
      DateTime? trialDeadlineDate}) = _$_CalendarPageState;
  _CalendarPageState._() : super._();

  @override
  int get currentCalendarIndex => throw _privateConstructorUsedError;
  @override
  bool get isNotYetLoaded => throw _privateConstructorUsedError;
  @override
  List<Menstruation> get menstruations => throw _privateConstructorUsedError;
  @override
  Setting? get setting => throw _privateConstructorUsedError;
  @override
  PillSheet? get latestPillSheet => throw _privateConstructorUsedError;
  @override
  List<Diary> get diariesForMonth => throw _privateConstructorUsedError;
  @override
  List<PillSheetModifiedHistory> get allPillSheetModifiedHistories =>
      throw _privateConstructorUsedError;
  @override
  bool get isPremium => throw _privateConstructorUsedError;
  @override
  bool get isTrial => throw _privateConstructorUsedError;
  @override
  DateTime? get trialDeadlineDate => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$CalendarPageStateCopyWith<_CalendarPageState> get copyWith =>
      throw _privateConstructorUsedError;
}
