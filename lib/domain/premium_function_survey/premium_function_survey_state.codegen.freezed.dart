// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'premium_function_survey_state.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PremiumFunctionSurveyStateTearOff {
  const _$PremiumFunctionSurveyStateTearOff();

  _PremiumFunctionSurveyState call(
      {List<PremiumFunctionSurveyElementType> selectedElements = const [],
      String message = ""}) {
    return _PremiumFunctionSurveyState(
      selectedElements: selectedElements,
      message: message,
    );
  }
}

/// @nodoc
const $PremiumFunctionSurveyState = _$PremiumFunctionSurveyStateTearOff();

/// @nodoc
mixin _$PremiumFunctionSurveyState {
  List<PremiumFunctionSurveyElementType> get selectedElements =>
      throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PremiumFunctionSurveyStateCopyWith<PremiumFunctionSurveyState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PremiumFunctionSurveyStateCopyWith<$Res> {
  factory $PremiumFunctionSurveyStateCopyWith(PremiumFunctionSurveyState value,
          $Res Function(PremiumFunctionSurveyState) then) =
      _$PremiumFunctionSurveyStateCopyWithImpl<$Res>;
  $Res call(
      {List<PremiumFunctionSurveyElementType> selectedElements,
      String message});
}

/// @nodoc
class _$PremiumFunctionSurveyStateCopyWithImpl<$Res>
    implements $PremiumFunctionSurveyStateCopyWith<$Res> {
  _$PremiumFunctionSurveyStateCopyWithImpl(this._value, this._then);

  final PremiumFunctionSurveyState _value;
  // ignore: unused_field
  final $Res Function(PremiumFunctionSurveyState) _then;

  @override
  $Res call({
    Object? selectedElements = freezed,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      selectedElements: selectedElements == freezed
          ? _value.selectedElements
          : selectedElements // ignore: cast_nullable_to_non_nullable
              as List<PremiumFunctionSurveyElementType>,
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$PremiumFunctionSurveyStateCopyWith<$Res>
    implements $PremiumFunctionSurveyStateCopyWith<$Res> {
  factory _$PremiumFunctionSurveyStateCopyWith(
          _PremiumFunctionSurveyState value,
          $Res Function(_PremiumFunctionSurveyState) then) =
      __$PremiumFunctionSurveyStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {List<PremiumFunctionSurveyElementType> selectedElements,
      String message});
}

/// @nodoc
class __$PremiumFunctionSurveyStateCopyWithImpl<$Res>
    extends _$PremiumFunctionSurveyStateCopyWithImpl<$Res>
    implements _$PremiumFunctionSurveyStateCopyWith<$Res> {
  __$PremiumFunctionSurveyStateCopyWithImpl(_PremiumFunctionSurveyState _value,
      $Res Function(_PremiumFunctionSurveyState) _then)
      : super(_value, (v) => _then(v as _PremiumFunctionSurveyState));

  @override
  _PremiumFunctionSurveyState get _value =>
      super._value as _PremiumFunctionSurveyState;

  @override
  $Res call({
    Object? selectedElements = freezed,
    Object? message = freezed,
  }) {
    return _then(_PremiumFunctionSurveyState(
      selectedElements: selectedElements == freezed
          ? _value.selectedElements
          : selectedElements // ignore: cast_nullable_to_non_nullable
              as List<PremiumFunctionSurveyElementType>,
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_PremiumFunctionSurveyState extends _PremiumFunctionSurveyState {
  const _$_PremiumFunctionSurveyState(
      {this.selectedElements = const [], this.message = ""})
      : super._();

  @JsonKey()
  @override
  final List<PremiumFunctionSurveyElementType> selectedElements;
  @JsonKey()
  @override
  final String message;

  @override
  String toString() {
    return 'PremiumFunctionSurveyState(selectedElements: $selectedElements, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PremiumFunctionSurveyState &&
            const DeepCollectionEquality()
                .equals(other.selectedElements, selectedElements) &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(selectedElements),
      const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$PremiumFunctionSurveyStateCopyWith<_PremiumFunctionSurveyState>
      get copyWith => __$PremiumFunctionSurveyStateCopyWithImpl<
          _PremiumFunctionSurveyState>(this, _$identity);
}

abstract class _PremiumFunctionSurveyState extends PremiumFunctionSurveyState {
  const factory _PremiumFunctionSurveyState(
      {List<PremiumFunctionSurveyElementType> selectedElements,
      String message}) = _$_PremiumFunctionSurveyState;
  const _PremiumFunctionSurveyState._() : super._();

  @override
  List<PremiumFunctionSurveyElementType> get selectedElements;
  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$PremiumFunctionSurveyStateCopyWith<_PremiumFunctionSurveyState>
      get copyWith => throw _privateConstructorUsedError;
}
