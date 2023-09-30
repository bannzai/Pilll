// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_sheet_group.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activePillSheetHash() => r'd97b98bec663ae25286aba1eed3305df7766dd7c';

/// See also [activePillSheet].
@ProviderFor(activePillSheet)
final activePillSheetProvider =
    AutoDisposeProvider<AsyncValue<PillSheet?>>.internal(
  activePillSheet,
  name: r'activePillSheetProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activePillSheetHash,
  dependencies: <ProviderOrFamily>[latestPillSheetGroupProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    latestPillSheetGroupProvider,
    ...?latestPillSheetGroupProvider.allTransitiveDependencies
  },
);

typedef ActivePillSheetRef = AutoDisposeProviderRef<AsyncValue<PillSheet?>>;
String _$latestPillSheetGroupHash() =>
    r'0f6c0a0c8039d84749c9020f5561b75c8c05639b';

/// See also [latestPillSheetGroup].
@ProviderFor(latestPillSheetGroup)
final latestPillSheetGroupProvider =
    AutoDisposeStreamProvider<PillSheetGroup?>.internal(
  latestPillSheetGroup,
  name: r'latestPillSheetGroupProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$latestPillSheetGroupHash,
  dependencies: <ProviderOrFamily>[databaseProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    databaseProvider,
    ...?databaseProvider.allTransitiveDependencies
  },
);

typedef LatestPillSheetGroupRef = AutoDisposeStreamProviderRef<PillSheetGroup?>;
String _$beforePillSheetGroupHash() =>
    r'92e86347882a13b63bb8d2a7dc8380fe0ffbf1fd';

/// See also [beforePillSheetGroup].
@ProviderFor(beforePillSheetGroup)
final beforePillSheetGroupProvider =
    AutoDisposeFutureProvider<PillSheetGroup?>.internal(
  beforePillSheetGroup,
  name: r'beforePillSheetGroupProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$beforePillSheetGroupHash,
  dependencies: <ProviderOrFamily>[databaseProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    databaseProvider,
    ...?databaseProvider.allTransitiveDependencies
  },
);

typedef BeforePillSheetGroupRef = AutoDisposeFutureProviderRef<PillSheetGroup?>;
String _$batchSetPillSheetGroupHash() =>
    r'69769ffb3eb87ea3fe0d7b0eada4f447fa9fd0d4';

/// See also [batchSetPillSheetGroup].
@ProviderFor(batchSetPillSheetGroup)
final batchSetPillSheetGroupProvider =
    AutoDisposeProvider<BatchSetPillSheetGroup>.internal(
  batchSetPillSheetGroup,
  name: r'batchSetPillSheetGroupProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$batchSetPillSheetGroupHash,
  dependencies: <ProviderOrFamily>[databaseProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    databaseProvider,
    ...?databaseProvider.allTransitiveDependencies
  },
);

typedef BatchSetPillSheetGroupRef
    = AutoDisposeProviderRef<BatchSetPillSheetGroup>;
String _$setPillSheetGroupHash() => r'c8f16da419ae0bd4ad77f2d95070189c3a748f4c';

/// See also [setPillSheetGroup].
@ProviderFor(setPillSheetGroup)
final setPillSheetGroupProvider =
    AutoDisposeProvider<SetPillSheetGroup>.internal(
  setPillSheetGroup,
  name: r'setPillSheetGroupProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$setPillSheetGroupHash,
  dependencies: <ProviderOrFamily>[databaseProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    databaseProvider,
    ...?databaseProvider.allTransitiveDependencies
  },
);

typedef SetPillSheetGroupRef = AutoDisposeProviderRef<SetPillSheetGroup>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
