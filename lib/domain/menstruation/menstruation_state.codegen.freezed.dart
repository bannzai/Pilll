// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'menstruation_state.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MenstruationState {
  int get currentCalendarPageIndex => throw _privateConstructorUsedError;
  int get todayCalendarPageIndex => throw _privateConstructorUsedError;
  List<Diary> get diariesForAround90Days => throw _privateConstructorUsedError;
  List<Schedule> get schedulesForAround90Days =>
      throw _privateConstructorUsedError;
  List<Menstruation> get menstruations => throw _privateConstructorUsedError;
  PremiumAndTrial get premiumAndTrial => throw _privateConstructorUsedError;
  Setting get setting => throw _privateConstructorUsedError;
  PillSheetGroup? get latestPillSheetGroup =>
      throw _privateConstructorUsedError;
  List<CalendarMenstruationBandModel> get calendarMenstruationBandModels =>
      throw _privateConstructorUsedError;
  List<CalendarScheduledMenstruationBandModel>
      get calendarScheduledMenstruationBandModels =>
          throw _privateConstructorUsedError;
  List<CalendarNextPillSheetBandModel> get calendarNextPillSheetBandModels =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MenstruationStateCopyWith<MenstruationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MenstruationStateCopyWith<$Res> {
  factory $MenstruationStateCopyWith(
          MenstruationState value, $Res Function(MenstruationState) then) =
      _$MenstruationStateCopyWithImpl<$Res, MenstruationState>;
  @useResult
  $Res call(
      {int currentCalendarPageIndex,
      int todayCalendarPageIndex,
      List<Diary> diariesForAround90Days,
      List<Schedule> schedulesForAround90Days,
      List<Menstruation> menstruations,
      PremiumAndTrial premiumAndTrial,
      Setting setting,
      PillSheetGroup? latestPillSheetGroup,
      List<CalendarMenstruationBandModel> calendarMenstruationBandModels,
      List<CalendarScheduledMenstruationBandModel>
          calendarScheduledMenstruationBandModels,
      List<CalendarNextPillSheetBandModel> calendarNextPillSheetBandModels});

  $PremiumAndTrialCopyWith<$Res> get premiumAndTrial;
  $SettingCopyWith<$Res> get setting;
  $PillSheetGroupCopyWith<$Res>? get latestPillSheetGroup;
}

