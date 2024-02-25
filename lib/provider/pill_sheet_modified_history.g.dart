// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_sheet_modified_history.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pillSheetModifiedHistoriesWithLimitHash() =>
    r'6ce11b768ad4c04c8dd52a6e5dd007d84f8ebca9';

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

String _$pillSheetModifiedHistoriesWithRangeHash() =>
    r'ea775de86dd0b2b2bb7879a0fb01e3978df3836d';

/// See also [pillSheetModifiedHistoriesWithRange].
@ProviderFor(pillSheetModifiedHistoriesWithRange)
const pillSheetModifiedHistoriesWithRangeProvider =
    PillSheetModifiedHistoriesWithRangeFamily();

/// See also [pillSheetModifiedHistoriesWithRange].
class PillSheetModifiedHistoriesWithRangeFamily
    extends Family<AsyncValue<List<PillSheetModifiedHistory>>> {
  /// See also [pillSheetModifiedHistoriesWithRange].
  const PillSheetModifiedHistoriesWithRangeFamily();

  /// See also [pillSheetModifiedHistoriesWithRange].
  PillSheetModifiedHistoriesWithRangeProvider call({
    required DateTime begin,
    required DateTime end,
  }) {
    return PillSheetModifiedHistoriesWithRangeProvider(
      begin: begin,
      end: end,
    );
  }

  @override
  PillSheetModifiedHistoriesWithRangeProvider getProviderOverride(
    covariant PillSheetModifiedHistoriesWithRangeProvider provider,
  ) {
    return call(
      begin: provider.begin,
      end: provider.end,
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
  String? get name => r'pillSheetModifiedHistoriesWithRangeProvider';
}

/// See also [pillSheetModifiedHistoriesWithRange].
class PillSheetModifiedHistoriesWithRangeProvider
    extends StreamProvider<List<PillSheetModifiedHistory>> {
  /// See also [pillSheetModifiedHistoriesWithRange].
  PillSheetModifiedHistoriesWithRangeProvider({
    required DateTime begin,
    required DateTime end,
  }) : this._internal(
          (ref) => pillSheetModifiedHistoriesWithRange(
            ref as PillSheetModifiedHistoriesWithRangeRef,
            begin: begin,
            end: end,
          ),
          from: pillSheetModifiedHistoriesWithRangeProvider,
          name: r'pillSheetModifiedHistoriesWithRangeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$pillSheetModifiedHistoriesWithRangeHash,
          dependencies: PillSheetModifiedHistoriesWithRangeFamily._dependencies,
          allTransitiveDependencies: PillSheetModifiedHistoriesWithRangeFamily
              ._allTransitiveDependencies,
          begin: begin,
          end: end,
        );

  PillSheetModifiedHistoriesWithRangeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.begin,
    required this.end,
  }) : super.internal();

  final DateTime begin;
  final DateTime end;

  @override
  Override overrideWith(
    Stream<List<PillSheetModifiedHistory>> Function(
            PillSheetModifiedHistoriesWithRangeRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PillSheetModifiedHistoriesWithRangeProvider._internal(
        (ref) => create(ref as PillSheetModifiedHistoriesWithRangeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        begin: begin,
        end: end,
      ),
    );
  }

  @override
  StreamProviderElement<List<PillSheetModifiedHistory>> createElement() {
    return _PillSheetModifiedHistoriesWithRangeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PillSheetModifiedHistoriesWithRangeProvider &&
        other.begin == begin &&
        other.end == end;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, begin.hashCode);
    hash = _SystemHash.combine(hash, end.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PillSheetModifiedHistoriesWithRangeRef
    on StreamProviderRef<List<PillSheetModifiedHistory>> {
  /// The parameter `begin` of this provider.
  DateTime get begin;

  /// The parameter `end` of this provider.
  DateTime get end;
}

class _PillSheetModifiedHistoriesWithRangeProviderElement
    extends StreamProviderElement<List<PillSheetModifiedHistory>>
    with PillSheetModifiedHistoriesWithRangeRef {
  _PillSheetModifiedHistoriesWithRangeProviderElement(super.provider);

  @override
  DateTime get begin =>
      (origin as PillSheetModifiedHistoriesWithRangeProvider).begin;
  @override
  DateTime get end =>
      (origin as PillSheetModifiedHistoriesWithRangeProvider).end;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
