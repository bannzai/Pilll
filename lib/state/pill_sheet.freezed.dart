// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'pill_sheet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$PillSheetStateTearOff {
  const _$PillSheetStateTearOff();

// ignore: unused_element
  _PillSheetState call({List<PillSheetModel> entities}) {
    return _PillSheetState(
      entities: entities,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $PillSheetState = _$PillSheetStateTearOff();

/// @nodoc
mixin _$PillSheetState {
  List<PillSheetModel> get entities;

  $PillSheetStateCopyWith<PillSheetState> get copyWith;
}

/// @nodoc
abstract class $PillSheetStateCopyWith<$Res> {
  factory $PillSheetStateCopyWith(
          PillSheetState value, $Res Function(PillSheetState) then) =
      _$PillSheetStateCopyWithImpl<$Res>;
  $Res call({List<PillSheetModel> entities});
}

/// @nodoc
class _$PillSheetStateCopyWithImpl<$Res>
    implements $PillSheetStateCopyWith<$Res> {
  _$PillSheetStateCopyWithImpl(this._value, this._then);

  final PillSheetState _value;
  // ignore: unused_field
  final $Res Function(PillSheetState) _then;

  @override
  $Res call({
    Object entities = freezed,
  }) {
    return _then(_value.copyWith(
      entities: entities == freezed
          ? _value.entities
          : entities as List<PillSheetModel>,
    ));
  }
}

/// @nodoc
abstract class _$PillSheetStateCopyWith<$Res>
    implements $PillSheetStateCopyWith<$Res> {
  factory _$PillSheetStateCopyWith(
          _PillSheetState value, $Res Function(_PillSheetState) then) =
      __$PillSheetStateCopyWithImpl<$Res>;
  @override
  $Res call({List<PillSheetModel> entities});
}

/// @nodoc
class __$PillSheetStateCopyWithImpl<$Res>
    extends _$PillSheetStateCopyWithImpl<$Res>
    implements _$PillSheetStateCopyWith<$Res> {
  __$PillSheetStateCopyWithImpl(
      _PillSheetState _value, $Res Function(_PillSheetState) _then)
      : super(_value, (v) => _then(v as _PillSheetState));

  @override
  _PillSheetState get _value => super._value as _PillSheetState;

  @override
  $Res call({
    Object entities = freezed,
  }) {
    return _then(_PillSheetState(
      entities: entities == freezed
          ? _value.entities
          : entities as List<PillSheetModel>,
    ));
  }
}

/// @nodoc
class _$_PillSheetState extends _PillSheetState {
  _$_PillSheetState({this.entities}) : super._();

  @override
  final List<PillSheetModel> entities;

  @override
  String toString() {
    return 'PillSheetState(entities: $entities)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _PillSheetState &&
            (identical(other.entities, entities) ||
                const DeepCollectionEquality()
                    .equals(other.entities, entities)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(entities);

  @override
  _$PillSheetStateCopyWith<_PillSheetState> get copyWith =>
      __$PillSheetStateCopyWithImpl<_PillSheetState>(this, _$identity);
}

abstract class _PillSheetState extends PillSheetState {
  _PillSheetState._() : super._();
  factory _PillSheetState({List<PillSheetModel> entities}) = _$_PillSheetState;

  @override
  List<PillSheetModel> get entities;
  @override
  _$PillSheetStateCopyWith<_PillSheetState> get copyWith;
}
