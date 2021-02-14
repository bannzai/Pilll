// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'initial_setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$InitialSettingModelTearOff {
  const _$InitialSettingModelTearOff();

// ignore: unused_element
  _InitialSettingModel initial(
      {int fromMenstruation = 23,
      int durationMenstruation = 4,
      List<ReminderTime> reminderTimes = const [
        ReminderTime(hour: 21, minute: 0),
        ReminderTime(hour: 22, minute: 0)
      ],
      bool isOnReminder = false,
      int todayPillNumber,
      PillSheetType pillSheetType}) {
    return _InitialSettingModel(
      fromMenstruation: fromMenstruation,
      durationMenstruation: durationMenstruation,
      reminderTimes: reminderTimes,
      isOnReminder: isOnReminder,
      todayPillNumber: todayPillNumber,
      pillSheetType: pillSheetType,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $InitialSettingModel = _$InitialSettingModelTearOff();

/// @nodoc
mixin _$InitialSettingModel {
  int get fromMenstruation;
  int get durationMenstruation;
  List<ReminderTime> get reminderTimes;
  bool get isOnReminder;
  int get todayPillNumber;
  PillSheetType get pillSheetType;

  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required
        TResult initial(
            int fromMenstruation,
            int durationMenstruation,
            List<ReminderTime> reminderTimes,
            bool isOnReminder,
            int todayPillNumber,
            PillSheetType pillSheetType),
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult initial(
        int fromMenstruation,
        int durationMenstruation,
        List<ReminderTime> reminderTimes,
        bool isOnReminder,
        int todayPillNumber,
        PillSheetType pillSheetType),
    @required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult initial(_InitialSettingModel value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(_InitialSettingModel value),
    @required TResult orElse(),
  });

  $InitialSettingModelCopyWith<InitialSettingModel> get copyWith;
}

/// @nodoc
abstract class $InitialSettingModelCopyWith<$Res> {
  factory $InitialSettingModelCopyWith(
          InitialSettingModel value, $Res Function(InitialSettingModel) then) =
      _$InitialSettingModelCopyWithImpl<$Res>;
  $Res call(
      {int fromMenstruation,
      int durationMenstruation,
      List<ReminderTime> reminderTimes,
      bool isOnReminder,
      int todayPillNumber,
      PillSheetType pillSheetType});
}

/// @nodoc
class _$InitialSettingModelCopyWithImpl<$Res>
    implements $InitialSettingModelCopyWith<$Res> {
  _$InitialSettingModelCopyWithImpl(this._value, this._then);

  final InitialSettingModel _value;
  // ignore: unused_field
  final $Res Function(InitialSettingModel) _then;

  @override
  $Res call({
    Object fromMenstruation = freezed,
    Object durationMenstruation = freezed,
    Object reminderTimes = freezed,
    Object isOnReminder = freezed,
    Object todayPillNumber = freezed,
    Object pillSheetType = freezed,
  }) {
    return _then(_value.copyWith(
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
      todayPillNumber: todayPillNumber == freezed
          ? _value.todayPillNumber
          : todayPillNumber as int,
      pillSheetType: pillSheetType == freezed
          ? _value.pillSheetType
          : pillSheetType as PillSheetType,
    ));
  }
}

/// @nodoc
abstract class _$InitialSettingModelCopyWith<$Res>
    implements $InitialSettingModelCopyWith<$Res> {
  factory _$InitialSettingModelCopyWith(_InitialSettingModel value,
          $Res Function(_InitialSettingModel) then) =
      __$InitialSettingModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {int fromMenstruation,
      int durationMenstruation,
      List<ReminderTime> reminderTimes,
      bool isOnReminder,
      int todayPillNumber,
      PillSheetType pillSheetType});
}

/// @nodoc
class __$InitialSettingModelCopyWithImpl<$Res>
    extends _$InitialSettingModelCopyWithImpl<$Res>
    implements _$InitialSettingModelCopyWith<$Res> {
  __$InitialSettingModelCopyWithImpl(
      _InitialSettingModel _value, $Res Function(_InitialSettingModel) _then)
      : super(_value, (v) => _then(v as _InitialSettingModel));

  @override
  _InitialSettingModel get _value => super._value as _InitialSettingModel;

  @override
  $Res call({
    Object fromMenstruation = freezed,
    Object durationMenstruation = freezed,
    Object reminderTimes = freezed,
    Object isOnReminder = freezed,
    Object todayPillNumber = freezed,
    Object pillSheetType = freezed,
  }) {
    return _then(_InitialSettingModel(
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
      todayPillNumber: todayPillNumber == freezed
          ? _value.todayPillNumber
          : todayPillNumber as int,
      pillSheetType: pillSheetType == freezed
          ? _value.pillSheetType
          : pillSheetType as PillSheetType,
    ));
  }
}

