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
abstract class _$$_DiarySettingPhysicalConditionDetailStateCopyWith<$Res>
    implements $DiarySettingPhysicalConditionDetailStateCopyWith<$Res> {
  factory _$$_DiarySettingPhysicalConditionDetailStateCopyWith(
          _$_DiarySettingPhysicalConditionDetailState value,
          $Res Function(_$_DiarySettingPhysicalConditionDetailState) then) =
      __$$_DiarySettingPhysicalConditionDetailStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DiarySetting? diarySetting});

  @override
  $DiarySettingCopyWith<$Res>? get diarySetting;
}

/// @nodoc
class __$$_DiarySettingPhysicalConditionDetailStateCopyWithImpl<$Res>
    extends _$DiarySettingPhysicalConditionDetailStateCopyWithImpl<$Res,
        _$_DiarySettingPhysicalConditionDetailState>
    implements _$$_DiarySettingPhysicalConditionDetailStateCopyWith<$Res> {
  __$$_DiarySettingPhysicalConditionDetailStateCopyWithImpl(
      _$_DiarySettingPhysicalConditionDetailState _value,
      $Res Function(_$_DiarySettingPhysicalConditionDetailState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? diarySetting = freezed,
  }) {
    return _then(_$_DiarySettingPhysicalConditionDetailState(
      diarySetting: freezed == diarySetting
          ? _value.diarySetting
          : diarySetting // ignore: cast_nullable_to_non_nullable
              as DiarySetting?,
    ));
  }
}

/// @nodoc

class _$_DiarySettingPhysicalConditionDetailState
    extends _DiarySettingPhysicalConditionDetailState {
  _$_DiarySettingPhysicalConditionDetailState({required this.diarySetting})
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
            other is _$_DiarySettingPhysicalConditionDetailState &&
            (identical(other.diarySetting, diarySetting) ||
                other.diarySetting == diarySetting));
  }

  @override
  int get hashCode => Object.hash(runtimeType, diarySetting);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_DiarySettingPhysicalConditionDetailStateCopyWith<
          _$_DiarySettingPhysicalConditionDetailState>
      get copyWith => __$$_DiarySettingPhysicalConditionDetailStateCopyWithImpl<
          _$_DiarySettingPhysicalConditionDetailState>(this, _$identity);
}

abstract class _DiarySettingPhysicalConditionDetailState
    extends DiarySettingPhysicalConditionDetailState {
  factory _DiarySettingPhysicalConditionDetailState(
          {required final DiarySetting? diarySetting}) =
      _$_DiarySettingPhysicalConditionDetailState;
  _DiarySettingPhysicalConditionDetailState._() : super._();

  @override
  DiarySetting? get diarySetting;
  @override
  @JsonKey(ignore: true)
  _$$_DiarySettingPhysicalConditionDetailStateCopyWith<
          _$_DiarySettingPhysicalConditionDetailState>
      get copyWith => throw _privateConstructorUsedError;
}
