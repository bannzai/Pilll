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
  /// 時刻の時（24時間形式）
  ///
  /// 0-23の範囲で指定します。
  /// リマインダー通知の生成時刻として使用されます。
  int get hour => throw _privateConstructorUsedError;

  /// 時刻の分
  ///
  /// 0-59の範囲で指定します。
  /// リマインダー通知の生成時刻として使用されます。
  int get minute => throw _privateConstructorUsedError;

  /// Serializes this ReminderTime to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReminderTime
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReminderTimeCopyWith<ReminderTime> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReminderTimeCopyWith<$Res> {
  factory $ReminderTimeCopyWith(ReminderTime value, $Res Function(ReminderTime) then) = _$ReminderTimeCopyWithImpl<$Res, ReminderTime>;
  @useResult
  $Res call({int hour, int minute});
}

/// @nodoc
class _$ReminderTimeCopyWithImpl<$Res, $Val extends ReminderTime> implements $ReminderTimeCopyWith<$Res> {
  _$ReminderTimeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReminderTime
  /// with the given fields replaced by the non-null parameter values.
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
abstract class _$$ReminderTimeImplCopyWith<$Res> implements $ReminderTimeCopyWith<$Res> {
  factory _$$ReminderTimeImplCopyWith(_$ReminderTimeImpl value, $Res Function(_$ReminderTimeImpl) then) = __$$ReminderTimeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int hour, int minute});
}

/// @nodoc
class __$$ReminderTimeImplCopyWithImpl<$Res> extends _$ReminderTimeCopyWithImpl<$Res, _$ReminderTimeImpl>
    implements _$$ReminderTimeImplCopyWith<$Res> {
  __$$ReminderTimeImplCopyWithImpl(_$ReminderTimeImpl _value, $Res Function(_$ReminderTimeImpl) _then) : super(_value, _then);

  /// Create a copy of ReminderTime
  /// with the given fields replaced by the non-null parameter values.
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
  const _$ReminderTimeImpl({required this.hour, required this.minute}) : super._();

  factory _$ReminderTimeImpl.fromJson(Map<String, dynamic> json) => _$$ReminderTimeImplFromJson(json);

  /// 時刻の時（24時間形式）
  ///
  /// 0-23の範囲で指定します。
  /// リマインダー通知の生成時刻として使用されます。
  @override
  final int hour;

  /// 時刻の分
  ///
  /// 0-59の範囲で指定します。
  /// リマインダー通知の生成時刻として使用されます。
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

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, hour, minute);

  /// Create a copy of ReminderTime
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReminderTimeImplCopyWith<_$ReminderTimeImpl> get copyWith => __$$ReminderTimeImplCopyWithImpl<_$ReminderTimeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReminderTimeImplToJson(
      this,
    );
  }
}

abstract class _ReminderTime extends ReminderTime {
  const factory _ReminderTime({required final int hour, required final int minute}) = _$ReminderTimeImpl;
  const _ReminderTime._() : super._();

  factory _ReminderTime.fromJson(Map<String, dynamic> json) = _$ReminderTimeImpl.fromJson;

  /// 時刻の時（24時間形式）
  ///
  /// 0-23の範囲で指定します。
  /// リマインダー通知の生成時刻として使用されます。
  @override
  int get hour;

  /// 時刻の分
  ///
  /// 0-59の範囲で指定します。
  /// リマインダー通知の生成時刻として使用されます。
  @override
  int get minute;

  /// Create a copy of ReminderTime
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReminderTimeImplCopyWith<_$ReminderTimeImpl> get copyWith => throw _privateConstructorUsedError;
}

Setting _$SettingFromJson(Map<String, dynamic> json) {
  return _Setting.fromJson(json);
}

