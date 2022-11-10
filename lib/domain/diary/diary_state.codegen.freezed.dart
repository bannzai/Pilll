// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'diary_state.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

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
      _$DiaryStateCopyWithImpl<$Res, DiaryState>;
  @useResult
  $Res call({Diary diary});

  $DiaryCopyWith<$Res> get diary;
}

/// @nodoc
class _$DiaryStateCopyWithImpl<$Res, $Val extends DiaryState>
    implements $DiaryStateCopyWith<$Res> {
  _$DiaryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? diary = null,
  }) {
    return _then(_value.copyWith(
      diary: null == diary
          ? _value.diary
          : diary // ignore: cast_nullable_to_non_nullable
              as Diary,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DiaryCopyWith<$Res> get diary {
    return $DiaryCopyWith<$Res>(_value.diary, (value) {
      return _then(_value.copyWith(diary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_DiaryStateCopyWith<$Res>
    implements $DiaryStateCopyWith<$Res> {
  factory _$$_DiaryStateCopyWith(
          _$_DiaryState value, $Res Function(_$_DiaryState) then) =
      __$$_DiaryStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Diary diary});

  @override
  $DiaryCopyWith<$Res> get diary;
}

/// @nodoc
class __$$_DiaryStateCopyWithImpl<$Res>
    extends _$DiaryStateCopyWithImpl<$Res, _$_DiaryState>
    implements _$$_DiaryStateCopyWith<$Res> {
  __$$_DiaryStateCopyWithImpl(
      _$_DiaryState _value, $Res Function(_$_DiaryState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? diary = null,
  }) {
    return _then(_$_DiaryState(
      diary: null == diary
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
            other is _$_DiaryState &&
            (identical(other.diary, diary) || other.diary == diary));
  }

  @override
  int get hashCode => Object.hash(runtimeType, diary);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_DiaryStateCopyWith<_$_DiaryState> get copyWith =>
      __$$_DiaryStateCopyWithImpl<_$_DiaryState>(this, _$identity);
}

abstract class _DiaryState extends DiaryState {
  const factory _DiaryState({required final Diary diary}) = _$_DiaryState;
  const _DiaryState._() : super._();

  @override
  Diary get diary;
  @override
  @JsonKey(ignore: true)
  _$$_DiaryStateCopyWith<_$_DiaryState> get copyWith =>
      throw _privateConstructorUsedError;
}
