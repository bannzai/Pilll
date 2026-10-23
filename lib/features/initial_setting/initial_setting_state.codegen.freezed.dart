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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InitialSettingTodayPillNumber {
  int get pageIndex => throw _privateConstructorUsedError;
  int get pillNumberInPillSheet => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $InitialSettingTodayPillNumberCopyWith<InitialSettingTodayPillNumber> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InitialSettingTodayPillNumberCopyWith<$Res> {
  factory $InitialSettingTodayPillNumberCopyWith(InitialSettingTodayPillNumber value, $Res Function(InitialSettingTodayPillNumber) then) =
      _$InitialSettingTodayPillNumberCopyWithImpl<$Res, InitialSettingTodayPillNumber>;
  @useResult
  $Res call({int pageIndex, int pillNumberInPillSheet});
}

/// @nodoc
class _$InitialSettingTodayPillNumberCopyWithImpl<$Res, $Val extends InitialSettingTodayPillNumber>
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
abstract class _$$InitialSettingTodayPillNumberImplCopyWith<$Res> implements $InitialSettingTodayPillNumberCopyWith<$Res> {
  factory _$$InitialSettingTodayPillNumberImplCopyWith(
          _$InitialSettingTodayPillNumberImpl value, $Res Function(_$InitialSettingTodayPillNumberImpl) then) =
      __$$InitialSettingTodayPillNumberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int pageIndex, int pillNumberInPillSheet});
}

