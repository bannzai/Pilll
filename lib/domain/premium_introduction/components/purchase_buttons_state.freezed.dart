// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'purchase_buttons_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PurchaseButtonsStateTearOff {
  const _$PurchaseButtonsStateTearOff();

  _PurchaseButtonsState call(
      {required Offerings offerings,
      required bool hasDiscountEntitlement,
      required bool isOverDiscountDeadline}) {
    return _PurchaseButtonsState(
      offerings: offerings,
      hasDiscountEntitlement: hasDiscountEntitlement,
      isOverDiscountDeadline: isOverDiscountDeadline,
    );
  }
}

/// @nodoc
const $PurchaseButtonsState = _$PurchaseButtonsStateTearOff();

/// @nodoc
mixin _$PurchaseButtonsState {
  Offerings get offerings => throw _privateConstructorUsedError;
  bool get hasDiscountEntitlement => throw _privateConstructorUsedError;
  bool get isOverDiscountDeadline => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PurchaseButtonsStateCopyWith<PurchaseButtonsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseButtonsStateCopyWith<$Res> {
  factory $PurchaseButtonsStateCopyWith(PurchaseButtonsState value,
          $Res Function(PurchaseButtonsState) then) =
      _$PurchaseButtonsStateCopyWithImpl<$Res>;
  $Res call(
      {Offerings offerings,
      bool hasDiscountEntitlement,
      bool isOverDiscountDeadline});
}

/// @nodoc
class _$PurchaseButtonsStateCopyWithImpl<$Res>
    implements $PurchaseButtonsStateCopyWith<$Res> {
  _$PurchaseButtonsStateCopyWithImpl(this._value, this._then);

  final PurchaseButtonsState _value;
  // ignore: unused_field
  final $Res Function(PurchaseButtonsState) _then;

  @override
  $Res call({
    Object? offerings = freezed,
    Object? hasDiscountEntitlement = freezed,
    Object? isOverDiscountDeadline = freezed,
  }) {
    return _then(_value.copyWith(
      offerings: offerings == freezed
          ? _value.offerings
          : offerings // ignore: cast_nullable_to_non_nullable
              as Offerings,
      hasDiscountEntitlement: hasDiscountEntitlement == freezed
          ? _value.hasDiscountEntitlement
          : hasDiscountEntitlement // ignore: cast_nullable_to_non_nullable
              as bool,
      isOverDiscountDeadline: isOverDiscountDeadline == freezed
          ? _value.isOverDiscountDeadline
          : isOverDiscountDeadline // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$PurchaseButtonsStateCopyWith<$Res>
    implements $PurchaseButtonsStateCopyWith<$Res> {
  factory _$PurchaseButtonsStateCopyWith(_PurchaseButtonsState value,
          $Res Function(_PurchaseButtonsState) then) =
      __$PurchaseButtonsStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {Offerings offerings,
      bool hasDiscountEntitlement,
      bool isOverDiscountDeadline});
}

/// @nodoc
class __$PurchaseButtonsStateCopyWithImpl<$Res>
    extends _$PurchaseButtonsStateCopyWithImpl<$Res>
    implements _$PurchaseButtonsStateCopyWith<$Res> {
  __$PurchaseButtonsStateCopyWithImpl(
      _PurchaseButtonsState _value, $Res Function(_PurchaseButtonsState) _then)
      : super(_value, (v) => _then(v as _PurchaseButtonsState));

  @override
  _PurchaseButtonsState get _value => super._value as _PurchaseButtonsState;

  @override
  $Res call({
    Object? offerings = freezed,
    Object? hasDiscountEntitlement = freezed,
    Object? isOverDiscountDeadline = freezed,
  }) {
    return _then(_PurchaseButtonsState(
      offerings: offerings == freezed
          ? _value.offerings
          : offerings // ignore: cast_nullable_to_non_nullable
              as Offerings,
      hasDiscountEntitlement: hasDiscountEntitlement == freezed
          ? _value.hasDiscountEntitlement
          : hasDiscountEntitlement // ignore: cast_nullable_to_non_nullable
              as bool,
      isOverDiscountDeadline: isOverDiscountDeadline == freezed
          ? _value.isOverDiscountDeadline
          : isOverDiscountDeadline // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_PurchaseButtonsState extends _PurchaseButtonsState {
  const _$_PurchaseButtonsState(
      {required this.offerings,
      required this.hasDiscountEntitlement,
      required this.isOverDiscountDeadline})
      : super._();

  @override
  final Offerings offerings;
  @override
  final bool hasDiscountEntitlement;
  @override
  final bool isOverDiscountDeadline;

  @override
  String toString() {
    return 'PurchaseButtonsState(offerings: $offerings, hasDiscountEntitlement: $hasDiscountEntitlement, isOverDiscountDeadline: $isOverDiscountDeadline)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PurchaseButtonsState &&
            const DeepCollectionEquality().equals(other.offerings, offerings) &&
            const DeepCollectionEquality()
                .equals(other.hasDiscountEntitlement, hasDiscountEntitlement) &&
            const DeepCollectionEquality()
                .equals(other.isOverDiscountDeadline, isOverDiscountDeadline));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(offerings),
      const DeepCollectionEquality().hash(hasDiscountEntitlement),
      const DeepCollectionEquality().hash(isOverDiscountDeadline));

  @JsonKey(ignore: true)
  @override
  _$PurchaseButtonsStateCopyWith<_PurchaseButtonsState> get copyWith =>
      __$PurchaseButtonsStateCopyWithImpl<_PurchaseButtonsState>(
          this, _$identity);
}

abstract class _PurchaseButtonsState extends PurchaseButtonsState {
  const factory _PurchaseButtonsState(
      {required Offerings offerings,
      required bool hasDiscountEntitlement,
      required bool isOverDiscountDeadline}) = _$_PurchaseButtonsState;
  const _PurchaseButtonsState._() : super._();

  @override
  Offerings get offerings;
  @override
  bool get hasDiscountEntitlement;
  @override
  bool get isOverDiscountDeadline;
  @override
  @JsonKey(ignore: true)
  _$PurchaseButtonsStateCopyWith<_PurchaseButtonsState> get copyWith =>
      throw _privateConstructorUsedError;
}
