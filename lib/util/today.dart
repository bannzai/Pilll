import 'package:Pilll/util/environment.dart';

DateTime Function() _fakeToday;
void injectToday(DateTime Function() closure) {
  if (!Environment.isProduction) _fakeToday = closure;
}

DateTime today() {
  if (Environment.isProduction) {
    return DateTime.now();
  }
  var date = _fakeToday();
  injectToday(null);
  return date ?? DateTime.now();
}
