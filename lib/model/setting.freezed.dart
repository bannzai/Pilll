// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
ReminderTime _$ReminderTimeFromJson(Map<String, dynamic> json) {
  return _Reminder.fromJson(json);
}

/// @nodoc
class _$ReminderTimeTearOff {
  const _$ReminderTimeTearOff();

// ignore: unused_element
  _Reminder call({@required int hour, @required int minute}) {
    return _Reminder(
      hour: hour,
      minute: minute,
    );
  }

// ignore: unused_element
  ReminderTime fromJson(Map<String, Object> json) {
    return ReminderTime.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $ReminderTime = _$ReminderTimeTearOff();

/// @nodoc
mixin _$ReminderTime {
  int get hour;
  int get minute;

  Map<String, dynamic> toJson();
  $ReminderTimeCopyWith<ReminderTime> get copyWith;
}

/// @nodoc
abstract class $ReminderTimeCopyWith<$Res> {
  factory $ReminderTimeCopyWith(
          ReminderTime value, $Res Function(ReminderTime) then) =
      _$ReminderTimeCopyWithImpl<$Res>;
  $Res call({int hour, int minute});
}

/// @nodoc
class _$ReminderTimeCopyWithImpl<$Res> implements $ReminderTimeCopyWith<$Res> {
  _$ReminderTimeCopyWithImpl(this._value, this._then);

  final ReminderTime _value;
  // ignore: unused_field
  final $Res Function(ReminderTime) _then;

  @override
  $Res call({
    Object hour = freezed,
    Object minute = freezed,
  }) {
    return _then(_value.copyWith(
      hour: hour == freezed ? _value.hour : hour as int,
      minute: minute == freezed ? _value.minute : minute as int,
    ));
  }
}

/// @nodoc
abstract class _$ReminderCopyWith<$Res> implements $ReminderTimeCopyWith<$Res> {
  factory _$ReminderCopyWith(_Reminder value, $Res Function(_Reminder) then) =
      __$ReminderCopyWithImpl<$Res>;
  @override
  $Res call({int hour, int minute});
}

/// @nodoc
class __$ReminderCopyWithImpl<$Res> extends _$ReminderTimeCopyWithImpl<$Res>
    implements _$ReminderCopyWith<$Res> {
  __$ReminderCopyWithImpl(_Reminder _value, $Res Function(_Reminder) _then)
      : super(_value, (v) => _then(v as _Reminder));

  @override
  _Reminder get _value => super._value as _Reminder;

  @override
  $Res call({
    Object hour = freezed,
    Object minute = freezed,
  }) {
    return _then(_Reminder(
      hour: hour == freezed ? _value.hour : hour as int,
      minute: minute == freezed ? _value.minute : minute as int,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_Reminder with DiagnosticableTreeMixin implements _Reminder {
  _$_Reminder({@required this.hour, @required this.minute})
      : assert(hour != null),
        assert(minute != null);

  factory _$_Reminder.fromJson(Map<String, dynamic> json) =>
      _$_$_ReminderFromJson(json);

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
        (other is _Reminder &&
            (identical(other.hour, hour) ||
                const DeepCollectionEquality().equals(other.hour, hour)) &&
            (identical(other.minute, minute) ||
                const DeepCollectionEquality().equals(other.minute, minute)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(hour) ^
      const DeepCollectionEquality().hash(minute);

  @override
  _$ReminderCopyWith<_Reminder> get copyWith =>
      __$ReminderCopyWithImpl<_Reminder>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ReminderToJson(this);
  }
}

abstract class _Reminder implements ReminderTime {
  factory _Reminder({@required int hour, @required int minute}) = _$_Reminder;

  factory _Reminder.fromJson(Map<String, dynamic> json) = _$_Reminder.fromJson;

  @override
  int get hour;
  @override
  int get minute;
  @override
  _$ReminderCopyWith<_Reminder> get copyWith;
}

Setting _$SettingFromJson(Map<String, dynamic> json) {
  return _Setting.fromJson(json);
}

/// @nodoc
class _$SettingTearOff {
  const _$SettingTearOff();

// ignore: unused_element
  _Setting call(
      {@required @nullable String pillSheetTypeRawPath,
      @required @nullable int fromMenstruation,
      @required @nullable int durationMenstruation,
      @required @nullable ReminderTime reminderTime,
      bool isOnReminder = false}) {
    return _Setting(
      pillSheetTypeRawPath: pillSheetTypeRawPath,
      fromMenstruation: fromMenstruation,
      durationMenstruation: durationMenstruation,
      reminderTime: reminderTime,
      isOnReminder: isOnReminder,
    );
  }

// ignore: unused_element
  Setting fromJson(Map<String, Object> json) {
    return Setting.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $Setting = _$SettingTearOff();

/// @nodoc
mixin _$Setting {
  @nullable
  String get pillSheetTypeRawPath;
  @nullable
  int get fromMenstruation;
  @nullable
  int get durationMenstruation;
  @nullable
  ReminderTime get reminderTime;
  bool get isOnReminder;

  Map<String, dynamic> toJson();
  $SettingCopyWith<Setting> get copyWith;
}

/// @nodoc
abstract class $SettingCopyWith<$Res> {
  factory $SettingCopyWith(Setting value, $Res Function(Setting) then) =
      _$SettingCopyWithImpl<$Res>;
  $Res call(
      {@nullable String pillSheetTypeRawPath,
      @nullable int fromMenstruation,
      @nullable int durationMenstruation,
      @nullable ReminderTime reminderTime,
      bool isOnReminder});

  $ReminderTimeCopyWith<$Res> get reminderTime;
}

/// @nodoc
class _$SettingCopyWithImpl<$Res> implements $SettingCopyWith<$Res> {
  _$SettingCopyWithImpl(this._value, this._then);

  final Setting _value;
  // ignore: unused_field
  final $Res Function(Setting) _then;

  @override
  $Res call({
    Object pillSheetTypeRawPath = freezed,
    Object fromMenstruation = freezed,
    Object durationMenstruation = freezed,
    Object reminderTime = freezed,
    Object isOnReminder = freezed,
  }) {
    return _then(_value.copyWith(
      pillSheetTypeRawPath: pillSheetTypeRawPath == freezed
          ? _value.pillSheetTypeRawPath
          : pillSheetTypeRawPath as String,
      fromMenstruation: fromMenstruation == freezed
          ? _value.fromMenstruation
          : fromMenstruation as int,
      durationMenstruation: durationMenstruation == freezed
          ? _value.durationMenstruation
          : durationMenstruation as int,
      reminderTime: reminderTime == freezed
          ? _value.reminderTime
          : reminderTime as ReminderTime,
      isOnReminder:
          isOnReminder == freezed ? _value.isOnReminder : isOnReminder as bool,
    ));
  }

  @override
  $ReminderTimeCopyWith<$Res> get reminderTime {
    if (_value.reminderTime == null) {
      return null;
    }
    return $ReminderTimeCopyWith<$Res>(_value.reminderTime, (value) {
      return _then(_value.copyWith(reminderTime: value));
    });
  }
}

/// @nodoc
abstract class _$SettingCopyWith<$Res> implements $SettingCopyWith<$Res> {
  factory _$SettingCopyWith(_Setting value, $Res Function(_Setting) then) =
      __$SettingCopyWithImpl<$Res>;
  @override
  $Res call(
      {@nullable String pillSheetTypeRawPath,
      @nullable int fromMenstruation,
      @nullable int durationMenstruation,
      @nullable ReminderTime reminderTime,
      bool isOnReminder});

  @override
  $ReminderTimeCopyWith<$Res> get reminderTime;
}

/// @nodoc
class __$SettingCopyWithImpl<$Res> extends _$SettingCopyWithImpl<$Res>
    implements _$SettingCopyWith<$Res> {
  __$SettingCopyWithImpl(_Setting _value, $Res Function(_Setting) _then)
      : super(_value, (v) => _then(v as _Setting));

  @override
  _Setting get _value => super._value as _Setting;

  @override
  $Res call({
    Object pillSheetTypeRawPath = freezed,
    Object fromMenstruation = freezed,
    Object durationMenstruation = freezed,
    Object reminderTime = freezed,
    Object isOnReminder = freezed,
  }) {
    return _then(_Setting(
      pillSheetTypeRawPath: pillSheetTypeRawPath == freezed
          ? _value.pillSheetTypeRawPath
          : pillSheetTypeRawPath as String,
      fromMenstruation: fromMenstruation == freezed
          ? _value.fromMenstruation
          : fromMenstruation as int,
      durationMenstruation: durationMenstruation == freezed
          ? _value.durationMenstruation
          : durationMenstruation as int,
      reminderTime: reminderTime == freezed
          ? _value.reminderTime
          : reminderTime as ReminderTime,
      isOnReminder:
          isOnReminder == freezed ? _value.isOnReminder : isOnReminder as bool,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_Setting with DiagnosticableTreeMixin implements _Setting {
  _$_Setting(
      {@required @nullable this.pillSheetTypeRawPath,
      @required @nullable this.fromMenstruation,
      @required @nullable this.durationMenstruation,
      @required @nullable this.reminderTime,
      this.isOnReminder = false})
      : assert(isOnReminder != null);

  factory _$_Setting.fromJson(Map<String, dynamic> json) =>
      _$_$_SettingFromJson(json);

  @override
  @nullable
  final String pillSheetTypeRawPath;
  @override
  @nullable
  final int fromMenstruation;
  @override
  @nullable
  final int durationMenstruation;
  @override
  @nullable
  final ReminderTime reminderTime;
  @JsonKey(defaultValue: false)
  @override
  final bool isOnReminder;

  bool _didpillSheetType = false;
  PillSheetType _pillSheetType;

  @override
  PillSheetType get pillSheetType {
    if (_didpillSheetType == false) {
      _didpillSheetType = true;
      _pillSheetType = PillSheetTypeFunctions.fromRawPath(pillSheetTypeRawPath);
    }
    return _pillSheetType;
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Setting(pillSheetTypeRawPath: $pillSheetTypeRawPath, fromMenstruation: $fromMenstruation, durationMenstruation: $durationMenstruation, reminderTime: $reminderTime, isOnReminder: $isOnReminder, pillSheetType: $pillSheetType)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Setting'))
      ..add(DiagnosticsProperty('pillSheetTypeRawPath', pillSheetTypeRawPath))
      ..add(DiagnosticsProperty('fromMenstruation', fromMenstruation))
      ..add(DiagnosticsProperty('durationMenstruation', durationMenstruation))
      ..add(DiagnosticsProperty('reminderTime', reminderTime))
      ..add(DiagnosticsProperty('isOnReminder', isOnReminder))
      ..add(DiagnosticsProperty('pillSheetType', pillSheetType));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Setting &&
            (identical(other.pillSheetTypeRawPath, pillSheetTypeRawPath) ||
                const DeepCollectionEquality().equals(
                    other.pillSheetTypeRawPath, pillSheetTypeRawPath)) &&
            (identical(other.fromMenstruation, fromMenstruation) ||
                const DeepCollectionEquality()
                    .equals(other.fromMenstruation, fromMenstruation)) &&
            (identical(other.durationMenstruation, durationMenstruation) ||
                const DeepCollectionEquality().equals(
                    other.durationMenstruation, durationMenstruation)) &&
            (identical(other.reminderTime, reminderTime) ||
                const DeepCollectionEquality()
                    .equals(other.reminderTime, reminderTime)) &&
            (identical(other.isOnReminder, isOnReminder) ||
                const DeepCollectionEquality()
                    .equals(other.isOnReminder, isOnReminder)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(pillSheetTypeRawPath) ^
      const DeepCollectionEquality().hash(fromMenstruation) ^
      const DeepCollectionEquality().hash(durationMenstruation) ^
      const DeepCollectionEquality().hash(reminderTime) ^
      const DeepCollectionEquality().hash(isOnReminder);

  @override
  _$SettingCopyWith<_Setting> get copyWith =>
      __$SettingCopyWithImpl<_Setting>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_SettingToJson(this);
  }
}

abstract class _Setting implements Setting {
  factory _Setting(
      {@required @nullable String pillSheetTypeRawPath,
      @required @nullable int fromMenstruation,
      @required @nullable int durationMenstruation,
      @required @nullable ReminderTime reminderTime,
      bool isOnReminder}) = _$_Setting;

  factory _Setting.fromJson(Map<String, dynamic> json) = _$_Setting.fromJson;

  @override
  @nullable
  String get pillSheetTypeRawPath;
  @override
  @nullable
  int get fromMenstruation;
  @override
  @nullable
  int get durationMenstruation;
  @override
  @nullable
  ReminderTime get reminderTime;
  @override
  bool get isOnReminder;
  @override
  _$SettingCopyWith<_Setting> get copyWith;
}
