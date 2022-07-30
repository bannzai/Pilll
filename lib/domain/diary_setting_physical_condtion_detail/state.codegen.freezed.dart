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
class _$DiarySettingPhysicalConditionDetailStateTearOff {
  const _$DiarySettingPhysicalConditionDetailStateTearOff();

  _DiarySettingPhysicalConditionDetailState call(
      {required DiarySetting diarySetting}) {
    return _DiarySettingPhysicalConditionDetailState(
      diarySetting: diarySetting,
    );
  }
}

/// @nodoc
const $DiarySettingPhysicalConditionDetailState =
    _$DiarySettingPhysicalConditionDetailStateTearOff();

/// @nodoc
mixin _$DiarySettingPhysicalConditionDetailState {
  DiarySetting get diarySetting => throw _privateConstructorUsedError;

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
      _$DiarySettingPhysicalConditionDetailStateCopyWithImpl<$Res>;
  $Res call({DiarySetting diarySetting});

  $DiarySettingCopyWith<$Res> get diarySetting;
}

/// @nodoc
class _$DiarySettingPhysicalConditionDetailStateCopyWithImpl<$Res>
    implements $DiarySettingPhysicalConditionDetailStateCopyWith<$Res> {
  _$DiarySettingPhysicalConditionDetailStateCopyWithImpl(
      this._value, this._then);

  final DiarySettingPhysicalConditionDetailState _value;
  // ignore: unused_field
  final $Res Function(DiarySettingPhysicalConditionDetailState) _then;

  @override
  $Res call({
    Object? diarySetting = freezed,
  }) {
    return _then(_value.copyWith(
      diarySetting: diarySetting == freezed
          ? _value.diarySetting
          : diarySetting // ignore: cast_nullable_to_non_nullable
              as DiarySetting,
    ));
  }

  @override
  $DiarySettingCopyWith<$Res> get diarySetting {
    return $DiarySettingCopyWith<$Res>(_value.diarySetting, (value) {
      return _then(_value.copyWith(diarySetting: value));
    });
  }
}

/// @nodoc
abstract class _$DiarySettingPhysicalConditionDetailStateCopyWith<$Res>
    implements $DiarySettingPhysicalConditionDetailStateCopyWith<$Res> {
  factory _$DiarySettingPhysicalConditionDetailStateCopyWith(
          _DiarySettingPhysicalConditionDetailState value,
          $Res Function(_DiarySettingPhysicalConditionDetailState) then) =
      __$DiarySettingPhysicalConditionDetailStateCopyWithImpl<$Res>;
  @override
  $Res call({DiarySetting diarySetting});

  @override
  $DiarySettingCopyWith<$Res> get diarySetting;
}

/// @nodoc
class __$DiarySettingPhysicalConditionDetailStateCopyWithImpl<$Res>
    extends _$DiarySettingPhysicalConditionDetailStateCopyWithImpl<$Res>
    implements _$DiarySettingPhysicalConditionDetailStateCopyWith<$Res> {
  __$DiarySettingPhysicalConditionDetailStateCopyWithImpl(
      _DiarySettingPhysicalConditionDetailState _value,
      $Res Function(_DiarySettingPhysicalConditionDetailState) _then)
      : super(_value,
            (v) => _then(v as _DiarySettingPhysicalConditionDetailState));

  @override
  _DiarySettingPhysicalConditionDetailState get _value =>
      super._value as _DiarySettingPhysicalConditionDetailState;

  @override
  $Res call({
    Object? diarySetting = freezed,
  }) {
    return _then(_DiarySettingPhysicalConditionDetailState(
      diarySetting: diarySetting == freezed
          ? _value.diarySetting
          : diarySetting // ignore: cast_nullable_to_non_nullable
              as DiarySetting,
    ));
  }
}

/// @nodoc

class _$_DiarySettingPhysicalConditionDetailState
    extends _DiarySettingPhysicalConditionDetailState {
  _$_DiarySettingPhysicalConditionDetailState({required this.diarySetting})
      : super._();

  @override
  final DiarySetting diarySetting;

  @override
  String toString() {
    return 'DiarySettingPhysicalConditionDetailState(diarySetting: $diarySetting)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DiarySettingPhysicalConditionDetailState &&
            const DeepCollectionEquality()
                .equals(other.diarySetting, diarySetting));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(diarySetting));

  @JsonKey(ignore: true)
  @override
  _$DiarySettingPhysicalConditionDetailStateCopyWith<
          _DiarySettingPhysicalConditionDetailState>
      get copyWith => __$DiarySettingPhysicalConditionDetailStateCopyWithImpl<
          _DiarySettingPhysicalConditionDetailState>(this, _$identity);
}

abstract class _DiarySettingPhysicalConditionDetailState
    extends DiarySettingPhysicalConditionDetailState {
  factory _DiarySettingPhysicalConditionDetailState(
          {required DiarySetting diarySetting}) =
      _$_DiarySettingPhysicalConditionDetailState;
  _DiarySettingPhysicalConditionDetailState._() : super._();

  @override
  DiarySetting get diarySetting;
  @override
  @JsonKey(ignore: true)
  _$DiarySettingPhysicalConditionDetailStateCopyWith<
          _DiarySettingPhysicalConditionDetailState>
      get copyWith => throw _privateConstructorUsedError;
}
