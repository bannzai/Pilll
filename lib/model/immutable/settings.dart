import 'package:Pilll/model/pill_sheet_type.dart';

class Settings {
  PillSheetType pillSheetType;
  int fromMenstruation;
  int durationMenstruation;
  int hour;
  int minute;
  bool isOnReminder;

  Map<String, dynamic> get settings {
    var settings = Map<String, dynamic>();
    if (fromMenstruation != null)
      settings["beginingMenstruationFromAfterFakePeriod"] = fromMenstruation;
    if (durationMenstruation != null)
      settings["menstuationPeriod"] = fromMenstruation;
    settings["reminderTime"] = {};
    if (hour != null) settings["reminderTime"]["hour"] = hour;
    if (minute != null) settings["reminderTime"]["minute"] = minute;
    if (isOnReminder != null) settings["isOnReminder"] = isOnReminder;
    if (pillSheetType != null)
      settings["pillSheetTypeRawPath"] = pillSheetType.name;
    return settings;
  }
}
