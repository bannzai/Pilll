// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

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
      PillSheetGroup? latestPillSheetGroup}) {
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
  PillSheet? get latestPillSheetGroup => throw _privateConstructorUsedError;

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
      PillSheetGroup? latestPillSheetGroup});

  $SettingCopyWith<$Res>? get setting;
  $PillSheetCopyWith<$Res>? get latestPillSheetGroup;
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
              as PillSheet?,
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
  $PillSheetCopyWith<$Res>? get latestPillSheetGroup {
    if (_value.latestPillSheetGroup == null) {
      return null;
    }

    return $PillSheetCopyWith<$Res>(_value.latestPillSheetGroup!, (value) {
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
      PillSheetGroup? latestPillSheetGroup});

  @override
  $SettingCopyWith<$Res>? get setting;
  @override
  $PillSheetCopyWith<$Res>? get latestPillSheetGroup;
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
              as PillSheet?,
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
      this.latestPillSheetGroup})
      : super._();

  @JsonKey(defaultValue: true)
  @override
  final bool isNotYetLoaded;
  @JsonKey(defaultValue: 0)
  @override
  final int currentCalendarIndex;
  @JsonKey(defaultValue: const [])
  @override
  final List<Diary> diariesForMonth;
  @JsonKey(defaultValue: const [])
  @override
  final List<Menstruation> entities;
  @JsonKey(defaultValue: false)
  @override
  final bool isPremium;
  @JsonKey(defaultValue: false)
  @override
  final bool isTrial;
  @override
  final DateTime? trialDeadlineDate;
  @override
  final Setting? setting;
  @override
  final PillSheetGroup? latestPillSheetGroup;

  @override
  String toString() {
    return 'MenstruationState(isNotYetLoaded: $isNotYetLoaded, currentCalendarIndex: $currentCalendarIndex, diariesForMonth: $diariesForMonth, entities: $entities, isPremium: $isPremium, isTrial: $isTrial, trialDeadlineDate: $trialDeadlineDate, setting: $setting, latestPillSheetGroup: $latestPillSheetGroup)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _MenstruationState &&
            (identical(other.isNotYetLoaded, isNotYetLoaded) ||
                const DeepCollectionEquality()
                    .equals(other.isNotYetLoaded, isNotYetLoaded)) &&
            (identical(other.currentCalendarIndex, currentCalendarIndex) ||
                const DeepCollectionEquality().equals(
                    other.currentCalendarIndex, currentCalendarIndex)) &&
            (identical(other.diariesForMonth, diariesForMonth) ||
                const DeepCollectionEquality()
                    .equals(other.diariesForMonth, diariesForMonth)) &&
            (identical(other.entities, entities) ||
                const DeepCollectionEquality()
                    .equals(other.entities, entities)) &&
            (identical(other.isPremium, isPremium) ||
                const DeepCollectionEquality()
                    .equals(other.isPremium, isPremium)) &&
            (identical(other.isTrial, isTrial) ||
                const DeepCollectionEquality()
                    .equals(other.isTrial, isTrial)) &&
            (identical(other.trialDeadlineDate, trialDeadlineDate) ||
                const DeepCollectionEquality()
                    .equals(other.trialDeadlineDate, trialDeadlineDate)) &&
            (identical(other.setting, setting) ||
                const DeepCollectionEquality()
                    .equals(other.setting, setting)) &&
            (identical(other.latestPillSheetGroup, latestPillSheetGroup) ||
                const DeepCollectionEquality()
                    .equals(other.latestPillSheetGroup, latestPillSheetGroup)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(isNotYetLoaded) ^
      const DeepCollectionEquality().hash(currentCalendarIndex) ^
      const DeepCollectionEquality().hash(diariesForMonth) ^
      const DeepCollectionEquality().hash(entities) ^
      const DeepCollectionEquality().hash(isPremium) ^
      const DeepCollectionEquality().hash(isTrial) ^
      const DeepCollectionEquality().hash(trialDeadlineDate) ^
      const DeepCollectionEquality().hash(setting) ^
      const DeepCollectionEquality().hash(latestPillSheetGroup);

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
      PillSheetGroup? latestPillSheetGroup}) = _$_MenstruationState;
  _MenstruationState._() : super._();

  @override
  bool get isNotYetLoaded => throw _privateConstructorUsedError;
  @override
  int get currentCalendarIndex => throw _privateConstructorUsedError;
  @override
  List<Diary> get diariesForMonth => throw _privateConstructorUsedError;
  @override
  List<Menstruation> get entities => throw _privateConstructorUsedError;
  @override
  bool get isPremium => throw _privateConstructorUsedError;
  @override
  bool get isTrial => throw _privateConstructorUsedError;
  @override
  DateTime? get trialDeadlineDate => throw _privateConstructorUsedError;
  @override
  Setting? get setting => throw _privateConstructorUsedError;
  @override
  PillSheet? get latestPillSheetGroup => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$MenstruationStateCopyWith<_MenstruationState> get copyWith =>
      throw _privateConstructorUsedError;
}
