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
    r'f9bbe258a9205c61146a70e56446f92893648de8';

/// See also [latestPillSheetGroup].
@ProviderFor(latestPillSheetGroup)
final latestPillSheetGroupProvider = StreamProvider<PillSheetGroup?>.internal(
  latestPillSheetGroup,
  name: r'latestPillSheetGroupProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$latestPillSheetGroupHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LatestPillSheetGroupRef = StreamProviderRef<PillSheetGroup?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
