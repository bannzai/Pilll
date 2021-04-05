// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'menstruation_edit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$MenstruationEditStateTearOff {
  const _$MenstruationEditStateTearOff();

  _MenstruationEditState call({required Menstruation? menstruation}) {
    return _MenstruationEditState(
      menstruation: menstruation,
    );
  }
}

/// @nodoc
const $MenstruationEditState = _$MenstruationEditStateTearOff();

/// @nodoc
mixin _$MenstruationEditState {
  Menstruation? get menstruation => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MenstruationEditStateCopyWith<MenstruationEditState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MenstruationEditStateCopyWith<$Res> {
  factory $MenstruationEditStateCopyWith(MenstruationEditState value,
          $Res Function(MenstruationEditState) then) =
      _$MenstruationEditStateCopyWithImpl<$Res>;
  $Res call({Menstruation? menstruation});

  $MenstruationCopyWith<$Res>? get menstruation;
}

/// @nodoc
class _$MenstruationEditStateCopyWithImpl<$Res>
    implements $MenstruationEditStateCopyWith<$Res> {
  _$MenstruationEditStateCopyWithImpl(this._value, this._then);

  final MenstruationEditState _value;
  // ignore: unused_field
  final $Res Function(MenstruationEditState) _then;

  @override
  $Res call({
    Object? menstruation = freezed,
  }) {
    return _then(_value.copyWith(
      menstruation: menstruation == freezed
          ? _value.menstruation
          : menstruation // ignore: cast_nullable_to_non_nullable
              as Menstruation?,
    ));
  }

  @override
  $MenstruationCopyWith<$Res>? get menstruation {
    if (_value.menstruation == null) {
      return null;
    }

    return $MenstruationCopyWith<$Res>(_value.menstruation!, (value) {
      return _then(_value.copyWith(menstruation: value));
    });
  }
}

/// @nodoc
abstract class _$MenstruationEditStateCopyWith<$Res>
    implements $MenstruationEditStateCopyWith<$Res> {
  factory _$MenstruationEditStateCopyWith(_MenstruationEditState value,
          $Res Function(_MenstruationEditState) then) =
      __$MenstruationEditStateCopyWithImpl<$Res>;
  @override
  $Res call({Menstruation? menstruation});

  @override
  $MenstruationCopyWith<$Res>? get menstruation;
}

/// @nodoc
class __$MenstruationEditStateCopyWithImpl<$Res>
    extends _$MenstruationEditStateCopyWithImpl<$Res>
    implements _$MenstruationEditStateCopyWith<$Res> {
  __$MenstruationEditStateCopyWithImpl(_MenstruationEditState _value,
      $Res Function(_MenstruationEditState) _then)
      : super(_value, (v) => _then(v as _MenstruationEditState));

  @override
  _MenstruationEditState get _value => super._value as _MenstruationEditState;

  @override
  $Res call({
    Object? menstruation = freezed,
  }) {
    return _then(_MenstruationEditState(
      menstruation: menstruation == freezed
          ? _value.menstruation
          : menstruation // ignore: cast_nullable_to_non_nullable
              as Menstruation?,
    ));
  }
}

/// @nodoc
class _$_MenstruationEditState extends _MenstruationEditState {
  _$_MenstruationEditState({required this.menstruation}) : super._();

  @override
  final Menstruation? menstruation;

  @override
  String toString() {
    return 'MenstruationEditState(menstruation: $menstruation)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _MenstruationEditState &&
            (identical(other.menstruation, menstruation) ||
                const DeepCollectionEquality()
                    .equals(other.menstruation, menstruation)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(menstruation);

  @JsonKey(ignore: true)
  @override
  _$MenstruationEditStateCopyWith<_MenstruationEditState> get copyWith =>
      __$MenstruationEditStateCopyWithImpl<_MenstruationEditState>(
          this, _$identity);
}

abstract class _MenstruationEditState extends MenstruationEditState {
  factory _MenstruationEditState({required Menstruation? menstruation}) =
      _$_MenstruationEditState;
  _MenstruationEditState._() : super._();

  @override
  Menstruation? get menstruation => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$MenstruationEditStateCopyWith<_MenstruationEditState> get copyWith =>
      throw _privateConstructorUsedError;
}
