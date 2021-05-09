enum Flavor {
  DEVELOP,
  PRODUCTION,
  LOCAL, // Local is special flavor for development with firebase:emulators
}

abstract class Environment {
  static bool get isProduction => flavor == Flavor.PRODUCTION;
  static bool get isDevelopment =>
      flavor == Flavor.DEVELOP || flavor == Flavor.LOCAL;
  static bool get isLocal => flavor == Flavor.LOCAL;
  static bool isTest = false;
  static Flavor? flavor;
  // Avoid too, too much CPU usage.
  // Ref: https://github.com/flutter/flutter/issues/13203#issuecomment-430134157
  static bool get disableWidgetAnimation =>
      bool.fromEnvironment("DISABLE_WIDGET_ANIMATION") && isDevelopment;
}
