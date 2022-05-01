import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/util/datetime/day.dart';

List<Menstruation> dropInTheMiddleMenstruation(
    List<Menstruation> menstruations) {
  final _menstruations = [...menstruations];
  if (_menstruations.isEmpty) {
    return [];
  }
  final latestMenstruation = _menstruations.first;
  if (latestMenstruation.dateRange.inRange(today())) {
    _menstruations.removeAt(0);
  }
  return _menstruations;
}
