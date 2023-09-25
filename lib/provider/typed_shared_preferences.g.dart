// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'typed_shared_preferences.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$boolSharedPreferencesHash() =>
    r'74722005ae3dc56ee882744e65c2518f169318a9';

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

abstract class _$BoolSharedPreferences
    extends BuildlessNotifier<SharedPreferencesState<bool?>> {
  late final String key;

  SharedPreferencesState<bool?> build(
    String key,
  );
}

/// See also [BoolSharedPreferences].
@ProviderFor(BoolSharedPreferences)
const boolSharedPreferencesProvider = BoolSharedPreferencesFamily();

/// See also [BoolSharedPreferences].
class BoolSharedPreferencesFamily
    extends Family<SharedPreferencesState<bool?>> {
  /// See also [BoolSharedPreferences].
  const BoolSharedPreferencesFamily();

  /// See also [BoolSharedPreferences].
  BoolSharedPreferencesProvider call(
    String key,
  ) {
    return BoolSharedPreferencesProvider(
      key,
    );
  }

  @override
  BoolSharedPreferencesProvider getProviderOverride(
    covariant BoolSharedPreferencesProvider provider,
  ) {
    return call(
      provider.key,
    );
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    sharedPreferencesProvider
  ];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    sharedPreferencesProvider,
    ...?sharedPreferencesProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'boolSharedPreferencesProvider';
}

