// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'typed_shared_preferences.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BoolSharedPreferences)
const boolSharedPreferencesProvider = BoolSharedPreferencesFamily._();

final class BoolSharedPreferencesProvider extends $NotifierProvider<BoolSharedPreferences, SharedPreferencesState<bool?>> {
  const BoolSharedPreferencesProvider._({required BoolSharedPreferencesFamily super.from, required String super.argument})
    : super(retry: null, name: r'boolSharedPreferencesProvider', isAutoDispose: false, dependencies: null, $allTransitiveDependencies: null);

  static const $allTransitiveDependencies0 = sharedPreferencesProvider;

  @override
  String debugGetCreateSourceHash() => _$boolSharedPreferencesHash();

  @override
  String toString() {
    return r'boolSharedPreferencesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BoolSharedPreferences create() => BoolSharedPreferences();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferencesState<bool?> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<SharedPreferencesState<bool?>>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is BoolSharedPreferencesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$boolSharedPreferencesHash() => r'74722005ae3dc56ee882744e65c2518f169318a9';

final class BoolSharedPreferencesFamily extends $Family
    with
        $ClassFamilyOverride<
          BoolSharedPreferences,
          SharedPreferencesState<bool?>,
          SharedPreferencesState<bool?>,
          SharedPreferencesState<bool?>,
          String
        > {
  const BoolSharedPreferencesFamily._()
    : super(
        retry: null,
        name: r'boolSharedPreferencesProvider',
        dependencies: const <ProviderOrFamily>[sharedPreferencesProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[BoolSharedPreferencesProvider.$allTransitiveDependencies0],
        isAutoDispose: false,
      );

  BoolSharedPreferencesProvider call(String key) => BoolSharedPreferencesProvider._(argument: key, from: this);

  @override
  String toString() => r'boolSharedPreferencesProvider';
}

abstract class _$BoolSharedPreferences extends $Notifier<SharedPreferencesState<bool?>> {
  late final _$args = ref.$arg as String;
  String get key => _$args;

  SharedPreferencesState<bool?> build(String key);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<SharedPreferencesState<bool?>, SharedPreferencesState<bool?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SharedPreferencesState<bool?>, SharedPreferencesState<bool?>>,
              SharedPreferencesState<bool?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(IntSharedPreferences)
const intSharedPreferencesProvider = IntSharedPreferencesFamily._();

final class IntSharedPreferencesProvider extends $NotifierProvider<IntSharedPreferences, SharedPreferencesState<int?>> {
  const IntSharedPreferencesProvider._({required IntSharedPreferencesFamily super.from, required String super.argument})
    : super(retry: null, name: r'intSharedPreferencesProvider', isAutoDispose: false, dependencies: null, $allTransitiveDependencies: null);

  static const $allTransitiveDependencies0 = sharedPreferencesProvider;

  @override
  String debugGetCreateSourceHash() => _$intSharedPreferencesHash();

  @override
  String toString() {
    return r'intSharedPreferencesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  IntSharedPreferences create() => IntSharedPreferences();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferencesState<int?> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<SharedPreferencesState<int?>>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is IntSharedPreferencesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$intSharedPreferencesHash() => r'ae66140077df3922444c17579c2b5483ed6c21b8';

final class IntSharedPreferencesFamily extends $Family
    with
        $ClassFamilyOverride<IntSharedPreferences, SharedPreferencesState<int?>, SharedPreferencesState<int?>, SharedPreferencesState<int?>, String> {
  const IntSharedPreferencesFamily._()
    : super(
        retry: null,
        name: r'intSharedPreferencesProvider',
        dependencies: const <ProviderOrFamily>[sharedPreferencesProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[IntSharedPreferencesProvider.$allTransitiveDependencies0],
        isAutoDispose: false,
      );

  IntSharedPreferencesProvider call(String key) => IntSharedPreferencesProvider._(argument: key, from: this);

  @override
  String toString() => r'intSharedPreferencesProvider';
}

abstract class _$IntSharedPreferences extends $Notifier<SharedPreferencesState<int?>> {
  late final _$args = ref.$arg as String;
  String get key => _$args;

  SharedPreferencesState<int?> build(String key);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<SharedPreferencesState<int?>, SharedPreferencesState<int?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SharedPreferencesState<int?>, SharedPreferencesState<int?>>,
              SharedPreferencesState<int?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(StringSharedPreferences)
const stringSharedPreferencesProvider = StringSharedPreferencesFamily._();

final class StringSharedPreferencesProvider extends $NotifierProvider<StringSharedPreferences, SharedPreferencesState<String?>> {
  const StringSharedPreferencesProvider._({required StringSharedPreferencesFamily super.from, required String super.argument})
    : super(retry: null, name: r'stringSharedPreferencesProvider', isAutoDispose: false, dependencies: null, $allTransitiveDependencies: null);

  static const $allTransitiveDependencies0 = sharedPreferencesProvider;

  @override
  String debugGetCreateSourceHash() => _$stringSharedPreferencesHash();

  @override
  String toString() {
    return r'stringSharedPreferencesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  StringSharedPreferences create() => StringSharedPreferences();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferencesState<String?> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<SharedPreferencesState<String?>>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is StringSharedPreferencesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stringSharedPreferencesHash() => r'3dbe38b126b12544017f8538c33ea459704cf110';

final class StringSharedPreferencesFamily extends $Family
    with
        $ClassFamilyOverride<
          StringSharedPreferences,
          SharedPreferencesState<String?>,
          SharedPreferencesState<String?>,
          SharedPreferencesState<String?>,
          String
        > {
  const StringSharedPreferencesFamily._()
    : super(
        retry: null,
        name: r'stringSharedPreferencesProvider',
        dependencies: const <ProviderOrFamily>[sharedPreferencesProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[StringSharedPreferencesProvider.$allTransitiveDependencies0],
        isAutoDispose: false,
      );

  StringSharedPreferencesProvider call(String key) => StringSharedPreferencesProvider._(argument: key, from: this);

  @override
  String toString() => r'stringSharedPreferencesProvider';
}

abstract class _$StringSharedPreferences extends $Notifier<SharedPreferencesState<String?>> {
  late final _$args = ref.$arg as String;
  String get key => _$args;

  SharedPreferencesState<String?> build(String key);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<SharedPreferencesState<String?>, SharedPreferencesState<String?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SharedPreferencesState<String?>, SharedPreferencesState<String?>>,
              SharedPreferencesState<String?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
