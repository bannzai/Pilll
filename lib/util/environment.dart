abstract class Environment {
  static bool get isProduction => bool.fromEnvironment('dart.vm.product');
  static bool get isDevelopment => !isProduction;
  static bool isTest = false;
}
