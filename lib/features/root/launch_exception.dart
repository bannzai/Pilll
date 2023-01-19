class LaunchException {
  final String message;
  final Object underlyingException;

  LaunchException(
    this.message,
    this.underlyingException,
  );

  @override
  String toString() => message + underlyingException.toString();
}
