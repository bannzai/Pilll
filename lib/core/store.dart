class Store {
  static final Store shared = Store._internal();
  factory Store() => shared;
  Store._internal();
}
