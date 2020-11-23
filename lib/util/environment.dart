enum Flavor {
  DEVELOP,
  PRODUCTION,
}

abstract class Environment {
  static bool get isProduction => flavor == Flavor.PRODUCTION;
  static bool get isDevelopment => flavor == Flavor.DEVELOP;
  static bool isTest = false;
  static Flavor flavor;
}
