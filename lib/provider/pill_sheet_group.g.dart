// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_sheet_group.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(activePillSheet)
const activePillSheetProvider = ActivePillSheetProvider._();

final class ActivePillSheetProvider extends $FunctionalProvider<AsyncValue<PillSheet?>, AsyncValue<PillSheet?>, AsyncValue<PillSheet?>>
    with $Provider<AsyncValue<PillSheet?>> {
  const ActivePillSheetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activePillSheetProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[latestPillSheetGroupProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          ActivePillSheetProvider.$allTransitiveDependencies0,
          ActivePillSheetProvider.$allTransitiveDependencies1,
          ActivePillSheetProvider.$allTransitiveDependencies2,
        ],
      );

  static const $allTransitiveDependencies0 = latestPillSheetGroupProvider;
  static const $allTransitiveDependencies1 = LatestPillSheetGroupProvider.$allTransitiveDependencies0;
  static const $allTransitiveDependencies2 = LatestPillSheetGroupProvider.$allTransitiveDependencies1;

  @override
  String debugGetCreateSourceHash() => _$activePillSheetHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<PillSheet?>> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  AsyncValue<PillSheet?> create(Ref ref) {
    return activePillSheet(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<PillSheet?> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<AsyncValue<PillSheet?>>(value));
  }
}

String _$activePillSheetHash() => r'6ec7ca5f1540651dbabc48d63ed16724b936e824';

@ProviderFor(latestPillSheetGroup)
const latestPillSheetGroupProvider = LatestPillSheetGroupProvider._();

final class LatestPillSheetGroupProvider extends $FunctionalProvider<AsyncValue<PillSheetGroup?>, PillSheetGroup?, Stream<PillSheetGroup?>>
    with $FutureModifier<PillSheetGroup?>, $StreamProvider<PillSheetGroup?> {
  const LatestPillSheetGroupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'latestPillSheetGroupProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[databaseProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          LatestPillSheetGroupProvider.$allTransitiveDependencies0,
          LatestPillSheetGroupProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = databaseProvider;
  static const $allTransitiveDependencies1 = DatabaseProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$latestPillSheetGroupHash();

  @$internal
  @override
  $StreamProviderElement<PillSheetGroup?> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<PillSheetGroup?> create(Ref ref) {
    return latestPillSheetGroup(ref);
  }
}

String _$latestPillSheetGroupHash() => r'09cb62d3e0d338fcf47639594584b973ce30224e';

@ProviderFor(beforePillSheetGroup)
const beforePillSheetGroupProvider = BeforePillSheetGroupProvider._();

final class BeforePillSheetGroupProvider extends $FunctionalProvider<AsyncValue<PillSheetGroup?>, PillSheetGroup?, FutureOr<PillSheetGroup?>>
    with $FutureModifier<PillSheetGroup?>, $FutureProvider<PillSheetGroup?> {
  const BeforePillSheetGroupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'beforePillSheetGroupProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[databaseProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          BeforePillSheetGroupProvider.$allTransitiveDependencies0,
          BeforePillSheetGroupProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = databaseProvider;
  static const $allTransitiveDependencies1 = DatabaseProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$beforePillSheetGroupHash();

  @$internal
  @override
  $FutureProviderElement<PillSheetGroup?> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<PillSheetGroup?> create(Ref ref) {
    return beforePillSheetGroup(ref);
  }
}

String _$beforePillSheetGroupHash() => r'9420bbf774e6ec2d8ac98972559c580e0295be03';

@ProviderFor(batchSetPillSheetGroup)
const batchSetPillSheetGroupProvider = BatchSetPillSheetGroupProvider._();

final class BatchSetPillSheetGroupProvider extends $FunctionalProvider<BatchSetPillSheetGroup, BatchSetPillSheetGroup, BatchSetPillSheetGroup>
    with $Provider<BatchSetPillSheetGroup> {
  const BatchSetPillSheetGroupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'batchSetPillSheetGroupProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[databaseProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          BatchSetPillSheetGroupProvider.$allTransitiveDependencies0,
          BatchSetPillSheetGroupProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = databaseProvider;
  static const $allTransitiveDependencies1 = DatabaseProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$batchSetPillSheetGroupHash();

  @$internal
  @override
  $ProviderElement<BatchSetPillSheetGroup> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  BatchSetPillSheetGroup create(Ref ref) {
    return batchSetPillSheetGroup(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BatchSetPillSheetGroup value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<BatchSetPillSheetGroup>(value));
  }
}

String _$batchSetPillSheetGroupHash() => r'424cd09eeec8a29348601f2ab61910c70a74cbf8';

@ProviderFor(setPillSheetGroup)
const setPillSheetGroupProvider = SetPillSheetGroupProvider._();

final class SetPillSheetGroupProvider extends $FunctionalProvider<SetPillSheetGroup, SetPillSheetGroup, SetPillSheetGroup>
    with $Provider<SetPillSheetGroup> {
  const SetPillSheetGroupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setPillSheetGroupProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[databaseProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          SetPillSheetGroupProvider.$allTransitiveDependencies0,
          SetPillSheetGroupProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = databaseProvider;
  static const $allTransitiveDependencies1 = DatabaseProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$setPillSheetGroupHash();

  @$internal
  @override
  $ProviderElement<SetPillSheetGroup> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  SetPillSheetGroup create(Ref ref) {
    return setPillSheetGroup(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SetPillSheetGroup value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<SetPillSheetGroup>(value));
  }
}

String _$setPillSheetGroupHash() => r'3e500bf9b84626af97f57cce1b758c8e2c84a9c9';
