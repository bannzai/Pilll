// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'record_page_state.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$RecordPageState {
  PillSheetGroup? get pillSheetGroup => throw _privateConstructorUsedError;
  Setting get setting => throw _privateConstructorUsedError;
  PremiumAndTrial get premiumAndTrial => throw _privateConstructorUsedError;
  int get totalCountOfActionForTakenPill => throw _privateConstructorUsedError;
  bool get isAlreadyShowPremiumSurvey => throw _privateConstructorUsedError;
  bool get shouldShowMigrateInfo => throw _privateConstructorUsedError;
  bool get isLinkedLoginProvider =>
      throw _privateConstructorUsedError; // Workaround for no update RecordPageStateNotifier when pillSheetGroup.activedPillSheet.restDurations is change
// Add and always update timestamp when every stream or provider changed to avoid this issue
  DateTime get timestamp => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RecordPageStateCopyWith<RecordPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecordPageStateCopyWith<$Res> {
  factory $RecordPageStateCopyWith(
          RecordPageState value, $Res Function(RecordPageState) then) =
      _$RecordPageStateCopyWithImpl<$Res, RecordPageState>;
  @useResult
  $Res call(
      {PillSheetGroup? pillSheetGroup,
      Setting setting,
      PremiumAndTrial premiumAndTrial,
      int totalCountOfActionForTakenPill,
      bool isAlreadyShowPremiumSurvey,
      bool shouldShowMigrateInfo,
      bool isLinkedLoginProvider,
      DateTime timestamp});

  $PillSheetGroupCopyWith<$Res>? get pillSheetGroup;
  $SettingCopyWith<$Res> get setting;
  $PremiumAndTrialCopyWith<$Res> get premiumAndTrial;
}

