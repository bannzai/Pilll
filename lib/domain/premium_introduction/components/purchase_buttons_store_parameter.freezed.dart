// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'purchase_buttons_store_parameter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PurchaseButtonsStoreParameterTearOff {
  const _$PurchaseButtonsStoreParameterTearOff();

  _PurchaseButtonsStoreParameter call(
      {required Offerings offerings, required DateTime? trialDeadlineDate}) {
    return _PurchaseButtonsStoreParameter(
      offerings: offerings,
      trialDeadlineDate: trialDeadlineDate,
    );
  }
}

/// @nodoc
const $PurchaseButtonsStoreParameter = _$PurchaseButtonsStoreParameterTearOff();

/// @nodoc
mixin _$PurchaseButtonsStoreParameter {
  Offerings get offerings => throw _privateConstructorUsedError;
  DateTime? get trialDeadlineDate => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PurchaseButtonsStoreParameterCopyWith<PurchaseButtonsStoreParameter>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseButtonsStoreParameterCopyWith<$Res> {
  factory $PurchaseButtonsStoreParameterCopyWith(
          PurchaseButtonsStoreParameter value,
          $Res Function(PurchaseButtonsStoreParameter) then) =
      _$PurchaseButtonsStoreParameterCopyWithImpl<$Res>;
  $Res call({Offerings offerings, DateTime? trialDeadlineDate});
}

/// @nodoc
class _$PurchaseButtonsStoreParameterCopyWithImpl<$Res>
    implements $PurchaseButtonsStoreParameterCopyWith<$Res> {
  _$PurchaseButtonsStoreParameterCopyWithImpl(this._value, this._then);

  final PurchaseButtonsStoreParameter _value;
  // ignore: unused_field
  final $Res Function(PurchaseButtonsStoreParameter) _then;

  @override
  $Res call({
    Object? offerings = freezed,
    Object? trialDeadlineDate = freezed,
  }) {
    return _then(_value.copyWith(
      offerings: offerings == freezed
          ? _value.offerings
          : offerings // ignore: cast_nullable_to_non_nullable
              as Offerings,
      trialDeadlineDate: trialDeadlineDate == freezed
          ? _value.trialDeadlineDate
          : trialDeadlineDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
abstract class _$PurchaseButtonsStoreParameterCopyWith<$Res>
    implements $PurchaseButtonsStoreParameterCopyWith<$Res> {
  factory _$PurchaseButtonsStoreParameterCopyWith(
          _PurchaseButtonsStoreParameter value,
          $Res Function(_PurchaseButtonsStoreParameter) then) =
      __$PurchaseButtonsStoreParameterCopyWithImpl<$Res>;
  @override
  $Res call({Offerings offerings, DateTime? trialDeadlineDate});
}

/// @nodoc
class __$PurchaseButtonsStoreParameterCopyWithImpl<$Res>
    extends _$PurchaseButtonsStoreParameterCopyWithImpl<$Res>
    implements _$PurchaseButtonsStoreParameterCopyWith<$Res> {
  __$PurchaseButtonsStoreParameterCopyWithImpl(
      _PurchaseButtonsStoreParameter _value,
      $Res Function(_PurchaseButtonsStoreParameter) _then)
      : super(_value, (v) => _then(v as _PurchaseButtonsStoreParameter));

  @override
  _PurchaseButtonsStoreParameter get _value =>
      super._value as _PurchaseButtonsStoreParameter;

  @override
  $Res call({
    Object? offerings = freezed,
    Object? trialDeadlineDate = freezed,
  }) {
    return _then(_PurchaseButtonsStoreParameter(
      offerings: offerings == freezed
          ? _value.offerings
          : offerings // ignore: cast_nullable_to_non_nullable
              as Offerings,
      trialDeadlineDate: trialDeadlineDate == freezed
          ? _value.trialDeadlineDate
          : trialDeadlineDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$_PurchaseButtonsStoreParameter
    implements _PurchaseButtonsStoreParameter {
  _$_PurchaseButtonsStoreParameter(
      {required this.offerings, required this.trialDeadlineDate});

  @override
  final Offerings offerings;
  @override
  final DateTime? trialDeadlineDate;

  @override
  String toString() {
    return 'PurchaseButtonsStoreParameter(offerings: $offerings, trialDeadlineDate: $trialDeadlineDate)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _PurchaseButtonsStoreParameter &&
            (identical(other.offerings, offerings) ||
                const DeepCollectionEquality()
                    .equals(other.offerings, offerings)) &&
            (identical(other.trialDeadlineDate, trialDeadlineDate) ||
                const DeepCollectionEquality()
                    .equals(other.trialDeadlineDate, trialDeadlineDate)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(offerings) ^
      const DeepCollectionEquality().hash(trialDeadlineDate);

  @JsonKey(ignore: true)
  @override
  _$PurchaseButtonsStoreParameterCopyWith<_PurchaseButtonsStoreParameter>
      get copyWith => __$PurchaseButtonsStoreParameterCopyWithImpl<
          _PurchaseButtonsStoreParameter>(this, _$identity);
}

abstract class _PurchaseButtonsStoreParameter
    implements PurchaseButtonsStoreParameter {
  factory _PurchaseButtonsStoreParameter(
      {required Offerings offerings,
      required DateTime? trialDeadlineDate}) = _$_PurchaseButtonsStoreParameter;

  @override
  Offerings get offerings => throw _privateConstructorUsedError;
  @override
  DateTime? get trialDeadlineDate => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$PurchaseButtonsStoreParameterCopyWith<_PurchaseButtonsStoreParameter>
      get copyWith => throw _privateConstructorUsedError;
}
