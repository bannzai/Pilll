// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'setting.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ReminderTime _$ReminderTimeFromJson(Map<String, dynamic> json) {
  return _ReminderTime.fromJson(json);
}

/// @nodoc
mixin _$ReminderTime {
  int get hour => throw _privateConstructorUsedError;
  int get minute => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReminderTimeCopyWith<ReminderTime> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReminderTimeCopyWith<$Res> {
  factory $ReminderTimeCopyWith(
          ReminderTime value, $Res Function(ReminderTime) then) =
      _$ReminderTimeCopyWithImpl<$Res, ReminderTime>;
  @useResult
  $Res call({int hour, int minute});
}

/// @nodoc
class _$ReminderTimeCopyWithImpl<$Res, $Val extends ReminderTime>
    implements $ReminderTimeCopyWith<$Res> {
  _$ReminderTimeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hour = null,
    Object? minute = null,
  }) {
    return _then(_value.copyWith(
      hour: null == hour
          ? _value.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as int,
      minute: null == minute
          ? _value.minute
          : minute // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ReminderTimeCopyWith<$Res>
    implements $ReminderTimeCopyWith<$Res> {
  factory _$$_ReminderTimeCopyWith(
          _$_ReminderTime value, $Res Function(_$_ReminderTime) then) =
      __$$_ReminderTimeCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int hour, int minute});
}

/// @nodoc
class __$$_ReminderTimeCopyWithImpl<$Res>
    extends _$ReminderTimeCopyWithImpl<$Res, _$_ReminderTime>
    implements _$$_ReminderTimeCopyWith<$Res> {
  __$$_ReminderTimeCopyWithImpl(
      _$_ReminderTime _value, $Res Function(_$_ReminderTime) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hour = null,
    Object? minute = null,
  }) {
    return _then(_$_ReminderTime(
      hour: null == hour
          ? _value.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as int,
      minute: null == minute
          ? _value.minute
          : minute // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_ReminderTime extends _ReminderTime with DiagnosticableTreeMixin {
  const _$_ReminderTime({required this.hour, required this.minute}) : super._();

  factory _$_ReminderTime.fromJson(Map<String, dynamic> json) =>
      _$$_ReminderTimeFromJson(json);

  @override
  final int hour;
  @override
  final int minute;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ReminderTime(hour: $hour, minute: $minute)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ReminderTime'))
      ..add(DiagnosticsProperty('hour', hour))
      ..add(DiagnosticsProperty('minute', minute));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ReminderTime &&
            (identical(other.hour, hour) || other.hour == hour) &&
            (identical(other.minute, minute) || other.minute == minute));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, hour, minute);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ReminderTimeCopyWith<_$_ReminderTime> get copyWith =>
      __$$_ReminderTimeCopyWithImpl<_$_ReminderTime>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ReminderTimeToJson(
      this,
    );
  }
}

abstract class _ReminderTime extends ReminderTime {
  const factory _ReminderTime(
      {required final int hour, required final int minute}) = _$_ReminderTime;
  const _ReminderTime._() : super._();

  factory _ReminderTime.fromJson(Map<String, dynamic> json) =
      _$_ReminderTime.fromJson;

  @override
  int get hour;
  @override
  int get minute;
  @override
  @JsonKey(ignore: true)
  _$$_ReminderTimeCopyWith<_$_ReminderTime> get copyWith =>
      throw _privateConstructorUsedError;
}

Setting _$SettingFromJson(Map<String, dynamic> json) {
  return _Setting.fromJson(json);
}

