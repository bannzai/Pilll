// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tick.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Tick)
const tickProvider = TickProvider._();

final class TickProvider extends $NotifierProvider<Tick, DateTime> {
  const TickProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tickProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tickHash();

  @$internal
  @override
  Tick create() => Tick();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<DateTime>(value));
  }
}

String _$tickHash() => r'686abe45d9c3fcc30740691654bd6533752d671e';

abstract class _$Tick extends $Notifier<DateTime> {
  DateTime build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DateTime, DateTime>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<DateTime, DateTime>, DateTime, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
