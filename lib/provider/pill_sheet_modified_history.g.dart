// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_sheet_modified_history.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(pillSheetModifiedHistoriesWithLimit)
const pillSheetModifiedHistoriesWithLimitProvider = PillSheetModifiedHistoriesWithLimitFamily._();

final class PillSheetModifiedHistoriesWithLimitProvider
    extends $FunctionalProvider<AsyncValue<List<PillSheetModifiedHistory>>, List<PillSheetModifiedHistory>, Stream<List<PillSheetModifiedHistory>>>
    with $FutureModifier<List<PillSheetModifiedHistory>>, $StreamProvider<List<PillSheetModifiedHistory>> {
  const PillSheetModifiedHistoriesWithLimitProvider._({required PillSheetModifiedHistoriesWithLimitFamily super.from, required int super.argument})
    : super(
        retry: null,
        name: r'pillSheetModifiedHistoriesWithLimitProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  static const $allTransitiveDependencies0 = databaseProvider;
  static const $allTransitiveDependencies1 = DatabaseProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$pillSheetModifiedHistoriesWithLimitHash();

  @override
  String toString() {
    return r'pillSheetModifiedHistoriesWithLimitProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<PillSheetModifiedHistory>> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<List<PillSheetModifiedHistory>> create(Ref ref) {
    final argument = this.argument as int;
    return pillSheetModifiedHistoriesWithLimit(ref, limit: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PillSheetModifiedHistoriesWithLimitProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pillSheetModifiedHistoriesWithLimitHash() => r'f264a27d6d98bfe27d945c727f4d4dc952dd9264';

final class PillSheetModifiedHistoriesWithLimitFamily extends $Family with $FunctionalFamilyOverride<Stream<List<PillSheetModifiedHistory>>, int> {
  const PillSheetModifiedHistoriesWithLimitFamily._()
    : super(
        retry: null,
        name: r'pillSheetModifiedHistoriesWithLimitProvider',
        dependencies: const <ProviderOrFamily>[databaseProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          PillSheetModifiedHistoriesWithLimitProvider.$allTransitiveDependencies0,
          PillSheetModifiedHistoriesWithLimitProvider.$allTransitiveDependencies1,
        ],
        isAutoDispose: true,
      );

  PillSheetModifiedHistoriesWithLimitProvider call({required int limit}) =>
      PillSheetModifiedHistoriesWithLimitProvider._(argument: limit, from: this);

  @override
  String toString() => r'pillSheetModifiedHistoriesWithLimitProvider';
}

@ProviderFor(pillSheetModifiedHistoriesWithRange)
const pillSheetModifiedHistoriesWithRangeProvider = PillSheetModifiedHistoriesWithRangeFamily._();

final class PillSheetModifiedHistoriesWithRangeProvider
    extends $FunctionalProvider<AsyncValue<List<PillSheetModifiedHistory>>, List<PillSheetModifiedHistory>, Stream<List<PillSheetModifiedHistory>>>
    with $FutureModifier<List<PillSheetModifiedHistory>>, $StreamProvider<List<PillSheetModifiedHistory>> {
  const PillSheetModifiedHistoriesWithRangeProvider._({
    required PillSheetModifiedHistoriesWithRangeFamily super.from,
    required ({DateTime begin, DateTime end}) super.argument,
  }) : super(
         retry: null,
         name: r'pillSheetModifiedHistoriesWithRangeProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static const $allTransitiveDependencies0 = databaseProvider;
  static const $allTransitiveDependencies1 = DatabaseProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$pillSheetModifiedHistoriesWithRangeHash();

  @override
  String toString() {
    return r'pillSheetModifiedHistoriesWithRangeProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<List<PillSheetModifiedHistory>> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<List<PillSheetModifiedHistory>> create(Ref ref) {
    final argument = this.argument as ({DateTime begin, DateTime end});
    return pillSheetModifiedHistoriesWithRange(ref, begin: argument.begin, end: argument.end);
  }

  @override
  bool operator ==(Object other) {
    return other is PillSheetModifiedHistoriesWithRangeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pillSheetModifiedHistoriesWithRangeHash() => r'b4bf2eeab38900e7ee77a60bc99a7fdb31b4ea62';

final class PillSheetModifiedHistoriesWithRangeFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<PillSheetModifiedHistory>>, ({DateTime begin, DateTime end})> {
  const PillSheetModifiedHistoriesWithRangeFamily._()
    : super(
        retry: null,
        name: r'pillSheetModifiedHistoriesWithRangeProvider',
        dependencies: const <ProviderOrFamily>[databaseProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          PillSheetModifiedHistoriesWithRangeProvider.$allTransitiveDependencies0,
          PillSheetModifiedHistoriesWithRangeProvider.$allTransitiveDependencies1,
        ],
        isAutoDispose: false,
      );

  PillSheetModifiedHistoriesWithRangeProvider call({required DateTime begin, required DateTime end}) =>
      PillSheetModifiedHistoriesWithRangeProvider._(argument: (begin: begin, end: end), from: this);

  @override
  String toString() => r'pillSheetModifiedHistoriesWithRangeProvider';
}