/// @nodoc
class __$$InitialSettingTodayPillNumberImplCopyWithImpl<$Res>
    extends _$InitialSettingTodayPillNumberCopyWithImpl<$Res, _$InitialSettingTodayPillNumberImpl>
    implements _$$InitialSettingTodayPillNumberImplCopyWith<$Res> {
  __$$InitialSettingTodayPillNumberImplCopyWithImpl(
      _$InitialSettingTodayPillNumberImpl _value, $Res Function(_$InitialSettingTodayPillNumberImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pageIndex = null,
    Object? pillNumberInPillSheet = null,
  }) {
    return _then(_$InitialSettingTodayPillNumberImpl(
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

class _$InitialSettingTodayPillNumberImpl implements _InitialSettingTodayPillNumber {
  const _$InitialSettingTodayPillNumberImpl({this.pageIndex = 0, this.pillNumberInPillSheet = 0});

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
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InitialSettingTodayPillNumberImpl &&
            (identical(other.pageIndex, pageIndex) || other.pageIndex == pageIndex) &&
            (identical(other.pillNumberInPillSheet, pillNumberInPillSheet) || other.pillNumberInPillSheet == pillNumberInPillSheet));
  }

  @override
  int get hashCode => Object.hash(runtimeType, pageIndex, pillNumberInPillSheet);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InitialSettingTodayPillNumberImplCopyWith<_$InitialSettingTodayPillNumberImpl> get copyWith =>
      __$$InitialSettingTodayPillNumberImplCopyWithImpl<_$InitialSettingTodayPillNumberImpl>(this, _$identity);
}

abstract class _InitialSettingTodayPillNumber implements InitialSettingTodayPillNumber {
  const factory _InitialSettingTodayPillNumber({final int pageIndex, final int pillNumberInPillSheet}) = _$InitialSettingTodayPillNumberImpl;

  @override
  int get pageIndex;
  @override
  int get pillNumberInPillSheet;
  @override
  @JsonKey(ignore: true)
  _$$InitialSettingTodayPillNumberImplCopyWith<_$InitialSettingTodayPillNumberImpl> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$InitialSettingState {
  List<PillSheetType> get pillSheetTypes => throw _privateConstructorUsedError;
  InitialSettingTodayPillNumber? get todayPillNumber => throw _privateConstructorUsedError;
  List<ReminderTime> get reminderTimes => throw _privateConstructorUsedError;
  bool get isOnReminder => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get settingIsExist => throw _privateConstructorUsedError;
  LinkAccountType? get accountType => throw _privateConstructorUsedError;
  int get pillTakenCount => throw _privateConstructorUsedError;

  /// 初期設定の最初のページで「ヤーズフレックスの方ですか？」に「はい」と答えたか
  /// true の時はヤーズフレックス向けの導線 (28錠タイプ固定・前回の休薬・開始番号の入力) で登録する
  bool get isYazFlex => throw _privateConstructorUsedError;

  /// ヤーズフレックス向けの導線で前回の休薬の入力をスキップしたか (休薬はまだしていない、または後でホームから入力する)
  /// true の時は入力済みの日付があっても休薬を登録しない
  bool get yazFlexHasNotRestedYet => throw _privateConstructorUsedError;

  /// ヤーズフレックス向けの導線で入力した、前回の休薬が始まった日
  DateTime? get yazFlexLastRestDurationBeginDate => throw _privateConstructorUsedError;

  /// ヤーズフレックス向けの導線で入力した、前回の休薬が終わった日 (服用を再開した日)
  /// 開始日があって終了日が null の時は、休薬中でまだ再開していない (終了日の無い服用お休み中) として登録する
  DateTime? get yazFlexLastRestDurationEndDate => throw _privateConstructorUsedError;

  /// ヤーズフレックス向けの導線で入力した開始番号 (1枚目の1番は休薬明けから何日目か)
  /// 既定の 1 は、休薬明けの初日にシートの1番から飲み始めた (休薬明けとシートの切り替わりが一致している) 想定
  int get yazFlexBeginPillNumber => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $InitialSettingStateCopyWith<InitialSettingState> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InitialSettingStateCopyWith<$Res> {
  factory $InitialSettingStateCopyWith(InitialSettingState value, $Res Function(InitialSettingState) then) =
      _$InitialSettingStateCopyWithImpl<$Res, InitialSettingState>;
  @useResult
  $Res call(
      {List<PillSheetType> pillSheetTypes,
      InitialSettingTodayPillNumber? todayPillNumber,
      List<ReminderTime> reminderTimes,
      bool isOnReminder,
      bool isLoading,
      bool settingIsExist,
      LinkAccountType? accountType,
      int pillTakenCount,
      bool isYazFlex,
      bool yazFlexHasNotRestedYet,
      DateTime? yazFlexLastRestDurationBeginDate,
      DateTime? yazFlexLastRestDurationEndDate,
      int yazFlexBeginPillNumber});

  $InitialSettingTodayPillNumberCopyWith<$Res>? get todayPillNumber;
}

/// @nodoc
class _$InitialSettingStateCopyWithImpl<$Res, $Val extends InitialSettingState> implements $InitialSettingStateCopyWith<$Res> {
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
    Object? settingIsExist = null,
    Object? accountType = freezed,
    Object? pillTakenCount = null,
    Object? isYazFlex = null,
    Object? yazFlexHasNotRestedYet = null,
    Object? yazFlexLastRestDurationBeginDate = freezed,
    Object? yazFlexLastRestDurationEndDate = freezed,
    Object? yazFlexBeginPillNumber = null,
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
      settingIsExist: null == settingIsExist
          ? _value.settingIsExist
          : settingIsExist // ignore: cast_nullable_to_non_nullable
              as bool,
      accountType: freezed == accountType
          ? _value.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as LinkAccountType?,
      pillTakenCount: null == pillTakenCount
          ? _value.pillTakenCount
          : pillTakenCount // ignore: cast_nullable_to_non_nullable
              as int,
      isYazFlex: null == isYazFlex
          ? _value.isYazFlex
          : isYazFlex // ignore: cast_nullable_to_non_nullable
              as bool,
      yazFlexHasNotRestedYet: null == yazFlexHasNotRestedYet
          ? _value.yazFlexHasNotRestedYet
          : yazFlexHasNotRestedYet // ignore: cast_nullable_to_non_nullable
              as bool,
      yazFlexLastRestDurationBeginDate: freezed == yazFlexLastRestDurationBeginDate
          ? _value.yazFlexLastRestDurationBeginDate
          : yazFlexLastRestDurationBeginDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      yazFlexLastRestDurationEndDate: freezed == yazFlexLastRestDurationEndDate
          ? _value.yazFlexLastRestDurationEndDate
          : yazFlexLastRestDurationEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      yazFlexBeginPillNumber: null == yazFlexBeginPillNumber
          ? _value.yazFlexBeginPillNumber
          : yazFlexBeginPillNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $InitialSettingTodayPillNumberCopyWith<$Res>? get todayPillNumber {
    if (_value.todayPillNumber == null) {
      return null;
    }

    return $InitialSettingTodayPillNumberCopyWith<$Res>(_value.todayPillNumber!, (value) {
      return _then(_value.copyWith(todayPillNumber: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InitialSettingStateImplCopyWith<$Res> implements $InitialSettingStateCopyWith<$Res> {
  factory _$$InitialSettingStateImplCopyWith(_$InitialSettingStateImpl value, $Res Function(_$InitialSettingStateImpl) then) =
      __$$InitialSettingStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<PillSheetType> pillSheetTypes,
      InitialSettingTodayPillNumber? todayPillNumber,
      List<ReminderTime> reminderTimes,
      bool isOnReminder,
      bool isLoading,
      bool settingIsExist,
      LinkAccountType? accountType,
      int pillTakenCount,
      bool isYazFlex,
      bool yazFlexHasNotRestedYet,
      DateTime? yazFlexLastRestDurationBeginDate,
      DateTime? yazFlexLastRestDurationEndDate,
      int yazFlexBeginPillNumber});

  @override
  $InitialSettingTodayPillNumberCopyWith<$Res>? get todayPillNumber;
}

/// @nodoc
class __$$InitialSettingStateImplCopyWithImpl<$Res> extends _$InitialSettingStateCopyWithImpl<$Res, _$InitialSettingStateImpl>
    implements _$$InitialSettingStateImplCopyWith<$Res> {
  __$$InitialSettingStateImplCopyWithImpl(_$InitialSettingStateImpl _value, $Res Function(_$InitialSettingStateImpl) _then) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pillSheetTypes = null,
    Object? todayPillNumber = freezed,
    Object? reminderTimes = null,
    Object? isOnReminder = null,
    Object? isLoading = null,
    Object? settingIsExist = null,
    Object? accountType = freezed,
    Object? pillTakenCount = null,
    Object? isYazFlex = null,
    Object? yazFlexHasNotRestedYet = null,
    Object? yazFlexLastRestDurationBeginDate = freezed,
    Object? yazFlexLastRestDurationEndDate = freezed,
    Object? yazFlexBeginPillNumber = null,
  }) {
    return _then(_$InitialSettingStateImpl(
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
      settingIsExist: null == settingIsExist
          ? _value.settingIsExist
          : settingIsExist // ignore: cast_nullable_to_non_nullable
              as bool,
      accountType: freezed == accountType
          ? _value.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as LinkAccountType?,
      pillTakenCount: null == pillTakenCount
          ? _value.pillTakenCount
          : pillTakenCount // ignore: cast_nullable_to_non_nullable
              as int,
      isYazFlex: null == isYazFlex
          ? _value.isYazFlex
          : isYazFlex // ignore: cast_nullable_to_non_nullable
              as bool,
      yazFlexHasNotRestedYet: null == yazFlexHasNotRestedYet
          ? _value.yazFlexHasNotRestedYet
          : yazFlexHasNotRestedYet // ignore: cast_nullable_to_non_nullable
              as bool,
      yazFlexLastRestDurationBeginDate: freezed == yazFlexLastRestDurationBeginDate
          ? _value.yazFlexLastRestDurationBeginDate
          : yazFlexLastRestDurationBeginDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      yazFlexLastRestDurationEndDate: freezed == yazFlexLastRestDurationEndDate
          ? _value.yazFlexLastRestDurationEndDate
          : yazFlexLastRestDurationEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      yazFlexBeginPillNumber: null == yazFlexBeginPillNumber
          ? _value.yazFlexBeginPillNumber
          : yazFlexBeginPillNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$InitialSettingStateImpl extends _InitialSettingState {
  const _$InitialSettingStateImpl(
      {final List<PillSheetType> pillSheetTypes = const [],
      this.todayPillNumber,
      required final List<ReminderTime> reminderTimes,
      this.isOnReminder = true,
      this.isLoading = false,
      this.settingIsExist = false,
      this.accountType,
      this.pillTakenCount = 1,
      this.isYazFlex = false,
      this.yazFlexHasNotRestedYet = false,
      this.yazFlexLastRestDurationBeginDate,
      this.yazFlexLastRestDurationEndDate,
      this.yazFlexBeginPillNumber = 1})
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
  final bool settingIsExist;
  @override
  final LinkAccountType? accountType;
  @override
  @JsonKey()
  final int pillTakenCount;

  /// 初期設定の最初のページで「ヤーズフレックスの方ですか？」に「はい」と答えたか
  /// true の時はヤーズフレックス向けの導線 (28錠タイプ固定・前回の休薬・開始番号の入力) で登録する
  @override
  @JsonKey()
  final bool isYazFlex;

  /// ヤーズフレックス向けの導線で前回の休薬の入力をスキップしたか (休薬はまだしていない、または後でホームから入力する)
  /// true の時は入力済みの日付があっても休薬を登録しない
  @override
  @JsonKey()
  final bool yazFlexHasNotRestedYet;

  /// ヤーズフレックス向けの導線で入力した、前回の休薬が始まった日
  @override
  final DateTime? yazFlexLastRestDurationBeginDate;

  /// ヤーズフレックス向けの導線で入力した、前回の休薬が終わった日 (服用を再開した日)
  /// 開始日があって終了日が null の時は、休薬中でまだ再開していない (終了日の無い服用お休み中) として登録する
  @override
  final DateTime? yazFlexLastRestDurationEndDate;

  /// ヤーズフレックス向けの導線で入力した開始番号 (1枚目の1番は休薬明けから何日目か)
  /// 既定の 1 は、休薬明けの初日にシートの1番から飲み始めた (休薬明けとシートの切り替わりが一致している) 想定
  @override
  @JsonKey()
  final int yazFlexBeginPillNumber;

  @override
  String toString() {
    return 'InitialSettingState(pillSheetTypes: $pillSheetTypes, todayPillNumber: $todayPillNumber, reminderTimes: $reminderTimes, isOnReminder: $isOnReminder, isLoading: $isLoading, settingIsExist: $settingIsExist, accountType: $accountType, pillTakenCount: $pillTakenCount, isYazFlex: $isYazFlex, yazFlexHasNotRestedYet: $yazFlexHasNotRestedYet, yazFlexLastRestDurationBeginDate: $yazFlexLastRestDurationBeginDate, yazFlexLastRestDurationEndDate: $yazFlexLastRestDurationEndDate, yazFlexBeginPillNumber: $yazFlexBeginPillNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InitialSettingStateImpl &&
            const DeepCollectionEquality().equals(other._pillSheetTypes, _pillSheetTypes) &&
            (identical(other.todayPillNumber, todayPillNumber) || other.todayPillNumber == todayPillNumber) &&
            const DeepCollectionEquality().equals(other._reminderTimes, _reminderTimes) &&
            (identical(other.isOnReminder, isOnReminder) || other.isOnReminder == isOnReminder) &&
            (identical(other.isLoading, isLoading) || other.isLoading == isLoading) &&
            (identical(other.settingIsExist, settingIsExist) || other.settingIsExist == settingIsExist) &&
            (identical(other.accountType, accountType) || other.accountType == accountType) &&
            (identical(other.pillTakenCount, pillTakenCount) || other.pillTakenCount == pillTakenCount) &&
            (identical(other.isYazFlex, isYazFlex) || other.isYazFlex == isYazFlex) &&
            (identical(other.yazFlexHasNotRestedYet, yazFlexHasNotRestedYet) || other.yazFlexHasNotRestedYet == yazFlexHasNotRestedYet) &&
            (identical(other.yazFlexLastRestDurationBeginDate, yazFlexLastRestDurationBeginDate) ||
                other.yazFlexLastRestDurationBeginDate == yazFlexLastRestDurationBeginDate) &&
            (identical(other.yazFlexLastRestDurationEndDate, yazFlexLastRestDurationEndDate) ||
                other.yazFlexLastRestDurationEndDate == yazFlexLastRestDurationEndDate) &&
            (identical(other.yazFlexBeginPillNumber, yazFlexBeginPillNumber) || other.yazFlexBeginPillNumber == yazFlexBeginPillNumber));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_pillSheetTypes),
      todayPillNumber,
      const DeepCollectionEquality().hash(_reminderTimes),
      isOnReminder,
      isLoading,
      settingIsExist,
      accountType,
      pillTakenCount,
      isYazFlex,
      yazFlexHasNotRestedYet,
      yazFlexLastRestDurationBeginDate,
      yazFlexLastRestDurationEndDate,
      yazFlexBeginPillNumber);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InitialSettingStateImplCopyWith<_$InitialSettingStateImpl> get copyWith =>
      __$$InitialSettingStateImplCopyWithImpl<_$InitialSettingStateImpl>(this, _$identity);
}

abstract class _InitialSettingState extends InitialSettingState {
  const factory _InitialSettingState(
      {final List<PillSheetType> pillSheetTypes,
      final InitialSettingTodayPillNumber? todayPillNumber,
      required final List<ReminderTime> reminderTimes,
      final bool isOnReminder,
      final bool isLoading,
      final bool settingIsExist,
      final LinkAccountType? accountType,
      final int pillTakenCount,
      final bool isYazFlex,
      final bool yazFlexHasNotRestedYet,
      final DateTime? yazFlexLastRestDurationBeginDate,
      final DateTime? yazFlexLastRestDurationEndDate,
      final int yazFlexBeginPillNumber}) = _$InitialSettingStateImpl;
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
  bool get settingIsExist;
  @override
  LinkAccountType? get accountType;
  @override
  int get pillTakenCount;
  @override

  /// 初期設定の最初のページで「ヤーズフレックスの方ですか？」に「はい」と答えたか
  /// true の時はヤーズフレックス向けの導線 (28錠タイプ固定・前回の休薬・開始番号の入力) で登録する
  bool get isYazFlex;
  @override

  /// ヤーズフレックス向けの導線で前回の休薬の入力をスキップしたか (休薬はまだしていない、または後でホームから入力する)
  /// true の時は入力済みの日付があっても休薬を登録しない
  bool get yazFlexHasNotRestedYet;
  @override

  /// ヤーズフレックス向けの導線で入力した、前回の休薬が始まった日
  DateTime? get yazFlexLastRestDurationBeginDate;
  @override

  /// ヤーズフレックス向けの導線で入力した、前回の休薬が終わった日 (服用を再開した日)
  /// 開始日があって終了日が null の時は、休薬中でまだ再開していない (終了日の無い服用お休み中) として登録する
  DateTime? get yazFlexLastRestDurationEndDate;
  @override

  /// ヤーズフレックス向けの導線で入力した開始番号 (1枚目の1番は休薬明けから何日目か)
  /// 既定の 1 は、休薬明けの初日にシートの1番から飲み始めた (休薬明けとシートの切り替わりが一致している) 想定
  int get yazFlexBeginPillNumber;
  @override
  @JsonKey(ignore: true)
  _$$InitialSettingStateImplCopyWith<_$InitialSettingStateImpl> get copyWith => throw _privateConstructorUsedError;
}
