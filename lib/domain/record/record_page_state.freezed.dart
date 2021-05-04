// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'record_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$RecordPageStateTearOff {
  const _$RecordPageStateTearOff();

  _RecordPageState call({required PillSheetModel? entity}) {
    return _RecordPageState(
      entity: entity,
    );
  }
}

/// @nodoc
const $RecordPageState = _$RecordPageStateTearOff();

/// @nodoc
mixin _$RecordPageState {
  PillSheetModel? get entity => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RecordPageStateCopyWith<RecordPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecordPageStateCopyWith<$Res> {
  factory $RecordPageStateCopyWith(
          RecordPageState value, $Res Function(RecordPageState) then) =
      _$RecordPageStateCopyWithImpl<$Res>;
  $Res call({PillSheetModel? entity});

  $PillSheetModelCopyWith<$Res>? get entity;
}

/// @nodoc
class _$RecordPageStateCopyWithImpl<$Res>
    implements $RecordPageStateCopyWith<$Res> {
  _$RecordPageStateCopyWithImpl(this._value, this._then);

  final RecordPageState _value;
  // ignore: unused_field
  final $Res Function(RecordPageState) _then;

  @override
  $Res call({
    Object? entity = freezed,
  }) {
    return _then(_value.copyWith(
      entity: entity == freezed
          ? _value.entity
          : entity // ignore: cast_nullable_to_non_nullable
              as PillSheetModel?,
    ));
  }

  @override
  $PillSheetModelCopyWith<$Res>? get entity {
    if (_value.entity == null) {
      return null;
    }

    return $PillSheetModelCopyWith<$Res>(_value.entity!, (value) {
      return _then(_value.copyWith(entity: value));
    });
  }
}

/// @nodoc
abstract class _$RecordPageStateCopyWith<$Res>
    implements $RecordPageStateCopyWith<$Res> {
  factory _$RecordPageStateCopyWith(
          _RecordPageState value, $Res Function(_RecordPageState) then) =
      __$RecordPageStateCopyWithImpl<$Res>;
  @override
  $Res call({PillSheetModel? entity});

  @override
  $PillSheetModelCopyWith<$Res>? get entity;
}

/// @nodoc
class __$RecordPageStateCopyWithImpl<$Res>
    extends _$RecordPageStateCopyWithImpl<$Res>
    implements _$RecordPageStateCopyWith<$Res> {
  __$RecordPageStateCopyWithImpl(
      _RecordPageState _value, $Res Function(_RecordPageState) _then)
      : super(_value, (v) => _then(v as _RecordPageState));

  @override
  _RecordPageState get _value => super._value as _RecordPageState;

  @override
  $Res call({
    Object? entity = freezed,
  }) {
    return _then(_RecordPageState(
      entity: entity == freezed
          ? _value.entity
          : entity // ignore: cast_nullable_to_non_nullable
              as PillSheetModel?,
    ));
  }
}

/// @nodoc

class _$_RecordPageState extends _RecordPageState {
  _$_RecordPageState({required this.entity}) : super._();

  @override
  final PillSheetModel? entity;

  @override
  String toString() {
    return 'RecordPageState(entity: $entity)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _RecordPageState &&
            (identical(other.entity, entity) ||
                const DeepCollectionEquality().equals(other.entity, entity)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(entity);

  @JsonKey(ignore: true)
  @override
  _$RecordPageStateCopyWith<_RecordPageState> get copyWith =>
      __$RecordPageStateCopyWithImpl<_RecordPageState>(this, _$identity);
}

abstract class _RecordPageState extends RecordPageState {
  factory _RecordPageState({required PillSheetModel? entity}) =
      _$_RecordPageState;
  _RecordPageState._() : super._();

  @override
  PillSheetModel? get entity => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$RecordPageStateCopyWith<_RecordPageState> get copyWith =>
      throw _privateConstructorUsedError;
}
