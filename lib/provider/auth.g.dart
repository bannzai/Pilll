// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(firebaseUserState)
const firebaseUserStateProvider = FirebaseUserStateProvider._();

final class FirebaseUserStateProvider extends $FunctionalProvider<AsyncValue<User?>, User?, Stream<User?>>
    with $FutureModifier<User?>, $StreamProvider<User?> {
  const FirebaseUserStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseUserStateProvider',
        isAutoDispose: false,
        dependencies: const <ProviderOrFamily>[],
        $allTransitiveDependencies: const <ProviderOrFamily>[],
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseUserStateHash();

  @$internal
  @override
  $StreamProviderElement<User?> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<User?> create(Ref ref) {
    return firebaseUserState(ref);
  }
}

String _$firebaseUserStateHash() => r'8abe639366f8d64aa1d964e7608435f09139e245';
