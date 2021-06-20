// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'demographic.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Demographic _$DemographicFromJson(Map<String, dynamic> json) {
  return _Demographic.fromJson(json);
}

/// @nodoc
class _$DemographicTearOff {
  const _$DemographicTearOff();

  _Demographic call(
      {required String purpose1,
      required String purpose2,
      required String prescription,
      required String birthYear,
      required String lifeTime}) {
    return _Demographic(
      purpose1: purpose1,
      purpose2: purpose2,
      prescription: prescription,
      birthYear: birthYear,
      lifeTime: lifeTime,
    );
  }

  Demographic fromJson(Map<String, Object> json) {
    return Demographic.fromJson(json);
  }
}

/// @nodoc
const $Demographic = _$DemographicTearOff();

/// @nodoc
mixin _$Demographic {
  String get purpose1 => throw _privateConstructorUsedError;
  String get purpose2 => throw _privateConstructorUsedError;
  String get prescription => throw _privateConstructorUsedError;
  String get birthYear => throw _privateConstructorUsedError;
  String get lifeTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DemographicCopyWith<Demographic> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DemographicCopyWith<$Res> {
  factory $DemographicCopyWith(
          Demographic value, $Res Function(Demographic) then) =
      _$DemographicCopyWithImpl<$Res>;
  $Res call(
      {String purpose1,
      String purpose2,
      String prescription,
      String birthYear,
      String lifeTime});
}

/// @nodoc
class _$DemographicCopyWithImpl<$Res> implements $DemographicCopyWith<$Res> {
  _$DemographicCopyWithImpl(this._value, this._then);

  final Demographic _value;
  // ignore: unused_field
  final $Res Function(Demographic) _then;

  @override
  $Res call({
    Object? purpose1 = freezed,
    Object? purpose2 = freezed,
    Object? prescription = freezed,
    Object? birthYear = freezed,
    Object? lifeTime = freezed,
  }) {
    return _then(_value.copyWith(
      purpose1: purpose1 == freezed
          ? _value.purpose1
          : purpose1 // ignore: cast_nullable_to_non_nullable
              as String,
      purpose2: purpose2 == freezed
          ? _value.purpose2
          : purpose2 // ignore: cast_nullable_to_non_nullable
              as String,
      prescription: prescription == freezed
          ? _value.prescription
          : prescription // ignore: cast_nullable_to_non_nullable
              as String,
      birthYear: birthYear == freezed
          ? _value.birthYear
          : birthYear // ignore: cast_nullable_to_non_nullable
              as String,
      lifeTime: lifeTime == freezed
          ? _value.lifeTime
          : lifeTime // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$DemographicCopyWith<$Res>
    implements $DemographicCopyWith<$Res> {
  factory _$DemographicCopyWith(
          _Demographic value, $Res Function(_Demographic) then) =
      __$DemographicCopyWithImpl<$Res>;
  @override
  $Res call(
      {String purpose1,
      String purpose2,
      String prescription,
      String birthYear,
      String lifeTime});
}

/// @nodoc
class __$DemographicCopyWithImpl<$Res> extends _$DemographicCopyWithImpl<$Res>
    implements _$DemographicCopyWith<$Res> {
  __$DemographicCopyWithImpl(
      _Demographic _value, $Res Function(_Demographic) _then)
      : super(_value, (v) => _then(v as _Demographic));

  @override
  _Demographic get _value => super._value as _Demographic;

  @override
  $Res call({
    Object? purpose1 = freezed,
    Object? purpose2 = freezed,
    Object? prescription = freezed,
    Object? birthYear = freezed,
    Object? lifeTime = freezed,
  }) {
    return _then(_Demographic(
      purpose1: purpose1 == freezed
          ? _value.purpose1
          : purpose1 // ignore: cast_nullable_to_non_nullable
              as String,
      purpose2: purpose2 == freezed
          ? _value.purpose2
          : purpose2 // ignore: cast_nullable_to_non_nullable
              as String,
      prescription: prescription == freezed
          ? _value.prescription
          : prescription // ignore: cast_nullable_to_non_nullable
              as String,
      birthYear: birthYear == freezed
          ? _value.birthYear
          : birthYear // ignore: cast_nullable_to_non_nullable
              as String,
      lifeTime: lifeTime == freezed
          ? _value.lifeTime
          : lifeTime // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_Demographic extends _Demographic {
  _$_Demographic(
      {required this.purpose1,
      required this.purpose2,
      required this.prescription,
      required this.birthYear,
      required this.lifeTime})
      : super._();

  factory _$_Demographic.fromJson(Map<String, dynamic> json) =>
      _$_$_DemographicFromJson(json);

  @override
  final String purpose1;
  @override
  final String purpose2;
  @override
  final String prescription;
  @override
  final String birthYear;
  @override
  final String lifeTime;

  @override
  String toString() {
    return 'Demographic(purpose1: $purpose1, purpose2: $purpose2, prescription: $prescription, birthYear: $birthYear, lifeTime: $lifeTime)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Demographic &&
            (identical(other.purpose1, purpose1) ||
                const DeepCollectionEquality()
                    .equals(other.purpose1, purpose1)) &&
            (identical(other.purpose2, purpose2) ||
                const DeepCollectionEquality()
                    .equals(other.purpose2, purpose2)) &&
            (identical(other.prescription, prescription) ||
                const DeepCollectionEquality()
                    .equals(other.prescription, prescription)) &&
            (identical(other.birthYear, birthYear) ||
                const DeepCollectionEquality()
                    .equals(other.birthYear, birthYear)) &&
            (identical(other.lifeTime, lifeTime) ||
                const DeepCollectionEquality()
                    .equals(other.lifeTime, lifeTime)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(purpose1) ^
      const DeepCollectionEquality().hash(purpose2) ^
      const DeepCollectionEquality().hash(prescription) ^
      const DeepCollectionEquality().hash(birthYear) ^
      const DeepCollectionEquality().hash(lifeTime);

  @JsonKey(ignore: true)
  @override
  _$DemographicCopyWith<_Demographic> get copyWith =>
      __$DemographicCopyWithImpl<_Demographic>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_DemographicToJson(this);
  }
}

abstract class _Demographic extends Demographic {
  factory _Demographic(
      {required String purpose1,
      required String purpose2,
      required String prescription,
      required String birthYear,
      required String lifeTime}) = _$_Demographic;
  _Demographic._() : super._();

  factory _Demographic.fromJson(Map<String, dynamic> json) =
      _$_Demographic.fromJson;

  @override
  String get purpose1 => throw _privateConstructorUsedError;
  @override
  String get purpose2 => throw _privateConstructorUsedError;
  @override
  String get prescription => throw _privateConstructorUsedError;
  @override
  String get birthYear => throw _privateConstructorUsedError;
  @override
  String get lifeTime => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$DemographicCopyWith<_Demographic> get copyWith =>
      throw _privateConstructorUsedError;
}
