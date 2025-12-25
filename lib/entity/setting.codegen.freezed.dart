// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'setting.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReminderTime implements DiagnosticableTreeMixin {

/// 時刻の時（24時間形式）
///
/// 0-23の範囲で指定します。
/// リマインダー通知の生成時刻として使用されます。
 int get hour;/// 時刻の分
///
/// 0-59の範囲で指定します。
/// リマインダー通知の生成時刻として使用されます。
 int get minute;
/// Create a copy of ReminderTime
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReminderTimeCopyWith<ReminderTime> get copyWith => _$ReminderTimeCopyWithImpl<ReminderTime>(this as ReminderTime, _$identity);

  /// Serializes this ReminderTime to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ReminderTime'))
    ..add(DiagnosticsProperty('hour', hour))..add(DiagnosticsProperty('minute', minute));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReminderTime&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.minute, minute) || other.minute == minute));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hour,minute);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ReminderTime(hour: $hour, minute: $minute)';
}


}

/// @nodoc
abstract mixin class $ReminderTimeCopyWith<$Res>  {
  factory $ReminderTimeCopyWith(ReminderTime value, $Res Function(ReminderTime) _then) = _$ReminderTimeCopyWithImpl;
@useResult
$Res call({
 int hour, int minute
});




}
/// @nodoc
class _$ReminderTimeCopyWithImpl<$Res>
    implements $ReminderTimeCopyWith<$Res> {
  _$ReminderTimeCopyWithImpl(this._self, this._then);

  final ReminderTime _self;
  final $Res Function(ReminderTime) _then;

/// Create a copy of ReminderTime
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hour = null,Object? minute = null,}) {
  return _then(_self.copyWith(
hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,minute: null == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReminderTime].
extension ReminderTimePatterns on ReminderTime {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReminderTime value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReminderTime() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReminderTime value)  $default,){
final _that = this;
switch (_that) {
case _ReminderTime():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReminderTime value)?  $default,){
final _that = this;
switch (_that) {
case _ReminderTime() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int hour,  int minute)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReminderTime() when $default != null:
return $default(_that.hour,_that.minute);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int hour,  int minute)  $default,) {final _that = this;
switch (_that) {
case _ReminderTime():
return $default(_that.hour,_that.minute);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int hour,  int minute)?  $default,) {final _that = this;
switch (_that) {
case _ReminderTime() when $default != null:
return $default(_that.hour,_that.minute);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ReminderTime extends ReminderTime with DiagnosticableTreeMixin {
  const _ReminderTime({required this.hour, required this.minute}): super._();
  factory _ReminderTime.fromJson(Map<String, dynamic> json) => _$ReminderTimeFromJson(json);

/// 時刻の時（24時間形式）
///
/// 0-23の範囲で指定します。
/// リマインダー通知の生成時刻として使用されます。
@override final  int hour;
/// 時刻の分
///
/// 0-59の範囲で指定します。
/// リマインダー通知の生成時刻として使用されます。
@override final  int minute;

/// Create a copy of ReminderTime
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReminderTimeCopyWith<_ReminderTime> get copyWith => __$ReminderTimeCopyWithImpl<_ReminderTime>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReminderTimeToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ReminderTime'))
    ..add(DiagnosticsProperty('hour', hour))..add(DiagnosticsProperty('minute', minute));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReminderTime&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.minute, minute) || other.minute == minute));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hour,minute);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ReminderTime(hour: $hour, minute: $minute)';
}


}

