// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'menstruation_card_state.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MenstruationCardState {
  String get title => throw _privateConstructorUsedError;
  DateTime get scheduleDate => throw _privateConstructorUsedError;
  String get countdownString => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MenstruationCardStateCopyWith<MenstruationCardState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MenstruationCardStateCopyWith<$Res> {
  factory $MenstruationCardStateCopyWith(MenstruationCardState value,
          $Res Function(MenstruationCardState) then) =
      _$MenstruationCardStateCopyWithImpl<$Res, MenstruationCardState>;
  @useResult
  $Res call({String title, DateTime scheduleDate, String countdownString});
}

/// @nodoc
class _$MenstruationCardStateCopyWithImpl<$Res,
        $Val extends MenstruationCardState>
    implements $MenstruationCardStateCopyWith<$Res> {
  _$MenstruationCardStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? scheduleDate = null,
    Object? countdownString = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      scheduleDate: null == scheduleDate
          ? _value.scheduleDate
          : scheduleDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      countdownString: null == countdownString
          ? _value.countdownString
          : countdownString // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MenstruationCardStateImplCopyWith<$Res>
    implements $MenstruationCardStateCopyWith<$Res> {
  factory _$$MenstruationCardStateImplCopyWith(
          _$MenstruationCardStateImpl value,
          $Res Function(_$MenstruationCardStateImpl) then) =
      __$$MenstruationCardStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, DateTime scheduleDate, String countdownString});
}

/// @nodoc
class __$$MenstruationCardStateImplCopyWithImpl<$Res>
    extends _$MenstruationCardStateCopyWithImpl<$Res,
        _$MenstruationCardStateImpl>
    implements _$$MenstruationCardStateImplCopyWith<$Res> {
  __$$MenstruationCardStateImplCopyWithImpl(_$MenstruationCardStateImpl _value,
      $Res Function(_$MenstruationCardStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? scheduleDate = null,
    Object? countdownString = null,
  }) {
    return _then(_$MenstruationCardStateImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      scheduleDate: null == scheduleDate
          ? _value.scheduleDate
          : scheduleDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      countdownString: null == countdownString
          ? _value.countdownString
          : countdownString // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$MenstruationCardStateImpl extends _MenstruationCardState {
  const _$MenstruationCardStateImpl(
      {required this.title,
      required this.scheduleDate,
      required this.countdownString})
      : super._();

  @override
  final String title;
  @override
  final DateTime scheduleDate;
  @override
  final String countdownString;

  @override
  String toString() {
    return 'MenstruationCardState(title: $title, scheduleDate: $scheduleDate, countdownString: $countdownString)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MenstruationCardStateImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.scheduleDate, scheduleDate) ||
                other.scheduleDate == scheduleDate) &&
            (identical(other.countdownString, countdownString) ||
                other.countdownString == countdownString));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, title, scheduleDate, countdownString);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MenstruationCardStateImplCopyWith<_$MenstruationCardStateImpl>
      get copyWith => __$$MenstruationCardStateImplCopyWithImpl<
          _$MenstruationCardStateImpl>(this, _$identity);
}

abstract class _MenstruationCardState extends MenstruationCardState {
  const factory _MenstruationCardState(
      {required final String title,
      required final DateTime scheduleDate,
      required final String countdownString}) = _$MenstruationCardStateImpl;
  const _MenstruationCardState._() : super._();

  @override
  String get title;
  @override
  DateTime get scheduleDate;
  @override
  String get countdownString;
  @override
  @JsonKey(ignore: true)
  _$$MenstruationCardStateImplCopyWith<_$MenstruationCardStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
