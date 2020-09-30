import 'package:Pilll/util/environment.dart';

DateTime Function() _fakeToday;
void injectToday(DateTime Function() closure) {
  if (!Environment.isProduction) _fakeToday = closure;
}

DateTime today() {
  if (!Environment.isProduction) return _fakeToday();
  return DateTime.now();
}