/// @nodoc
abstract mixin class _$ReminderTimeCopyWith<$Res> implements $ReminderTimeCopyWith<$Res> {
  factory _$ReminderTimeCopyWith(_ReminderTime value, $Res Function(_ReminderTime) _then) = __$ReminderTimeCopyWithImpl;
@override @useResult
$Res call({
 int hour, int minute
});




}
/// @nodoc
class __$ReminderTimeCopyWithImpl<$Res>
    implements _$ReminderTimeCopyWith<$Res> {
  __$ReminderTimeCopyWithImpl(this._self, this._then);

  final _ReminderTime _self;
  final $Res Function(_ReminderTime) _then;

/// Create a copy of ReminderTime
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hour = null,Object? minute = null,}) {
  return _then(_ReminderTime(
hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,minute: null == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Setting implements DiagnosticableTreeMixin {

/// ユーザーが使用するピルシートタイプのリスト
///
/// 複数のピルシートを管理する場合に使用します。
/// PillSheetTypeのenumで定義された値を格納し、
/// ピルシートUI表示やサイクル計算に使用されます。
 List<PillSheetType?> get pillSheetTypes;/// 生理開始からの日数設定
///
/// 生理開始日から何日目でピル服用を開始するかを定義します。
/// 生理周期計算や次回生理日予測に使用される重要なパラメータです。
 int get pillNumberForFromMenstruation;/// 生理期間の日数
///
/// ユーザーの平均的な生理期間を日数で定義します。
/// 生理日記機能や生理予測機能で使用されます。
 int get durationMenstruation;/// 服用リマインダー時刻のリスト
///
/// ReminderTimeオブジェクトのリストとして格納されます。
/// 最大3件まで設定可能で、通知スケジューリングに使用されます。
 List<ReminderTime> get reminderTimes;/// リマインダー通知の有効/無効フラグ
///
/// trueの場合、設定されたreminderTimesに基づいて通知が送信されます。
/// falseの場合、リマインダー通知は送信されません。
 bool get isOnReminder;/// 飲み忘れ期間中の通知有効フラグ
///
/// trueの場合、飲み忘れが検出されたときに追加の通知を送信します。
/// デフォルトはtrueで有効化されています。
 bool get isOnNotifyInNotTakenDuration;/// ピルシート自動作成機能の有効フラグ
///
/// trueの場合、現在のピルシートが終了したときに
/// 新しいピルシートを自動的に作成します。デフォルトはfalseです。
 bool get isAutomaticallyCreatePillSheet;/// リマインダー通知のカスタマイゼーション設定
///
/// 通知タイトル、メッセージ、表示項目などのカスタマイズ設定です。
/// デフォルトでReminderNotificationCustomizationの初期値が設定されます。
 ReminderNotificationCustomization get reminderNotificationCustomization;/// 緊急アラート機能の有効フラグ
///
/// trueの場合、重要な通知を緊急アラートとして送信します。
/// iOSのCritical Alertなど、端末の音量設定を無視した通知に使用されます。
 bool get useCriticalAlert;/// 緊急アラートの音量レベル
///
/// 0.0-1.0の範囲で緊急アラート時の音量を指定します。
/// デフォルトは0.5（50%）に設定されています。
 double get criticalAlertVolume;/// AlarmKit機能の有効フラグ
///
/// trueの場合、iOS 26+でAlarmKitを使用して服薬リマインダーを送信します。
/// サイレントモード・フォーカスモード時でも確実に通知が表示されます。
/// iOS 26未満やAndroidでは既存のlocal notificationが使用されます。
 bool get useAlarmKit;/// ユーザーのタイムゾーンデータベース名
///
/// timezone パッケージで使用されるタイムゾーン識別子です。
/// nullの場合は端末のローカルタイムゾーンが使用されます。
 String? get timezoneDatabaseName;
/// Create a copy of Setting
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingCopyWith<Setting> get copyWith => _$SettingCopyWithImpl<Setting>(this as Setting, _$identity);

  /// Serializes this Setting to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Setting'))
    ..add(DiagnosticsProperty('pillSheetTypes', pillSheetTypes))..add(DiagnosticsProperty('pillNumberForFromMenstruation', pillNumberForFromMenstruation))..add(DiagnosticsProperty('durationMenstruation', durationMenstruation))..add(DiagnosticsProperty('reminderTimes', reminderTimes))..add(DiagnosticsProperty('isOnReminder', isOnReminder))..add(DiagnosticsProperty('isOnNotifyInNotTakenDuration', isOnNotifyInNotTakenDuration))..add(DiagnosticsProperty('isAutomaticallyCreatePillSheet', isAutomaticallyCreatePillSheet))..add(DiagnosticsProperty('reminderNotificationCustomization', reminderNotificationCustomization))..add(DiagnosticsProperty('useCriticalAlert', useCriticalAlert))..add(DiagnosticsProperty('criticalAlertVolume', criticalAlertVolume))..add(DiagnosticsProperty('useAlarmKit', useAlarmKit))..add(DiagnosticsProperty('timezoneDatabaseName', timezoneDatabaseName));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Setting&&const DeepCollectionEquality().equals(other.pillSheetTypes, pillSheetTypes)&&(identical(other.pillNumberForFromMenstruation, pillNumberForFromMenstruation) || other.pillNumberForFromMenstruation == pillNumberForFromMenstruation)&&(identical(other.durationMenstruation, durationMenstruation) || other.durationMenstruation == durationMenstruation)&&const DeepCollectionEquality().equals(other.reminderTimes, reminderTimes)&&(identical(other.isOnReminder, isOnReminder) || other.isOnReminder == isOnReminder)&&(identical(other.isOnNotifyInNotTakenDuration, isOnNotifyInNotTakenDuration) || other.isOnNotifyInNotTakenDuration == isOnNotifyInNotTakenDuration)&&(identical(other.isAutomaticallyCreatePillSheet, isAutomaticallyCreatePillSheet) || other.isAutomaticallyCreatePillSheet == isAutomaticallyCreatePillSheet)&&(identical(other.reminderNotificationCustomization, reminderNotificationCustomization) || other.reminderNotificationCustomization == reminderNotificationCustomization)&&(identical(other.useCriticalAlert, useCriticalAlert) || other.useCriticalAlert == useCriticalAlert)&&(identical(other.criticalAlertVolume, criticalAlertVolume) || other.criticalAlertVolume == criticalAlertVolume)&&(identical(other.useAlarmKit, useAlarmKit) || other.useAlarmKit == useAlarmKit)&&(identical(other.timezoneDatabaseName, timezoneDatabaseName) || other.timezoneDatabaseName == timezoneDatabaseName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(pillSheetTypes),pillNumberForFromMenstruation,durationMenstruation,const DeepCollectionEquality().hash(reminderTimes),isOnReminder,isOnNotifyInNotTakenDuration,isAutomaticallyCreatePillSheet,reminderNotificationCustomization,useCriticalAlert,criticalAlertVolume,useAlarmKit,timezoneDatabaseName);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Setting(pillSheetTypes: $pillSheetTypes, pillNumberForFromMenstruation: $pillNumberForFromMenstruation, durationMenstruation: $durationMenstruation, reminderTimes: $reminderTimes, isOnReminder: $isOnReminder, isOnNotifyInNotTakenDuration: $isOnNotifyInNotTakenDuration, isAutomaticallyCreatePillSheet: $isAutomaticallyCreatePillSheet, reminderNotificationCustomization: $reminderNotificationCustomization, useCriticalAlert: $useCriticalAlert, criticalAlertVolume: $criticalAlertVolume, useAlarmKit: $useAlarmKit, timezoneDatabaseName: $timezoneDatabaseName)';
}


}

/// @nodoc
abstract mixin class $SettingCopyWith<$Res>  {
  factory $SettingCopyWith(Setting value, $Res Function(Setting) _then) = _$SettingCopyWithImpl;
@useResult
$Res call({
 List<PillSheetType?> pillSheetTypes, int pillNumberForFromMenstruation, int durationMenstruation, List<ReminderTime> reminderTimes, bool isOnReminder, bool isOnNotifyInNotTakenDuration, bool isAutomaticallyCreatePillSheet, ReminderNotificationCustomization reminderNotificationCustomization, bool useCriticalAlert, double criticalAlertVolume, bool useAlarmKit, String? timezoneDatabaseName
});


$ReminderNotificationCustomizationCopyWith<$Res> get reminderNotificationCustomization;

}
/// @nodoc
class _$SettingCopyWithImpl<$Res>
    implements $SettingCopyWith<$Res> {
  _$SettingCopyWithImpl(this._self, this._then);

  final Setting _self;
  final $Res Function(Setting) _then;

/// Create a copy of Setting
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pillSheetTypes = null,Object? pillNumberForFromMenstruation = null,Object? durationMenstruation = null,Object? reminderTimes = null,Object? isOnReminder = null,Object? isOnNotifyInNotTakenDuration = null,Object? isAutomaticallyCreatePillSheet = null,Object? reminderNotificationCustomization = null,Object? useCriticalAlert = null,Object? criticalAlertVolume = null,Object? useAlarmKit = null,Object? timezoneDatabaseName = freezed,}) {
  return _then(_self.copyWith(
pillSheetTypes: null == pillSheetTypes ? _self.pillSheetTypes : pillSheetTypes // ignore: cast_nullable_to_non_nullable
as List<PillSheetType?>,pillNumberForFromMenstruation: null == pillNumberForFromMenstruation ? _self.pillNumberForFromMenstruation : pillNumberForFromMenstruation // ignore: cast_nullable_to_non_nullable
as int,durationMenstruation: null == durationMenstruation ? _self.durationMenstruation : durationMenstruation // ignore: cast_nullable_to_non_nullable
as int,reminderTimes: null == reminderTimes ? _self.reminderTimes : reminderTimes // ignore: cast_nullable_to_non_nullable
as List<ReminderTime>,isOnReminder: null == isOnReminder ? _self.isOnReminder : isOnReminder // ignore: cast_nullable_to_non_nullable
as bool,isOnNotifyInNotTakenDuration: null == isOnNotifyInNotTakenDuration ? _self.isOnNotifyInNotTakenDuration : isOnNotifyInNotTakenDuration // ignore: cast_nullable_to_non_nullable
as bool,isAutomaticallyCreatePillSheet: null == isAutomaticallyCreatePillSheet ? _self.isAutomaticallyCreatePillSheet : isAutomaticallyCreatePillSheet // ignore: cast_nullable_to_non_nullable
as bool,reminderNotificationCustomization: null == reminderNotificationCustomization ? _self.reminderNotificationCustomization : reminderNotificationCustomization // ignore: cast_nullable_to_non_nullable
as ReminderNotificationCustomization,useCriticalAlert: null == useCriticalAlert ? _self.useCriticalAlert : useCriticalAlert // ignore: cast_nullable_to_non_nullable
as bool,criticalAlertVolume: null == criticalAlertVolume ? _self.criticalAlertVolume : criticalAlertVolume // ignore: cast_nullable_to_non_nullable
as double,useAlarmKit: null == useAlarmKit ? _self.useAlarmKit : useAlarmKit // ignore: cast_nullable_to_non_nullable
as bool,timezoneDatabaseName: freezed == timezoneDatabaseName ? _self.timezoneDatabaseName : timezoneDatabaseName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of Setting
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReminderNotificationCustomizationCopyWith<$Res> get reminderNotificationCustomization {
  
  return $ReminderNotificationCustomizationCopyWith<$Res>(_self.reminderNotificationCustomization, (value) {
    return _then(_self.copyWith(reminderNotificationCustomization: value));
  });
}
}


/// Adds pattern-matching-related methods to [Setting].
extension SettingPatterns on Setting {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Setting value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Setting() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Setting value)  $default,){
final _that = this;
switch (_that) {
case _Setting():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Setting value)?  $default,){
final _that = this;
switch (_that) {
case _Setting() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PillSheetType?> pillSheetTypes,  int pillNumberForFromMenstruation,  int durationMenstruation,  List<ReminderTime> reminderTimes,  bool isOnReminder,  bool isOnNotifyInNotTakenDuration,  bool isAutomaticallyCreatePillSheet,  ReminderNotificationCustomization reminderNotificationCustomization,  bool useCriticalAlert,  double criticalAlertVolume,  bool useAlarmKit,  String? timezoneDatabaseName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Setting() when $default != null:
return $default(_that.pillSheetTypes,_that.pillNumberForFromMenstruation,_that.durationMenstruation,_that.reminderTimes,_that.isOnReminder,_that.isOnNotifyInNotTakenDuration,_that.isAutomaticallyCreatePillSheet,_that.reminderNotificationCustomization,_that.useCriticalAlert,_that.criticalAlertVolume,_that.useAlarmKit,_that.timezoneDatabaseName);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PillSheetType?> pillSheetTypes,  int pillNumberForFromMenstruation,  int durationMenstruation,  List<ReminderTime> reminderTimes,  bool isOnReminder,  bool isOnNotifyInNotTakenDuration,  bool isAutomaticallyCreatePillSheet,  ReminderNotificationCustomization reminderNotificationCustomization,  bool useCriticalAlert,  double criticalAlertVolume,  bool useAlarmKit,  String? timezoneDatabaseName)  $default,) {final _that = this;
switch (_that) {
case _Setting():
return $default(_that.pillSheetTypes,_that.pillNumberForFromMenstruation,_that.durationMenstruation,_that.reminderTimes,_that.isOnReminder,_that.isOnNotifyInNotTakenDuration,_that.isAutomaticallyCreatePillSheet,_that.reminderNotificationCustomization,_that.useCriticalAlert,_that.criticalAlertVolume,_that.useAlarmKit,_that.timezoneDatabaseName);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PillSheetType?> pillSheetTypes,  int pillNumberForFromMenstruation,  int durationMenstruation,  List<ReminderTime> reminderTimes,  bool isOnReminder,  bool isOnNotifyInNotTakenDuration,  bool isAutomaticallyCreatePillSheet,  ReminderNotificationCustomization reminderNotificationCustomization,  bool useCriticalAlert,  double criticalAlertVolume,  bool useAlarmKit,  String? timezoneDatabaseName)?  $default,) {final _that = this;
switch (_that) {
case _Setting() when $default != null:
return $default(_that.pillSheetTypes,_that.pillNumberForFromMenstruation,_that.durationMenstruation,_that.reminderTimes,_that.isOnReminder,_that.isOnNotifyInNotTakenDuration,_that.isAutomaticallyCreatePillSheet,_that.reminderNotificationCustomization,_that.useCriticalAlert,_that.criticalAlertVolume,_that.useAlarmKit,_that.timezoneDatabaseName);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Setting extends Setting with DiagnosticableTreeMixin {
  const _Setting({final  List<PillSheetType?> pillSheetTypes = const [], required this.pillNumberForFromMenstruation, required this.durationMenstruation, final  List<ReminderTime> reminderTimes = const [], required this.isOnReminder, this.isOnNotifyInNotTakenDuration = true, this.isAutomaticallyCreatePillSheet = false, this.reminderNotificationCustomization = const ReminderNotificationCustomization(), this.useCriticalAlert = false, this.criticalAlertVolume = 0.5, this.useAlarmKit = false, required this.timezoneDatabaseName}): _pillSheetTypes = pillSheetTypes,_reminderTimes = reminderTimes,super._();
  factory _Setting.fromJson(Map<String, dynamic> json) => _$SettingFromJson(json);

/// ユーザーが使用するピルシートタイプのリスト
///
/// 複数のピルシートを管理する場合に使用します。
/// PillSheetTypeのenumで定義された値を格納し、
/// ピルシートUI表示やサイクル計算に使用されます。
 final  List<PillSheetType?> _pillSheetTypes;
/// ユーザーが使用するピルシートタイプのリスト
///
/// 複数のピルシートを管理する場合に使用します。
/// PillSheetTypeのenumで定義された値を格納し、
/// ピルシートUI表示やサイクル計算に使用されます。
@override@JsonKey() List<PillSheetType?> get pillSheetTypes {
  if (_pillSheetTypes is EqualUnmodifiableListView) return _pillSheetTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pillSheetTypes);
}

/// 生理開始からの日数設定
///
/// 生理開始日から何日目でピル服用を開始するかを定義します。
/// 生理周期計算や次回生理日予測に使用される重要なパラメータです。
@override final  int pillNumberForFromMenstruation;
/// 生理期間の日数
///
/// ユーザーの平均的な生理期間を日数で定義します。
/// 生理日記機能や生理予測機能で使用されます。
@override final  int durationMenstruation;
/// 服用リマインダー時刻のリスト
///
/// ReminderTimeオブジェクトのリストとして格納されます。
/// 最大3件まで設定可能で、通知スケジューリングに使用されます。
 final  List<ReminderTime> _reminderTimes;
/// 服用リマインダー時刻のリスト
///
/// ReminderTimeオブジェクトのリストとして格納されます。
/// 最大3件まで設定可能で、通知スケジューリングに使用されます。
@override@JsonKey() List<ReminderTime> get reminderTimes {
  if (_reminderTimes is EqualUnmodifiableListView) return _reminderTimes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reminderTimes);
}

/// リマインダー通知の有効/無効フラグ
///
/// trueの場合、設定されたreminderTimesに基づいて通知が送信されます。
/// falseの場合、リマインダー通知は送信されません。
@override final  bool isOnReminder;
/// 飲み忘れ期間中の通知有効フラグ
///
/// trueの場合、飲み忘れが検出されたときに追加の通知を送信します。
/// デフォルトはtrueで有効化されています。
@override@JsonKey() final  bool isOnNotifyInNotTakenDuration;
/// ピルシート自動作成機能の有効フラグ
///
/// trueの場合、現在のピルシートが終了したときに
/// 新しいピルシートを自動的に作成します。デフォルトはfalseです。
@override@JsonKey() final  bool isAutomaticallyCreatePillSheet;
/// リマインダー通知のカスタマイゼーション設定
///
/// 通知タイトル、メッセージ、表示項目などのカスタマイズ設定です。
/// デフォルトでReminderNotificationCustomizationの初期値が設定されます。
@override@JsonKey() final  ReminderNotificationCustomization reminderNotificationCustomization;
/// 緊急アラート機能の有効フラグ
///
/// trueの場合、重要な通知を緊急アラートとして送信します。
/// iOSのCritical Alertなど、端末の音量設定を無視した通知に使用されます。
@override@JsonKey() final  bool useCriticalAlert;
/// 緊急アラートの音量レベル
///
/// 0.0-1.0の範囲で緊急アラート時の音量を指定します。
/// デフォルトは0.5（50%）に設定されています。
@override@JsonKey() final  double criticalAlertVolume;
/// AlarmKit機能の有効フラグ
///
/// trueの場合、iOS 26+でAlarmKitを使用して服薬リマインダーを送信します。
/// サイレントモード・フォーカスモード時でも確実に通知が表示されます。
/// iOS 26未満やAndroidでは既存のlocal notificationが使用されます。
@override@JsonKey() final  bool useAlarmKit;
/// ユーザーのタイムゾーンデータベース名
///
/// timezone パッケージで使用されるタイムゾーン識別子です。
/// nullの場合は端末のローカルタイムゾーンが使用されます。
@override final  String? timezoneDatabaseName;

/// Create a copy of Setting
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingCopyWith<_Setting> get copyWith => __$SettingCopyWithImpl<_Setting>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SettingToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Setting'))
    ..add(DiagnosticsProperty('pillSheetTypes', pillSheetTypes))..add(DiagnosticsProperty('pillNumberForFromMenstruation', pillNumberForFromMenstruation))..add(DiagnosticsProperty('durationMenstruation', durationMenstruation))..add(DiagnosticsProperty('reminderTimes', reminderTimes))..add(DiagnosticsProperty('isOnReminder', isOnReminder))..add(DiagnosticsProperty('isOnNotifyInNotTakenDuration', isOnNotifyInNotTakenDuration))..add(DiagnosticsProperty('isAutomaticallyCreatePillSheet', isAutomaticallyCreatePillSheet))..add(DiagnosticsProperty('reminderNotificationCustomization', reminderNotificationCustomization))..add(DiagnosticsProperty('useCriticalAlert', useCriticalAlert))..add(DiagnosticsProperty('criticalAlertVolume', criticalAlertVolume))..add(DiagnosticsProperty('useAlarmKit', useAlarmKit))..add(DiagnosticsProperty('timezoneDatabaseName', timezoneDatabaseName));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Setting&&const DeepCollectionEquality().equals(other._pillSheetTypes, _pillSheetTypes)&&(identical(other.pillNumberForFromMenstruation, pillNumberForFromMenstruation) || other.pillNumberForFromMenstruation == pillNumberForFromMenstruation)&&(identical(other.durationMenstruation, durationMenstruation) || other.durationMenstruation == durationMenstruation)&&const DeepCollectionEquality().equals(other._reminderTimes, _reminderTimes)&&(identical(other.isOnReminder, isOnReminder) || other.isOnReminder == isOnReminder)&&(identical(other.isOnNotifyInNotTakenDuration, isOnNotifyInNotTakenDuration) || other.isOnNotifyInNotTakenDuration == isOnNotifyInNotTakenDuration)&&(identical(other.isAutomaticallyCreatePillSheet, isAutomaticallyCreatePillSheet) || other.isAutomaticallyCreatePillSheet == isAutomaticallyCreatePillSheet)&&(identical(other.reminderNotificationCustomization, reminderNotificationCustomization) || other.reminderNotificationCustomization == reminderNotificationCustomization)&&(identical(other.useCriticalAlert, useCriticalAlert) || other.useCriticalAlert == useCriticalAlert)&&(identical(other.criticalAlertVolume, criticalAlertVolume) || other.criticalAlertVolume == criticalAlertVolume)&&(identical(other.useAlarmKit, useAlarmKit) || other.useAlarmKit == useAlarmKit)&&(identical(other.timezoneDatabaseName, timezoneDatabaseName) || other.timezoneDatabaseName == timezoneDatabaseName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_pillSheetTypes),pillNumberForFromMenstruation,durationMenstruation,const DeepCollectionEquality().hash(_reminderTimes),isOnReminder,isOnNotifyInNotTakenDuration,isAutomaticallyCreatePillSheet,reminderNotificationCustomization,useCriticalAlert,criticalAlertVolume,useAlarmKit,timezoneDatabaseName);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Setting(pillSheetTypes: $pillSheetTypes, pillNumberForFromMenstruation: $pillNumberForFromMenstruation, durationMenstruation: $durationMenstruation, reminderTimes: $reminderTimes, isOnReminder: $isOnReminder, isOnNotifyInNotTakenDuration: $isOnNotifyInNotTakenDuration, isAutomaticallyCreatePillSheet: $isAutomaticallyCreatePillSheet, reminderNotificationCustomization: $reminderNotificationCustomization, useCriticalAlert: $useCriticalAlert, criticalAlertVolume: $criticalAlertVolume, useAlarmKit: $useAlarmKit, timezoneDatabaseName: $timezoneDatabaseName)';
}


}

