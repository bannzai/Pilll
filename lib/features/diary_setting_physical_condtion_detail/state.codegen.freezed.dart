// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'state.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$DiarySettingPhysicalConditionDetailState {
  DiarySetting? get diarySetting => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DiarySettingPhysicalConditionDetailStateCopyWith<
          DiarySettingPhysicalConditionDetailState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiarySettingPhysicalConditionDetailStateCopyWith<$Res> {
  factory $DiarySettingPhysicalConditionDetailStateCopyWith(
          DiarySettingPhysicalConditionDetailState value,
          $Res Function(DiarySettingPhysicalConditionDetailState) then) =
      _$DiarySettingPhysicalConditionDetailStateCopyWithImpl<$Res,
          DiarySettingPhysicalConditionDetailState>;
  @useResult
  $Res call({DiarySetting? diarySetting});

  $DiarySettingCopyWith<$Res>? get diarySetting;
}

/// @nodoc
class _$DiarySettingPhysicalConditionDetailStateCopyWithImpl<$Res,
        $Val extends DiarySettingPhysicalConditionDetailState>
    implements $DiarySettingPhysicalConditionDetailStateCopyWith<$Res> {
  _$DiarySettingPhysicalConditionDetailStateCopyWithImpl(
      this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? diarySetting = freezed,
  }) {
    return _then(_value.copyWith(
      diarySetting: freezed == diarySetting
          ? _value.diarySetting
          : diarySetting // ignore: cast_nullable_to_non_nullable
              as DiarySetting?,
    ) as $Val);
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
abstract class _$$DiarySettingPhysicalConditionDetailStateImplCopyWith<$Res>
    implements $DiarySettingPhysicalConditionDetailStateCopyWith<$Res> {
  factory _$$DiarySettingPhysicalConditionDetailStateImplCopyWith(
          _$DiarySettingPhysicalConditionDetailStateImpl value,
          $Res Function(_$DiarySettingPhysicalConditionDetailStateImpl) then) =
      __$$DiarySettingPhysicalConditionDetailStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DiarySetting? diarySetting});

  @override
  $DiarySettingCopyWith<$Res>? get diarySetting;
}

/// @nodoc
class __$$DiarySettingPhysicalConditionDetailStateImplCopyWithImpl<$Res>
    extends _$DiarySettingPhysicalConditionDetailStateCopyWithImpl<$Res,
        _$DiarySettingPhysicalConditionDetailStateImpl>
    implements _$$DiarySettingPhysicalConditionDetailStateImplCopyWith<$Res> {
  __$$DiarySettingPhysicalConditionDetailStateImplCopyWithImpl(
      _$DiarySettingPhysicalConditionDetailStateImpl _value,
      $Res Function(_$DiarySettingPhysicalConditionDetailStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? diarySetting = freezed,
  }) {
    return _then(_$DiarySettingPhysicalConditionDetailStateImpl(
      diarySetting: freezed == diarySetting
          ? _value.diarySetting
          : diarySetting // ignore: cast_nullable_to_non_nullable
              as DiarySetting?,
    ));
  }
}

/// @nodoc

class _$DiarySettingPhysicalConditionDetailStateImpl
    extends _DiarySettingPhysicalConditionDetailState {
  _$DiarySettingPhysicalConditionDetailStateImpl({required this.diarySetting})
      : super._();

  @override
  final DiarySetting? diarySetting;

  @override
  String toString() {
    return 'DiarySettingPhysicalConditionDetailState(diarySetting: $diarySetting)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiarySettingPhysicalConditionDetailStateImpl &&
            (identical(other.diarySetting, diarySetting) ||
                other.diarySetting == diarySetting));
  }

  @override
  int get hashCode => Object.hash(runtimeType, diarySetting);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DiarySettingPhysicalConditionDetailStateImplCopyWith<
          _$DiarySettingPhysicalConditionDetailStateImpl>
      get copyWith =>
          __$$DiarySettingPhysicalConditionDetailStateImplCopyWithImpl<
              _$DiarySettingPhysicalConditionDetailStateImpl>(this, _$identity);
}

abstract class _DiarySettingPhysicalConditionDetailState
    extends DiarySettingPhysicalConditionDetailState {
  factory _DiarySettingPhysicalConditionDetailState(
          {required final DiarySetting? diarySetting}) =
      _$DiarySettingPhysicalConditionDetailStateImpl;
  _DiarySettingPhysicalConditionDetailState._() : super._();

  @override
  DiarySetting? get diarySetting;
  @override
  @JsonKey(ignore: true)
  _$$DiarySettingPhysicalConditionDetailStateImplCopyWith<
          _$DiarySettingPhysicalConditionDetailStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