/// @nodoc
mixin _$Setting {
  List<PillSheetType?> get pillSheetTypes => throw _privateConstructorUsedError;
  int get pillNumberForFromMenstruation => throw _privateConstructorUsedError;
  int get durationMenstruation => throw _privateConstructorUsedError;
  List<ReminderTime> get reminderTimes => throw _privateConstructorUsedError;
  bool get isOnReminder => throw _privateConstructorUsedError;
  bool get isOnNotifyInNotTakenDuration => throw _privateConstructorUsedError;
  PillSheetAppearanceMode get pillSheetAppearanceMode =>
      throw _privateConstructorUsedError;
  bool get isAutomaticallyCreatePillSheet => throw _privateConstructorUsedError;
  ReminderNotificationCustomization get reminderNotificationCustomization =>
      throw _privateConstructorUsedError;
  String? get timezoneDatabaseName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SettingCopyWith<Setting> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingCopyWith<$Res> {
  factory $SettingCopyWith(Setting value, $Res Function(Setting) then) =
      _$SettingCopyWithImpl<$Res, Setting>;
  @useResult
  $Res call(
      {List<PillSheetType?> pillSheetTypes,
      int pillNumberForFromMenstruation,
      int durationMenstruation,
      List<ReminderTime> reminderTimes,
      bool isOnReminder,
      bool isOnNotifyInNotTakenDuration,
      PillSheetAppearanceMode pillSheetAppearanceMode,
      bool isAutomaticallyCreatePillSheet,
      ReminderNotificationCustomization reminderNotificationCustomization,
      String? timezoneDatabaseName});

  $ReminderNotificationCustomizationCopyWith<$Res>
      get reminderNotificationCustomization;
}

/// @nodoc
class _$SettingCopyWithImpl<$Res, $Val extends Setting>
    implements $SettingCopyWith<$Res> {
  _$SettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pillSheetTypes = null,
    Object? pillNumberForFromMenstruation = null,
    Object? durationMenstruation = null,
    Object? reminderTimes = null,
    Object? isOnReminder = null,
    Object? isOnNotifyInNotTakenDuration = null,
    Object? pillSheetAppearanceMode = null,
    Object? isAutomaticallyCreatePillSheet = null,
    Object? reminderNotificationCustomization = null,
    Object? timezoneDatabaseName = freezed,
  }) {
    return _then(_value.copyWith(
      pillSheetTypes: null == pillSheetTypes
          ? _value.pillSheetTypes
          : pillSheetTypes // ignore: cast_nullable_to_non_nullable
              as List<PillSheetType?>,
      pillNumberForFromMenstruation: null == pillNumberForFromMenstruation
          ? _value.pillNumberForFromMenstruation
          : pillNumberForFromMenstruation // ignore: cast_nullable_to_non_nullable
              as int,
      durationMenstruation: null == durationMenstruation
          ? _value.durationMenstruation
          : durationMenstruation // ignore: cast_nullable_to_non_nullable
              as int,
      reminderTimes: null == reminderTimes
          ? _value.reminderTimes
          : reminderTimes // ignore: cast_nullable_to_non_nullable
              as List<ReminderTime>,
      isOnReminder: null == isOnReminder
          ? _value.isOnReminder
          : isOnReminder // ignore: cast_nullable_to_non_nullable
              as bool,
      isOnNotifyInNotTakenDuration: null == isOnNotifyInNotTakenDuration
          ? _value.isOnNotifyInNotTakenDuration
          : isOnNotifyInNotTakenDuration // ignore: cast_nullable_to_non_nullable
              as bool,
      pillSheetAppearanceMode: null == pillSheetAppearanceMode
          ? _value.pillSheetAppearanceMode
          : pillSheetAppearanceMode // ignore: cast_nullable_to_non_nullable
              as PillSheetAppearanceMode,
      isAutomaticallyCreatePillSheet: null == isAutomaticallyCreatePillSheet
          ? _value.isAutomaticallyCreatePillSheet
          : isAutomaticallyCreatePillSheet // ignore: cast_nullable_to_non_nullable
              as bool,
      reminderNotificationCustomization: null ==
              reminderNotificationCustomization
          ? _value.reminderNotificationCustomization
          : reminderNotificationCustomization // ignore: cast_nullable_to_non_nullable
              as ReminderNotificationCustomization,
      timezoneDatabaseName: freezed == timezoneDatabaseName
          ? _value.timezoneDatabaseName
          : timezoneDatabaseName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ReminderNotificationCustomizationCopyWith<$Res>
      get reminderNotificationCustomization {
    return $ReminderNotificationCustomizationCopyWith<$Res>(
        _value.reminderNotificationCustomization, (value) {
      return _then(
          _value.copyWith(reminderNotificationCustomization: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_SettingCopyWith<$Res> implements $SettingCopyWith<$Res> {
  factory _$$_SettingCopyWith(
          _$_Setting value, $Res Function(_$_Setting) then) =
      __$$_SettingCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<PillSheetType?> pillSheetTypes,
      int pillNumberForFromMenstruation,
      int durationMenstruation,
      List<ReminderTime> reminderTimes,
      bool isOnReminder,
      bool isOnNotifyInNotTakenDuration,
      PillSheetAppearanceMode pillSheetAppearanceMode,
      bool isAutomaticallyCreatePillSheet,
      ReminderNotificationCustomization reminderNotificationCustomization,
      String? timezoneDatabaseName});

  @override
  $ReminderNotificationCustomizationCopyWith<$Res>
      get reminderNotificationCustomization;
}

/// @nodoc
class __$$_SettingCopyWithImpl<$Res>
    extends _$SettingCopyWithImpl<$Res, _$_Setting>
    implements _$$_SettingCopyWith<$Res> {
  __$$_SettingCopyWithImpl(_$_Setting _value, $Res Function(_$_Setting) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pillSheetTypes = null,
    Object? pillNumberForFromMenstruation = null,
    Object? durationMenstruation = null,
    Object? reminderTimes = null,
    Object? isOnReminder = null,
    Object? isOnNotifyInNotTakenDuration = null,
    Object? pillSheetAppearanceMode = null,
    Object? isAutomaticallyCreatePillSheet = null,
    Object? reminderNotificationCustomization = null,
    Object? timezoneDatabaseName = freezed,
  }) {
    return _then(_$_Setting(
      pillSheetTypes: null == pillSheetTypes
          ? _value._pillSheetTypes
          : pillSheetTypes // ignore: cast_nullable_to_non_nullable
              as List<PillSheetType?>,
      pillNumberForFromMenstruation: null == pillNumberForFromMenstruation
          ? _value.pillNumberForFromMenstruation
          : pillNumberForFromMenstruation // ignore: cast_nullable_to_non_nullable
              as int,
      durationMenstruation: null == durationMenstruation
          ? _value.durationMenstruation
          : durationMenstruation // ignore: cast_nullable_to_non_nullable
              as int,
      reminderTimes: null == reminderTimes
          ? _value._reminderTimes
          : reminderTimes // ignore: cast_nullable_to_non_nullable
              as List<ReminderTime>,
      isOnReminder: null == isOnReminder
          ? _value.isOnReminder
          : isOnReminder // ignore: cast_nullable_to_non_nullable
              as bool,
      isOnNotifyInNotTakenDuration: null == isOnNotifyInNotTakenDuration
          ? _value.isOnNotifyInNotTakenDuration
          : isOnNotifyInNotTakenDuration // ignore: cast_nullable_to_non_nullable
              as bool,
      pillSheetAppearanceMode: null == pillSheetAppearanceMode
          ? _value.pillSheetAppearanceMode
          : pillSheetAppearanceMode // ignore: cast_nullable_to_non_nullable
              as PillSheetAppearanceMode,
      isAutomaticallyCreatePillSheet: null == isAutomaticallyCreatePillSheet
          ? _value.isAutomaticallyCreatePillSheet
          : isAutomaticallyCreatePillSheet // ignore: cast_nullable_to_non_nullable
              as bool,
      reminderNotificationCustomization: null ==
              reminderNotificationCustomization
          ? _value.reminderNotificationCustomization
          : reminderNotificationCustomization // ignore: cast_nullable_to_non_nullable
              as ReminderNotificationCustomization,
      timezoneDatabaseName: freezed == timezoneDatabaseName
          ? _value.timezoneDatabaseName
          : timezoneDatabaseName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_Setting extends _Setting with DiagnosticableTreeMixin {
  const _$_Setting(
      {final List<PillSheetType?> pillSheetTypes = const [],
      required this.pillNumberForFromMenstruation,
      required this.durationMenstruation,
      final List<ReminderTime> reminderTimes = const [],
      required this.isOnReminder,
      this.isOnNotifyInNotTakenDuration = true,
      this.pillSheetAppearanceMode = PillSheetAppearanceMode.number,
      this.isAutomaticallyCreatePillSheet = false,
      this.reminderNotificationCustomization =
          const ReminderNotificationCustomization(),
      required this.timezoneDatabaseName})
      : _pillSheetTypes = pillSheetTypes,
        _reminderTimes = reminderTimes,
        super._();

  factory _$_Setting.fromJson(Map<String, dynamic> json) =>
      _$$_SettingFromJson(json);

  final List<PillSheetType?> _pillSheetTypes;
  @override
  @JsonKey()
  List<PillSheetType?> get pillSheetTypes {
    if (_pillSheetTypes is EqualUnmodifiableListView) return _pillSheetTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pillSheetTypes);
  }

  @override
  final int pillNumberForFromMenstruation;
  @override
  final int durationMenstruation;
  final List<ReminderTime> _reminderTimes;
  @override
  @JsonKey()
  List<ReminderTime> get reminderTimes {
    if (_reminderTimes is EqualUnmodifiableListView) return _reminderTimes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reminderTimes);
  }

  @override
  final bool isOnReminder;
  @override
  @JsonKey()
  final bool isOnNotifyInNotTakenDuration;
  @override
  @JsonKey()
  final PillSheetAppearanceMode pillSheetAppearanceMode;
  @override
  @JsonKey()
  final bool isAutomaticallyCreatePillSheet;
  @override
  @JsonKey()
  final ReminderNotificationCustomization reminderNotificationCustomization;
  @override
  final String? timezoneDatabaseName;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Setting(pillSheetTypes: $pillSheetTypes, pillNumberForFromMenstruation: $pillNumberForFromMenstruation, durationMenstruation: $durationMenstruation, reminderTimes: $reminderTimes, isOnReminder: $isOnReminder, isOnNotifyInNotTakenDuration: $isOnNotifyInNotTakenDuration, pillSheetAppearanceMode: $pillSheetAppearanceMode, isAutomaticallyCreatePillSheet: $isAutomaticallyCreatePillSheet, reminderNotificationCustomization: $reminderNotificationCustomization, timezoneDatabaseName: $timezoneDatabaseName)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Setting'))
      ..add(DiagnosticsProperty('pillSheetTypes', pillSheetTypes))
      ..add(DiagnosticsProperty(
          'pillNumberForFromMenstruation', pillNumberForFromMenstruation))
      ..add(DiagnosticsProperty('durationMenstruation', durationMenstruation))
      ..add(DiagnosticsProperty('reminderTimes', reminderTimes))
      ..add(DiagnosticsProperty('isOnReminder', isOnReminder))
      ..add(DiagnosticsProperty(
          'isOnNotifyInNotTakenDuration', isOnNotifyInNotTakenDuration))
      ..add(DiagnosticsProperty(
          'pillSheetAppearanceMode', pillSheetAppearanceMode))
      ..add(DiagnosticsProperty(
          'isAutomaticallyCreatePillSheet', isAutomaticallyCreatePillSheet))
      ..add(DiagnosticsProperty('reminderNotificationCustomization',
          reminderNotificationCustomization))
      ..add(DiagnosticsProperty('timezoneDatabaseName', timezoneDatabaseName));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Setting &&
            const DeepCollectionEquality()
                .equals(other._pillSheetTypes, _pillSheetTypes) &&
            (identical(other.pillNumberForFromMenstruation,
                    pillNumberForFromMenstruation) ||
                other.pillNumberForFromMenstruation ==
                    pillNumberForFromMenstruation) &&
            (identical(other.durationMenstruation, durationMenstruation) ||
                other.durationMenstruation == durationMenstruation) &&
            const DeepCollectionEquality()
                .equals(other._reminderTimes, _reminderTimes) &&
            (identical(other.isOnReminder, isOnReminder) ||
                other.isOnReminder == isOnReminder) &&
            (identical(other.isOnNotifyInNotTakenDuration,
                    isOnNotifyInNotTakenDuration) ||
                other.isOnNotifyInNotTakenDuration ==
                    isOnNotifyInNotTakenDuration) &&
            (identical(
                    other.pillSheetAppearanceMode, pillSheetAppearanceMode) ||
                other.pillSheetAppearanceMode == pillSheetAppearanceMode) &&
            (identical(other.isAutomaticallyCreatePillSheet,
                    isAutomaticallyCreatePillSheet) ||
                other.isAutomaticallyCreatePillSheet ==
                    isAutomaticallyCreatePillSheet) &&
            (identical(other.reminderNotificationCustomization,
                    reminderNotificationCustomization) ||
                other.reminderNotificationCustomization ==
                    reminderNotificationCustomization) &&
            (identical(other.timezoneDatabaseName, timezoneDatabaseName) ||
                other.timezoneDatabaseName == timezoneDatabaseName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_pillSheetTypes),
      pillNumberForFromMenstruation,
      durationMenstruation,
      const DeepCollectionEquality().hash(_reminderTimes),
      isOnReminder,
      isOnNotifyInNotTakenDuration,
      pillSheetAppearanceMode,
      isAutomaticallyCreatePillSheet,
      reminderNotificationCustomization,
      timezoneDatabaseName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SettingCopyWith<_$_Setting> get copyWith =>
      __$$_SettingCopyWithImpl<_$_Setting>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SettingToJson(
      this,
    );
  }
}

abstract class _Setting extends Setting {
  const factory _Setting(
      {final List<PillSheetType?> pillSheetTypes,
      required final int pillNumberForFromMenstruation,
      required final int durationMenstruation,
      final List<ReminderTime> reminderTimes,
      required final bool isOnReminder,
      final bool isOnNotifyInNotTakenDuration,
      final PillSheetAppearanceMode pillSheetAppearanceMode,
      final bool isAutomaticallyCreatePillSheet,
      final ReminderNotificationCustomization reminderNotificationCustomization,
      required final String? timezoneDatabaseName}) = _$_Setting;
  const _Setting._() : super._();

  factory _Setting.fromJson(Map<String, dynamic> json) = _$_Setting.fromJson;

  @override
  List<PillSheetType?> get pillSheetTypes;
  @override
  int get pillNumberForFromMenstruation;
  @override
  int get durationMenstruation;
  @override
  List<ReminderTime> get reminderTimes;
  @override
  bool get isOnReminder;
  @override
  bool get isOnNotifyInNotTakenDuration;
  @override
  PillSheetAppearanceMode get pillSheetAppearanceMode;
  @override
  bool get isAutomaticallyCreatePillSheet;
  @override
  ReminderNotificationCustomization get reminderNotificationCustomization;
  @override
  String? get timezoneDatabaseName;
  @override
  @JsonKey(ignore: true)
  _$$_SettingCopyWith<_$_Setting> get copyWith =>
      throw _privateConstructorUsedError;
}
