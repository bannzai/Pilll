// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$databaseProviderHash() => r'ff1cb73a25e2c15782be690516175d9e39daa82c';

/// See also [databaseProvider].
@ProviderFor(databaseProvider)
final databaseProviderProvider = Provider<DatabaseConnection>.internal(
  databaseProvider,
  name: r'databaseProviderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$databaseProviderHash,
  dependencies: <ProviderOrFamily>[firebaseUserStateProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    firebaseUserStateProvider,
    ...?firebaseUserStateProvider.allTransitiveDependencies
  },
);

typedef DatabaseProviderRef = ProviderRef<DatabaseConnection>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
