// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'premium_introduction_state.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PremiumIntroductionStateTearOff {
  const _$PremiumIntroductionStateTearOff();

  _PremiumIntroductionState call(
      {Offerings? offerings,
      bool isOverDiscountDeadline = false,
      bool isCompletedRestore = false,
      bool isLoading = false,
      bool isPremium = false,
      bool hasLoginProvider = false,
      bool isTrial = false,
      bool hasDiscountEntitlement = false,
      DateTime? beginTrialDate,
      DateTime? discountEntitlementDeadlineDate}) {
    return _PremiumIntroductionState(
      offerings: offerings,
      isOverDiscountDeadline: isOverDiscountDeadline,
      isCompletedRestore: isCompletedRestore,
      isLoading: isLoading,
      isPremium: isPremium,
      hasLoginProvider: hasLoginProvider,
      isTrial: isTrial,
      hasDiscountEntitlement: hasDiscountEntitlement,
      beginTrialDate: beginTrialDate,
      discountEntitlementDeadlineDate: discountEntitlementDeadlineDate,
    );
  }
}

/// @nodoc
const $PremiumIntroductionState = _$PremiumIntroductionStateTearOff();

/// @nodoc
mixin _$PremiumIntroductionState {
  Offerings? get offerings => throw _privateConstructorUsedError;
  bool get isOverDiscountDeadline => throw _privateConstructorUsedError;
  bool get isCompletedRestore => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isPremium => throw _privateConstructorUsedError;
  bool get hasLoginProvider => throw _privateConstructorUsedError;
  bool get isTrial => throw _privateConstructorUsedError;
  bool get hasDiscountEntitlement => throw _privateConstructorUsedError;
  DateTime? get beginTrialDate => throw _privateConstructorUsedError;
  DateTime? get discountEntitlementDeadlineDate =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PremiumIntroductionStateCopyWith<PremiumIntroductionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PremiumIntroductionStateCopyWith<$Res> {
  factory $PremiumIntroductionStateCopyWith(PremiumIntroductionState value,
          $Res Function(PremiumIntroductionState) then) =
      _$PremiumIntroductionStateCopyWithImpl<$Res>;
  $Res call(
      {Offerings? offerings,
      bool isOverDiscountDeadline,
      bool isCompletedRestore,
      bool isLoading,
      bool isPremium,
      bool hasLoginProvider,
      bool isTrial,
      bool hasDiscountEntitlement,
      DateTime? beginTrialDate,
      DateTime? discountEntitlementDeadlineDate});

  $OfferingsCopyWith<$Res>? get offerings;
}

/// @nodoc
class _$PremiumIntroductionStateCopyWithImpl<$Res>
    implements $PremiumIntroductionStateCopyWith<$Res> {
  _$PremiumIntroductionStateCopyWithImpl(this._value, this._then);

  final PremiumIntroductionState _value;
  // ignore: unused_field
  final $Res Function(PremiumIntroductionState) _then;

  @override
  $Res call({
    Object? offerings = freezed,
    Object? isOverDiscountDeadline = freezed,
    Object? isCompletedRestore = freezed,
    Object? isLoading = freezed,
    Object? isPremium = freezed,
    Object? hasLoginProvider = freezed,
    Object? isTrial = freezed,
    Object? hasDiscountEntitlement = freezed,
    Object? beginTrialDate = freezed,
    Object? discountEntitlementDeadlineDate = freezed,
  }) {
    return _then(_value.copyWith(
      offerings: offerings == freezed
          ? _value.offerings
          : offerings // ignore: cast_nullable_to_non_nullable
              as Offerings?,
      isOverDiscountDeadline: isOverDiscountDeadline == freezed
          ? _value.isOverDiscountDeadline
          : isOverDiscountDeadline // ignore: cast_nullable_to_non_nullable
              as bool,
      isCompletedRestore: isCompletedRestore == freezed
          ? _value.isCompletedRestore
          : isCompletedRestore // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: isLoading == freezed
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isPremium: isPremium == freezed
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      hasLoginProvider: hasLoginProvider == freezed
          ? _value.hasLoginProvider
          : hasLoginProvider // ignore: cast_nullable_to_non_nullable
              as bool,
      isTrial: isTrial == freezed
          ? _value.isTrial
          : isTrial // ignore: cast_nullable_to_non_nullable
              as bool,
      hasDiscountEntitlement: hasDiscountEntitlement == freezed
          ? _value.hasDiscountEntitlement
          : hasDiscountEntitlement // ignore: cast_nullable_to_non_nullable
              as bool,
      beginTrialDate: beginTrialDate == freezed
          ? _value.beginTrialDate
          : beginTrialDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      discountEntitlementDeadlineDate: discountEntitlementDeadlineDate ==
              freezed
          ? _value.discountEntitlementDeadlineDate
          : discountEntitlementDeadlineDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }

  @override
  $OfferingsCopyWith<$Res>? get offerings {
    if (_value.offerings == null) {
      return null;
    }

    return $OfferingsCopyWith<$Res>(_value.offerings!, (value) {
      return _then(_value.copyWith(offerings: value));
    });
  }
}

/// @nodoc
abstract class _$PremiumIntroductionStateCopyWith<$Res>
    implements $PremiumIntroductionStateCopyWith<$Res> {
  factory _$PremiumIntroductionStateCopyWith(_PremiumIntroductionState value,
          $Res Function(_PremiumIntroductionState) then) =
      __$PremiumIntroductionStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {Offerings? offerings,
      bool isOverDiscountDeadline,
      bool isCompletedRestore,
      bool isLoading,
      bool isPremium,
      bool hasLoginProvider,
      bool isTrial,
      bool hasDiscountEntitlement,
      DateTime? beginTrialDate,
      DateTime? discountEntitlementDeadlineDate});

  @override
  $OfferingsCopyWith<$Res>? get offerings;
}

/// @nodoc
class __$PremiumIntroductionStateCopyWithImpl<$Res>
    extends _$PremiumIntroductionStateCopyWithImpl<$Res>
    implements _$PremiumIntroductionStateCopyWith<$Res> {
  __$PremiumIntroductionStateCopyWithImpl(_PremiumIntroductionState _value,
      $Res Function(_PremiumIntroductionState) _then)
      : super(_value, (v) => _then(v as _PremiumIntroductionState));

  @override
  _PremiumIntroductionState get _value =>
      super._value as _PremiumIntroductionState;

  @override
  $Res call({
    Object? offerings = freezed,
    Object? isOverDiscountDeadline = freezed,
    Object? isCompletedRestore = freezed,
    Object? isLoading = freezed,
    Object? isPremium = freezed,
    Object? hasLoginProvider = freezed,
    Object? isTrial = freezed,
    Object? hasDiscountEntitlement = freezed,
    Object? beginTrialDate = freezed,
    Object? discountEntitlementDeadlineDate = freezed,
  }) {
    return _then(_PremiumIntroductionState(
      offerings: offerings == freezed
          ? _value.offerings
          : offerings // ignore: cast_nullable_to_non_nullable
              as Offerings?,
      isOverDiscountDeadline: isOverDiscountDeadline == freezed
          ? _value.isOverDiscountDeadline
          : isOverDiscountDeadline // ignore: cast_nullable_to_non_nullable
              as bool,
      isCompletedRestore: isCompletedRestore == freezed
          ? _value.isCompletedRestore
          : isCompletedRestore // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: isLoading == freezed
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isPremium: isPremium == freezed
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      hasLoginProvider: hasLoginProvider == freezed
          ? _value.hasLoginProvider
          : hasLoginProvider // ignore: cast_nullable_to_non_nullable
              as bool,
      isTrial: isTrial == freezed
          ? _value.isTrial
          : isTrial // ignore: cast_nullable_to_non_nullable
              as bool,
      hasDiscountEntitlement: hasDiscountEntitlement == freezed
          ? _value.hasDiscountEntitlement
          : hasDiscountEntitlement // ignore: cast_nullable_to_non_nullable
              as bool,
      beginTrialDate: beginTrialDate == freezed
          ? _value.beginTrialDate
          : beginTrialDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      discountEntitlementDeadlineDate: discountEntitlementDeadlineDate ==
              freezed
          ? _value.discountEntitlementDeadlineDate
          : discountEntitlementDeadlineDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$_PremiumIntroductionState extends _PremiumIntroductionState
    with DiagnosticableTreeMixin {
  const _$_PremiumIntroductionState(
      {this.offerings,
      this.isOverDiscountDeadline = false,
      this.isCompletedRestore = false,
      this.isLoading = false,
      this.isPremium = false,
      this.hasLoginProvider = false,
      this.isTrial = false,
      this.hasDiscountEntitlement = false,
      this.beginTrialDate,
      this.discountEntitlementDeadlineDate})
      : super._();

  @override
  final Offerings? offerings;
  @JsonKey()
  @override
  final bool isOverDiscountDeadline;
  @JsonKey()
  @override
  final bool isCompletedRestore;
  @JsonKey()
  @override
  final bool isLoading;
  @JsonKey()
  @override
  final bool isPremium;
  @JsonKey()
  @override
  final bool hasLoginProvider;
  @JsonKey()
  @override
  final bool isTrial;
  @JsonKey()
  @override
  final bool hasDiscountEntitlement;
  @override
  final DateTime? beginTrialDate;
  @override
  final DateTime? discountEntitlementDeadlineDate;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PremiumIntroductionState(offerings: $offerings, isOverDiscountDeadline: $isOverDiscountDeadline, isCompletedRestore: $isCompletedRestore, isLoading: $isLoading, isPremium: $isPremium, hasLoginProvider: $hasLoginProvider, isTrial: $isTrial, hasDiscountEntitlement: $hasDiscountEntitlement, beginTrialDate: $beginTrialDate, discountEntitlementDeadlineDate: $discountEntitlementDeadlineDate)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PremiumIntroductionState'))
      ..add(DiagnosticsProperty('offerings', offerings))
      ..add(
          DiagnosticsProperty('isOverDiscountDeadline', isOverDiscountDeadline))
      ..add(DiagnosticsProperty('isCompletedRestore', isCompletedRestore))
      ..add(DiagnosticsProperty('isLoading', isLoading))
      ..add(DiagnosticsProperty('isPremium', isPremium))
      ..add(DiagnosticsProperty('hasLoginProvider', hasLoginProvider))
      ..add(DiagnosticsProperty('isTrial', isTrial))
      ..add(
          DiagnosticsProperty('hasDiscountEntitlement', hasDiscountEntitlement))
      ..add(DiagnosticsProperty('beginTrialDate', beginTrialDate))
      ..add(DiagnosticsProperty(
          'discountEntitlementDeadlineDate', discountEntitlementDeadlineDate));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PremiumIntroductionState &&
            const DeepCollectionEquality().equals(other.offerings, offerings) &&
            const DeepCollectionEquality()
                .equals(other.isOverDiscountDeadline, isOverDiscountDeadline) &&
            const DeepCollectionEquality()
                .equals(other.isCompletedRestore, isCompletedRestore) &&
            const DeepCollectionEquality().equals(other.isLoading, isLoading) &&
            const DeepCollectionEquality().equals(other.isPremium, isPremium) &&
            const DeepCollectionEquality()
                .equals(other.hasLoginProvider, hasLoginProvider) &&
            const DeepCollectionEquality().equals(other.isTrial, isTrial) &&
            const DeepCollectionEquality()
                .equals(other.hasDiscountEntitlement, hasDiscountEntitlement) &&
            const DeepCollectionEquality()
                .equals(other.beginTrialDate, beginTrialDate) &&
            const DeepCollectionEquality().equals(
                other.discountEntitlementDeadlineDate,
                discountEntitlementDeadlineDate));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(offerings),
      const DeepCollectionEquality().hash(isOverDiscountDeadline),
      const DeepCollectionEquality().hash(isCompletedRestore),
      const DeepCollectionEquality().hash(isLoading),
      const DeepCollectionEquality().hash(isPremium),
      const DeepCollectionEquality().hash(hasLoginProvider),
      const DeepCollectionEquality().hash(isTrial),
      const DeepCollectionEquality().hash(hasDiscountEntitlement),
      const DeepCollectionEquality().hash(beginTrialDate),
      const DeepCollectionEquality().hash(discountEntitlementDeadlineDate));

  @JsonKey(ignore: true)
  @override
  _$PremiumIntroductionStateCopyWith<_PremiumIntroductionState> get copyWith =>
      __$PremiumIntroductionStateCopyWithImpl<_PremiumIntroductionState>(
          this, _$identity);
}

abstract class _PremiumIntroductionState extends PremiumIntroductionState {
  const factory _PremiumIntroductionState(
      {Offerings? offerings,
      bool isOverDiscountDeadline,
      bool isCompletedRestore,
      bool isLoading,
      bool isPremium,
      bool hasLoginProvider,
      bool isTrial,
      bool hasDiscountEntitlement,
      DateTime? beginTrialDate,
      DateTime? discountEntitlementDeadlineDate}) = _$_PremiumIntroductionState;
  const _PremiumIntroductionState._() : super._();

  @override
  Offerings? get offerings;
  @override
  bool get isOverDiscountDeadline;
  @override
  bool get isCompletedRestore;
  @override
  bool get isLoading;
  @override
  bool get isPremium;
  @override
  bool get hasLoginProvider;
  @override
  bool get isTrial;
  @override
  bool get hasDiscountEntitlement;
  @override
  DateTime? get beginTrialDate;
  @override
  DateTime? get discountEntitlementDeadlineDate;
  @override
  @JsonKey(ignore: true)
  _$PremiumIntroductionStateCopyWith<_PremiumIntroductionState> get copyWith =>
      throw _privateConstructorUsedError;
}