/// @nodoc
class _$RecordPageStateCopyWithImpl<$Res, $Val extends RecordPageState>
    implements $RecordPageStateCopyWith<$Res> {
  _$RecordPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pillSheetGroup = freezed,
    Object? setting = null,
    Object? premiumAndTrial = null,
    Object? totalCountOfActionForTakenPill = null,
    Object? isAlreadyShowPremiumSurvey = null,
    Object? shouldShowMigrateInfo = null,
    Object? isLinkedLoginProvider = null,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      pillSheetGroup: freezed == pillSheetGroup
          ? _value.pillSheetGroup
          : pillSheetGroup // ignore: cast_nullable_to_non_nullable
              as PillSheetGroup?,
      setting: null == setting
          ? _value.setting
          : setting // ignore: cast_nullable_to_non_nullable
              as Setting,
      premiumAndTrial: null == premiumAndTrial
          ? _value.premiumAndTrial
          : premiumAndTrial // ignore: cast_nullable_to_non_nullable
              as PremiumAndTrial,
      totalCountOfActionForTakenPill: null == totalCountOfActionForTakenPill
          ? _value.totalCountOfActionForTakenPill
          : totalCountOfActionForTakenPill // ignore: cast_nullable_to_non_nullable
              as int,
      isAlreadyShowPremiumSurvey: null == isAlreadyShowPremiumSurvey
          ? _value.isAlreadyShowPremiumSurvey
          : isAlreadyShowPremiumSurvey // ignore: cast_nullable_to_non_nullable
              as bool,
      shouldShowMigrateInfo: null == shouldShowMigrateInfo
          ? _value.shouldShowMigrateInfo
          : shouldShowMigrateInfo // ignore: cast_nullable_to_non_nullable
              as bool,
      isLinkedLoginProvider: null == isLinkedLoginProvider
          ? _value.isLinkedLoginProvider
          : isLinkedLoginProvider // ignore: cast_nullable_to_non_nullable
              as bool,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PillSheetGroupCopyWith<$Res>? get pillSheetGroup {
    if (_value.pillSheetGroup == null) {
      return null;
    }

    return $PillSheetGroupCopyWith<$Res>(_value.pillSheetGroup!, (value) {
      return _then(_value.copyWith(pillSheetGroup: value) as $Val);
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
  $PremiumAndTrialCopyWith<$Res> get premiumAndTrial {
    return $PremiumAndTrialCopyWith<$Res>(_value.premiumAndTrial, (value) {
      return _then(_value.copyWith(premiumAndTrial: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_RecordPageStateCopyWith<$Res>
    implements $RecordPageStateCopyWith<$Res> {
  factory _$$_RecordPageStateCopyWith(
          _$_RecordPageState value, $Res Function(_$_RecordPageState) then) =
      __$$_RecordPageStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PillSheetGroup? pillSheetGroup,
      Setting setting,
      PremiumAndTrial premiumAndTrial,
      int totalCountOfActionForTakenPill,
      bool isAlreadyShowPremiumSurvey,
      bool shouldShowMigrateInfo,
      bool isLinkedLoginProvider,
      DateTime timestamp});

  @override
  $PillSheetGroupCopyWith<$Res>? get pillSheetGroup;
  @override
  $SettingCopyWith<$Res> get setting;
  @override
  $PremiumAndTrialCopyWith<$Res> get premiumAndTrial;
}

/// @nodoc
class __$$_RecordPageStateCopyWithImpl<$Res>
    extends _$RecordPageStateCopyWithImpl<$Res, _$_RecordPageState>
    implements _$$_RecordPageStateCopyWith<$Res> {
  __$$_RecordPageStateCopyWithImpl(
      _$_RecordPageState _value, $Res Function(_$_RecordPageState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pillSheetGroup = freezed,
    Object? setting = null,
    Object? premiumAndTrial = null,
    Object? totalCountOfActionForTakenPill = null,
    Object? isAlreadyShowPremiumSurvey = null,
    Object? shouldShowMigrateInfo = null,
    Object? isLinkedLoginProvider = null,
    Object? timestamp = null,
  }) {
    return _then(_$_RecordPageState(
      pillSheetGroup: freezed == pillSheetGroup
          ? _value.pillSheetGroup
          : pillSheetGroup // ignore: cast_nullable_to_non_nullable
              as PillSheetGroup?,
      setting: null == setting
          ? _value.setting
          : setting // ignore: cast_nullable_to_non_nullable
              as Setting,
      premiumAndTrial: null == premiumAndTrial
          ? _value.premiumAndTrial
          : premiumAndTrial // ignore: cast_nullable_to_non_nullable
              as PremiumAndTrial,
      totalCountOfActionForTakenPill: null == totalCountOfActionForTakenPill
          ? _value.totalCountOfActionForTakenPill
          : totalCountOfActionForTakenPill // ignore: cast_nullable_to_non_nullable
              as int,
      isAlreadyShowPremiumSurvey: null == isAlreadyShowPremiumSurvey
          ? _value.isAlreadyShowPremiumSurvey
          : isAlreadyShowPremiumSurvey // ignore: cast_nullable_to_non_nullable
              as bool,
      shouldShowMigrateInfo: null == shouldShowMigrateInfo
          ? _value.shouldShowMigrateInfo
          : shouldShowMigrateInfo // ignore: cast_nullable_to_non_nullable
              as bool,
      isLinkedLoginProvider: null == isLinkedLoginProvider
          ? _value.isLinkedLoginProvider
          : isLinkedLoginProvider // ignore: cast_nullable_to_non_nullable
              as bool,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$_RecordPageState extends _RecordPageState {
  const _$_RecordPageState(
      {required this.pillSheetGroup,
      required this.setting,
      required this.premiumAndTrial,
      required this.totalCountOfActionForTakenPill,
      required this.isAlreadyShowPremiumSurvey,
      required this.shouldShowMigrateInfo,
      required this.isLinkedLoginProvider,
      required this.timestamp})
      : super._();

  @override
  final PillSheetGroup? pillSheetGroup;
  @override
  final Setting setting;
  @override
  final PremiumAndTrial premiumAndTrial;
  @override
  final int totalCountOfActionForTakenPill;
  @override
  final bool isAlreadyShowPremiumSurvey;
  @override
  final bool shouldShowMigrateInfo;
  @override
  final bool isLinkedLoginProvider;
// Workaround for no update RecordPageStateNotifier when pillSheetGroup.activedPillSheet.restDurations is change
// Add and always update timestamp when every stream or provider changed to avoid this issue
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'RecordPageState(pillSheetGroup: $pillSheetGroup, setting: $setting, premiumAndTrial: $premiumAndTrial, totalCountOfActionForTakenPill: $totalCountOfActionForTakenPill, isAlreadyShowPremiumSurvey: $isAlreadyShowPremiumSurvey, shouldShowMigrateInfo: $shouldShowMigrateInfo, isLinkedLoginProvider: $isLinkedLoginProvider, timestamp: $timestamp)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RecordPageState &&
            (identical(other.pillSheetGroup, pillSheetGroup) ||
                other.pillSheetGroup == pillSheetGroup) &&
            (identical(other.setting, setting) || other.setting == setting) &&
            (identical(other.premiumAndTrial, premiumAndTrial) ||
                other.premiumAndTrial == premiumAndTrial) &&
            (identical(other.totalCountOfActionForTakenPill,
                    totalCountOfActionForTakenPill) ||
                other.totalCountOfActionForTakenPill ==
                    totalCountOfActionForTakenPill) &&
            (identical(other.isAlreadyShowPremiumSurvey,
                    isAlreadyShowPremiumSurvey) ||
                other.isAlreadyShowPremiumSurvey ==
                    isAlreadyShowPremiumSurvey) &&
            (identical(other.shouldShowMigrateInfo, shouldShowMigrateInfo) ||
                other.shouldShowMigrateInfo == shouldShowMigrateInfo) &&
            (identical(other.isLinkedLoginProvider, isLinkedLoginProvider) ||
                other.isLinkedLoginProvider == isLinkedLoginProvider) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      pillSheetGroup,
      setting,
      premiumAndTrial,
      totalCountOfActionForTakenPill,
      isAlreadyShowPremiumSurvey,
      shouldShowMigrateInfo,
      isLinkedLoginProvider,
      timestamp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_RecordPageStateCopyWith<_$_RecordPageState> get copyWith =>
      __$$_RecordPageStateCopyWithImpl<_$_RecordPageState>(this, _$identity);
}

abstract class _RecordPageState extends RecordPageState {
  const factory _RecordPageState(
      {required final PillSheetGroup? pillSheetGroup,
      required final Setting setting,
      required final PremiumAndTrial premiumAndTrial,
      required final int totalCountOfActionForTakenPill,
      required final bool isAlreadyShowPremiumSurvey,
      required final bool shouldShowMigrateInfo,
      required final bool isLinkedLoginProvider,
      required final DateTime timestamp}) = _$_RecordPageState;
  const _RecordPageState._() : super._();

  @override
  PillSheetGroup? get pillSheetGroup;
  @override
  Setting get setting;
  @override
  PremiumAndTrial get premiumAndTrial;
  @override
  int get totalCountOfActionForTakenPill;
  @override
  bool get isAlreadyShowPremiumSurvey;
  @override
  bool get shouldShowMigrateInfo;
  @override
  bool get isLinkedLoginProvider;
  @override // Workaround for no update RecordPageStateNotifier when pillSheetGroup.activedPillSheet.restDurations is change
// Add and always update timestamp when every stream or provider changed to avoid this issue
  DateTime get timestamp;
  @override
  @JsonKey(ignore: true)
  _$$_RecordPageStateCopyWith<_$_RecordPageState> get copyWith =>
      throw _privateConstructorUsedError;
}
