// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'diary_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$DiaryStateTearOff {
  const _$DiaryStateTearOff();

  _DiaryState call({required Diary diary}) {
    return _DiaryState(
      diary: diary,
    );
  }
}

/// @nodoc
const $DiaryState = _$DiaryStateTearOff();

/// @nodoc
mixin _$DiaryState {
  Diary get diary => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DiaryStateCopyWith<DiaryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiaryStateCopyWith<$Res> {
  factory $DiaryStateCopyWith(
          DiaryState value, $Res Function(DiaryState) then) =
      _$DiaryStateCopyWithImpl<$Res>;
  $Res call({Diary diary});

  $DiaryCopyWith<$Res> get diary;
}

/// @nodoc
class _$DiaryStateCopyWithImpl<$Res> implements $DiaryStateCopyWith<$Res> {
  _$DiaryStateCopyWithImpl(this._value, this._then);

  final DiaryState _value;
  // ignore: unused_field
  final $Res Function(DiaryState) _then;

  @override
  $Res call({
    Object? diary = freezed,
  }) {
    return _then(_value.copyWith(
      diary: diary == freezed
          ? _value.diary
          : diary // ignore: cast_nullable_to_non_nullable
              as Diary,
    ));
  }

  @override
  $DiaryCopyWith<$Res> get diary {
    return $DiaryCopyWith<$Res>(_value.diary, (value) {
      return _then(_value.copyWith(diary: value));
    });
  }
}

/// @nodoc
abstract class _$DiaryStateCopyWith<$Res> implements $DiaryStateCopyWith<$Res> {
  factory _$DiaryStateCopyWith(
          _DiaryState value, $Res Function(_DiaryState) then) =
      __$DiaryStateCopyWithImpl<$Res>;
  @override
  $Res call({Diary diary});

  @override
  $DiaryCopyWith<$Res> get diary;
}

/// @nodoc
class __$DiaryStateCopyWithImpl<$Res> extends _$DiaryStateCopyWithImpl<$Res>
    implements _$DiaryStateCopyWith<$Res> {
  __$DiaryStateCopyWithImpl(
      _DiaryState _value, $Res Function(_DiaryState) _then)
      : super(_value, (v) => _then(v as _DiaryState));

  @override
  _DiaryState get _value => super._value as _DiaryState;

  @override
  $Res call({
    Object? diary = freezed,
  }) {
    return _then(_DiaryState(
      diary: diary == freezed
          ? _value.diary
          : diary // ignore: cast_nullable_to_non_nullable
              as Diary,
    ));
  }
}

/// @nodoc

class _$_DiaryState extends _DiaryState {
  const _$_DiaryState({required this.diary}) : super._();

  @override
  final Diary diary;

  @override
  String toString() {
    return 'DiaryState(diary: $diary)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DiaryState &&
            const DeepCollectionEquality().equals(other.diary, diary));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(diary));

  @JsonKey(ignore: true)
  @override
  _$DiaryStateCopyWith<_DiaryState> get copyWith =>
      __$DiaryStateCopyWithImpl<_DiaryState>(this, _$identity);
}

abstract class _DiaryState extends DiaryState {
  const factory _DiaryState({required Diary diary}) = _$_DiaryState;
  const _DiaryState._() : super._();

  @override
  Diary get diary;
  @override
  @JsonKey(ignore: true)
  _$DiaryStateCopyWith<_DiaryState> get copyWith =>
      throw _privateConstructorUsedError;
}
