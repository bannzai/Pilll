// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'premium_function_survey.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PremiumFunctionSurvey _$PremiumFunctionSurveyFromJson(
    Map<String, dynamic> json) {
  return _PremiumFunctionSurvey.fromJson(json);
}

/// @nodoc
class _$PremiumFunctionSurveyTearOff {
  const _$PremiumFunctionSurveyTearOff();

  _PremiumFunctionSurvey call(
      {required List<PremiumFunctionSurveyElementType> elements,
      required String message}) {
    return _PremiumFunctionSurvey(
      elements: elements,
      message: message,
    );
  }

  PremiumFunctionSurvey fromJson(Map<String, Object?> json) {
    return PremiumFunctionSurvey.fromJson(json);
  }
}

/// @nodoc
const $PremiumFunctionSurvey = _$PremiumFunctionSurveyTearOff();

/// @nodoc
mixin _$PremiumFunctionSurvey {
  List<PremiumFunctionSurveyElementType> get elements =>
      throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PremiumFunctionSurveyCopyWith<PremiumFunctionSurvey> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PremiumFunctionSurveyCopyWith<$Res> {
  factory $PremiumFunctionSurveyCopyWith(PremiumFunctionSurvey value,
          $Res Function(PremiumFunctionSurvey) then) =
      _$PremiumFunctionSurveyCopyWithImpl<$Res>;
  $Res call({List<PremiumFunctionSurveyElementType> elements, String message});
}

/// @nodoc
class _$PremiumFunctionSurveyCopyWithImpl<$Res>
    implements $PremiumFunctionSurveyCopyWith<$Res> {
  _$PremiumFunctionSurveyCopyWithImpl(this._value, this._then);

  final PremiumFunctionSurvey _value;
  // ignore: unused_field
  final $Res Function(PremiumFunctionSurvey) _then;

  @override
  $Res call({
    Object? elements = freezed,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      elements: elements == freezed
          ? _value.elements
          : elements // ignore: cast_nullable_to_non_nullable
              as List<PremiumFunctionSurveyElementType>,
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$PremiumFunctionSurveyCopyWith<$Res>
    implements $PremiumFunctionSurveyCopyWith<$Res> {
  factory _$PremiumFunctionSurveyCopyWith(_PremiumFunctionSurvey value,
          $Res Function(_PremiumFunctionSurvey) then) =
      __$PremiumFunctionSurveyCopyWithImpl<$Res>;
  @override
  $Res call({List<PremiumFunctionSurveyElementType> elements, String message});
}

/// @nodoc
class __$PremiumFunctionSurveyCopyWithImpl<$Res>
    extends _$PremiumFunctionSurveyCopyWithImpl<$Res>
    implements _$PremiumFunctionSurveyCopyWith<$Res> {
  __$PremiumFunctionSurveyCopyWithImpl(_PremiumFunctionSurvey _value,
      $Res Function(_PremiumFunctionSurvey) _then)
      : super(_value, (v) => _then(v as _PremiumFunctionSurvey));

  @override
  _PremiumFunctionSurvey get _value => super._value as _PremiumFunctionSurvey;

  @override
  $Res call({
    Object? elements = freezed,
    Object? message = freezed,
  }) {
    return _then(_PremiumFunctionSurvey(
      elements: elements == freezed
          ? _value.elements
          : elements // ignore: cast_nullable_to_non_nullable
              as List<PremiumFunctionSurveyElementType>,
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_PremiumFunctionSurvey extends _PremiumFunctionSurvey {
  const _$_PremiumFunctionSurvey(
      {required this.elements, required this.message})
      : super._();

  factory _$_PremiumFunctionSurvey.fromJson(Map<String, dynamic> json) =>
      _$$_PremiumFunctionSurveyFromJson(json);

  @override
  final List<PremiumFunctionSurveyElementType> elements;
  @override
  final String message;

  @override
  String toString() {
    return 'PremiumFunctionSurvey(elements: $elements, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PremiumFunctionSurvey &&
            const DeepCollectionEquality().equals(other.elements, elements) &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(elements),
      const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$PremiumFunctionSurveyCopyWith<_PremiumFunctionSurvey> get copyWith =>
      __$PremiumFunctionSurveyCopyWithImpl<_PremiumFunctionSurvey>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PremiumFunctionSurveyToJson(this);
  }
}

abstract class _PremiumFunctionSurvey extends PremiumFunctionSurvey {
  const factory _PremiumFunctionSurvey(
      {required List<PremiumFunctionSurveyElementType> elements,
      required String message}) = _$_PremiumFunctionSurvey;
  const _PremiumFunctionSurvey._() : super._();

  factory _PremiumFunctionSurvey.fromJson(Map<String, dynamic> json) =
      _$_PremiumFunctionSurvey.fromJson;

  @override
  List<PremiumFunctionSurveyElementType> get elements;
  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$PremiumFunctionSurveyCopyWith<_PremiumFunctionSurvey> get copyWith =>
      throw _privateConstructorUsedError;
}
