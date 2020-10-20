// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
ReminderTime _$ReminderTimeFromJson(Map<String, dynamic> json) {
  return _ReminderTime.fromJson(json);
}

/// @nodoc
class _$ReminderTimeTearOff {
  const _$ReminderTimeTearOff();

// ignore: unused_element
  _ReminderTime call({@required int hour, @required int minute}) {
    return _ReminderTime(
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
abstract class _$ReminderTimeCopyWith<$Res>
    implements $ReminderTimeCopyWith<$Res> {
  factory _$ReminderTimeCopyWith(
          _ReminderTime value, $Res Function(_ReminderTime) then) =
      __$ReminderTimeCopyWithImpl<$Res>;
  @override
  $Res call({int hour, int minute});
}

/// @nodoc
class __$ReminderTimeCopyWithImpl<$Res> extends _$ReminderTimeCopyWithImpl<$Res>
    implements _$ReminderTimeCopyWith<$Res> {
  __$ReminderTimeCopyWithImpl(
      _ReminderTime _value, $Res Function(_ReminderTime) _then)
      : super(_value, (v) => _then(v as _ReminderTime));

  @override
  _ReminderTime get _value => super._value as _ReminderTime;

  @override
  $Res call({
    Object hour = freezed,
    Object minute = freezed,
  }) {
    return _then(_ReminderTime(
      hour: hour == freezed ? _value.hour : hour as int,
      minute: minute == freezed ? _value.minute : minute as int,
    ));
  }
}

@JsonSerializable(explicitToJson: true)

/// @nodoc
class _$_ReminderTime with DiagnosticableTreeMixin implements _ReminderTime {
  _$_ReminderTime({@required this.hour, @required this.minute})
      : assert(hour != null),
        assert(minute != null);

  factory _$_ReminderTime.fromJson(Map<String, dynamic> json) =>
      _$_$_ReminderTimeFromJson(json);

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
        (other is _ReminderTime &&
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
  _$ReminderTimeCopyWith<_ReminderTime> get copyWith =>
      __$ReminderTimeCopyWithImpl<_ReminderTime>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ReminderTimeToJson(this);
  }
}

abstract class _ReminderTime implements ReminderTime {
  factory _ReminderTime({@required int hour, @required int minute}) =
      _$_ReminderTime;

  factory _ReminderTime.fromJson(Map<String, dynamic> json) =
      _$_ReminderTime.fromJson;

  @override
  int get hour;
  @override
  int get minute;
  @override
  _$ReminderTimeCopyWith<_ReminderTime> get copyWith;
}

Setting _$SettingFromJson(Map<String, dynamic> json) {
  return _Setting.fromJson(json);
}

/// @nodoc
class _$SettingTearOff {
  const _$SettingTearOff();

// ignore: unused_element
  _Setting call(
      {@required String pillSheetTypeRawPath,
      @required int fromMenstruation,
      @required int durationMenstruation,
      @required List<ReminderTime> reminderTimes,
      @required @JsonSerializable(explicitToJson: true) bool isOnReminder}) {
    return _Setting(
      pillSheetTypeRawPath: pillSheetTypeRawPath,
      fromMenstruation: fromMenstruation,
      durationMenstruation: durationMenstruation,
      reminderTimes: reminderTimes,
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
  String get pillSheetTypeRawPath;
  int get fromMenstruation;
  int get durationMenstruation;
  List<ReminderTime> get reminderTimes;
  @JsonSerializable(explicitToJson: true)
  bool get isOnReminder;

  Map<String, dynamic> toJson();
  $SettingCopyWith<Setting> get copyWith;
}

/// @nodoc
abstract class $SettingCopyWith<$Res> {
  factory $SettingCopyWith(Setting value, $Res Function(Setting) then) =
      _$SettingCopyWithImpl<$Res>;
  $Res call(
      {String pillSheetTypeRawPath,
      int fromMenstruation,
      int durationMenstruation,
      List<ReminderTime> reminderTimes,
      @JsonSerializable(explicitToJson: true) bool isOnReminder});
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
    Object reminderTimes = freezed,
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
      reminderTimes: reminderTimes == freezed
          ? _value.reminderTimes
          : reminderTimes as List<ReminderTime>,
      isOnReminder:
          isOnReminder == freezed ? _value.isOnReminder : isOnReminder as bool,
    ));
  }
}

/// @nodoc
abstract class _$SettingCopyWith<$Res> implements $SettingCopyWith<$Res> {
  factory _$SettingCopyWith(_Setting value, $Res Function(_Setting) then) =
      __$SettingCopyWithImpl<$Res>;
  @override
  $Res call(
      {String pillSheetTypeRawPath,
      int fromMenstruation,
      int durationMenstruation,
      List<ReminderTime> reminderTimes,
      @JsonSerializable(explicitToJson: true) bool isOnReminder});
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
    Object reminderTimes = freezed,
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
      reminderTimes: reminderTimes == freezed
          ? _value.reminderTimes
          : reminderTimes as List<ReminderTime>,
      isOnReminder:
          isOnReminder == freezed ? _value.isOnReminder : isOnReminder as bool,
    ));
  }
}

