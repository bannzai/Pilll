// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$databaseHash() => r'28567367b7034c4ae52606373e30c94f89bacbd4';

/// See also [database].
@ProviderFor(database)
final databaseProvider = Provider<DatabaseConnection>.internal(
  database,
  name: r'databaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$databaseHash,
  dependencies: <ProviderOrFamily>[firebaseUserStateProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    firebaseUserStateProvider,
    ...?firebaseUserStateProvider.allTransitiveDependencies
  },
);

typedef DatabaseRef = ProviderRef<DatabaseConnection>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
