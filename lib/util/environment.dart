abstract class Environment {
  static bool get isProduction => bool.fromEnvironment('dart.vm.product');
}
