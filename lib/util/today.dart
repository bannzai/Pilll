DateTime Function() _fakeToday;
void injectToday(DateTime Function() closure) {
  if (!bool.fromEnvironment('testing_mode', defaultValue: false)) {
    assert(false, "inject today should use testing mode");
  }
  _fakeToday = closure;
}

DateTime today() {
  if (bool.fromEnvironment('testing_mode', defaultValue: false)) {
    return _fakeToday();
  }
  return DateTime.now();
}
