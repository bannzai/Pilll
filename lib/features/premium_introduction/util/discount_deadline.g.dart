// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discount_deadline.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isOverDiscountDeadlineHash() =>
    r'4336d52719c10c6d3e9acc171f33f9ebc744976b';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [isOverDiscountDeadline].
@ProviderFor(isOverDiscountDeadline)
const isOverDiscountDeadlineProvider = IsOverDiscountDeadlineFamily();

/// See also [isOverDiscountDeadline].
class IsOverDiscountDeadlineFamily extends Family<bool> {
  /// See also [isOverDiscountDeadline].
  const IsOverDiscountDeadlineFamily();

  /// See also [isOverDiscountDeadline].
  IsOverDiscountDeadlineProvider call({
    required DateTime? discountEntitlementDeadlineDate,
  }) {
    return IsOverDiscountDeadlineProvider(
      discountEntitlementDeadlineDate: discountEntitlementDeadlineDate,
    );
  }

  @override
  IsOverDiscountDeadlineProvider getProviderOverride(
    covariant IsOverDiscountDeadlineProvider provider,
  ) {
    return call(
      discountEntitlementDeadlineDate: provider.discountEntitlementDeadlineDate,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'isOverDiscountDeadlineProvider';
}

/// See also [isOverDiscountDeadline].
class IsOverDiscountDeadlineProvider extends AutoDisposeProvider<bool> {
  /// See also [isOverDiscountDeadline].
  IsOverDiscountDeadlineProvider({
    required DateTime? discountEntitlementDeadlineDate,
  }) : this._internal(
          (ref) => isOverDiscountDeadline(
            ref as IsOverDiscountDeadlineRef,
            discountEntitlementDeadlineDate: discountEntitlementDeadlineDate,
          ),
          from: isOverDiscountDeadlineProvider,
          name: r'isOverDiscountDeadlineProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isOverDiscountDeadlineHash,
          dependencies: IsOverDiscountDeadlineFamily._dependencies,
          allTransitiveDependencies:
              IsOverDiscountDeadlineFamily._allTransitiveDependencies,
          discountEntitlementDeadlineDate: discountEntitlementDeadlineDate,
        );

  IsOverDiscountDeadlineProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.discountEntitlementDeadlineDate,
  }) : super.internal();

  final DateTime? discountEntitlementDeadlineDate;

