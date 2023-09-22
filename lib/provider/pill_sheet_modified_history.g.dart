// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_sheet_modified_history.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pillSheetModifiedHistoriesHash() =>
    r'ceefe2c96a4814bda43249e43e4c52e1cbcbdf1d';

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
    String? afterCursor,
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

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    databaseProvider
  ];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    databaseProvider,
    ...?databaseProvider.allTransitiveDependencies
  };

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
    String? afterCursor,
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

  final String? afterCursor;

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
  String? get afterCursor;
}

class _PillSheetModifiedHistoriesProviderElement
    extends AutoDisposeStreamProviderElement<List<PillSheetModifiedHistory>>
    with PillSheetModifiedHistoriesRef {
  _PillSheetModifiedHistoriesProviderElement(super.provider);

  @override
  String? get afterCursor =>
      (origin as PillSheetModifiedHistoriesProvider).afterCursor;
}

String _$archivedPillSheetModifiedHistoriesHash() =>
    r'675c8ba98a48b6b7f8fa918a1c544ddea62eb2f3';

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
    String? afterCursor,
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

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    databaseProvider
  ];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    databaseProvider,
    ...?databaseProvider.allTransitiveDependencies
  };

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
    String? afterCursor,
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

  final String? afterCursor;

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
  String? get afterCursor;
}

class _ArchivedPillSheetModifiedHistoriesProviderElement
    extends AutoDisposeStreamProviderElement<List<PillSheetModifiedHistory>>
    with ArchivedPillSheetModifiedHistoriesRef {
  _ArchivedPillSheetModifiedHistoriesProviderElement(super.provider);

  @override
  String? get afterCursor =>
      (origin as ArchivedPillSheetModifiedHistoriesProvider).afterCursor;
}

String _$pillSheetModifiedHistoriesWithLimitProviderHash() =>
    r'a8e96e198e760887d8e331058ee22bf45cda0c9e';

/// See also [pillSheetModifiedHistoriesWithLimitProvider].
@ProviderFor(pillSheetModifiedHistoriesWithLimitProvider)
const pillSheetModifiedHistoriesWithLimitProviderProvider =
    PillSheetModifiedHistoriesWithLimitProviderFamily();

/// See also [pillSheetModifiedHistoriesWithLimitProvider].
class PillSheetModifiedHistoriesWithLimitProviderFamily
    extends Family<AsyncValue<List<PillSheetModifiedHistory>>> {
  /// See also [pillSheetModifiedHistoriesWithLimitProvider].
  const PillSheetModifiedHistoriesWithLimitProviderFamily();

  /// See also [pillSheetModifiedHistoriesWithLimitProvider].
  PillSheetModifiedHistoriesWithLimitProviderProvider call({
    required int limit,
  }) {
    return PillSheetModifiedHistoriesWithLimitProviderProvider(
      limit: limit,
    );
  }

  @override
  PillSheetModifiedHistoriesWithLimitProviderProvider getProviderOverride(
    covariant PillSheetModifiedHistoriesWithLimitProviderProvider provider,
  ) {
    return call(
      limit: provider.limit,
    );
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    databaseProvider
  ];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    databaseProvider,
    ...?databaseProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'pillSheetModifiedHistoriesWithLimitProviderProvider';
}

/// See also [pillSheetModifiedHistoriesWithLimitProvider].
class PillSheetModifiedHistoriesWithLimitProviderProvider
    extends AutoDisposeStreamProvider<List<PillSheetModifiedHistory>> {
  /// See also [pillSheetModifiedHistoriesWithLimitProvider].
  PillSheetModifiedHistoriesWithLimitProviderProvider({
    required int limit,
  }) : this._internal(
          (ref) => pillSheetModifiedHistoriesWithLimitProvider(
            ref as PillSheetModifiedHistoriesWithLimitProviderRef,
            limit: limit,
          ),
          from: pillSheetModifiedHistoriesWithLimitProviderProvider,
          name: r'pillSheetModifiedHistoriesWithLimitProviderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$pillSheetModifiedHistoriesWithLimitProviderHash,
          dependencies:
              PillSheetModifiedHistoriesWithLimitProviderFamily._dependencies,
          allTransitiveDependencies:
              PillSheetModifiedHistoriesWithLimitProviderFamily
                  ._allTransitiveDependencies,
          limit: limit,
        );

  PillSheetModifiedHistoriesWithLimitProviderProvider._internal(
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
            PillSheetModifiedHistoriesWithLimitProviderRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PillSheetModifiedHistoriesWithLimitProviderProvider._internal(
        (ref) => create(ref as PillSheetModifiedHistoriesWithLimitProviderRef),
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
    return _PillSheetModifiedHistoriesWithLimitProviderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PillSheetModifiedHistoriesWithLimitProviderProvider &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PillSheetModifiedHistoriesWithLimitProviderRef
    on AutoDisposeStreamProviderRef<List<PillSheetModifiedHistory>> {
  /// The parameter `limit` of this provider.
  int get limit;
}

class _PillSheetModifiedHistoriesWithLimitProviderProviderElement
    extends AutoDisposeStreamProviderElement<List<PillSheetModifiedHistory>>
    with PillSheetModifiedHistoriesWithLimitProviderRef {
  _PillSheetModifiedHistoriesWithLimitProviderProviderElement(super.provider);

  @override
  int get limit =>
      (origin as PillSheetModifiedHistoriesWithLimitProviderProvider).limit;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
