// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_sheet_modified_history.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pillSheetModifiedHistoriesHash() =>
    r'5d9db87ff632844b1633e0d7785f8e42ea04de3f';

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

/// See also [pillSheetModifiedHistories].
@ProviderFor(pillSheetModifiedHistories)
const pillSheetModifiedHistoriesProvider = PillSheetModifiedHistoriesFamily();

/// See also [pillSheetModifiedHistories].
class PillSheetModifiedHistoriesFamily
    extends Family<AsyncValue<List<PillSheetModifiedHistory>>> {
  /// See also [pillSheetModifiedHistories].
  const PillSheetModifiedHistoriesFamily();

  /// See also [pillSheetModifiedHistories].
  PillSheetModifiedHistoriesProvider call({
    DateTime? afterCursor,
  }) {
    return PillSheetModifiedHistoriesProvider(
      afterCursor: afterCursor,
    );
  }

  @override
  PillSheetModifiedHistoriesProvider getProviderOverride(
    covariant PillSheetModifiedHistoriesProvider provider,
  ) {
    return call(
      afterCursor: provider.afterCursor,
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
  String? get name => r'pillSheetModifiedHistoriesProvider';
}

/// See also [pillSheetModifiedHistories].
class PillSheetModifiedHistoriesProvider
    extends AutoDisposeStreamProvider<List<PillSheetModifiedHistory>> {
  /// See also [pillSheetModifiedHistories].
  PillSheetModifiedHistoriesProvider({
    DateTime? afterCursor,
  }) : this._internal(
          (ref) => pillSheetModifiedHistories(
            ref as PillSheetModifiedHistoriesRef,
            afterCursor: afterCursor,
          ),
          from: pillSheetModifiedHistoriesProvider,
          name: r'pillSheetModifiedHistoriesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$pillSheetModifiedHistoriesHash,
          dependencies: PillSheetModifiedHistoriesFamily._dependencies,
          allTransitiveDependencies:
              PillSheetModifiedHistoriesFamily._allTransitiveDependencies,
          afterCursor: afterCursor,
        );

  PillSheetModifiedHistoriesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.afterCursor,
  }) : super.internal();

  final DateTime? afterCursor;

  @override
  Override overrideWith(
    Stream<List<PillSheetModifiedHistory>> Function(
            PillSheetModifiedHistoriesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PillSheetModifiedHistoriesProvider._internal(
        (ref) => create(ref as PillSheetModifiedHistoriesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        afterCursor: afterCursor,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<PillSheetModifiedHistory>>
      createElement() {
    return _PillSheetModifiedHistoriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PillSheetModifiedHistoriesProvider &&
        other.afterCursor == afterCursor;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, afterCursor.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PillSheetModifiedHistoriesRef
    on AutoDisposeStreamProviderRef<List<PillSheetModifiedHistory>> {
  /// The parameter `afterCursor` of this provider.
  DateTime? get afterCursor;
}

class _PillSheetModifiedHistoriesProviderElement
    extends AutoDisposeStreamProviderElement<List<PillSheetModifiedHistory>>
    with PillSheetModifiedHistoriesRef {
  _PillSheetModifiedHistoriesProviderElement(super.provider);

  @override
  DateTime? get afterCursor =>
      (origin as PillSheetModifiedHistoriesProvider).afterCursor;
}

String _$archivedPillSheetModifiedHistoriesHash() =>
    r'847f681fc83651f1d30911be14439023fca634dc';

/// See also [archivedPillSheetModifiedHistories].
@ProviderFor(archivedPillSheetModifiedHistories)
const archivedPillSheetModifiedHistoriesProvider =
    ArchivedPillSheetModifiedHistoriesFamily();

/// See also [archivedPillSheetModifiedHistories].
class ArchivedPillSheetModifiedHistoriesFamily
    extends Family<AsyncValue<List<PillSheetModifiedHistory>>> {
  /// See also [archivedPillSheetModifiedHistories].
  const ArchivedPillSheetModifiedHistoriesFamily();

  /// See also [archivedPillSheetModifiedHistories].
  ArchivedPillSheetModifiedHistoriesProvider call({
    DateTime? afterCursor,
  }) {
    return ArchivedPillSheetModifiedHistoriesProvider(
      afterCursor: afterCursor,
    );
  }

  @override
  ArchivedPillSheetModifiedHistoriesProvider getProviderOverride(
    covariant ArchivedPillSheetModifiedHistoriesProvider provider,
  ) {
    return call(
      afterCursor: provider.afterCursor,
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
  String? get name => r'archivedPillSheetModifiedHistoriesProvider';
}

/// See also [archivedPillSheetModifiedHistories].
class ArchivedPillSheetModifiedHistoriesProvider
    extends AutoDisposeStreamProvider<List<PillSheetModifiedHistory>> {
  /// See also [archivedPillSheetModifiedHistories].
  ArchivedPillSheetModifiedHistoriesProvider({
    DateTime? afterCursor,
  }) : this._internal(
          (ref) => archivedPillSheetModifiedHistories(
            ref as ArchivedPillSheetModifiedHistoriesRef,
            afterCursor: afterCursor,
          ),
          from: archivedPillSheetModifiedHistoriesProvider,
          name: r'archivedPillSheetModifiedHistoriesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$archivedPillSheetModifiedHistoriesHash,
          dependencies: ArchivedPillSheetModifiedHistoriesFamily._dependencies,
          allTransitiveDependencies: ArchivedPillSheetModifiedHistoriesFamily
              ._allTransitiveDependencies,
          afterCursor: afterCursor,
        );

  ArchivedPillSheetModifiedHistoriesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.afterCursor,
  }) : super.internal();

  final DateTime? afterCursor;

  @override
  Override overrideWith(
    Stream<List<PillSheetModifiedHistory>> Function(
            ArchivedPillSheetModifiedHistoriesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ArchivedPillSheetModifiedHistoriesProvider._internal(
        (ref) => create(ref as ArchivedPillSheetModifiedHistoriesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        afterCursor: afterCursor,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<PillSheetModifiedHistory>>
      createElement() {
    return _ArchivedPillSheetModifiedHistoriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ArchivedPillSheetModifiedHistoriesProvider &&
        other.afterCursor == afterCursor;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, afterCursor.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ArchivedPillSheetModifiedHistoriesRef
    on AutoDisposeStreamProviderRef<List<PillSheetModifiedHistory>> {
  /// The parameter `afterCursor` of this provider.
  DateTime? get afterCursor;
}

class _ArchivedPillSheetModifiedHistoriesProviderElement
    extends AutoDisposeStreamProviderElement<List<PillSheetModifiedHistory>>
    with ArchivedPillSheetModifiedHistoriesRef {
  _ArchivedPillSheetModifiedHistoriesProviderElement(super.provider);

  @override
  DateTime? get afterCursor =>
      (origin as ArchivedPillSheetModifiedHistoriesProvider).afterCursor;
}

String _$pillSheetModifiedHistoriesWithLimitHash() =>
    r'ef2177bae47599b8f67aefb3828f347c44ae084a';

/// See also [pillSheetModifiedHistoriesWithLimit].
@ProviderFor(pillSheetModifiedHistoriesWithLimit)
const pillSheetModifiedHistoriesWithLimitProvider =
    PillSheetModifiedHistoriesWithLimitFamily();

/// See also [pillSheetModifiedHistoriesWithLimit].
class PillSheetModifiedHistoriesWithLimitFamily
    extends Family<AsyncValue<List<PillSheetModifiedHistory>>> {
  /// See also [pillSheetModifiedHistoriesWithLimit].
  const PillSheetModifiedHistoriesWithLimitFamily();

  /// See also [pillSheetModifiedHistoriesWithLimit].
  PillSheetModifiedHistoriesWithLimitProvider call({
    required int limit,
  }) {
    return PillSheetModifiedHistoriesWithLimitProvider(
      limit: limit,
    );
  }

  @override
  PillSheetModifiedHistoriesWithLimitProvider getProviderOverride(
    covariant PillSheetModifiedHistoriesWithLimitProvider provider,
  ) {
    return call(
      limit: provider.limit,
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
  String? get name => r'pillSheetModifiedHistoriesWithLimitProvider';
}

/// See also [pillSheetModifiedHistoriesWithLimit].
class PillSheetModifiedHistoriesWithLimitProvider
    extends AutoDisposeStreamProvider<List<PillSheetModifiedHistory>> {
  /// See also [pillSheetModifiedHistoriesWithLimit].
  PillSheetModifiedHistoriesWithLimitProvider({
    required int limit,
  }) : this._internal(
          (ref) => pillSheetModifiedHistoriesWithLimit(
            ref as PillSheetModifiedHistoriesWithLimitRef,
            limit: limit,
          ),
          from: pillSheetModifiedHistoriesWithLimitProvider,
          name: r'pillSheetModifiedHistoriesWithLimitProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$pillSheetModifiedHistoriesWithLimitHash,
          dependencies: PillSheetModifiedHistoriesWithLimitFamily._dependencies,
          allTransitiveDependencies: PillSheetModifiedHistoriesWithLimitFamily
              ._allTransitiveDependencies,
          limit: limit,
        );

  PillSheetModifiedHistoriesWithLimitProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.limit,
  }) : super.internal();

  final int limit;

  @override
  Override overrideWith(
    Stream<List<PillSheetModifiedHistory>> Function(
            PillSheetModifiedHistoriesWithLimitRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PillSheetModifiedHistoriesWithLimitProvider._internal(
        (ref) => create(ref as PillSheetModifiedHistoriesWithLimitRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<PillSheetModifiedHistory>>
      createElement() {
    return _PillSheetModifiedHistoriesWithLimitProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PillSheetModifiedHistoriesWithLimitProvider &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PillSheetModifiedHistoriesWithLimitRef
    on AutoDisposeStreamProviderRef<List<PillSheetModifiedHistory>> {
  /// The parameter `limit` of this provider.
  int get limit;
}

class _PillSheetModifiedHistoriesWithLimitProviderElement
    extends AutoDisposeStreamProviderElement<List<PillSheetModifiedHistory>>
    with PillSheetModifiedHistoriesWithLimitRef {
  _PillSheetModifiedHistoriesWithLimitProviderElement(super.provider);

  @override
  int get limit =>
      (origin as PillSheetModifiedHistoriesWithLimitProvider).limit;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
