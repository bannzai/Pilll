// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(database)
const databaseProvider = DatabaseProvider._();

final class DatabaseProvider extends $FunctionalProvider<DatabaseConnection, DatabaseConnection, DatabaseConnection>
    with $Provider<DatabaseConnection> {
  const DatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'databaseProvider',
        isAutoDispose: false,
        dependencies: const <ProviderOrFamily>[firebaseUserStateProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[DatabaseProvider.$allTransitiveDependencies0],
      );

  static const $allTransitiveDependencies0 = firebaseUserStateProvider;

  @override
  String debugGetCreateSourceHash() => _$databaseHash();

  @$internal
  @override
  $ProviderElement<DatabaseConnection> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  DatabaseConnection create(Ref ref) {
    return database(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DatabaseConnection value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<DatabaseConnection>(value));
  }
}

String _$databaseHash() => r'e09790f75507610ce1bc16e9194fbd76dc86a497';
