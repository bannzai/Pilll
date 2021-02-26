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
  _PillSheetState call({PillSheetModel entity}) {
    return _PillSheetState(
      entity: entity,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $PillSheetState = _$PillSheetStateTearOff();

/// @nodoc
mixin _$PillSheetState {
  PillSheetModel get entity;

  $PillSheetStateCopyWith<PillSheetState> get copyWith;
}

/// @nodoc
abstract class $PillSheetStateCopyWith<$Res> {
  factory $PillSheetStateCopyWith(
          PillSheetState value, $Res Function(PillSheetState) then) =
      _$PillSheetStateCopyWithImpl<$Res>;
  $Res call({PillSheetModel entity});

  $PillSheetModelCopyWith<$Res> get entity;
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
    Object entity = freezed,
  }) {
    return _then(_value.copyWith(
      entity: entity == freezed ? _value.entity : entity as PillSheetModel,
    ));
  }

  @override
  $PillSheetModelCopyWith<$Res> get entity {
    if (_value.entity == null) {
      return null;
    }
    return $PillSheetModelCopyWith<$Res>(_value.entity, (value) {
      return _then(_value.copyWith(entity: value));
    });
  }
}

/// @nodoc
abstract class _$PillSheetStateCopyWith<$Res>
    implements $PillSheetStateCopyWith<$Res> {
  factory _$PillSheetStateCopyWith(
          _PillSheetState value, $Res Function(_PillSheetState) then) =
      __$PillSheetStateCopyWithImpl<$Res>;
  @override
  $Res call({PillSheetModel entity});

  @override
  $PillSheetModelCopyWith<$Res> get entity;
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
    Object entity = freezed,
  }) {
    return _then(_PillSheetState(
      entity: entity == freezed ? _value.entity : entity as PillSheetModel,
    ));
  }
}

/// @nodoc
class _$_PillSheetState extends _PillSheetState {
  _$_PillSheetState({this.entity}) : super._();

  @override
  final PillSheetModel entity;

  @override
  String toString() {
    return 'PillSheetState(entity: $entity)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _PillSheetState &&
            (identical(other.entity, entity) ||
                const DeepCollectionEquality().equals(other.entity, entity)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(entity);

  @override
  _$PillSheetStateCopyWith<_PillSheetState> get copyWith =>
      __$PillSheetStateCopyWithImpl<_PillSheetState>(this, _$identity);
}

abstract class _PillSheetState extends PillSheetState {
  _PillSheetState._() : super._();
  factory _PillSheetState({PillSheetModel entity}) = _$_PillSheetState;

  @override
  PillSheetModel get entity;
  @override
  _$PillSheetStateCopyWith<_PillSheetState> get copyWith;
}
