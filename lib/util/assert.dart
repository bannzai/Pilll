void fatal(
    {bool condition = false, String message = "Cause Pill fatal error"}) {
  const isProduction = bool.fromEnvironment('dart.vm.product');
  if (condition) {
    return;
  }
  if (isProduction) {
    throw FormatException(message);
  }
  assert(condition, message);
}
