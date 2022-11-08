// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'menstruation_list_state.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$MenstruationListStateTearOff {
  const _$MenstruationListStateTearOff();

  _MenstruationListState call(
      {bool isNotYetLoaded = true,
      List<Menstruation> allMenstruations = const []}) {
    return _MenstruationListState(
      isNotYetLoaded: isNotYetLoaded,
      allMenstruations: allMenstruations,
    );
  }
}

/// @nodoc
const $MenstruationListState = _$MenstruationListStateTearOff();

/// @nodoc
mixin _$MenstruationListState {
  bool get isNotYetLoaded => throw _privateConstructorUsedError;
  List<Menstruation> get allMenstruations => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MenstruationListStateCopyWith<MenstruationListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MenstruationListStateCopyWith<$Res> {
  factory $MenstruationListStateCopyWith(MenstruationListState value,
          $Res Function(MenstruationListState) then) =
      _$MenstruationListStateCopyWithImpl<$Res>;
  $Res call({bool isNotYetLoaded, List<Menstruation> allMenstruations});
}

/// @nodoc
class _$MenstruationListStateCopyWithImpl<$Res>
    implements $MenstruationListStateCopyWith<$Res> {
  _$MenstruationListStateCopyWithImpl(this._value, this._then);

  final MenstruationListState _value;
  // ignore: unused_field
  final $Res Function(MenstruationListState) _then;

  @override
  $Res call({
    Object? isNotYetLoaded = freezed,
    Object? allMenstruations = freezed,
  }) {
    return _then(_value.copyWith(
      isNotYetLoaded: isNotYetLoaded == freezed
          ? _value.isNotYetLoaded
          : isNotYetLoaded // ignore: cast_nullable_to_non_nullable
              as bool,
      allMenstruations: allMenstruations == freezed
          ? _value.allMenstruations
          : allMenstruations // ignore: cast_nullable_to_non_nullable
              as List<Menstruation>,
    ));
  }
}

/// @nodoc
abstract class _$MenstruationListStateCopyWith<$Res>
    implements $MenstruationListStateCopyWith<$Res> {
  factory _$MenstruationListStateCopyWith(_MenstruationListState value,
          $Res Function(_MenstruationListState) then) =
      __$MenstruationListStateCopyWithImpl<$Res>;
  @override
  $Res call({bool isNotYetLoaded, List<Menstruation> allMenstruations});
}

/// @nodoc
class __$MenstruationListStateCopyWithImpl<$Res>
    extends _$MenstruationListStateCopyWithImpl<$Res>
    implements _$MenstruationListStateCopyWith<$Res> {
  __$MenstruationListStateCopyWithImpl(_MenstruationListState _value,
      $Res Function(_MenstruationListState) _then)
      : super(_value, (v) => _then(v as _MenstruationListState));

  @override
  _MenstruationListState get _value => super._value as _MenstruationListState;

  @override
  $Res call({
    Object? isNotYetLoaded = freezed,
    Object? allMenstruations = freezed,
  }) {
    return _then(_MenstruationListState(
      isNotYetLoaded: isNotYetLoaded == freezed
          ? _value.isNotYetLoaded
          : isNotYetLoaded // ignore: cast_nullable_to_non_nullable
              as bool,
      allMenstruations: allMenstruations == freezed
          ? _value.allMenstruations
          : allMenstruations // ignore: cast_nullable_to_non_nullable
              as List<Menstruation>,
    ));
  }
}

/// @nodoc

class _$_MenstruationListState extends _MenstruationListState {
  const _$_MenstruationListState(
      {this.isNotYetLoaded = true, this.allMenstruations = const []})
      : super._();

  @JsonKey()
  @override
  final bool isNotYetLoaded;
  @JsonKey()
  @override
  final List<Menstruation> allMenstruations;

  @override
  String toString() {
    return 'MenstruationListState(isNotYetLoaded: $isNotYetLoaded, allMenstruations: $allMenstruations)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MenstruationListState &&
            const DeepCollectionEquality()
                .equals(other.isNotYetLoaded, isNotYetLoaded) &&
            const DeepCollectionEquality()
                .equals(other.allMenstruations, allMenstruations));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(isNotYetLoaded),
      const DeepCollectionEquality().hash(allMenstruations));

  @JsonKey(ignore: true)
  @override
  _$MenstruationListStateCopyWith<_MenstruationListState> get copyWith =>
      __$MenstruationListStateCopyWithImpl<_MenstruationListState>(
          this, _$identity);
}

abstract class _MenstruationListState extends MenstruationListState {
  const factory _MenstruationListState(
      {bool isNotYetLoaded,
      List<Menstruation> allMenstruations}) = _$_MenstruationListState;
  const _MenstruationListState._() : super._();

  @override
  bool get isNotYetLoaded;
  @override
  List<Menstruation> get allMenstruations;
  @override
  @JsonKey(ignore: true)
  _$MenstruationListStateCopyWith<_MenstruationListState> get copyWith =>
      throw _privateConstructorUsedError;
}
