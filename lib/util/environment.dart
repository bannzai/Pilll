enum Flavor {
  DEVELOP,
  PRODUCTION,
}

abstract class Environment {
  static bool get isProduction => flavor == Flavor.DEVELOP;
  static bool get isDevelopment => flavor == Flavor.PRODUCTION;
  static bool isTest = false;
  static Flavor flavor;
}
