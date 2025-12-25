// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_config.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appIsReleased)
const appIsReleasedProvider = AppIsReleasedProvider._();

final class AppIsReleasedProvider extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const AppIsReleasedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appIsReleasedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appIsReleasedHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return appIsReleased(ref);
  }
}

String _$appIsReleasedHash() => r'a5a56ad848b6f86958c52b7bf8ef5d2f7808361a';
