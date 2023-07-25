// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'initial_setting_state.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$InitialSettingTodayPillNumber {
  int get pageIndex => throw _privateConstructorUsedError;
  int get pillNumberInPillSheet => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $InitialSettingTodayPillNumberCopyWith<InitialSettingTodayPillNumber>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InitialSettingTodayPillNumberCopyWith<$Res> {
  factory $InitialSettingTodayPillNumberCopyWith(
          InitialSettingTodayPillNumber value,
          $Res Function(InitialSettingTodayPillNumber) then) =
      _$InitialSettingTodayPillNumberCopyWithImpl<$Res,
          InitialSettingTodayPillNumber>;
  @useResult
  $Res call({int pageIndex, int pillNumberInPillSheet});
}

/// @nodoc
class _$InitialSettingTodayPillNumberCopyWithImpl<$Res,
        $Val extends InitialSettingTodayPillNumber>
    implements $InitialSettingTodayPillNumberCopyWith<$Res> {
  _$InitialSettingTodayPillNumberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pageIndex = null,
    Object? pillNumberInPillSheet = null,
  }) {
    return _then(_value.copyWith(
      pageIndex: null == pageIndex
          ? _value.pageIndex
          : pageIndex // ignore: cast_nullable_to_non_nullable
              as int,
      pillNumberInPillSheet: null == pillNumberInPillSheet
          ? _value.pillNumberInPillSheet
          : pillNumberInPillSheet // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_InitialSettingTodayPillNumberCopyWith<$Res>
    implements $InitialSettingTodayPillNumberCopyWith<$Res> {
  factory _$$_InitialSettingTodayPillNumberCopyWith(
          _$_InitialSettingTodayPillNumber value,
          $Res Function(_$_InitialSettingTodayPillNumber) then) =
      __$$_InitialSettingTodayPillNumberCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int pageIndex, int pillNumberInPillSheet});
}

/// @nodoc
class __$$_InitialSettingTodayPillNumberCopyWithImpl<$Res>
    extends _$InitialSettingTodayPillNumberCopyWithImpl<$Res,
        _$_InitialSettingTodayPillNumber>
    implements _$$_InitialSettingTodayPillNumberCopyWith<$Res> {
  __$$_InitialSettingTodayPillNumberCopyWithImpl(
      _$_InitialSettingTodayPillNumber _value,
      $Res Function(_$_InitialSettingTodayPillNumber) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pageIndex = null,
    Object? pillNumberInPillSheet = null,
  }) {
    return _then(_$_InitialSettingTodayPillNumber(
      pageIndex: null == pageIndex
          ? _value.pageIndex
          : pageIndex // ignore: cast_nullable_to_non_nullable
              as int,
      pillNumberInPillSheet: null == pillNumberInPillSheet
          ? _value.pillNumberInPillSheet
          : pillNumberInPillSheet // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_InitialSettingTodayPillNumber
    implements _InitialSettingTodayPillNumber {
  const _$_InitialSettingTodayPillNumber(
      {this.pageIndex = 0, this.pillNumberInPillSheet = 0});

  @override
  @JsonKey()
  final int pageIndex;
  @override
  @JsonKey()
  final int pillNumberInPillSheet;

  @override
  String toString() {
    return 'InitialSettingTodayPillNumber(pageIndex: $pageIndex, pillNumberInPillSheet: $pillNumberInPillSheet)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_InitialSettingTodayPillNumber &&
            (identical(other.pageIndex, pageIndex) ||
                other.pageIndex == pageIndex) &&
            (identical(other.pillNumberInPillSheet, pillNumberInPillSheet) ||
                other.pillNumberInPillSheet == pillNumberInPillSheet));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, pageIndex, pillNumberInPillSheet);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_InitialSettingTodayPillNumberCopyWith<_$_InitialSettingTodayPillNumber>
      get copyWith => __$$_InitialSettingTodayPillNumberCopyWithImpl<
          _$_InitialSettingTodayPillNumber>(this, _$identity);
}

abstract class _InitialSettingTodayPillNumber
    implements InitialSettingTodayPillNumber {
  const factory _InitialSettingTodayPillNumber(
      {final int pageIndex,
      final int pillNumberInPillSheet}) = _$_InitialSettingTodayPillNumber;

  @override
  int get pageIndex;
  @override
  int get pillNumberInPillSheet;
  @override
  @JsonKey(ignore: true)
  _$$_InitialSettingTodayPillNumberCopyWith<_$_InitialSettingTodayPillNumber>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$InitialSettingState {
  List<PillSheetType> get pillSheetTypes => throw _privateConstructorUsedError;
  InitialSettingTodayPillNumber? get todayPillNumber =>
      throw _privateConstructorUsedError;
  List<ReminderTime> get reminderTimes => throw _privateConstructorUsedError;
  bool get isOnReminder => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get userIsNotAnonymous => throw _privateConstructorUsedError;
  bool get settingIsExist => throw _privateConstructorUsedError;
  bool get pillSheetTakesTwicePerDay => throw _privateConstructorUsedError;
  LinkAccountType? get accountType => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $InitialSettingStateCopyWith<InitialSettingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InitialSettingStateCopyWith<$Res> {
  factory $InitialSettingStateCopyWith(
          InitialSettingState value, $Res Function(InitialSettingState) then) =
      _$InitialSettingStateCopyWithImpl<$Res, InitialSettingState>;
  @useResult
  $Res call(
      {List<PillSheetType> pillSheetTypes,
      InitialSettingTodayPillNumber? todayPillNumber,
      List<ReminderTime> reminderTimes,
      bool isOnReminder,
      bool isLoading,
      bool userIsNotAnonymous,
      bool settingIsExist,
      bool pillSheetTakesTwicePerDay,
      LinkAccountType? accountType});

  $InitialSettingTodayPillNumberCopyWith<$Res>? get todayPillNumber;
}

/// @nodoc
class _$InitialSettingStateCopyWithImpl<$Res, $Val extends InitialSettingState>
    implements $InitialSettingStateCopyWith<$Res> {
  _$InitialSettingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pillSheetTypes = null,
    Object? todayPillNumber = freezed,
    Object? reminderTimes = null,
    Object? isOnReminder = null,
    Object? isLoading = null,
    Object? userIsNotAnonymous = null,
    Object? settingIsExist = null,
    Object? pillSheetTakesTwicePerDay = null,
    Object? accountType = freezed,
  }) {
    return _then(_value.copyWith(
      pillSheetTypes: null == pillSheetTypes
          ? _value.pillSheetTypes
          : pillSheetTypes // ignore: cast_nullable_to_non_nullable
              as List<PillSheetType>,
      todayPillNumber: freezed == todayPillNumber
          ? _value.todayPillNumber
          : todayPillNumber // ignore: cast_nullable_to_non_nullable
              as InitialSettingTodayPillNumber?,
      reminderTimes: null == reminderTimes
          ? _value.reminderTimes
          : reminderTimes // ignore: cast_nullable_to_non_nullable
              as List<ReminderTime>,
      isOnReminder: null == isOnReminder
          ? _value.isOnReminder
          : isOnReminder // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      userIsNotAnonymous: null == userIsNotAnonymous
          ? _value.userIsNotAnonymous
          : userIsNotAnonymous // ignore: cast_nullable_to_non_nullable
              as bool,
      settingIsExist: null == settingIsExist
          ? _value.settingIsExist
          : settingIsExist // ignore: cast_nullable_to_non_nullable
              as bool,
      pillSheetTakesTwicePerDay: null == pillSheetTakesTwicePerDay
          ? _value.pillSheetTakesTwicePerDay
          : pillSheetTakesTwicePerDay // ignore: cast_nullable_to_non_nullable
              as bool,
      accountType: freezed == accountType
          ? _value.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as LinkAccountType?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $InitialSettingTodayPillNumberCopyWith<$Res>? get todayPillNumber {
    if (_value.todayPillNumber == null) {
      return null;
    }

    return $InitialSettingTodayPillNumberCopyWith<$Res>(_value.todayPillNumber!,
        (value) {
      return _then(_value.copyWith(todayPillNumber: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_InitialSettingStateCopyWith<$Res>
    implements $InitialSettingStateCopyWith<$Res> {
  factory _$$_InitialSettingStateCopyWith(_$_InitialSettingState value,
          $Res Function(_$_InitialSettingState) then) =
      __$$_InitialSettingStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<PillSheetType> pillSheetTypes,
      InitialSettingTodayPillNumber? todayPillNumber,
      List<ReminderTime> reminderTimes,
      bool isOnReminder,
      bool isLoading,
      bool userIsNotAnonymous,
      bool settingIsExist,
      bool pillSheetTakesTwicePerDay,
      LinkAccountType? accountType});

  @override
  $InitialSettingTodayPillNumberCopyWith<$Res>? get todayPillNumber;
}

/// @nodoc
class __$$_InitialSettingStateCopyWithImpl<$Res>
    extends _$InitialSettingStateCopyWithImpl<$Res, _$_InitialSettingState>
    implements _$$_InitialSettingStateCopyWith<$Res> {
  __$$_InitialSettingStateCopyWithImpl(_$_InitialSettingState _value,
      $Res Function(_$_InitialSettingState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pillSheetTypes = null,
    Object? todayPillNumber = freezed,
    Object? reminderTimes = null,
    Object? isOnReminder = null,
    Object? isLoading = null,
    Object? userIsNotAnonymous = null,
    Object? settingIsExist = null,
    Object? pillSheetTakesTwicePerDay = null,
    Object? accountType = freezed,
  }) {
    return _then(_$_InitialSettingState(
      pillSheetTypes: null == pillSheetTypes
          ? _value._pillSheetTypes
          : pillSheetTypes // ignore: cast_nullable_to_non_nullable
              as List<PillSheetType>,
      todayPillNumber: freezed == todayPillNumber
          ? _value.todayPillNumber
          : todayPillNumber // ignore: cast_nullable_to_non_nullable
              as InitialSettingTodayPillNumber?,
      reminderTimes: null == reminderTimes
          ? _value._reminderTimes
          : reminderTimes // ignore: cast_nullable_to_non_nullable
              as List<ReminderTime>,
      isOnReminder: null == isOnReminder
          ? _value.isOnReminder
          : isOnReminder // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      userIsNotAnonymous: null == userIsNotAnonymous
          ? _value.userIsNotAnonymous
          : userIsNotAnonymous // ignore: cast_nullable_to_non_nullable
              as bool,
      settingIsExist: null == settingIsExist
          ? _value.settingIsExist
          : settingIsExist // ignore: cast_nullable_to_non_nullable
              as bool,
      pillSheetTakesTwicePerDay: null == pillSheetTakesTwicePerDay
          ? _value.pillSheetTakesTwicePerDay
          : pillSheetTakesTwicePerDay // ignore: cast_nullable_to_non_nullable
              as bool,
      accountType: freezed == accountType
          ? _value.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as LinkAccountType?,
    ));
  }
}

/// @nodoc

class _$_InitialSettingState extends _InitialSettingState {
  const _$_InitialSettingState(
      {final List<PillSheetType> pillSheetTypes = const [],
      this.todayPillNumber,
      required final List<ReminderTime> reminderTimes,
      this.isOnReminder = true,
      this.isLoading = false,
      this.userIsNotAnonymous = false,
      this.settingIsExist = false,
      this.pillSheetTakesTwicePerDay = false,
      this.accountType})
      : _pillSheetTypes = pillSheetTypes,
        _reminderTimes = reminderTimes,
        super._();

  final List<PillSheetType> _pillSheetTypes;
  @override
  @JsonKey()
  List<PillSheetType> get pillSheetTypes {
    if (_pillSheetTypes is EqualUnmodifiableListView) return _pillSheetTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pillSheetTypes);
  }

  @override
  final InitialSettingTodayPillNumber? todayPillNumber;
  final List<ReminderTime> _reminderTimes;
  @override
  List<ReminderTime> get reminderTimes {
    if (_reminderTimes is EqualUnmodifiableListView) return _reminderTimes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reminderTimes);
  }

  @override
  @JsonKey()
  final bool isOnReminder;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool userIsNotAnonymous;
  @override
  @JsonKey()
  final bool settingIsExist;
  @override
  @JsonKey()
  final bool pillSheetTakesTwicePerDay;
  @override
  final LinkAccountType? accountType;

  @override
  String toString() {
    return 'InitialSettingState(pillSheetTypes: $pillSheetTypes, todayPillNumber: $todayPillNumber, reminderTimes: $reminderTimes, isOnReminder: $isOnReminder, isLoading: $isLoading, userIsNotAnonymous: $userIsNotAnonymous, settingIsExist: $settingIsExist, pillSheetTakesTwicePerDay: $pillSheetTakesTwicePerDay, accountType: $accountType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_InitialSettingState &&
            const DeepCollectionEquality()
                .equals(other._pillSheetTypes, _pillSheetTypes) &&
            (identical(other.todayPillNumber, todayPillNumber) ||
                other.todayPillNumber == todayPillNumber) &&
            const DeepCollectionEquality()
                .equals(other._reminderTimes, _reminderTimes) &&
            (identical(other.isOnReminder, isOnReminder) ||
                other.isOnReminder == isOnReminder) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.userIsNotAnonymous, userIsNotAnonymous) ||
                other.userIsNotAnonymous == userIsNotAnonymous) &&
            (identical(other.settingIsExist, settingIsExist) ||
                other.settingIsExist == settingIsExist) &&
            (identical(other.pillSheetTakesTwicePerDay,
                    pillSheetTakesTwicePerDay) ||
                other.pillSheetTakesTwicePerDay == pillSheetTakesTwicePerDay) &&
            (identical(other.accountType, accountType) ||
                other.accountType == accountType));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_pillSheetTypes),
      todayPillNumber,
      const DeepCollectionEquality().hash(_reminderTimes),
      isOnReminder,
      isLoading,
      userIsNotAnonymous,
      settingIsExist,
      pillSheetTakesTwicePerDay,
      accountType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_InitialSettingStateCopyWith<_$_InitialSettingState> get copyWith =>
      __$$_InitialSettingStateCopyWithImpl<_$_InitialSettingState>(
          this, _$identity);
}

abstract class _InitialSettingState extends InitialSettingState {
  const factory _InitialSettingState(
      {final List<PillSheetType> pillSheetTypes,
      final InitialSettingTodayPillNumber? todayPillNumber,
      required final List<ReminderTime> reminderTimes,
      final bool isOnReminder,
      final bool isLoading,
      final bool userIsNotAnonymous,
      final bool settingIsExist,
      final bool pillSheetTakesTwicePerDay,
      final LinkAccountType? accountType}) = _$_InitialSettingState;
  const _InitialSettingState._() : super._();

  @override
  List<PillSheetType> get pillSheetTypes;
  @override
  InitialSettingTodayPillNumber? get todayPillNumber;
  @override
  List<ReminderTime> get reminderTimes;
  @override
  bool get isOnReminder;
  @override
  bool get isLoading;
  @override
  bool get userIsNotAnonymous;
  @override
  bool get settingIsExist;
  @override
  bool get pillSheetTakesTwicePerDay;
  @override
  LinkAccountType? get accountType;
  @override
  @JsonKey(ignore: true)
  _$$_InitialSettingStateCopyWith<_$_InitialSettingState> get copyWith =>
      throw _privateConstructorUsedError;
}
