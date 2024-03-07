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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

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
abstract class _$$ReminderTimeImplCopyWith<$Res>
    implements $ReminderTimeCopyWith<$Res> {
  factory _$$ReminderTimeImplCopyWith(
          _$ReminderTimeImpl value, $Res Function(_$ReminderTimeImpl) then) =
      __$$ReminderTimeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int hour, int minute});
}

/// @nodoc
class __$$ReminderTimeImplCopyWithImpl<$Res>
    extends _$ReminderTimeCopyWithImpl<$Res, _$ReminderTimeImpl>
    implements _$$ReminderTimeImplCopyWith<$Res> {
  __$$ReminderTimeImplCopyWithImpl(
      _$ReminderTimeImpl _value, $Res Function(_$ReminderTimeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hour = null,
    Object? minute = null,
  }) {
    return _then(_$ReminderTimeImpl(
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
class _$ReminderTimeImpl extends _ReminderTime with DiagnosticableTreeMixin {
  const _$ReminderTimeImpl({required this.hour, required this.minute})
      : super._();

  factory _$ReminderTimeImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReminderTimeImplFromJson(json);

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
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReminderTimeImpl &&
            (identical(other.hour, hour) || other.hour == hour) &&
            (identical(other.minute, minute) || other.minute == minute));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, hour, minute);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReminderTimeImplCopyWith<_$ReminderTimeImpl> get copyWith =>
      __$$ReminderTimeImplCopyWithImpl<_$ReminderTimeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReminderTimeImplToJson(
      this,
    );
  }
}

abstract class _ReminderTime extends ReminderTime {
  const factory _ReminderTime(
      {required final int hour,
      required final int minute}) = _$ReminderTimeImpl;
  const _ReminderTime._() : super._();

  factory _ReminderTime.fromJson(Map<String, dynamic> json) =
      _$ReminderTimeImpl.fromJson;

  @override
  int get hour;
  @override
  int get minute;
  @override
  @JsonKey(ignore: true)
  _$$ReminderTimeImplCopyWith<_$ReminderTimeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Setting _$SettingFromJson(Map<String, dynamic> json) {
  return _Setting.fromJson(json);
}

/// @nodoc
mixin _$Setting {
  List<PillSheetTypeInfo?> get pillSheetTypeInfos =>
      throw _privateConstructorUsedError;
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
      {List<PillSheetTypeInfo?> pillSheetTypeInfos,
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
    Object? pillSheetTypeInfos = null,
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
      pillSheetTypeInfos: null == pillSheetTypeInfos
          ? _value.pillSheetTypeInfos
          : pillSheetTypeInfos // ignore: cast_nullable_to_non_nullable
              as List<PillSheetTypeInfo?>,
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
abstract class _$$SettingImplCopyWith<$Res> implements $SettingCopyWith<$Res> {
  factory _$$SettingImplCopyWith(
          _$SettingImpl value, $Res Function(_$SettingImpl) then) =
      __$$SettingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<PillSheetTypeInfo?> pillSheetTypeInfos,
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
class __$$SettingImplCopyWithImpl<$Res>
    extends _$SettingCopyWithImpl<$Res, _$SettingImpl>
    implements _$$SettingImplCopyWith<$Res> {
  __$$SettingImplCopyWithImpl(
      _$SettingImpl _value, $Res Function(_$SettingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pillSheetTypeInfos = null,
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
    return _then(_$SettingImpl(
      pillSheetTypeInfos: null == pillSheetTypeInfos
          ? _value._pillSheetTypeInfos
          : pillSheetTypeInfos // ignore: cast_nullable_to_non_nullable
              as List<PillSheetTypeInfo?>,
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
class _$SettingImpl extends _Setting with DiagnosticableTreeMixin {
  const _$SettingImpl(
      {final List<PillSheetTypeInfo?> pillSheetTypeInfos = const [],
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
      : _pillSheetTypeInfos = pillSheetTypeInfos,
        _reminderTimes = reminderTimes,
        super._();

  factory _$SettingImpl.fromJson(Map<String, dynamic> json) =>
      _$$SettingImplFromJson(json);

  final List<PillSheetTypeInfo?> _pillSheetTypeInfos;
  @override
  @JsonKey()
  List<PillSheetTypeInfo?> get pillSheetTypeInfos {
    if (_pillSheetTypeInfos is EqualUnmodifiableListView)
      return _pillSheetTypeInfos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pillSheetTypeInfos);
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
    return 'Setting(pillSheetTypeInfos: $pillSheetTypeInfos, pillNumberForFromMenstruation: $pillNumberForFromMenstruation, durationMenstruation: $durationMenstruation, reminderTimes: $reminderTimes, isOnReminder: $isOnReminder, isOnNotifyInNotTakenDuration: $isOnNotifyInNotTakenDuration, pillSheetAppearanceMode: $pillSheetAppearanceMode, isAutomaticallyCreatePillSheet: $isAutomaticallyCreatePillSheet, reminderNotificationCustomization: $reminderNotificationCustomization, timezoneDatabaseName: $timezoneDatabaseName)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Setting'))
      ..add(DiagnosticsProperty('pillSheetTypeInfos', pillSheetTypeInfos))
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
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingImpl &&
            const DeepCollectionEquality()
                .equals(other._pillSheetTypeInfos, _pillSheetTypeInfos) &&
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
      const DeepCollectionEquality().hash(_pillSheetTypeInfos),
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
  _$$SettingImplCopyWith<_$SettingImpl> get copyWith =>
      __$$SettingImplCopyWithImpl<_$SettingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SettingImplToJson(
      this,
    );
  }
}

abstract class _Setting extends Setting {
  const factory _Setting(
      {final List<PillSheetTypeInfo?> pillSheetTypeInfos,
      required final int pillNumberForFromMenstruation,
      required final int durationMenstruation,
      final List<ReminderTime> reminderTimes,
      required final bool isOnReminder,
      final bool isOnNotifyInNotTakenDuration,
      final PillSheetAppearanceMode pillSheetAppearanceMode,
      final bool isAutomaticallyCreatePillSheet,
      final ReminderNotificationCustomization reminderNotificationCustomization,
      required final String? timezoneDatabaseName}) = _$SettingImpl;
  const _Setting._() : super._();

  factory _Setting.fromJson(Map<String, dynamic> json) = _$SettingImpl.fromJson;

  @override
  List<PillSheetTypeInfo?> get pillSheetTypeInfos;
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
  _$$SettingImplCopyWith<_$SettingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