@JsonSerializable(explicitToJson: true)

/// @nodoc
class _$_Setting extends _Setting with DiagnosticableTreeMixin {
  _$_Setting(
      {@required this.pillSheetTypeRawPath,
      @required this.fromMenstruation,
      @required this.durationMenstruation,
      @required this.reminderTimes,
      @required @JsonSerializable(explicitToJson: true) this.isOnReminder})
      : assert(pillSheetTypeRawPath != null),
        assert(fromMenstruation != null),
        assert(durationMenstruation != null),
        assert(reminderTimes != null),
        assert(isOnReminder != null),
        super._();

  factory _$_Setting.fromJson(Map<String, dynamic> json) =>
      _$_$_SettingFromJson(json);

  @override
  final String pillSheetTypeRawPath;
  @override
  final int fromMenstruation;
  @override
  final int durationMenstruation;
  @override
  final List<ReminderTime> reminderTimes;
  @override
  @JsonSerializable(explicitToJson: true)
  final bool isOnReminder;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Setting(pillSheetTypeRawPath: $pillSheetTypeRawPath, fromMenstruation: $fromMenstruation, durationMenstruation: $durationMenstruation, reminderTimes: $reminderTimes, isOnReminder: $isOnReminder)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Setting'))
      ..add(DiagnosticsProperty('pillSheetTypeRawPath', pillSheetTypeRawPath))
      ..add(DiagnosticsProperty('fromMenstruation', fromMenstruation))
      ..add(DiagnosticsProperty('durationMenstruation', durationMenstruation))
      ..add(DiagnosticsProperty('reminderTimes', reminderTimes))
      ..add(DiagnosticsProperty('isOnReminder', isOnReminder));
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
            (identical(other.reminderTimes, reminderTimes) ||
                const DeepCollectionEquality()
                    .equals(other.reminderTimes, reminderTimes)) &&
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
      const DeepCollectionEquality().hash(reminderTimes) ^
      const DeepCollectionEquality().hash(isOnReminder);

  @override
  _$SettingCopyWith<_Setting> get copyWith =>
      __$SettingCopyWithImpl<_Setting>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_SettingToJson(this);
  }
}

abstract class _Setting extends Setting {
  _Setting._() : super._();
  factory _Setting(
      {@required
          String pillSheetTypeRawPath,
      @required
          int fromMenstruation,
      @required
          int durationMenstruation,
      @required
          List<ReminderTime> reminderTimes,
      @required
      @JsonSerializable(explicitToJson: true)
          bool isOnReminder}) = _$_Setting;

  factory _Setting.fromJson(Map<String, dynamic> json) = _$_Setting.fromJson;

  @override
  String get pillSheetTypeRawPath;
  @override
  int get fromMenstruation;
  @override
  int get durationMenstruation;
  @override
  List<ReminderTime> get reminderTimes;
  @override
  @JsonSerializable(explicitToJson: true)
  bool get isOnReminder;
  @override
  _$SettingCopyWith<_Setting> get copyWith;
}