/// @nodoc
abstract mixin class _$SettingCopyWith<$Res> implements $SettingCopyWith<$Res> {
  factory _$SettingCopyWith(_Setting value, $Res Function(_Setting) _then) = __$SettingCopyWithImpl;
@override @useResult
$Res call({
 List<PillSheetType?> pillSheetTypes, int pillNumberForFromMenstruation, int durationMenstruation, List<ReminderTime> reminderTimes, bool isOnReminder, bool isOnNotifyInNotTakenDuration, bool isAutomaticallyCreatePillSheet, ReminderNotificationCustomization reminderNotificationCustomization, bool useCriticalAlert, double criticalAlertVolume, bool useAlarmKit, String? timezoneDatabaseName
});


@override $ReminderNotificationCustomizationCopyWith<$Res> get reminderNotificationCustomization;

}
/// @nodoc
class __$SettingCopyWithImpl<$Res>
    implements _$SettingCopyWith<$Res> {
  __$SettingCopyWithImpl(this._self, this._then);

  final _Setting _self;
  final $Res Function(_Setting) _then;

/// Create a copy of Setting
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pillSheetTypes = null,Object? pillNumberForFromMenstruation = null,Object? durationMenstruation = null,Object? reminderTimes = null,Object? isOnReminder = null,Object? isOnNotifyInNotTakenDuration = null,Object? isAutomaticallyCreatePillSheet = null,Object? reminderNotificationCustomization = null,Object? useCriticalAlert = null,Object? criticalAlertVolume = null,Object? useAlarmKit = null,Object? timezoneDatabaseName = freezed,}) {
  return _then(_Setting(
pillSheetTypes: null == pillSheetTypes ? _self._pillSheetTypes : pillSheetTypes // ignore: cast_nullable_to_non_nullable
as List<PillSheetType?>,pillNumberForFromMenstruation: null == pillNumberForFromMenstruation ? _self.pillNumberForFromMenstruation : pillNumberForFromMenstruation // ignore: cast_nullable_to_non_nullable
as int,durationMenstruation: null == durationMenstruation ? _self.durationMenstruation : durationMenstruation // ignore: cast_nullable_to_non_nullable
as int,reminderTimes: null == reminderTimes ? _self._reminderTimes : reminderTimes // ignore: cast_nullable_to_non_nullable
as List<ReminderTime>,isOnReminder: null == isOnReminder ? _self.isOnReminder : isOnReminder // ignore: cast_nullable_to_non_nullable
as bool,isOnNotifyInNotTakenDuration: null == isOnNotifyInNotTakenDuration ? _self.isOnNotifyInNotTakenDuration : isOnNotifyInNotTakenDuration // ignore: cast_nullable_to_non_nullable
as bool,isAutomaticallyCreatePillSheet: null == isAutomaticallyCreatePillSheet ? _self.isAutomaticallyCreatePillSheet : isAutomaticallyCreatePillSheet // ignore: cast_nullable_to_non_nullable
as bool,reminderNotificationCustomization: null == reminderNotificationCustomization ? _self.reminderNotificationCustomization : reminderNotificationCustomization // ignore: cast_nullable_to_non_nullable
as ReminderNotificationCustomization,useCriticalAlert: null == useCriticalAlert ? _self.useCriticalAlert : useCriticalAlert // ignore: cast_nullable_to_non_nullable
as bool,criticalAlertVolume: null == criticalAlertVolume ? _self.criticalAlertVolume : criticalAlertVolume // ignore: cast_nullable_to_non_nullable
as double,useAlarmKit: null == useAlarmKit ? _self.useAlarmKit : useAlarmKit // ignore: cast_nullable_to_non_nullable
as bool,timezoneDatabaseName: freezed == timezoneDatabaseName ? _self.timezoneDatabaseName : timezoneDatabaseName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Setting
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReminderNotificationCustomizationCopyWith<$Res> get reminderNotificationCustomization {
  
  return $ReminderNotificationCustomizationCopyWith<$Res>(_self.reminderNotificationCustomization, (value) {
    return _then(_self.copyWith(reminderNotificationCustomization: value));
  });
}
}

// dart format on
