import 'package:flutter/foundation.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:pilll/utils/version/version.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_is_released.g.dart';

/// アプリの現在バージョンがストアに既に公開済みかどうかを返す。
///
/// `true`: ストアに既に公開されている版。通常の告知表示・割引計算が動作する。
/// `false`: ストアにまだ出ていない未リリース版。非プレミアムユーザーにAdMob広告を表示し、割引計算をスキップする。
///
/// iOSは iTunes Search API、Android は Google Play Store のページ HTML から
/// ストア側の最新バージョン文字列を取得し、端末のアプリバージョンと比較する。
/// ストア取得失敗時は安全側に倒して `false`(未リリース扱い)を返す。
@Riverpod(keepAlive: true)
Future<bool> appIsReleased(AppIsReleasedRef ref) async {
  if (kDebugMode) {
    return true;
  }
  try {
    final packageInfo = await PackageInfo.fromPlatform();
    final status = await NewVersionPlus(
      iOSId: packageInfo.packageName,
      androidId: packageInfo.packageName,
      iOSAppStoreCountry: 'jp',
      androidPlayStoreCountry: 'jp',
    ).getVersionStatus().timeout(const Duration(seconds: 8));
    if (status == null) {
      return false;
    }
    return appIsReleasedFromVersions(
      appVersion: status.localVersion,
      storeVersion: status.storeVersion,
    );
  } catch (error, stack) {
    errorLogger.recordError(error, stack);
    return false;
  }
}

/// `appVersion` と `storeVersion` 文字列から「既にストア公開済みかどうか」を判定する純粋関数。
///
/// `storeVersion` が null(ストア取得失敗)のときは `false`(未リリース扱い)を返す。
/// それ以外は `appVersion <= storeVersion` なら `true`(公開済み)。
@visibleForTesting
bool appIsReleasedFromVersions({
  required String appVersion,
  required String? storeVersion,
}) {
  if (storeVersion == null) {
    return false;
  }
  return !Version.parse(appVersion).isGreaterThan(Version.parse(storeVersion));
}
