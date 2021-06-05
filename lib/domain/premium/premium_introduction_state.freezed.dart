// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'premium_introduction_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PremiumIntroductionStateTearOff {
  const _$PremiumIntroductionStateTearOff();

  _PremiumIntroductionState call({Offerings? offerings}) {
    return _PremiumIntroductionState(
      offerings: offerings,
    );
  }
}

/// @nodoc
const $PremiumIntroductionState = _$PremiumIntroductionStateTearOff();

/// @nodoc
mixin _$PremiumIntroductionState {
  Offerings? get offerings => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PremiumIntroductionStateCopyWith<PremiumIntroductionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PremiumIntroductionStateCopyWith<$Res> {
  factory $PremiumIntroductionStateCopyWith(PremiumIntroductionState value,
          $Res Function(PremiumIntroductionState) then) =
      _$PremiumIntroductionStateCopyWithImpl<$Res>;
  $Res call({Offerings? offerings});
}

/// @nodoc
class _$PremiumIntroductionStateCopyWithImpl<$Res>
    implements $PremiumIntroductionStateCopyWith<$Res> {
  _$PremiumIntroductionStateCopyWithImpl(this._value, this._then);

  final PremiumIntroductionState _value;
  // ignore: unused_field
  final $Res Function(PremiumIntroductionState) _then;

  @override
  $Res call({
    Object? offerings = freezed,
  }) {
    return _then(_value.copyWith(
      offerings: offerings == freezed
          ? _value.offerings
          : offerings // ignore: cast_nullable_to_non_nullable
              as Offerings?,
    ));
  }
}

/// @nodoc
abstract class _$PremiumIntroductionStateCopyWith<$Res>
    implements $PremiumIntroductionStateCopyWith<$Res> {
  factory _$PremiumIntroductionStateCopyWith(_PremiumIntroductionState value,
          $Res Function(_PremiumIntroductionState) then) =
      __$PremiumIntroductionStateCopyWithImpl<$Res>;
  @override
  $Res call({Offerings? offerings});
}

/// @nodoc
class __$PremiumIntroductionStateCopyWithImpl<$Res>
    extends _$PremiumIntroductionStateCopyWithImpl<$Res>
    implements _$PremiumIntroductionStateCopyWith<$Res> {
  __$PremiumIntroductionStateCopyWithImpl(_PremiumIntroductionState _value,
      $Res Function(_PremiumIntroductionState) _then)
      : super(_value, (v) => _then(v as _PremiumIntroductionState));

  @override
  _PremiumIntroductionState get _value =>
      super._value as _PremiumIntroductionState;

  @override
  $Res call({
    Object? offerings = freezed,
  }) {
    return _then(_PremiumIntroductionState(
      offerings: offerings == freezed
          ? _value.offerings
          : offerings // ignore: cast_nullable_to_non_nullable
              as Offerings?,
    ));
  }
}

/// @nodoc

class _$_PremiumIntroductionState extends _PremiumIntroductionState {
  _$_PremiumIntroductionState({this.offerings}) : super._();

  @override
  final Offerings? offerings;

  @override
  String toString() {
    return 'PremiumIntroductionState(offerings: $offerings)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _PremiumIntroductionState &&
            (identical(other.offerings, offerings) ||
                const DeepCollectionEquality()
                    .equals(other.offerings, offerings)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(offerings);

  @JsonKey(ignore: true)
  @override
  _$PremiumIntroductionStateCopyWith<_PremiumIntroductionState> get copyWith =>
      __$PremiumIntroductionStateCopyWithImpl<_PremiumIntroductionState>(
          this, _$identity);
}

abstract class _PremiumIntroductionState extends PremiumIntroductionState {
  factory _PremiumIntroductionState({Offerings? offerings}) =
      _$_PremiumIntroductionState;
  _PremiumIntroductionState._() : super._();

  @override
  Offerings? get offerings => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$PremiumIntroductionStateCopyWith<_PremiumIntroductionState> get copyWith =>
      throw _privateConstructorUsedError;
}