/// @nodoc
mixin _$Setting {
  /// ユーザーが使用するピルシートタイプのリスト
  ///
  /// 複数のピルシートを管理する場合に使用します。
  /// PillSheetTypeのenumで定義された値を格納し、
  /// ピルシートUI表示やサイクル計算に使用されます。
  List<PillSheetType?> get pillSheetTypes => throw _privateConstructorUsedError;

  /// 生理開始からの日数設定
  ///
  /// 生理開始日から何日目でピル服用を開始するかを定義します。
  /// 生理周期計算や次回生理日予測に使用される重要なパラメータです。
  int get pillNumberForFromMenstruation => throw _privateConstructorUsedError;

  /// 生理期間の日数
  ///
  /// ユーザーの平均的な生理期間を日数で定義します。
  /// 生理日記機能や生理予測機能で使用されます。
  int get durationMenstruation => throw _privateConstructorUsedError;

  /// 服用リマインダー時刻のリスト
  ///
  /// ReminderTimeオブジェクトのリストとして格納されます。
  /// 最大3件まで設定可能で、通知スケジューリングに使用されます。
  List<ReminderTime> get reminderTimes => throw _privateConstructorUsedError;

  /// リマインダー通知の有効/無効フラグ
  ///
  /// trueの場合、設定されたreminderTimesに基づいて通知が送信されます。
  /// falseの場合、リマインダー通知は送信されません。
  bool get isOnReminder => throw _privateConstructorUsedError;

  /// 飲み忘れ期間中の通知有効フラグ
  ///
  /// trueの場合、飲み忘れが検出されたときに追加の通知を送信します。
  /// デフォルトはtrueで有効化されています。
  bool get isOnNotifyInNotTakenDuration => throw _privateConstructorUsedError;

  /// ピルシート自動作成機能の有効フラグ
  ///
  /// trueの場合、現在のピルシートが終了したときに
  /// 新しいピルシートを自動的に作成します。デフォルトはfalseです。
  bool get isAutomaticallyCreatePillSheet => throw _privateConstructorUsedError;

  /// リマインダー通知のカスタマイゼーション設定
  ///
  /// 通知タイトル、メッセージ、表示項目などのカスタマイズ設定です。
  /// デフォルトでReminderNotificationCustomizationの初期値が設定されます。
  ReminderNotificationCustomization get reminderNotificationCustomization => throw _privateConstructorUsedError;

  /// 緊急アラート機能の有効フラグ
  ///
  /// trueの場合、重要な通知を緊急アラートとして送信します。
  /// iOSのCritical Alertなど、端末の音量設定を無視した通知に使用されます。
  bool get useCriticalAlert => throw _privateConstructorUsedError;

  /// 緊急アラートの音量レベル
  ///
  /// 0.0-1.0の範囲で緊急アラート時の音量を指定します。
  /// デフォルトは0.5（50%）に設定されています。
  double get criticalAlertVolume => throw _privateConstructorUsedError;

  /// ユーザーのタイムゾーンデータベース名
  ///
  /// timezone パッケージで使用されるタイムゾーン識別子です。
  /// nullの場合は端末のローカルタイムゾーンが使用されます。
  String? get timezoneDatabaseName => throw _privateConstructorUsedError;

  /// Serializes this Setting to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Setting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SettingCopyWith<Setting> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingCopyWith<$Res> {
  factory $SettingCopyWith(Setting value, $Res Function(Setting) then) = _$SettingCopyWithImpl<$Res, Setting>;
  @useResult
  $Res call(
      {List<PillSheetType?> pillSheetTypes,
      int pillNumberForFromMenstruation,
      int durationMenstruation,
      List<ReminderTime> reminderTimes,
      bool isOnReminder,
      bool isOnNotifyInNotTakenDuration,
      bool isAutomaticallyCreatePillSheet,
      ReminderNotificationCustomization reminderNotificationCustomization,
      bool useCriticalAlert,
      double criticalAlertVolume,
      String? timezoneDatabaseName});

  $ReminderNotificationCustomizationCopyWith<$Res> get reminderNotificationCustomization;
}

