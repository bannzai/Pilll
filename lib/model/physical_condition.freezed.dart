// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'physical_condition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
PhysicalCondition _$PhysicalConditionFromJson(Map<String, dynamic> json) {
  return _PhysicalCondition.fromJson(json);
}

/// @nodoc
class _$PhysicalConditionTearOff {
  const _$PhysicalConditionTearOff();

// ignore: unused_element
  _PhysicalCondition call({@required String name}) {
    return _PhysicalCondition(
      name: name,
    );
  }

// ignore: unused_element
  PhysicalCondition fromJson(Map<String, Object> json) {
    return PhysicalCondition.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $PhysicalCondition = _$PhysicalConditionTearOff();

/// @nodoc
mixin _$PhysicalCondition {
  String get name;

  Map<String, dynamic> toJson();
  $PhysicalConditionCopyWith<PhysicalCondition> get copyWith;
}

/// @nodoc
abstract class $PhysicalConditionCopyWith<$Res> {
  factory $PhysicalConditionCopyWith(
          PhysicalCondition value, $Res Function(PhysicalCondition) then) =
      _$PhysicalConditionCopyWithImpl<$Res>;
  $Res call({String name});
}

/// @nodoc
class _$PhysicalConditionCopyWithImpl<$Res>
    implements $PhysicalConditionCopyWith<$Res> {
  _$PhysicalConditionCopyWithImpl(this._value, this._then);

  final PhysicalCondition _value;
  // ignore: unused_field
  final $Res Function(PhysicalCondition) _then;

  @override
  $Res call({
    Object name = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed ? _value.name : name as String,
    ));
  }
}

/// @nodoc
abstract class _$PhysicalConditionCopyWith<$Res>
    implements $PhysicalConditionCopyWith<$Res> {
  factory _$PhysicalConditionCopyWith(
          _PhysicalCondition value, $Res Function(_PhysicalCondition) then) =
      __$PhysicalConditionCopyWithImpl<$Res>;
  @override
  $Res call({String name});
}

/// @nodoc
class __$PhysicalConditionCopyWithImpl<$Res>
    extends _$PhysicalConditionCopyWithImpl<$Res>
    implements _$PhysicalConditionCopyWith<$Res> {
  __$PhysicalConditionCopyWithImpl(
      _PhysicalCondition _value, $Res Function(_PhysicalCondition) _then)
      : super(_value, (v) => _then(v as _PhysicalCondition));

  @override
  _PhysicalCondition get _value => super._value as _PhysicalCondition;

  @override
  $Res call({
    Object name = freezed,
  }) {
    return _then(_PhysicalCondition(
      name: name == freezed ? _value.name : name as String,
    ));
  }
}

@JsonSerializable(nullable: false, explicitToJson: true)

/// @nodoc
class _$_PhysicalCondition implements _PhysicalCondition {
  _$_PhysicalCondition({@required this.name}) : assert(name != null);

  factory _$_PhysicalCondition.fromJson(Map<String, dynamic> json) =>
      _$_$_PhysicalConditionFromJson(json);

  @override
  final String name;

  @override
  String toString() {
    return 'PhysicalCondition(name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _PhysicalCondition &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(name);

  @override
  _$PhysicalConditionCopyWith<_PhysicalCondition> get copyWith =>
      __$PhysicalConditionCopyWithImpl<_PhysicalCondition>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_PhysicalConditionToJson(this);
  }
}

abstract class _PhysicalCondition implements PhysicalCondition {
  factory _PhysicalCondition({@required String name}) = _$_PhysicalCondition;

  factory _PhysicalCondition.fromJson(Map<String, dynamic> json) =
      _$_PhysicalCondition.fromJson;

  @override
  String get name;
  @override
  _$PhysicalConditionCopyWith<_PhysicalCondition> get copyWith;
}
