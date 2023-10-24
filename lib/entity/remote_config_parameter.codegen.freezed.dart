// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_config_parameter.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

RemoteConfigParameter _$RemoteConfigParameterFromJson(
    Map<String, dynamic> json) {
  return _RemoteConfigParameter.fromJson(json);
}

/// @nodoc
mixin _$RemoteConfigParameter {
  bool get isPaywallFirst => throw _privateConstructorUsedError;
  bool get isUnnecessaryOnBoarding => throw _privateConstructorUsedError;
  bool get trialDay => throw _privateConstructorUsedError;
  bool get discountDay => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RemoteConfigParameterCopyWith<RemoteConfigParameter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RemoteConfigParameterCopyWith<$Res> {
  factory $RemoteConfigParameterCopyWith(RemoteConfigParameter value,
          $Res Function(RemoteConfigParameter) then) =
      _$RemoteConfigParameterCopyWithImpl<$Res, RemoteConfigParameter>;
  @useResult
  $Res call(
      {bool isPaywallFirst,
      bool isUnnecessaryOnBoarding,
      bool trialDay,
      bool discountDay});
}

/// @nodoc
class _$RemoteConfigParameterCopyWithImpl<$Res,
        $Val extends RemoteConfigParameter>
    implements $RemoteConfigParameterCopyWith<$Res> {
  _$RemoteConfigParameterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isPaywallFirst = null,
    Object? isUnnecessaryOnBoarding = null,
    Object? trialDay = null,
    Object? discountDay = null,
  }) {
    return _then(_value.copyWith(
      isPaywallFirst: null == isPaywallFirst
          ? _value.isPaywallFirst
          : isPaywallFirst // ignore: cast_nullable_to_non_nullable
              as bool,
      isUnnecessaryOnBoarding: null == isUnnecessaryOnBoarding
          ? _value.isUnnecessaryOnBoarding
          : isUnnecessaryOnBoarding // ignore: cast_nullable_to_non_nullable
              as bool,
      trialDay: null == trialDay
          ? _value.trialDay
          : trialDay // ignore: cast_nullable_to_non_nullable
              as bool,
      discountDay: null == discountDay
          ? _value.discountDay
          : discountDay // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RemoteConfigParameterImplCopyWith<$Res>
    implements $RemoteConfigParameterCopyWith<$Res> {
  factory _$$RemoteConfigParameterImplCopyWith(
          _$RemoteConfigParameterImpl value,
          $Res Function(_$RemoteConfigParameterImpl) then) =
      __$$RemoteConfigParameterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isPaywallFirst,
      bool isUnnecessaryOnBoarding,
      bool trialDay,
      bool discountDay});
}

/// @nodoc
class __$$RemoteConfigParameterImplCopyWithImpl<$Res>
    extends _$RemoteConfigParameterCopyWithImpl<$Res,
        _$RemoteConfigParameterImpl>
    implements _$$RemoteConfigParameterImplCopyWith<$Res> {
  __$$RemoteConfigParameterImplCopyWithImpl(_$RemoteConfigParameterImpl _value,
      $Res Function(_$RemoteConfigParameterImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isPaywallFirst = null,
    Object? isUnnecessaryOnBoarding = null,
    Object? trialDay = null,
    Object? discountDay = null,
  }) {
    return _then(_$RemoteConfigParameterImpl(
      isPaywallFirst: null == isPaywallFirst
          ? _value.isPaywallFirst
          : isPaywallFirst // ignore: cast_nullable_to_non_nullable
              as bool,
      isUnnecessaryOnBoarding: null == isUnnecessaryOnBoarding
          ? _value.isUnnecessaryOnBoarding
          : isUnnecessaryOnBoarding // ignore: cast_nullable_to_non_nullable
              as bool,
      trialDay: null == trialDay
          ? _value.trialDay
          : trialDay // ignore: cast_nullable_to_non_nullable
              as bool,
      discountDay: null == discountDay
          ? _value.discountDay
          : discountDay // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RemoteConfigParameterImpl extends _RemoteConfigParameter {
  _$RemoteConfigParameterImpl(
      {this.isPaywallFirst = false,
      this.isUnnecessaryOnBoarding = false,
      this.trialDay = false,
      this.discountDay = false})
      : super._();

  factory _$RemoteConfigParameterImpl.fromJson(Map<String, dynamic> json) =>
      _$$RemoteConfigParameterImplFromJson(json);

  @override
  @JsonKey()
  final bool isPaywallFirst;
  @override
  @JsonKey()
  final bool isUnnecessaryOnBoarding;
  @override
  @JsonKey()
  final bool trialDay;
  @override
  @JsonKey()
  final bool discountDay;

  @override
  String toString() {
    return 'RemoteConfigParameter(isPaywallFirst: $isPaywallFirst, isUnnecessaryOnBoarding: $isUnnecessaryOnBoarding, trialDay: $trialDay, discountDay: $discountDay)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RemoteConfigParameterImpl &&
            (identical(other.isPaywallFirst, isPaywallFirst) ||
                other.isPaywallFirst == isPaywallFirst) &&
            (identical(
                    other.isUnnecessaryOnBoarding, isUnnecessaryOnBoarding) ||
                other.isUnnecessaryOnBoarding == isUnnecessaryOnBoarding) &&
            (identical(other.trialDay, trialDay) ||
                other.trialDay == trialDay) &&
            (identical(other.discountDay, discountDay) ||
                other.discountDay == discountDay));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, isPaywallFirst,
      isUnnecessaryOnBoarding, trialDay, discountDay);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RemoteConfigParameterImplCopyWith<_$RemoteConfigParameterImpl>
      get copyWith => __$$RemoteConfigParameterImplCopyWithImpl<
          _$RemoteConfigParameterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RemoteConfigParameterImplToJson(
      this,
    );
  }
}

abstract class _RemoteConfigParameter extends RemoteConfigParameter {
  factory _RemoteConfigParameter(
      {final bool isPaywallFirst,
      final bool isUnnecessaryOnBoarding,
      final bool trialDay,
      final bool discountDay}) = _$RemoteConfigParameterImpl;
  _RemoteConfigParameter._() : super._();

  factory _RemoteConfigParameter.fromJson(Map<String, dynamic> json) =
      _$RemoteConfigParameterImpl.fromJson;

  @override
  bool get isPaywallFirst;
  @override
  bool get isUnnecessaryOnBoarding;
  @override
  bool get trialDay;
  @override
  bool get discountDay;
  @override
  @JsonKey(ignore: true)
  _$$RemoteConfigParameterImplCopyWith<_$RemoteConfigParameterImpl>
      get copyWith => throw _privateConstructorUsedError;
}