/// @nodoc
class _$SettingCopyWithImpl<$Res, $Val extends Setting> implements $SettingCopyWith<$Res> {
  _$SettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Setting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pillSheetTypes = null,
    Object? pillNumberForFromMenstruation = null,
    Object? durationMenstruation = null,
    Object? reminderTimes = null,
    Object? isOnReminder = null,
    Object? isOnNotifyInNotTakenDuration = null,
    Object? isAutomaticallyCreatePillSheet = null,
    Object? reminderNotificationCustomization = null,
    Object? useCriticalAlert = null,
    Object? criticalAlertVolume = null,
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
      isAutomaticallyCreatePillSheet: null == isAutomaticallyCreatePillSheet
          ? _value.isAutomaticallyCreatePillSheet
          : isAutomaticallyCreatePillSheet // ignore: cast_nullable_to_non_nullable
              as bool,
      reminderNotificationCustomization: null == reminderNotificationCustomization
          ? _value.reminderNotificationCustomization
          : reminderNotificationCustomization // ignore: cast_nullable_to_non_nullable
              as ReminderNotificationCustomization,
      useCriticalAlert: null == useCriticalAlert
          ? _value.useCriticalAlert
          : useCriticalAlert // ignore: cast_nullable_to_non_nullable
              as bool,
      criticalAlertVolume: null == criticalAlertVolume
          ? _value.criticalAlertVolume
          : criticalAlertVolume // ignore: cast_nullable_to_non_nullable
              as double,
      timezoneDatabaseName: freezed == timezoneDatabaseName
          ? _value.timezoneDatabaseName
          : timezoneDatabaseName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of Setting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReminderNotificationCustomizationCopyWith<$Res> get reminderNotificationCustomization {
    return $ReminderNotificationCustomizationCopyWith<$Res>(_value.reminderNotificationCustomization, (value) {
      return _then(_value.copyWith(reminderNotificationCustomization: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SettingImplCopyWith<$Res> implements $SettingCopyWith<$Res> {
  factory _$$SettingImplCopyWith(_$SettingImpl value, $Res Function(_$SettingImpl) then) = __$$SettingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<PillSheetType?> pillSheetTypes,
      int pillNumberForFromMenstruation,
      int durationMenstruation,
      List<ReminderTime> reminderTimes,
      bool isOnReminder,
      bool isOnNotifyInNotTakenDuration,
      bool isAutomaticallyCreatePillSheet,
      ReminderNotificationCustomization reminderNotificationCustomization,
      bool useCriticalAlert,
      double criticalAlertVolume,
      String? timezoneDatabaseName});

  @override
  $ReminderNotificationCustomizationCopyWith<$Res> get reminderNotificationCustomization;
}

/// @nodoc
class __$$SettingImplCopyWithImpl<$Res> extends _$SettingCopyWithImpl<$Res, _$SettingImpl> implements _$$SettingImplCopyWith<$Res> {
  __$$SettingImplCopyWithImpl(_$SettingImpl _value, $Res Function(_$SettingImpl) _then) : super(_value, _then);

  /// Create a copy of Setting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pillSheetTypes = null,
    Object? pillNumberForFromMenstruation = null,
    Object? durationMenstruation = null,
    Object? reminderTimes = null,
    Object? isOnReminder = null,
    Object? isOnNotifyInNotTakenDuration = null,
    Object? isAutomaticallyCreatePillSheet = null,
    Object? reminderNotificationCustomization = null,
    Object? useCriticalAlert = null,
    Object? criticalAlertVolume = null,
    Object? timezoneDatabaseName = freezed,
  }) {
    return _then(_$SettingImpl(
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
      isAutomaticallyCreatePillSheet: null == isAutomaticallyCreatePillSheet
          ? _value.isAutomaticallyCreatePillSheet
          : isAutomaticallyCreatePillSheet // ignore: cast_nullable_to_non_nullable
              as bool,
      reminderNotificationCustomization: null == reminderNotificationCustomization
          ? _value.reminderNotificationCustomization
          : reminderNotificationCustomization // ignore: cast_nullable_to_non_nullable
              as ReminderNotificationCustomization,
      useCriticalAlert: null == useCriticalAlert
          ? _value.useCriticalAlert
          : useCriticalAlert // ignore: cast_nullable_to_non_nullable
              as bool,
      criticalAlertVolume: null == criticalAlertVolume
          ? _value.criticalAlertVolume
          : criticalAlertVolume // ignore: cast_nullable_to_non_nullable
              as double,
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
      {final List<PillSheetType?> pillSheetTypes = const [],
      required this.pillNumberForFromMenstruation,
      required this.durationMenstruation,
      final List<ReminderTime> reminderTimes = const [],
      required this.isOnReminder,
      this.isOnNotifyInNotTakenDuration = true,
      this.isAutomaticallyCreatePillSheet = false,
      this.reminderNotificationCustomization = const ReminderNotificationCustomization(),
      this.useCriticalAlert = false,
      this.criticalAlertVolume = 0.5,
      required this.timezoneDatabaseName})
      : _pillSheetTypes = pillSheetTypes,
        _reminderTimes = reminderTimes,
        super._();

  factory _$SettingImpl.fromJson(Map<String, dynamic> json) => _$$SettingImplFromJson(json);

  /// ユーザーが使用するピルシートタイプのリスト
  ///
  /// 複数のピルシートを管理する場合に使用します。
  /// PillSheetTypeのenumで定義された値を格納し、
  /// ピルシートUI表示やサイクル計算に使用されます。
  final List<PillSheetType?> _pillSheetTypes;

  /// ユーザーが使用するピルシートタイプのリスト
  ///
  /// 複数のピルシートを管理する場合に使用します。
  /// PillSheetTypeのenumで定義された値を格納し、
  /// ピルシートUI表示やサイクル計算に使用されます。
  @override
  @JsonKey()
  List<PillSheetType?> get pillSheetTypes {
    if (_pillSheetTypes is EqualUnmodifiableListView) return _pillSheetTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pillSheetTypes);
  }

  /// 生理開始からの日数設定
  ///
  /// 生理開始日から何日目でピル服用を開始するかを定義します。
  /// 生理周期計算や次回生理日予測に使用される重要なパラメータです。
  @override
  final int pillNumberForFromMenstruation;

  /// 生理期間の日数
  ///
  /// ユーザーの平均的な生理期間を日数で定義します。
  /// 生理日記機能や生理予測機能で使用されます。
  @override
  final int durationMenstruation;

  /// 服用リマインダー時刻のリスト
  ///
  /// ReminderTimeオブジェクトのリストとして格納されます。
  /// 最大3件まで設定可能で、通知スケジューリングに使用されます。
  final List<ReminderTime> _reminderTimes;

  /// 服用リマインダー時刻のリスト
  ///
  /// ReminderTimeオブジェクトのリストとして格納されます。
  /// 最大3件まで設定可能で、通知スケジューリングに使用されます。
  @override
  @JsonKey()
  List<ReminderTime> get reminderTimes {
    if (_reminderTimes is EqualUnmodifiableListView) return _reminderTimes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reminderTimes);
  }

  /// リマインダー通知の有効/無効フラグ
  ///
  /// trueの場合、設定されたreminderTimesに基づいて通知が送信されます。
  /// falseの場合、リマインダー通知は送信されません。
  @override
  final bool isOnReminder;

  /// 飲み忘れ期間中の通知有効フラグ
  ///
  /// trueの場合、飲み忘れが検出されたときに追加の通知を送信します。
  /// デフォルトはtrueで有効化されています。
  @override
  @JsonKey()
  final bool isOnNotifyInNotTakenDuration;

  /// ピルシート自動作成機能の有効フラグ
  ///
  /// trueの場合、現在のピルシートが終了したときに
  /// 新しいピルシートを自動的に作成します。デフォルトはfalseです。
  @override
  @JsonKey()
  final bool isAutomaticallyCreatePillSheet;

  /// リマインダー通知のカスタマイゼーション設定
  ///
  /// 通知タイトル、メッセージ、表示項目などのカスタマイズ設定です。
  /// デフォルトでReminderNotificationCustomizationの初期値が設定されます。
  @override
  @JsonKey()
  final ReminderNotificationCustomization reminderNotificationCustomization;

  /// 緊急アラート機能の有効フラグ
  ///
  /// trueの場合、重要な通知を緊急アラートとして送信します。
  /// iOSのCritical Alertなど、端末の音量設定を無視した通知に使用されます。
  @override
  @JsonKey()
  final bool useCriticalAlert;

  /// 緊急アラートの音量レベル
  ///
  /// 0.0-1.0の範囲で緊急アラート時の音量を指定します。
  /// デフォルトは0.5（50%）に設定されています。
  @override
  @JsonKey()
  final double criticalAlertVolume;

  /// ユーザーのタイムゾーンデータベース名
  ///
  /// timezone パッケージで使用されるタイムゾーン識別子です。
  /// nullの場合は端末のローカルタイムゾーンが使用されます。
  @override
  final String? timezoneDatabaseName;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Setting(pillSheetTypes: $pillSheetTypes, pillNumberForFromMenstruation: $pillNumberForFromMenstruation, durationMenstruation: $durationMenstruation, reminderTimes: $reminderTimes, isOnReminder: $isOnReminder, isOnNotifyInNotTakenDuration: $isOnNotifyInNotTakenDuration, isAutomaticallyCreatePillSheet: $isAutomaticallyCreatePillSheet, reminderNotificationCustomization: $reminderNotificationCustomization, useCriticalAlert: $useCriticalAlert, criticalAlertVolume: $criticalAlertVolume, timezoneDatabaseName: $timezoneDatabaseName)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Setting'))
      ..add(DiagnosticsProperty('pillSheetTypes', pillSheetTypes))
      ..add(DiagnosticsProperty('pillNumberForFromMenstruation', pillNumberForFromMenstruation))
      ..add(DiagnosticsProperty('durationMenstruation', durationMenstruation))
      ..add(DiagnosticsProperty('reminderTimes', reminderTimes))
      ..add(DiagnosticsProperty('isOnReminder', isOnReminder))
      ..add(DiagnosticsProperty('isOnNotifyInNotTakenDuration', isOnNotifyInNotTakenDuration))
      ..add(DiagnosticsProperty('isAutomaticallyCreatePillSheet', isAutomaticallyCreatePillSheet))
      ..add(DiagnosticsProperty('reminderNotificationCustomization', reminderNotificationCustomization))
      ..add(DiagnosticsProperty('useCriticalAlert', useCriticalAlert))
      ..add(DiagnosticsProperty('criticalAlertVolume', criticalAlertVolume))
      ..add(DiagnosticsProperty('timezoneDatabaseName', timezoneDatabaseName));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingImpl &&
            const DeepCollectionEquality().equals(other._pillSheetTypes, _pillSheetTypes) &&
            (identical(other.pillNumberForFromMenstruation, pillNumberForFromMenstruation) ||
                other.pillNumberForFromMenstruation == pillNumberForFromMenstruation) &&
            (identical(other.durationMenstruation, durationMenstruation) || other.durationMenstruation == durationMenstruation) &&
            const DeepCollectionEquality().equals(other._reminderTimes, _reminderTimes) &&
            (identical(other.isOnReminder, isOnReminder) || other.isOnReminder == isOnReminder) &&
            (identical(other.isOnNotifyInNotTakenDuration, isOnNotifyInNotTakenDuration) ||
                other.isOnNotifyInNotTakenDuration == isOnNotifyInNotTakenDuration) &&
            (identical(other.isAutomaticallyCreatePillSheet, isAutomaticallyCreatePillSheet) ||
                other.isAutomaticallyCreatePillSheet == isAutomaticallyCreatePillSheet) &&
            (identical(other.reminderNotificationCustomization, reminderNotificationCustomization) ||
                other.reminderNotificationCustomization == reminderNotificationCustomization) &&
            (identical(other.useCriticalAlert, useCriticalAlert) || other.useCriticalAlert == useCriticalAlert) &&
            (identical(other.criticalAlertVolume, criticalAlertVolume) || other.criticalAlertVolume == criticalAlertVolume) &&
            (identical(other.timezoneDatabaseName, timezoneDatabaseName) || other.timezoneDatabaseName == timezoneDatabaseName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_pillSheetTypes),
      pillNumberForFromMenstruation,
      durationMenstruation,
      const DeepCollectionEquality().hash(_reminderTimes),
      isOnReminder,
      isOnNotifyInNotTakenDuration,
      isAutomaticallyCreatePillSheet,
      reminderNotificationCustomization,
      useCriticalAlert,
      criticalAlertVolume,
      timezoneDatabaseName);

  /// Create a copy of Setting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingImplCopyWith<_$SettingImpl> get copyWith => __$$SettingImplCopyWithImpl<_$SettingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SettingImplToJson(
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
      final bool isAutomaticallyCreatePillSheet,
      final ReminderNotificationCustomization reminderNotificationCustomization,
      final bool useCriticalAlert,
      final double criticalAlertVolume,
      required final String? timezoneDatabaseName}) = _$SettingImpl;
  const _Setting._() : super._();

  factory _Setting.fromJson(Map<String, dynamic> json) = _$SettingImpl.fromJson;

  /// ユーザーが使用するピルシートタイプのリスト
  ///
  /// 複数のピルシートを管理する場合に使用します。
  /// PillSheetTypeのenumで定義された値を格納し、
  /// ピルシートUI表示やサイクル計算に使用されます。
  @override
  List<PillSheetType?> get pillSheetTypes;

  /// 生理開始からの日数設定
  ///
  /// 生理開始日から何日目でピル服用を開始するかを定義します。
  /// 生理周期計算や次回生理日予測に使用される重要なパラメータです。
  @override
  int get pillNumberForFromMenstruation;

  /// 生理期間の日数
  ///
  /// ユーザーの平均的な生理期間を日数で定義します。
  /// 生理日記機能や生理予測機能で使用されます。
  @override
  int get durationMenstruation;

  /// 服用リマインダー時刻のリスト
  ///
  /// ReminderTimeオブジェクトのリストとして格納されます。
  /// 最大3件まで設定可能で、通知スケジューリングに使用されます。
  @override
  List<ReminderTime> get reminderTimes;

  /// リマインダー通知の有効/無効フラグ
  ///
  /// trueの場合、設定されたreminderTimesに基づいて通知が送信されます。
  /// falseの場合、リマインダー通知は送信されません。
  @override
  bool get isOnReminder;

  /// 飲み忘れ期間中の通知有効フラグ
  ///
  /// trueの場合、飲み忘れが検出されたときに追加の通知を送信します。
  /// デフォルトはtrueで有効化されています。
  @override
  bool get isOnNotifyInNotTakenDuration;

  /// ピルシート自動作成機能の有効フラグ
  ///
  /// trueの場合、現在のピルシートが終了したときに
  /// 新しいピルシートを自動的に作成します。デフォルトはfalseです。
  @override
  bool get isAutomaticallyCreatePillSheet;

  /// リマインダー通知のカスタマイゼーション設定
  ///
  /// 通知タイトル、メッセージ、表示項目などのカスタマイズ設定です。
  /// デフォルトでReminderNotificationCustomizationの初期値が設定されます。
  @override
  ReminderNotificationCustomization get reminderNotificationCustomization;

  /// 緊急アラート機能の有効フラグ
  ///
  /// trueの場合、重要な通知を緊急アラートとして送信します。
  /// iOSのCritical Alertなど、端末の音量設定を無視した通知に使用されます。
  @override
  bool get useCriticalAlert;

  /// 緊急アラートの音量レベル
  ///
  /// 0.0-1.0の範囲で緊急アラート時の音量を指定します。
  /// デフォルトは0.5（50%）に設定されています。
  @override
  double get criticalAlertVolume;

  /// ユーザーのタイムゾーンデータベース名
  ///
  /// timezone パッケージで使用されるタイムゾーン識別子です。
  /// nullの場合は端末のローカルタイムゾーンが使用されます。
  @override
  String? get timezoneDatabaseName;

  /// Create a copy of Setting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SettingImplCopyWith<_$SettingImpl> get copyWith => throw _privateConstructorUsedError;
}