/// See also [BoolSharedPreferences].
class BoolSharedPreferencesProvider extends NotifierProviderImpl<
    BoolSharedPreferences, SharedPreferencesState<bool?>> {
  /// See also [BoolSharedPreferences].
  BoolSharedPreferencesProvider(
    String key,
  ) : this._internal(
          () => BoolSharedPreferences()..key = key,
          from: boolSharedPreferencesProvider,
          name: r'boolSharedPreferencesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$boolSharedPreferencesHash,
          dependencies: BoolSharedPreferencesFamily._dependencies,
          allTransitiveDependencies:
              BoolSharedPreferencesFamily._allTransitiveDependencies,
          key: key,
        );

  BoolSharedPreferencesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.key,
  }) : super.internal();

  final String key;

  @override
  SharedPreferencesState<bool?> runNotifierBuild(
    covariant BoolSharedPreferences notifier,
  ) {
    return notifier.build(
      key,
    );
  }

  @override
  Override overrideWith(BoolSharedPreferences Function() create) {
    return ProviderOverride(
      origin: this,
      override: BoolSharedPreferencesProvider._internal(
        () => create()..key = key,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        key: key,
      ),
    );
  }

  @override
  NotifierProviderElement<BoolSharedPreferences, SharedPreferencesState<bool?>>
      createElement() {
    return _BoolSharedPreferencesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BoolSharedPreferencesProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin BoolSharedPreferencesRef
    on NotifierProviderRef<SharedPreferencesState<bool?>> {
  /// The parameter `key` of this provider.
  String get key;
}

class _BoolSharedPreferencesProviderElement extends NotifierProviderElement<
    BoolSharedPreferences,
    SharedPreferencesState<bool?>> with BoolSharedPreferencesRef {
  _BoolSharedPreferencesProviderElement(super.provider);

  @override
  String get key => (origin as BoolSharedPreferencesProvider).key;
}

String _$intSharedPreferencesHash() =>
    r'ae66140077df3922444c17579c2b5483ed6c21b8';

abstract class _$IntSharedPreferences
    extends BuildlessNotifier<SharedPreferencesState<int?>> {
  late final String key;

  SharedPreferencesState<int?> build(
    String key,
  );
}

/// See also [IntSharedPreferences].
@ProviderFor(IntSharedPreferences)
const intSharedPreferencesProvider = IntSharedPreferencesFamily();

/// See also [IntSharedPreferences].
class IntSharedPreferencesFamily extends Family<SharedPreferencesState<int?>> {
  /// See also [IntSharedPreferences].
  const IntSharedPreferencesFamily();

  /// See also [IntSharedPreferences].
  IntSharedPreferencesProvider call(
    String key,
  ) {
    return IntSharedPreferencesProvider(
      key,
    );
  }

  @override
  IntSharedPreferencesProvider getProviderOverride(
    covariant IntSharedPreferencesProvider provider,
  ) {
    return call(
      provider.key,
    );
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    sharedPreferencesProvider
  ];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    sharedPreferencesProvider,
    ...?sharedPreferencesProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'intSharedPreferencesProvider';
}

/// See also [IntSharedPreferences].
class IntSharedPreferencesProvider extends NotifierProviderImpl<
    IntSharedPreferences, SharedPreferencesState<int?>> {
  /// See also [IntSharedPreferences].
  IntSharedPreferencesProvider(
    String key,
  ) : this._internal(
          () => IntSharedPreferences()..key = key,
          from: intSharedPreferencesProvider,
          name: r'intSharedPreferencesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$intSharedPreferencesHash,
          dependencies: IntSharedPreferencesFamily._dependencies,
          allTransitiveDependencies:
              IntSharedPreferencesFamily._allTransitiveDependencies,
          key: key,
        );

  IntSharedPreferencesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.key,
  }) : super.internal();

  final String key;

  @override
  SharedPreferencesState<int?> runNotifierBuild(
    covariant IntSharedPreferences notifier,
  ) {
    return notifier.build(
      key,
    );
  }

  @override
  Override overrideWith(IntSharedPreferences Function() create) {
    return ProviderOverride(
      origin: this,
      override: IntSharedPreferencesProvider._internal(
        () => create()..key = key,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        key: key,
      ),
    );
  }

  @override
  NotifierProviderElement<IntSharedPreferences, SharedPreferencesState<int?>>
      createElement() {
    return _IntSharedPreferencesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IntSharedPreferencesProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin IntSharedPreferencesRef
    on NotifierProviderRef<SharedPreferencesState<int?>> {
  /// The parameter `key` of this provider.
  String get key;
}

class _IntSharedPreferencesProviderElement extends NotifierProviderElement<
    IntSharedPreferences,
    SharedPreferencesState<int?>> with IntSharedPreferencesRef {
  _IntSharedPreferencesProviderElement(super.provider);

  @override
  String get key => (origin as IntSharedPreferencesProvider).key;
}

String _$stringSharedPreferencesHash() =>
    r'3dbe38b126b12544017f8538c33ea459704cf110';

abstract class _$StringSharedPreferences
    extends BuildlessNotifier<SharedPreferencesState<String?>> {
  late final String key;

  SharedPreferencesState<String?> build(
    String key,
  );
}

/// See also [StringSharedPreferences].
@ProviderFor(StringSharedPreferences)
const stringSharedPreferencesProvider = StringSharedPreferencesFamily();

/// See also [StringSharedPreferences].
class StringSharedPreferencesFamily
    extends Family<SharedPreferencesState<String?>> {
  /// See also [StringSharedPreferences].
  const StringSharedPreferencesFamily();

  /// See also [StringSharedPreferences].
  StringSharedPreferencesProvider call(
    String key,
  ) {
    return StringSharedPreferencesProvider(
      key,
    );
  }

  @override
  StringSharedPreferencesProvider getProviderOverride(
    covariant StringSharedPreferencesProvider provider,
  ) {
    return call(
      provider.key,
    );
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    sharedPreferencesProvider
  ];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    sharedPreferencesProvider,
    ...?sharedPreferencesProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'stringSharedPreferencesProvider';
}

/// See also [StringSharedPreferences].
class StringSharedPreferencesProvider extends NotifierProviderImpl<
    StringSharedPreferences, SharedPreferencesState<String?>> {
  /// See also [StringSharedPreferences].
  StringSharedPreferencesProvider(
    String key,
  ) : this._internal(
          () => StringSharedPreferences()..key = key,
          from: stringSharedPreferencesProvider,
          name: r'stringSharedPreferencesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$stringSharedPreferencesHash,
          dependencies: StringSharedPreferencesFamily._dependencies,
          allTransitiveDependencies:
              StringSharedPreferencesFamily._allTransitiveDependencies,
          key: key,
        );

  StringSharedPreferencesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.key,
  }) : super.internal();

  final String key;

  @override
  SharedPreferencesState<String?> runNotifierBuild(
    covariant StringSharedPreferences notifier,
  ) {
    return notifier.build(
      key,
    );
  }

  @override
  Override overrideWith(StringSharedPreferences Function() create) {
    return ProviderOverride(
      origin: this,
      override: StringSharedPreferencesProvider._internal(
        () => create()..key = key,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        key: key,
      ),
    );
  }

  @override
  NotifierProviderElement<StringSharedPreferences,
      SharedPreferencesState<String?>> createElement() {
    return _StringSharedPreferencesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StringSharedPreferencesProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin StringSharedPreferencesRef
    on NotifierProviderRef<SharedPreferencesState<String?>> {
  /// The parameter `key` of this provider.
  String get key;
}

class _StringSharedPreferencesProviderElement extends NotifierProviderElement<
    StringSharedPreferences,
    SharedPreferencesState<String?>> with StringSharedPreferencesRef {
  _StringSharedPreferencesProviderElement(super.provider);

  @override
  String get key => (origin as StringSharedPreferencesProvider).key;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
