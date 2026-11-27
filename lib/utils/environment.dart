// ignore_for_file: constant_identifier_names

enum Flavor {
  DEVELOP,
  PRODUCTION,
  LOCAL, // Local is special flavor for development with firebase:emulators
}

abstract class Environment {
  static bool get isProduction => flavor == Flavor.PRODUCTION;
  static bool get isDevelopment => flavor == Flavor.DEVELOP || flavor == Flavor.LOCAL;
  static bool get isLocal => flavor == Flavor.LOCAL;
  static bool isTest = false;
  static Flavor? flavor;
  // Avoid too, too much CPU usage.
  // Ref: https://github.com/flutter/flutter/issues/13203#issuecomment-430134157
  static bool get disableWidgetAnimation => const bool.fromEnvironment('DISABLE_WIDGET_ANIMATION') && isDevelopment;

  static const siwaServiceIdentifier = String.fromEnvironment(
    'SIWA_SERVICE_IDENTIFIIER',
  );
  static const androidSiwaRedirectURL = String.fromEnvironment(
    'ANDROID_SIWA_REDIRECT_URL',
  );

  /// メンテナンス中かどうかを読む先 (service-maintenance の Worker の `/pilll`)。
  /// 開発用のビルドだけ `--dart-define=MAINTENANCE_STATE_URL=<URL>` で手元の確認用のサーバーに差し替えられる。
  /// 本番のビルドは dart-define の値を使わず、常に本番の URL を読む
  static String get maintenanceStateURL {
    const overriddenURL = String.fromEnvironment('MAINTENANCE_STATE_URL');
    if (overriddenURL.isNotEmpty && isDevelopment) {
      return overriddenURL;
    }
    return 'https://service-maintenance.star-kojiki.workers.dev/pilll';
  }

  static Function()? deleteUser;
  static Function()? signOutUser;
}
