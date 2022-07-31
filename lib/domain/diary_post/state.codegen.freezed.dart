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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$DiaryPostStateTearOff {
  const _$DiaryPostStateTearOff();

  _DiaryPostState call(
      {required Diary diary, required DiarySetting? diarySetting}) {
    return _DiaryPostState(
      diary: diary,
      diarySetting: diarySetting,
    );
  }
}

/// @nodoc
const $DiaryPostState = _$DiaryPostStateTearOff();

/// @nodoc
mixin _$DiaryPostState {
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
      _$DiaryPostStateCopyWithImpl<$Res>;
  $Res call({Diary diary, DiarySetting? diarySetting});

  $DiaryCopyWith<$Res> get diary;
  $DiarySettingCopyWith<$Res>? get diarySetting;
}

/// @nodoc
class _$DiaryPostStateCopyWithImpl<$Res>
    implements $DiaryPostStateCopyWith<$Res> {
  _$DiaryPostStateCopyWithImpl(this._value, this._then);

  final DiaryPostState _value;
  // ignore: unused_field
  final $Res Function(DiaryPostState) _then;

  @override
  $Res call({
    Object? diary = freezed,
    Object? diarySetting = freezed,
  }) {
    return _then(_value.copyWith(
      diary: diary == freezed
          ? _value.diary
          : diary // ignore: cast_nullable_to_non_nullable
              as Diary,
      diarySetting: diarySetting == freezed
          ? _value.diarySetting
          : diarySetting // ignore: cast_nullable_to_non_nullable
              as DiarySetting?,
    ));
  }

  @override
  $DiaryCopyWith<$Res> get diary {
    return $DiaryCopyWith<$Res>(_value.diary, (value) {
      return _then(_value.copyWith(diary: value));
    });
  }

  @override
  $DiarySettingCopyWith<$Res>? get diarySetting {
    if (_value.diarySetting == null) {
      return null;
    }

    return $DiarySettingCopyWith<$Res>(_value.diarySetting!, (value) {
      return _then(_value.copyWith(diarySetting: value));
    });
  }
}

/// @nodoc
abstract class _$DiaryPostStateCopyWith<$Res>
    implements $DiaryPostStateCopyWith<$Res> {
  factory _$DiaryPostStateCopyWith(
          _DiaryPostState value, $Res Function(_DiaryPostState) then) =
      __$DiaryPostStateCopyWithImpl<$Res>;
  @override
  $Res call({Diary diary, DiarySetting? diarySetting});

  @override
  $DiaryCopyWith<$Res> get diary;
  @override
  $DiarySettingCopyWith<$Res>? get diarySetting;
}

/// @nodoc
class __$DiaryPostStateCopyWithImpl<$Res>
    extends _$DiaryPostStateCopyWithImpl<$Res>
    implements _$DiaryPostStateCopyWith<$Res> {
  __$DiaryPostStateCopyWithImpl(
      _DiaryPostState _value, $Res Function(_DiaryPostState) _then)
      : super(_value, (v) => _then(v as _DiaryPostState));

  @override
  _DiaryPostState get _value => super._value as _DiaryPostState;

  @override
  $Res call({
    Object? diary = freezed,
    Object? diarySetting = freezed,
  }) {
    return _then(_DiaryPostState(
      diary: diary == freezed
          ? _value.diary
          : diary // ignore: cast_nullable_to_non_nullable
              as Diary,
      diarySetting: diarySetting == freezed
          ? _value.diarySetting
          : diarySetting // ignore: cast_nullable_to_non_nullable
              as DiarySetting?,
    ));
  }
}

/// @nodoc

class _$_DiaryPostState extends _DiaryPostState {
  _$_DiaryPostState({required this.diary, required this.diarySetting})
      : super._();

  @override
  final Diary diary;
  @override
  final DiarySetting? diarySetting;

  @override
  String toString() {
    return 'DiaryPostState(diary: $diary, diarySetting: $diarySetting)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DiaryPostState &&
            const DeepCollectionEquality().equals(other.diary, diary) &&
            const DeepCollectionEquality()
                .equals(other.diarySetting, diarySetting));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(diary),
      const DeepCollectionEquality().hash(diarySetting));

  @JsonKey(ignore: true)
  @override
  _$DiaryPostStateCopyWith<_DiaryPostState> get copyWith =>
      __$DiaryPostStateCopyWithImpl<_DiaryPostState>(this, _$identity);
}

abstract class _DiaryPostState extends DiaryPostState {
  factory _DiaryPostState(
      {required Diary diary,
      required DiarySetting? diarySetting}) = _$_DiaryPostState;
  _DiaryPostState._() : super._();

  @override
  Diary get diary;
  @override
  DiarySetting? get diarySetting;
  @override
  @JsonKey(ignore: true)
  _$DiaryPostStateCopyWith<_DiaryPostState> get copyWith =>
      throw _privateConstructorUsedError;
}
