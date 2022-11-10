// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'state.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$DiaryPostState {
  PremiumAndTrial get premiumAndTrial => throw _privateConstructorUsedError;
  Diary get diary => throw _privateConstructorUsedError;
  DiarySetting? get diarySetting => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DiaryPostStateCopyWith<DiaryPostState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiaryPostStateCopyWith<$Res> {
  factory $DiaryPostStateCopyWith(
          DiaryPostState value, $Res Function(DiaryPostState) then) =
      _$DiaryPostStateCopyWithImpl<$Res, DiaryPostState>;
  @useResult
  $Res call(
      {PremiumAndTrial premiumAndTrial,
      Diary diary,
      DiarySetting? diarySetting});

  $PremiumAndTrialCopyWith<$Res> get premiumAndTrial;
  $DiaryCopyWith<$Res> get diary;
  $DiarySettingCopyWith<$Res>? get diarySetting;
}

/// @nodoc
class _$DiaryPostStateCopyWithImpl<$Res, $Val extends DiaryPostState>
    implements $DiaryPostStateCopyWith<$Res> {
  _$DiaryPostStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? premiumAndTrial = null,
    Object? diary = null,
    Object? diarySetting = freezed,
  }) {
    return _then(_value.copyWith(
      premiumAndTrial: null == premiumAndTrial
          ? _value.premiumAndTrial
          : premiumAndTrial // ignore: cast_nullable_to_non_nullable
              as PremiumAndTrial,
      diary: null == diary
          ? _value.diary
          : diary // ignore: cast_nullable_to_non_nullable
              as Diary,
      diarySetting: freezed == diarySetting
          ? _value.diarySetting
          : diarySetting // ignore: cast_nullable_to_non_nullable
              as DiarySetting?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PremiumAndTrialCopyWith<$Res> get premiumAndTrial {
    return $PremiumAndTrialCopyWith<$Res>(_value.premiumAndTrial, (value) {
      return _then(_value.copyWith(premiumAndTrial: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $DiaryCopyWith<$Res> get diary {
    return $DiaryCopyWith<$Res>(_value.diary, (value) {
      return _then(_value.copyWith(diary: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $DiarySettingCopyWith<$Res>? get diarySetting {
    if (_value.diarySetting == null) {
      return null;
    }

    return $DiarySettingCopyWith<$Res>(_value.diarySetting!, (value) {
      return _then(_value.copyWith(diarySetting: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_DiaryPostStateCopyWith<$Res>
    implements $DiaryPostStateCopyWith<$Res> {
  factory _$$_DiaryPostStateCopyWith(
          _$_DiaryPostState value, $Res Function(_$_DiaryPostState) then) =
      __$$_DiaryPostStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PremiumAndTrial premiumAndTrial,
      Diary diary,
      DiarySetting? diarySetting});

  @override
  $PremiumAndTrialCopyWith<$Res> get premiumAndTrial;
  @override
  $DiaryCopyWith<$Res> get diary;
  @override
  $DiarySettingCopyWith<$Res>? get diarySetting;
}

/// @nodoc
class __$$_DiaryPostStateCopyWithImpl<$Res>
    extends _$DiaryPostStateCopyWithImpl<$Res, _$_DiaryPostState>
    implements _$$_DiaryPostStateCopyWith<$Res> {
  __$$_DiaryPostStateCopyWithImpl(
      _$_DiaryPostState _value, $Res Function(_$_DiaryPostState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? premiumAndTrial = null,
    Object? diary = null,
    Object? diarySetting = freezed,
  }) {
    return _then(_$_DiaryPostState(
      premiumAndTrial: null == premiumAndTrial
          ? _value.premiumAndTrial
          : premiumAndTrial // ignore: cast_nullable_to_non_nullable
              as PremiumAndTrial,
      diary: null == diary
          ? _value.diary
          : diary // ignore: cast_nullable_to_non_nullable
              as Diary,
      diarySetting: freezed == diarySetting
          ? _value.diarySetting
          : diarySetting // ignore: cast_nullable_to_non_nullable
              as DiarySetting?,
    ));
  }
}

/// @nodoc

class _$_DiaryPostState extends _DiaryPostState {
  _$_DiaryPostState(
      {required this.premiumAndTrial,
      required this.diary,
      required this.diarySetting})
      : super._();

  @override
  final PremiumAndTrial premiumAndTrial;
  @override
  final Diary diary;
  @override
  final DiarySetting? diarySetting;

  @override
  String toString() {
    return 'DiaryPostState(premiumAndTrial: $premiumAndTrial, diary: $diary, diarySetting: $diarySetting)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DiaryPostState &&
            (identical(other.premiumAndTrial, premiumAndTrial) ||
                other.premiumAndTrial == premiumAndTrial) &&
            (identical(other.diary, diary) || other.diary == diary) &&
            (identical(other.diarySetting, diarySetting) ||
                other.diarySetting == diarySetting));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, premiumAndTrial, diary, diarySetting);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_DiaryPostStateCopyWith<_$_DiaryPostState> get copyWith =>
      __$$_DiaryPostStateCopyWithImpl<_$_DiaryPostState>(this, _$identity);
}

abstract class _DiaryPostState extends DiaryPostState {
  factory _DiaryPostState(
      {required final PremiumAndTrial premiumAndTrial,
      required final Diary diary,
      required final DiarySetting? diarySetting}) = _$_DiaryPostState;
  _DiaryPostState._() : super._();

  @override
  PremiumAndTrial get premiumAndTrial;
  @override
  Diary get diary;
  @override
  DiarySetting? get diarySetting;
  @override
  @JsonKey(ignore: true)
  _$$_DiaryPostStateCopyWith<_$_DiaryPostState> get copyWith =>
      throw _privateConstructorUsedError;
}