  @override
  Override overrideWith(
    bool Function(IsOverDiscountDeadlineRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsOverDiscountDeadlineProvider._internal(
        (ref) => create(ref as IsOverDiscountDeadlineRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        discountEntitlementDeadlineDate: discountEntitlementDeadlineDate,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _IsOverDiscountDeadlineProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsOverDiscountDeadlineProvider &&
        other.discountEntitlementDeadlineDate ==
            discountEntitlementDeadlineDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, discountEntitlementDeadlineDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin IsOverDiscountDeadlineRef on AutoDisposeProviderRef<bool> {
  /// The parameter `discountEntitlementDeadlineDate` of this provider.
  DateTime? get discountEntitlementDeadlineDate;
}

class _IsOverDiscountDeadlineProviderElement
    extends AutoDisposeProviderElement<bool> with IsOverDiscountDeadlineRef {
  _IsOverDiscountDeadlineProviderElement(super.provider);

  @override
  DateTime? get discountEntitlementDeadlineDate =>
      (origin as IsOverDiscountDeadlineProvider)
          .discountEntitlementDeadlineDate;
}

String _$hiddenCountdownDiscountDeadlineHash() =>
    r'0da1b4d0ab341f369edf7cda1ae3ee1ce1cea2ff';

/// See also [hiddenCountdownDiscountDeadline].
@ProviderFor(hiddenCountdownDiscountDeadline)
const hiddenCountdownDiscountDeadlineProvider =
    HiddenCountdownDiscountDeadlineFamily();

/// See also [hiddenCountdownDiscountDeadline].
class HiddenCountdownDiscountDeadlineFamily extends Family<bool> {
  /// See also [hiddenCountdownDiscountDeadline].
  const HiddenCountdownDiscountDeadlineFamily();

  /// See also [hiddenCountdownDiscountDeadline].
  HiddenCountdownDiscountDeadlineProvider call({
    required DateTime? discountEntitlementDeadlineDate,
  }) {
    return HiddenCountdownDiscountDeadlineProvider(
      discountEntitlementDeadlineDate: discountEntitlementDeadlineDate,
    );
  }

  @override
  HiddenCountdownDiscountDeadlineProvider getProviderOverride(
    covariant HiddenCountdownDiscountDeadlineProvider provider,
  ) {
    return call(
      discountEntitlementDeadlineDate: provider.discountEntitlementDeadlineDate,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'hiddenCountdownDiscountDeadlineProvider';
}

/// See also [hiddenCountdownDiscountDeadline].
class HiddenCountdownDiscountDeadlineProvider
    extends AutoDisposeProvider<bool> {
  /// See also [hiddenCountdownDiscountDeadline].
  HiddenCountdownDiscountDeadlineProvider({
    required DateTime? discountEntitlementDeadlineDate,
  }) : this._internal(
          (ref) => hiddenCountdownDiscountDeadline(
            ref as HiddenCountdownDiscountDeadlineRef,
            discountEntitlementDeadlineDate: discountEntitlementDeadlineDate,
          ),
          from: hiddenCountdownDiscountDeadlineProvider,
          name: r'hiddenCountdownDiscountDeadlineProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$hiddenCountdownDiscountDeadlineHash,
          dependencies: HiddenCountdownDiscountDeadlineFamily._dependencies,
          allTransitiveDependencies:
              HiddenCountdownDiscountDeadlineFamily._allTransitiveDependencies,
          discountEntitlementDeadlineDate: discountEntitlementDeadlineDate,
        );

  HiddenCountdownDiscountDeadlineProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.discountEntitlementDeadlineDate,
  }) : super.internal();

  final DateTime? discountEntitlementDeadlineDate;

  @override
  Override overrideWith(
    bool Function(HiddenCountdownDiscountDeadlineRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HiddenCountdownDiscountDeadlineProvider._internal(
        (ref) => create(ref as HiddenCountdownDiscountDeadlineRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        discountEntitlementDeadlineDate: discountEntitlementDeadlineDate,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _HiddenCountdownDiscountDeadlineProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HiddenCountdownDiscountDeadlineProvider &&
        other.discountEntitlementDeadlineDate ==
            discountEntitlementDeadlineDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, discountEntitlementDeadlineDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin HiddenCountdownDiscountDeadlineRef on AutoDisposeProviderRef<bool> {
  /// The parameter `discountEntitlementDeadlineDate` of this provider.
  DateTime? get discountEntitlementDeadlineDate;
}

class _HiddenCountdownDiscountDeadlineProviderElement
    extends AutoDisposeProviderElement<bool>
    with HiddenCountdownDiscountDeadlineRef {
  _HiddenCountdownDiscountDeadlineProviderElement(super.provider);

  @override
  DateTime? get discountEntitlementDeadlineDate =>
      (origin as HiddenCountdownDiscountDeadlineProvider)
          .discountEntitlementDeadlineDate;
}

String _$durationToDiscountPriceDeadlineHash() =>
    r'cf08e12e1dea3d5475632bc452d12a78aec274b7';

/// See also [durationToDiscountPriceDeadline].
@ProviderFor(durationToDiscountPriceDeadline)
const durationToDiscountPriceDeadlineProvider =
    DurationToDiscountPriceDeadlineFamily();

/// See also [durationToDiscountPriceDeadline].
class DurationToDiscountPriceDeadlineFamily extends Family<Duration> {
  /// See also [durationToDiscountPriceDeadline].
  const DurationToDiscountPriceDeadlineFamily();

  /// See also [durationToDiscountPriceDeadline].
  DurationToDiscountPriceDeadlineProvider call({
    required DateTime discountEntitlementDeadlineDate,
  }) {
    return DurationToDiscountPriceDeadlineProvider(
      discountEntitlementDeadlineDate: discountEntitlementDeadlineDate,
    );
  }

  @override
  DurationToDiscountPriceDeadlineProvider getProviderOverride(
    covariant DurationToDiscountPriceDeadlineProvider provider,
  ) {
    return call(
      discountEntitlementDeadlineDate: provider.discountEntitlementDeadlineDate,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'durationToDiscountPriceDeadlineProvider';
}

/// See also [durationToDiscountPriceDeadline].
class DurationToDiscountPriceDeadlineProvider
    extends AutoDisposeProvider<Duration> {
  /// See also [durationToDiscountPriceDeadline].
  DurationToDiscountPriceDeadlineProvider({
    required DateTime discountEntitlementDeadlineDate,
  }) : this._internal(
          (ref) => durationToDiscountPriceDeadline(
            ref as DurationToDiscountPriceDeadlineRef,
            discountEntitlementDeadlineDate: discountEntitlementDeadlineDate,
          ),
          from: durationToDiscountPriceDeadlineProvider,
          name: r'durationToDiscountPriceDeadlineProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$durationToDiscountPriceDeadlineHash,
          dependencies: DurationToDiscountPriceDeadlineFamily._dependencies,
          allTransitiveDependencies:
              DurationToDiscountPriceDeadlineFamily._allTransitiveDependencies,
          discountEntitlementDeadlineDate: discountEntitlementDeadlineDate,
        );

  DurationToDiscountPriceDeadlineProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.discountEntitlementDeadlineDate,
  }) : super.internal();

  final DateTime discountEntitlementDeadlineDate;

  @override
  Override overrideWith(
    Duration Function(DurationToDiscountPriceDeadlineRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DurationToDiscountPriceDeadlineProvider._internal(
        (ref) => create(ref as DurationToDiscountPriceDeadlineRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        discountEntitlementDeadlineDate: discountEntitlementDeadlineDate,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Duration> createElement() {
    return _DurationToDiscountPriceDeadlineProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DurationToDiscountPriceDeadlineProvider &&
        other.discountEntitlementDeadlineDate ==
            discountEntitlementDeadlineDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, discountEntitlementDeadlineDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DurationToDiscountPriceDeadlineRef on AutoDisposeProviderRef<Duration> {
  /// The parameter `discountEntitlementDeadlineDate` of this provider.
  DateTime get discountEntitlementDeadlineDate;
}

class _DurationToDiscountPriceDeadlineProviderElement
    extends AutoDisposeProviderElement<Duration>
    with DurationToDiscountPriceDeadlineRef {
  _DurationToDiscountPriceDeadlineProviderElement(super.provider);

  @override
  DateTime get discountEntitlementDeadlineDate =>
      (origin as DurationToDiscountPriceDeadlineProvider)
          .discountEntitlementDeadlineDate;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
