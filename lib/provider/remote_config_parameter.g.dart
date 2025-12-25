// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_config_parameter.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(remoteConfigParameter)
const remoteConfigParameterProvider = RemoteConfigParameterProvider._();

final class RemoteConfigParameterProvider extends $FunctionalProvider<RemoteConfigParameter, RemoteConfigParameter, RemoteConfigParameter>
    with $Provider<RemoteConfigParameter> {
  const RemoteConfigParameterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'remoteConfigParameterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$remoteConfigParameterHash();

  @$internal
  @override
  $ProviderElement<RemoteConfigParameter> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  RemoteConfigParameter create(Ref ref) {
    return remoteConfigParameter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RemoteConfigParameter value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<RemoteConfigParameter>(value));
  }
}

String _$remoteConfigParameterHash() => r'90d727824ec69f0eaa7ce5cb58527eb372a15a8b';
