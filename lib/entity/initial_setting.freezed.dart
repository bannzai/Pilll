// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'initial_setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$InitialSettingModelTearOff {
  const _$InitialSettingModelTearOff();

  _InitialSettingModel initial(
      {required int fromMenstruation = 23,
      required int durationMenstruation = 4,
      required List<ReminderTime> reminderTimes = const [
        const ReminderTime(hour: 21, minute: 0),
        const ReminderTime(hour: 22, minute: 0)
      ],
      required bool isOnReminder = false,
      int? todayPillNumber,
      PillSheetType? pillSheetType}) {
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
const $InitialSettingModel = _$InitialSettingModelTearOff();

/// @nodoc
mixin _$InitialSettingModel {
  int get fromMenstruation => throw _privateConstructorUsedError;
  int get durationMenstruation => throw _privateConstructorUsedError;
  List<ReminderTime> get reminderTimes => throw _privateConstructorUsedError;
  bool get isOnReminder => throw _privateConstructorUsedError;
  int? get todayPillNumber => throw _privateConstructorUsedError;
  PillSheetType? get pillSheetType => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int fromMenstruation,
            int durationMenstruation,
            List<ReminderTime> reminderTimes,
            bool isOnReminder,
            int? todayPillNumber,
            PillSheetType? pillSheetType)
        initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int fromMenstruation,
            int durationMenstruation,
            List<ReminderTime> reminderTimes,
            bool isOnReminder,
            int? todayPillNumber,
            PillSheetType? pillSheetType)?
        initial,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitialSettingModel value) initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitialSettingModel value)? initial,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $InitialSettingModelCopyWith<InitialSettingModel> get copyWith =>
      throw _privateConstructorUsedError;
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
      int? todayPillNumber,
      PillSheetType? pillSheetType});
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
    Object? fromMenstruation = freezed,
    Object? durationMenstruation = freezed,
    Object? reminderTimes = freezed,
    Object? isOnReminder = freezed,
    Object? todayPillNumber = freezed,
    Object? pillSheetType = freezed,
  }) {
    return _then(_value.copyWith(
      fromMenstruation: fromMenstruation == freezed
          ? _value.fromMenstruation
          : fromMenstruation // ignore: cast_nullable_to_non_nullable
              as int,
      durationMenstruation: durationMenstruation == freezed
          ? _value.durationMenstruation
          : durationMenstruation // ignore: cast_nullable_to_non_nullable
              as int,
      reminderTimes: reminderTimes == freezed
          ? _value.reminderTimes
          : reminderTimes // ignore: cast_nullable_to_non_nullable
              as List<ReminderTime>,
      isOnReminder: isOnReminder == freezed
          ? _value.isOnReminder
          : isOnReminder // ignore: cast_nullable_to_non_nullable
              as bool,
      todayPillNumber: todayPillNumber == freezed
          ? _value.todayPillNumber
          : todayPillNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      pillSheetType: pillSheetType == freezed
          ? _value.pillSheetType
          : pillSheetType // ignore: cast_nullable_to_non_nullable
              as PillSheetType?,
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
      int? todayPillNumber,
      PillSheetType? pillSheetType});
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
    Object? fromMenstruation = freezed,
    Object? durationMenstruation = freezed,
    Object? reminderTimes = freezed,
    Object? isOnReminder = freezed,
    Object? todayPillNumber = freezed,
    Object? pillSheetType = freezed,
  }) {
    return _then(_InitialSettingModel(
      fromMenstruation: fromMenstruation == freezed
          ? _value.fromMenstruation
          : fromMenstruation // ignore: cast_nullable_to_non_nullable
              as int,
      durationMenstruation: durationMenstruation == freezed
          ? _value.durationMenstruation
          : durationMenstruation // ignore: cast_nullable_to_non_nullable
              as int,
      reminderTimes: reminderTimes == freezed
          ? _value.reminderTimes
          : reminderTimes // ignore: cast_nullable_to_non_nullable
              as List<ReminderTime>,
      isOnReminder: isOnReminder == freezed
          ? _value.isOnReminder
          : isOnReminder // ignore: cast_nullable_to_non_nullable
              as bool,
      todayPillNumber: todayPillNumber == freezed
          ? _value.todayPillNumber
          : todayPillNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      pillSheetType: pillSheetType == freezed
          ? _value.pillSheetType
          : pillSheetType // ignore: cast_nullable_to_non_nullable
              as PillSheetType?,
    ));
  }
}

/// @nodoc
class _$_InitialSettingModel extends _InitialSettingModel {
  _$_InitialSettingModel(
      {required this.fromMenstruation = 23,
      required this.durationMenstruation = 4,
      required this.reminderTimes = const [
        const ReminderTime(hour: 21, minute: 0),
        const ReminderTime(hour: 22, minute: 0)
      ],
      required this.isOnReminder = false,
      this.todayPillNumber,
      this.pillSheetType})
      : super._();

  @JsonKey(defaultValue: 23)
  @override
  final int fromMenstruation;
  @JsonKey(defaultValue: 4)
  @override
  final int durationMenstruation;
  @JsonKey(defaultValue: const [
    const ReminderTime(hour: 21, minute: 0),
    const ReminderTime(hour: 22, minute: 0)
  ])
  @override
  final List<ReminderTime> reminderTimes;
  @JsonKey(defaultValue: false)
  @override
  final bool isOnReminder;
  @override
  final int? todayPillNumber;
  @override
  final PillSheetType? pillSheetType;

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

  @JsonKey(ignore: true)
  @override
  _$InitialSettingModelCopyWith<_InitialSettingModel> get copyWith =>
      __$InitialSettingModelCopyWithImpl<_InitialSettingModel>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int fromMenstruation,
            int durationMenstruation,
            List<ReminderTime> reminderTimes,
            bool isOnReminder,
            int? todayPillNumber,
            PillSheetType? pillSheetType)
        initial,
  }) {
    return initial(fromMenstruation, durationMenstruation, reminderTimes,
        isOnReminder, todayPillNumber, pillSheetType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int fromMenstruation,
            int durationMenstruation,
            List<ReminderTime> reminderTimes,
            bool isOnReminder,
            int? todayPillNumber,
            PillSheetType? pillSheetType)?
        initial,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(fromMenstruation, durationMenstruation, reminderTimes,
          isOnReminder, todayPillNumber, pillSheetType);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitialSettingModel value) initial,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitialSettingModel value)? initial,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _InitialSettingModel extends InitialSettingModel {
  factory _InitialSettingModel(
      {required int fromMenstruation,
      required int durationMenstruation,
      required List<ReminderTime> reminderTimes,
      required bool isOnReminder,
      int? todayPillNumber,
      PillSheetType? pillSheetType}) = _$_InitialSettingModel;
  _InitialSettingModel._() : super._();

  @override
  int get fromMenstruation => throw _privateConstructorUsedError;
  @override
  int get durationMenstruation => throw _privateConstructorUsedError;
  @override
  List<ReminderTime> get reminderTimes => throw _privateConstructorUsedError;
  @override
  bool get isOnReminder => throw _privateConstructorUsedError;
  @override
  int? get todayPillNumber => throw _privateConstructorUsedError;
  @override
  PillSheetType? get pillSheetType => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$InitialSettingModelCopyWith<_InitialSettingModel> get copyWith =>
      throw _privateConstructorUsedError;
}
