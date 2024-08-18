// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'number_range.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PillNumberRange {
  int get groupIndex => throw _privateConstructorUsedError;
  int get begin => throw _privateConstructorUsedError;
  int get end => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PillNumberRangeCopyWith<PillNumberRange> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PillNumberRangeCopyWith<$Res> {
  factory $PillNumberRangeCopyWith(
          PillNumberRange value, $Res Function(PillNumberRange) then) =
      _$PillNumberRangeCopyWithImpl<$Res, PillNumberRange>;
  @useResult
  $Res call({int groupIndex, int begin, int end});
}

/// @nodoc
class _$PillNumberRangeCopyWithImpl<$Res, $Val extends PillNumberRange>
    implements $PillNumberRangeCopyWith<$Res> {
  _$PillNumberRangeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupIndex = null,
    Object? begin = null,
    Object? end = null,
  }) {
    return _then(_value.copyWith(
      groupIndex: null == groupIndex
          ? _value.groupIndex
          : groupIndex // ignore: cast_nullable_to_non_nullable
              as int,
      begin: null == begin
          ? _value.begin
          : begin // ignore: cast_nullable_to_non_nullable
              as int,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PillNumberRangeImplCopyWith<$Res>
    implements $PillNumberRangeCopyWith<$Res> {
  factory _$$PillNumberRangeImplCopyWith(_$PillNumberRangeImpl value,
          $Res Function(_$PillNumberRangeImpl) then) =
      __$$PillNumberRangeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int groupIndex, int begin, int end});
}

/// @nodoc
class __$$PillNumberRangeImplCopyWithImpl<$Res>
    extends _$PillNumberRangeCopyWithImpl<$Res, _$PillNumberRangeImpl>
    implements _$$PillNumberRangeImplCopyWith<$Res> {
  __$$PillNumberRangeImplCopyWithImpl(
      _$PillNumberRangeImpl _value, $Res Function(_$PillNumberRangeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupIndex = null,
    Object? begin = null,
    Object? end = null,
  }) {
    return _then(_$PillNumberRangeImpl(
      groupIndex: null == groupIndex
          ? _value.groupIndex
          : groupIndex // ignore: cast_nullable_to_non_nullable
              as int,
      begin: null == begin
          ? _value.begin
          : begin // ignore: cast_nullable_to_non_nullable
              as int,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$PillNumberRangeImpl implements _PillNumberRange {
  const _$PillNumberRangeImpl(
      {required this.groupIndex, required this.begin, required this.end});

  @override
  final int groupIndex;
  @override
  final int begin;
  @override
  final int end;

  @override
  String toString() {
    return 'PillNumberRange(groupIndex: $groupIndex, begin: $begin, end: $end)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PillNumberRangeImpl &&
            (identical(other.groupIndex, groupIndex) ||
                other.groupIndex == groupIndex) &&
            (identical(other.begin, begin) || other.begin == begin) &&
            (identical(other.end, end) || other.end == end));
  }

  @override
  int get hashCode => Object.hash(runtimeType, groupIndex, begin, end);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PillNumberRangeImplCopyWith<_$PillNumberRangeImpl> get copyWith =>
      __$$PillNumberRangeImplCopyWithImpl<_$PillNumberRangeImpl>(
          this, _$identity);
}

abstract class _PillNumberRange implements PillNumberRange {
  const factory _PillNumberRange(
      {required final int groupIndex,
      required final int begin,
      required final int end}) = _$PillNumberRangeImpl;

  @override
  int get groupIndex;
  @override
  int get begin;
  @override
  int get end;
  @override
  @JsonKey(ignore: true)
  _$$PillNumberRangeImplCopyWith<_$PillNumberRangeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
