import 'package:Pilll/util/environment.dart';

DateTime Function() _fakeToday;
void injectToday(DateTime Function() closure) {
  if (!Environment.isProduction) _fakeToday = closure;
}

DateTime today() {
  if (!Environment.isProduction) {
    var date = _fakeToday();
    injectToday(null);
    return date;
  }
  return DateTime.now();
}