/// @nodoc
class _$_InitialSettingModel extends _InitialSettingModel {
  _$_InitialSettingModel(
      {this.fromMenstruation = 23,
      this.durationMenstruation = 4,
      this.reminderTimes = const [
        ReminderTime(hour: 21, minute: 0),
        ReminderTime(hour: 22, minute: 0)
      ],
      this.isOnReminder = false,
      this.todayPillNumber,
      this.pillSheetType})
      : assert(fromMenstruation != null),
        assert(durationMenstruation != null),
        assert(reminderTimes != null),
        assert(isOnReminder != null),
        super._();

  @JsonKey(defaultValue: 23)
  @override
  final int fromMenstruation;
  @JsonKey(defaultValue: 4)
  @override
  final int durationMenstruation;
  @JsonKey(defaultValue: const [
    ReminderTime(hour: 21, minute: 0),
    ReminderTime(hour: 22, minute: 0)
  ])
  @override
  final List<ReminderTime> reminderTimes;
  @JsonKey(defaultValue: false)
  @override
  final bool isOnReminder;
  @override
  final int todayPillNumber;
  @override
  final PillSheetType pillSheetType;

  @override
  String toString() {
    return 'InitialSettingModel.initial(fromMenstruation: $fromMenstruation, durationMenstruation: $durationMenstruation, reminderTimes: $reminderTimes, isOnReminder: $isOnReminder, todayPillNumber: $todayPillNumber, pillSheetType: $pillSheetType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _InitialSettingModel &&
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
                    .equals(other.isOnReminder, isOnReminder)) &&
            (identical(other.todayPillNumber, todayPillNumber) ||
                const DeepCollectionEquality()
                    .equals(other.todayPillNumber, todayPillNumber)) &&
            (identical(other.pillSheetType, pillSheetType) ||
                const DeepCollectionEquality()
                    .equals(other.pillSheetType, pillSheetType)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(fromMenstruation) ^
      const DeepCollectionEquality().hash(durationMenstruation) ^
      const DeepCollectionEquality().hash(reminderTimes) ^
      const DeepCollectionEquality().hash(isOnReminder) ^
      const DeepCollectionEquality().hash(todayPillNumber) ^
      const DeepCollectionEquality().hash(pillSheetType);

  @override
  _$InitialSettingModelCopyWith<_InitialSettingModel> get copyWith =>
      __$InitialSettingModelCopyWithImpl<_InitialSettingModel>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required
        TResult initial(
            int fromMenstruation,
            int durationMenstruation,
            List<ReminderTime> reminderTimes,
            bool isOnReminder,
            int todayPillNumber,
            PillSheetType pillSheetType),
  }) {
    assert(initial != null);
    return initial(fromMenstruation, durationMenstruation, reminderTimes,
        isOnReminder, todayPillNumber, pillSheetType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult initial(
        int fromMenstruation,
        int durationMenstruation,
        List<ReminderTime> reminderTimes,
        bool isOnReminder,
        int todayPillNumber,
        PillSheetType pillSheetType),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (initial != null) {
      return initial(fromMenstruation, durationMenstruation, reminderTimes,
          isOnReminder, todayPillNumber, pillSheetType);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult initial(_InitialSettingModel value),
  }) {
    assert(initial != null);
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(_InitialSettingModel value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _InitialSettingModel extends InitialSettingModel {
  _InitialSettingModel._() : super._();
  factory _InitialSettingModel(
      {int fromMenstruation,
      int durationMenstruation,
      List<ReminderTime> reminderTimes,
      bool isOnReminder,
      int todayPillNumber,
      PillSheetType pillSheetType}) = _$_InitialSettingModel;

  @override
  int get fromMenstruation;
  @override
  int get durationMenstruation;
  @override
  List<ReminderTime> get reminderTimes;
  @override
  bool get isOnReminder;
  @override
  int get todayPillNumber;
  @override
  PillSheetType get pillSheetType;
  @override
  _$InitialSettingModelCopyWith<_InitialSettingModel> get copyWith;
}
