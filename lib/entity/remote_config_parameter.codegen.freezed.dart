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
  int get trialDeadlineDateOffsetDay => throw _privateConstructorUsedError;
  int get discountEntitlementOffsetDay => throw _privateConstructorUsedError;
  int get discountCountdownBoundaryHour => throw _privateConstructorUsedError;

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
      int trialDeadlineDateOffsetDay,
      int discountEntitlementOffsetDay,
      int discountCountdownBoundaryHour});
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
    Object? trialDeadlineDateOffsetDay = null,
    Object? discountEntitlementOffsetDay = null,
    Object? discountCountdownBoundaryHour = null,
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
      trialDeadlineDateOffsetDay: null == trialDeadlineDateOffsetDay
          ? _value.trialDeadlineDateOffsetDay
          : trialDeadlineDateOffsetDay // ignore: cast_nullable_to_non_nullable
              as int,
      discountEntitlementOffsetDay: null == discountEntitlementOffsetDay
          ? _value.discountEntitlementOffsetDay
          : discountEntitlementOffsetDay // ignore: cast_nullable_to_non_nullable
              as int,
      discountCountdownBoundaryHour: null == discountCountdownBoundaryHour
          ? _value.discountCountdownBoundaryHour
          : discountCountdownBoundaryHour // ignore: cast_nullable_to_non_nullable
              as int,
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
      int trialDeadlineDateOffsetDay,
      int discountEntitlementOffsetDay,
      int discountCountdownBoundaryHour});
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
    Object? trialDeadlineDateOffsetDay = null,
    Object? discountEntitlementOffsetDay = null,
    Object? discountCountdownBoundaryHour = null,
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
      trialDeadlineDateOffsetDay: null == trialDeadlineDateOffsetDay
          ? _value.trialDeadlineDateOffsetDay
          : trialDeadlineDateOffsetDay // ignore: cast_nullable_to_non_nullable
              as int,
      discountEntitlementOffsetDay: null == discountEntitlementOffsetDay
          ? _value.discountEntitlementOffsetDay
          : discountEntitlementOffsetDay // ignore: cast_nullable_to_non_nullable
              as int,
      discountCountdownBoundaryHour: null == discountCountdownBoundaryHour
          ? _value.discountCountdownBoundaryHour
          : discountCountdownBoundaryHour // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RemoteConfigParameterImpl extends _RemoteConfigParameter {
  _$RemoteConfigParameterImpl(
      {this.isPaywallFirst = RemoteConfigParameterDefaultValues.isPaywallFirst,
      this.isUnnecessaryOnBoarding =
          RemoteConfigParameterDefaultValues.isUnnecessaryOnBoarding,
      this.trialDeadlineDateOffsetDay =
          RemoteConfigParameterDefaultValues.trialDeadlineDateOffsetDay,
      this.discountEntitlementOffsetDay =
          RemoteConfigParameterDefaultValues.discountEntitlementOffsetDay,
      this.discountCountdownBoundaryHour =
          RemoteConfigParameterDefaultValues.discountCountdownBoundaryHour})
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
  final int trialDeadlineDateOffsetDay;
  @override
  @JsonKey()
  final int discountEntitlementOffsetDay;
  @override
  @JsonKey()
  final int discountCountdownBoundaryHour;

  @override
  String toString() {
    return 'RemoteConfigParameter(isPaywallFirst: $isPaywallFirst, isUnnecessaryOnBoarding: $isUnnecessaryOnBoarding, trialDeadlineDateOffsetDay: $trialDeadlineDateOffsetDay, discountEntitlementOffsetDay: $discountEntitlementOffsetDay, discountCountdownBoundaryHour: $discountCountdownBoundaryHour)';
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
            (identical(other.trialDeadlineDateOffsetDay,
                    trialDeadlineDateOffsetDay) ||
                other.trialDeadlineDateOffsetDay ==
                    trialDeadlineDateOffsetDay) &&
            (identical(other.discountEntitlementOffsetDay,
                    discountEntitlementOffsetDay) ||
                other.discountEntitlementOffsetDay ==
                    discountEntitlementOffsetDay) &&
            (identical(other.discountCountdownBoundaryHour,
                    discountCountdownBoundaryHour) ||
                other.discountCountdownBoundaryHour ==
                    discountCountdownBoundaryHour));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      isPaywallFirst,
      isUnnecessaryOnBoarding,
      trialDeadlineDateOffsetDay,
      discountEntitlementOffsetDay,
      discountCountdownBoundaryHour);

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
      final int trialDeadlineDateOffsetDay,
      final int discountEntitlementOffsetDay,
      final int discountCountdownBoundaryHour}) = _$RemoteConfigParameterImpl;
  _RemoteConfigParameter._() : super._();

  factory _RemoteConfigParameter.fromJson(Map<String, dynamic> json) =
      _$RemoteConfigParameterImpl.fromJson;

  @override
  bool get isPaywallFirst;
  @override
  bool get isUnnecessaryOnBoarding;
  @override
  int get trialDeadlineDateOffsetDay;
  @override
  int get discountEntitlementOffsetDay;
  @override
  int get discountCountdownBoundaryHour;
  @override
  @JsonKey(ignore: true)
  _$$RemoteConfigParameterImplCopyWith<_$RemoteConfigParameterImpl>
      get copyWith => throw _privateConstructorUsedError;
}
