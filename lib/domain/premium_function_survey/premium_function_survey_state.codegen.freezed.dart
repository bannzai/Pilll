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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

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
      _$PremiumFunctionSurveyStateCopyWithImpl<$Res,
          PremiumFunctionSurveyState>;
  @useResult
  $Res call(
      {List<PremiumFunctionSurveyElementType> selectedElements,
      String message});
}

/// @nodoc
class _$PremiumFunctionSurveyStateCopyWithImpl<$Res,
        $Val extends PremiumFunctionSurveyState>
    implements $PremiumFunctionSurveyStateCopyWith<$Res> {
  _$PremiumFunctionSurveyStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedElements = null,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      selectedElements: null == selectedElements
          ? _value.selectedElements
          : selectedElements // ignore: cast_nullable_to_non_nullable
              as List<PremiumFunctionSurveyElementType>,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PremiumFunctionSurveyStateCopyWith<$Res>
    implements $PremiumFunctionSurveyStateCopyWith<$Res> {
  factory _$$_PremiumFunctionSurveyStateCopyWith(
          _$_PremiumFunctionSurveyState value,
          $Res Function(_$_PremiumFunctionSurveyState) then) =
      __$$_PremiumFunctionSurveyStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<PremiumFunctionSurveyElementType> selectedElements,
      String message});
}

/// @nodoc
class __$$_PremiumFunctionSurveyStateCopyWithImpl<$Res>
    extends _$PremiumFunctionSurveyStateCopyWithImpl<$Res,
        _$_PremiumFunctionSurveyState>
    implements _$$_PremiumFunctionSurveyStateCopyWith<$Res> {
  __$$_PremiumFunctionSurveyStateCopyWithImpl(
      _$_PremiumFunctionSurveyState _value,
      $Res Function(_$_PremiumFunctionSurveyState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedElements = null,
    Object? message = null,
  }) {
    return _then(_$_PremiumFunctionSurveyState(
      selectedElements: null == selectedElements
          ? _value._selectedElements
          : selectedElements // ignore: cast_nullable_to_non_nullable
              as List<PremiumFunctionSurveyElementType>,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_PremiumFunctionSurveyState extends _PremiumFunctionSurveyState {
  const _$_PremiumFunctionSurveyState(
      {final List<PremiumFunctionSurveyElementType> selectedElements = const [],
      this.message = ""})
      : _selectedElements = selectedElements,
        super._();

  final List<PremiumFunctionSurveyElementType> _selectedElements;
  @override
  @JsonKey()
  List<PremiumFunctionSurveyElementType> get selectedElements {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedElements);
  }

  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'PremiumFunctionSurveyState(selectedElements: $selectedElements, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PremiumFunctionSurveyState &&
            const DeepCollectionEquality()
                .equals(other._selectedElements, _selectedElements) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_selectedElements), message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PremiumFunctionSurveyStateCopyWith<_$_PremiumFunctionSurveyState>
      get copyWith => __$$_PremiumFunctionSurveyStateCopyWithImpl<
          _$_PremiumFunctionSurveyState>(this, _$identity);
}

abstract class _PremiumFunctionSurveyState extends PremiumFunctionSurveyState {
  const factory _PremiumFunctionSurveyState(
      {final List<PremiumFunctionSurveyElementType> selectedElements,
      final String message}) = _$_PremiumFunctionSurveyState;
  const _PremiumFunctionSurveyState._() : super._();

  @override
  List<PremiumFunctionSurveyElementType> get selectedElements;
  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$_PremiumFunctionSurveyStateCopyWith<_$_PremiumFunctionSurveyState>
      get copyWith => throw _privateConstructorUsedError;
}
