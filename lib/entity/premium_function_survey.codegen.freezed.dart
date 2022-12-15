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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PremiumFunctionSurvey _$PremiumFunctionSurveyFromJson(
    Map<String, dynamic> json) {
  return _PremiumFunctionSurvey.fromJson(json);
}

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
      _$PremiumFunctionSurveyCopyWithImpl<$Res, PremiumFunctionSurvey>;
  @useResult
  $Res call({List<PremiumFunctionSurveyElementType> elements, String message});
}

/// @nodoc
class _$PremiumFunctionSurveyCopyWithImpl<$Res,
        $Val extends PremiumFunctionSurvey>
    implements $PremiumFunctionSurveyCopyWith<$Res> {
  _$PremiumFunctionSurveyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? elements = null,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      elements: null == elements
          ? _value.elements
          : elements // ignore: cast_nullable_to_non_nullable
              as List<PremiumFunctionSurveyElementType>,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PremiumFunctionSurveyCopyWith<$Res>
    implements $PremiumFunctionSurveyCopyWith<$Res> {
  factory _$$_PremiumFunctionSurveyCopyWith(_$_PremiumFunctionSurvey value,
          $Res Function(_$_PremiumFunctionSurvey) then) =
      __$$_PremiumFunctionSurveyCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<PremiumFunctionSurveyElementType> elements, String message});
}

/// @nodoc
class __$$_PremiumFunctionSurveyCopyWithImpl<$Res>
    extends _$PremiumFunctionSurveyCopyWithImpl<$Res, _$_PremiumFunctionSurvey>
    implements _$$_PremiumFunctionSurveyCopyWith<$Res> {
  __$$_PremiumFunctionSurveyCopyWithImpl(_$_PremiumFunctionSurvey _value,
      $Res Function(_$_PremiumFunctionSurvey) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? elements = null,
    Object? message = null,
  }) {
    return _then(_$_PremiumFunctionSurvey(
      elements: null == elements
          ? _value._elements
          : elements // ignore: cast_nullable_to_non_nullable
              as List<PremiumFunctionSurveyElementType>,
      message: null == message
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
      {required final List<PremiumFunctionSurveyElementType> elements,
      required this.message})
      : _elements = elements,
        super._();

  factory _$_PremiumFunctionSurvey.fromJson(Map<String, dynamic> json) =>
      _$$_PremiumFunctionSurveyFromJson(json);

  final List<PremiumFunctionSurveyElementType> _elements;
  @override
  List<PremiumFunctionSurveyElementType> get elements {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_elements);
  }

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
            other is _$_PremiumFunctionSurvey &&
            const DeepCollectionEquality().equals(other._elements, _elements) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_elements), message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PremiumFunctionSurveyCopyWith<_$_PremiumFunctionSurvey> get copyWith =>
      __$$_PremiumFunctionSurveyCopyWithImpl<_$_PremiumFunctionSurvey>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PremiumFunctionSurveyToJson(
      this,
    );
  }
}

abstract class _PremiumFunctionSurvey extends PremiumFunctionSurvey {
  const factory _PremiumFunctionSurvey(
      {required final List<PremiumFunctionSurveyElementType> elements,
      required final String message}) = _$_PremiumFunctionSurvey;
  const _PremiumFunctionSurvey._() : super._();

  factory _PremiumFunctionSurvey.fromJson(Map<String, dynamic> json) =
      _$_PremiumFunctionSurvey.fromJson;

  @override
  List<PremiumFunctionSurveyElementType> get elements;
  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$_PremiumFunctionSurveyCopyWith<_$_PremiumFunctionSurvey> get copyWith =>
      throw _privateConstructorUsedError;
}
