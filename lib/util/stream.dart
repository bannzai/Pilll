import 'dart:async';

extension ExtendStream<T extends Object> on Stream<T?> {
  Stream<T> whereNotNull() => where((event) => event != null).cast();
}
