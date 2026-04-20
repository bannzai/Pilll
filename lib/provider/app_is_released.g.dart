// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_is_released.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appIsReleasedHash() => r'21463ba1d3ce5add8298b0bddb54bdb773ea8444';

/// アプリの現在バージョンがストアに既に公開済みかどうかを返す。
///
/// `true`: ストアに既に公開されている版。通常の告知表示・割引計算が動作する。
/// `false`: ストアにまだ出ていない未リリース版。非プレミアムユーザーにAdMob広告を表示し、割引計算をスキップする。
///
/// iOSは iTunes Search API、Android は Google Play Store のページ HTML から
/// ストア側の最新バージョン文字列を取得し、端末のアプリバージョンと比較する。
/// ストア取得失敗時は安全側に倒して `false`(未リリース扱い)を返す。
///
/// Copied from [appIsReleased].
@ProviderFor(appIsReleased)
final appIsReleasedProvider = FutureProvider<bool>.internal(
  appIsReleased,
  name: r'appIsReleasedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$appIsReleasedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppIsReleasedRef = FutureProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
