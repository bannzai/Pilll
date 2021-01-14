int timeZoneOffsetHour(int jstHour) {
  final date = DateTime(2020, 1, 1, jstHour);
  if (date.timeZoneName == "JST") {
    return jstHour;
  }
  final jstOffset = 9;
  final offset = date.timeZoneOffset.inHours;
  return DateTime(2020, 1, 1, jstHour + jstOffset - offset).hour;
}
