// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'menstruation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$MenstruationStateTearOff {
  const _$MenstruationStateTearOff();

  _MenstruationState call(
      {bool isNotYetLoaded = true,
      required DateTime targetDate,
      List<Menstruation> entities = const []}) {
    return _MenstruationState(
      isNotYetLoaded: isNotYetLoaded,
      targetDate: targetDate,
      entities: entities,
    );
  }
}

/// @nodoc
const $MenstruationState = _$MenstruationStateTearOff();

/// @nodoc
mixin _$MenstruationState {
  bool get isNotYetLoaded => throw _privateConstructorUsedError;
  DateTime get targetDate => throw _privateConstructorUsedError;
  List<Menstruation> get entities => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MenstruationStateCopyWith<MenstruationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MenstruationStateCopyWith<$Res> {
  factory $MenstruationStateCopyWith(
          MenstruationState value, $Res Function(MenstruationState) then) =
      _$MenstruationStateCopyWithImpl<$Res>;
  $Res call(
      {bool isNotYetLoaded, DateTime targetDate, List<Menstruation> entities});
}

/// @nodoc
class _$MenstruationStateCopyWithImpl<$Res>
    implements $MenstruationStateCopyWith<$Res> {
  _$MenstruationStateCopyWithImpl(this._value, this._then);

  final MenstruationState _value;
  // ignore: unused_field
  final $Res Function(MenstruationState) _then;

  @override
  $Res call({
    Object? isNotYetLoaded = freezed,
    Object? targetDate = freezed,
    Object? entities = freezed,
  }) {
    return _then(_value.copyWith(
      isNotYetLoaded: isNotYetLoaded == freezed
          ? _value.isNotYetLoaded
          : isNotYetLoaded // ignore: cast_nullable_to_non_nullable
              as bool,
      targetDate: targetDate == freezed
          ? _value.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      entities: entities == freezed
          ? _value.entities
          : entities // ignore: cast_nullable_to_non_nullable
              as List<Menstruation>,
    ));
  }
}

/// @nodoc
abstract class _$MenstruationStateCopyWith<$Res>
    implements $MenstruationStateCopyWith<$Res> {
  factory _$MenstruationStateCopyWith(
          _MenstruationState value, $Res Function(_MenstruationState) then) =
      __$MenstruationStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {bool isNotYetLoaded, DateTime targetDate, List<Menstruation> entities});
}

/// @nodoc
class __$MenstruationStateCopyWithImpl<$Res>
    extends _$MenstruationStateCopyWithImpl<$Res>
    implements _$MenstruationStateCopyWith<$Res> {
  __$MenstruationStateCopyWithImpl(
      _MenstruationState _value, $Res Function(_MenstruationState) _then)
      : super(_value, (v) => _then(v as _MenstruationState));

  @override
  _MenstruationState get _value => super._value as _MenstruationState;

  @override
  $Res call({
    Object? isNotYetLoaded = freezed,
    Object? targetDate = freezed,
    Object? entities = freezed,
  }) {
    return _then(_MenstruationState(
      isNotYetLoaded: isNotYetLoaded == freezed
          ? _value.isNotYetLoaded
          : isNotYetLoaded // ignore: cast_nullable_to_non_nullable
              as bool,
      targetDate: targetDate == freezed
          ? _value.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      entities: entities == freezed
          ? _value.entities
          : entities // ignore: cast_nullable_to_non_nullable
              as List<Menstruation>,
    ));
  }
}

/// @nodoc
class _$_MenstruationState extends _MenstruationState {
  _$_MenstruationState(
      {this.isNotYetLoaded = true,
      required this.targetDate,
      this.entities = const []})
      : super._();

  @JsonKey(defaultValue: true)
  @override
  final bool isNotYetLoaded;
  @override
  final DateTime targetDate;
  @JsonKey(defaultValue: const [])
  @override
  final List<Menstruation> entities;

  @override
  String toString() {
    return 'MenstruationState(isNotYetLoaded: $isNotYetLoaded, targetDate: $targetDate, entities: $entities)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _MenstruationState &&
            (identical(other.isNotYetLoaded, isNotYetLoaded) ||
                const DeepCollectionEquality()
                    .equals(other.isNotYetLoaded, isNotYetLoaded)) &&
            (identical(other.targetDate, targetDate) ||
                const DeepCollectionEquality()
                    .equals(other.targetDate, targetDate)) &&
            (identical(other.entities, entities) ||
                const DeepCollectionEquality()
                    .equals(other.entities, entities)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(isNotYetLoaded) ^
      const DeepCollectionEquality().hash(targetDate) ^
      const DeepCollectionEquality().hash(entities);

  @JsonKey(ignore: true)
  @override
  _$MenstruationStateCopyWith<_MenstruationState> get copyWith =>
      __$MenstruationStateCopyWithImpl<_MenstruationState>(this, _$identity);
}

abstract class _MenstruationState extends MenstruationState {
  factory _MenstruationState(
      {bool isNotYetLoaded,
      required DateTime targetDate,
      List<Menstruation> entities}) = _$_MenstruationState;
  _MenstruationState._() : super._();

  @override
  bool get isNotYetLoaded => throw _privateConstructorUsedError;
  @override
  DateTime get targetDate => throw _privateConstructorUsedError;
  @override
  List<Menstruation> get entities => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$MenstruationStateCopyWith<_MenstruationState> get copyWith =>
      throw _privateConstructorUsedError;
}