/// @nodoc
class _$MenstruationStateCopyWithImpl<$Res, $Val extends MenstruationState>
    implements $MenstruationStateCopyWith<$Res> {
  _$MenstruationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentCalendarPageIndex = null,
    Object? todayCalendarPageIndex = null,
    Object? diariesForAround90Days = null,
    Object? schedulesForAround90Days = null,
    Object? menstruations = null,
    Object? premiumAndTrial = null,
    Object? setting = null,
    Object? latestPillSheetGroup = freezed,
    Object? calendarMenstruationBandModels = null,
    Object? calendarScheduledMenstruationBandModels = null,
    Object? calendarNextPillSheetBandModels = null,
  }) {
    return _then(_value.copyWith(
      currentCalendarPageIndex: null == currentCalendarPageIndex
          ? _value.currentCalendarPageIndex
          : currentCalendarPageIndex // ignore: cast_nullable_to_non_nullable
              as int,
      todayCalendarPageIndex: null == todayCalendarPageIndex
          ? _value.todayCalendarPageIndex
          : todayCalendarPageIndex // ignore: cast_nullable_to_non_nullable
              as int,
      diariesForAround90Days: null == diariesForAround90Days
          ? _value.diariesForAround90Days
          : diariesForAround90Days // ignore: cast_nullable_to_non_nullable
              as List<Diary>,
      schedulesForAround90Days: null == schedulesForAround90Days
          ? _value.schedulesForAround90Days
          : schedulesForAround90Days // ignore: cast_nullable_to_non_nullable
              as List<Schedule>,
      menstruations: null == menstruations
          ? _value.menstruations
          : menstruations // ignore: cast_nullable_to_non_nullable
              as List<Menstruation>,
      premiumAndTrial: null == premiumAndTrial
          ? _value.premiumAndTrial
          : premiumAndTrial // ignore: cast_nullable_to_non_nullable
              as PremiumAndTrial,
      setting: null == setting
          ? _value.setting
          : setting // ignore: cast_nullable_to_non_nullable
              as Setting,
      latestPillSheetGroup: freezed == latestPillSheetGroup
          ? _value.latestPillSheetGroup
          : latestPillSheetGroup // ignore: cast_nullable_to_non_nullable
              as PillSheetGroup?,
      calendarMenstruationBandModels: null == calendarMenstruationBandModels
          ? _value.calendarMenstruationBandModels
          : calendarMenstruationBandModels // ignore: cast_nullable_to_non_nullable
              as List<CalendarMenstruationBandModel>,
      calendarScheduledMenstruationBandModels: null ==
              calendarScheduledMenstruationBandModels
          ? _value.calendarScheduledMenstruationBandModels
          : calendarScheduledMenstruationBandModels // ignore: cast_nullable_to_non_nullable
              as List<CalendarScheduledMenstruationBandModel>,
      calendarNextPillSheetBandModels: null == calendarNextPillSheetBandModels
          ? _value.calendarNextPillSheetBandModels
          : calendarNextPillSheetBandModels // ignore: cast_nullable_to_non_nullable
              as List<CalendarNextPillSheetBandModel>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PremiumAndTrialCopyWith<$Res> get premiumAndTrial {
    return $PremiumAndTrialCopyWith<$Res>(_value.premiumAndTrial, (value) {
      return _then(_value.copyWith(premiumAndTrial: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $SettingCopyWith<$Res> get setting {
    return $SettingCopyWith<$Res>(_value.setting, (value) {
      return _then(_value.copyWith(setting: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PillSheetGroupCopyWith<$Res>? get latestPillSheetGroup {
    if (_value.latestPillSheetGroup == null) {
      return null;
    }

    return $PillSheetGroupCopyWith<$Res>(_value.latestPillSheetGroup!, (value) {
      return _then(_value.copyWith(latestPillSheetGroup: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_MenstruationStateCopyWith<$Res>
    implements $MenstruationStateCopyWith<$Res> {
  factory _$$_MenstruationStateCopyWith(_$_MenstruationState value,
          $Res Function(_$_MenstruationState) then) =
      __$$_MenstruationStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int currentCalendarPageIndex,
      int todayCalendarPageIndex,
      List<Diary> diariesForAround90Days,
      List<Schedule> schedulesForAround90Days,
      List<Menstruation> menstruations,
      PremiumAndTrial premiumAndTrial,
      Setting setting,
      PillSheetGroup? latestPillSheetGroup,
      List<CalendarMenstruationBandModel> calendarMenstruationBandModels,
      List<CalendarScheduledMenstruationBandModel>
          calendarScheduledMenstruationBandModels,
      List<CalendarNextPillSheetBandModel> calendarNextPillSheetBandModels});

  @override
  $PremiumAndTrialCopyWith<$Res> get premiumAndTrial;
  @override
  $SettingCopyWith<$Res> get setting;
  @override
  $PillSheetGroupCopyWith<$Res>? get latestPillSheetGroup;
}

/// @nodoc
class __$$_MenstruationStateCopyWithImpl<$Res>
    extends _$MenstruationStateCopyWithImpl<$Res, _$_MenstruationState>
    implements _$$_MenstruationStateCopyWith<$Res> {
  __$$_MenstruationStateCopyWithImpl(
      _$_MenstruationState _value, $Res Function(_$_MenstruationState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentCalendarPageIndex = null,
    Object? todayCalendarPageIndex = null,
    Object? diariesForAround90Days = null,
    Object? schedulesForAround90Days = null,
    Object? menstruations = null,
    Object? premiumAndTrial = null,
    Object? setting = null,
    Object? latestPillSheetGroup = freezed,
    Object? calendarMenstruationBandModels = null,
    Object? calendarScheduledMenstruationBandModels = null,
    Object? calendarNextPillSheetBandModels = null,
  }) {
    return _then(_$_MenstruationState(
      currentCalendarPageIndex: null == currentCalendarPageIndex
          ? _value.currentCalendarPageIndex
          : currentCalendarPageIndex // ignore: cast_nullable_to_non_nullable
              as int,
      todayCalendarPageIndex: null == todayCalendarPageIndex
          ? _value.todayCalendarPageIndex
          : todayCalendarPageIndex // ignore: cast_nullable_to_non_nullable
              as int,
      diariesForAround90Days: null == diariesForAround90Days
          ? _value._diariesForAround90Days
          : diariesForAround90Days // ignore: cast_nullable_to_non_nullable
              as List<Diary>,
      schedulesForAround90Days: null == schedulesForAround90Days
          ? _value._schedulesForAround90Days
          : schedulesForAround90Days // ignore: cast_nullable_to_non_nullable
              as List<Schedule>,
      menstruations: null == menstruations
          ? _value._menstruations
          : menstruations // ignore: cast_nullable_to_non_nullable
              as List<Menstruation>,
      premiumAndTrial: null == premiumAndTrial
          ? _value.premiumAndTrial
          : premiumAndTrial // ignore: cast_nullable_to_non_nullable
              as PremiumAndTrial,
      setting: null == setting
          ? _value.setting
          : setting // ignore: cast_nullable_to_non_nullable
              as Setting,
      latestPillSheetGroup: freezed == latestPillSheetGroup
          ? _value.latestPillSheetGroup
          : latestPillSheetGroup // ignore: cast_nullable_to_non_nullable
              as PillSheetGroup?,
      calendarMenstruationBandModels: null == calendarMenstruationBandModels
          ? _value._calendarMenstruationBandModels
          : calendarMenstruationBandModels // ignore: cast_nullable_to_non_nullable
              as List<CalendarMenstruationBandModel>,
      calendarScheduledMenstruationBandModels: null ==
              calendarScheduledMenstruationBandModels
          ? _value._calendarScheduledMenstruationBandModels
          : calendarScheduledMenstruationBandModels // ignore: cast_nullable_to_non_nullable
              as List<CalendarScheduledMenstruationBandModel>,
      calendarNextPillSheetBandModels: null == calendarNextPillSheetBandModels
          ? _value._calendarNextPillSheetBandModels
          : calendarNextPillSheetBandModels // ignore: cast_nullable_to_non_nullable
              as List<CalendarNextPillSheetBandModel>,
    ));
  }
}

/// @nodoc

class _$_MenstruationState extends _MenstruationState {
  _$_MenstruationState(
      {required this.currentCalendarPageIndex,
      required this.todayCalendarPageIndex,
      required final List<Diary> diariesForAround90Days,
      required final List<Schedule> schedulesForAround90Days,
      required final List<Menstruation> menstruations,
      required this.premiumAndTrial,
      required this.setting,
      required this.latestPillSheetGroup,
      required final List<CalendarMenstruationBandModel>
          calendarMenstruationBandModels,
      required final List<CalendarScheduledMenstruationBandModel>
          calendarScheduledMenstruationBandModels,
      required final List<CalendarNextPillSheetBandModel>
          calendarNextPillSheetBandModels})
      : _diariesForAround90Days = diariesForAround90Days,
        _schedulesForAround90Days = schedulesForAround90Days,
        _menstruations = menstruations,
        _calendarMenstruationBandModels = calendarMenstruationBandModels,
        _calendarScheduledMenstruationBandModels =
            calendarScheduledMenstruationBandModels,
        _calendarNextPillSheetBandModels = calendarNextPillSheetBandModels,
        super._();

  @override
  final int currentCalendarPageIndex;
  @override
  final int todayCalendarPageIndex;
  final List<Diary> _diariesForAround90Days;
  @override
  List<Diary> get diariesForAround90Days {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_diariesForAround90Days);
  }

  final List<Schedule> _schedulesForAround90Days;
  @override
  List<Schedule> get schedulesForAround90Days {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_schedulesForAround90Days);
  }

  final List<Menstruation> _menstruations;
  @override
  List<Menstruation> get menstruations {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_menstruations);
  }

  @override
  final PremiumAndTrial premiumAndTrial;
  @override
  final Setting setting;
  @override
  final PillSheetGroup? latestPillSheetGroup;
  final List<CalendarMenstruationBandModel> _calendarMenstruationBandModels;
  @override
  List<CalendarMenstruationBandModel> get calendarMenstruationBandModels {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_calendarMenstruationBandModels);
  }

  final List<CalendarScheduledMenstruationBandModel>
      _calendarScheduledMenstruationBandModels;
  @override
  List<CalendarScheduledMenstruationBandModel>
      get calendarScheduledMenstruationBandModels {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_calendarScheduledMenstruationBandModels);
  }

  final List<CalendarNextPillSheetBandModel> _calendarNextPillSheetBandModels;
  @override
  List<CalendarNextPillSheetBandModel> get calendarNextPillSheetBandModels {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_calendarNextPillSheetBandModels);
  }

  @override
  String toString() {
    return 'MenstruationState(currentCalendarPageIndex: $currentCalendarPageIndex, todayCalendarPageIndex: $todayCalendarPageIndex, diariesForAround90Days: $diariesForAround90Days, schedulesForAround90Days: $schedulesForAround90Days, menstruations: $menstruations, premiumAndTrial: $premiumAndTrial, setting: $setting, latestPillSheetGroup: $latestPillSheetGroup, calendarMenstruationBandModels: $calendarMenstruationBandModels, calendarScheduledMenstruationBandModels: $calendarScheduledMenstruationBandModels, calendarNextPillSheetBandModels: $calendarNextPillSheetBandModels)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MenstruationState &&
            (identical(
                    other.currentCalendarPageIndex, currentCalendarPageIndex) ||
                other.currentCalendarPageIndex == currentCalendarPageIndex) &&
            (identical(other.todayCalendarPageIndex, todayCalendarPageIndex) ||
                other.todayCalendarPageIndex == todayCalendarPageIndex) &&
            const DeepCollectionEquality().equals(
                other._diariesForAround90Days, _diariesForAround90Days) &&
            const DeepCollectionEquality().equals(
                other._schedulesForAround90Days, _schedulesForAround90Days) &&
            const DeepCollectionEquality()
                .equals(other._menstruations, _menstruations) &&
            (identical(other.premiumAndTrial, premiumAndTrial) ||
                other.premiumAndTrial == premiumAndTrial) &&
            (identical(other.setting, setting) || other.setting == setting) &&
            (identical(other.latestPillSheetGroup, latestPillSheetGroup) ||
                other.latestPillSheetGroup == latestPillSheetGroup) &&
            const DeepCollectionEquality().equals(
                other._calendarMenstruationBandModels,
                _calendarMenstruationBandModels) &&
            const DeepCollectionEquality().equals(
                other._calendarScheduledMenstruationBandModels,
                _calendarScheduledMenstruationBandModels) &&
            const DeepCollectionEquality().equals(
                other._calendarNextPillSheetBandModels,
                _calendarNextPillSheetBandModels));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentCalendarPageIndex,
      todayCalendarPageIndex,
      const DeepCollectionEquality().hash(_diariesForAround90Days),
      const DeepCollectionEquality().hash(_schedulesForAround90Days),
      const DeepCollectionEquality().hash(_menstruations),
      premiumAndTrial,
      setting,
      latestPillSheetGroup,
      const DeepCollectionEquality().hash(_calendarMenstruationBandModels),
      const DeepCollectionEquality()
          .hash(_calendarScheduledMenstruationBandModels),
      const DeepCollectionEquality().hash(_calendarNextPillSheetBandModels));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MenstruationStateCopyWith<_$_MenstruationState> get copyWith =>
      __$$_MenstruationStateCopyWithImpl<_$_MenstruationState>(
          this, _$identity);
}

abstract class _MenstruationState extends MenstruationState {
  factory _MenstruationState(
      {required final int currentCalendarPageIndex,
      required final int todayCalendarPageIndex,
      required final List<Diary> diariesForAround90Days,
      required final List<Schedule> schedulesForAround90Days,
      required final List<Menstruation> menstruations,
      required final PremiumAndTrial premiumAndTrial,
      required final Setting setting,
      required final PillSheetGroup? latestPillSheetGroup,
      required final List<CalendarMenstruationBandModel>
          calendarMenstruationBandModels,
      required final List<CalendarScheduledMenstruationBandModel>
          calendarScheduledMenstruationBandModels,
      required final List<CalendarNextPillSheetBandModel>
          calendarNextPillSheetBandModels}) = _$_MenstruationState;
  _MenstruationState._() : super._();

  @override
  int get currentCalendarPageIndex;
  @override
  int get todayCalendarPageIndex;
  @override
  List<Diary> get diariesForAround90Days;
  @override
  List<Schedule> get schedulesForAround90Days;
  @override
  List<Menstruation> get menstruations;
  @override
  PremiumAndTrial get premiumAndTrial;
  @override
  Setting get setting;
  @override
  PillSheetGroup? get latestPillSheetGroup;
  @override
  List<CalendarMenstruationBandModel> get calendarMenstruationBandModels;
  @override
  List<CalendarScheduledMenstruationBandModel>
      get calendarScheduledMenstruationBandModels;
  @override
  List<CalendarNextPillSheetBandModel> get calendarNextPillSheetBandModels;
  @override
  @JsonKey(ignore: true)
  _$$_MenstruationStateCopyWith<_$_MenstruationState> get copyWith =>
      throw _privateConstructorUsedError;
}
