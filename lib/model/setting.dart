import 'package:Pilll/model/app_state.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/model/user.dart';
import 'package:Pilll/repository/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'setting.g.dart';

@JsonSerializable(explicitToJson: true)
class ReminderTime {
  final int hour;
  final int minute;
  ReminderTime({
    @required this.hour,
    @required this.minute,
  })  : assert(hour != null),
        assert(minute != null);

  factory ReminderTime.fromJson(Map<String, dynamic> json) =>
      _$ReminderTimeFromJson(json);
  Map<String, dynamic> toJson() => _$ReminderTimeToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Setting {
  String pillSheetTypeRawPath;
  int fromMenstruation;
  int durationMenstruation;
  ReminderTime reminderTime;

  @JsonKey(defaultValue: false)
  bool isOnReminder = false;

  Setting({
    @required this.pillSheetTypeRawPath,
    @required this.fromMenstruation,
    @required this.durationMenstruation,
    @required this.reminderTime,
    @required this.isOnReminder,
  })  : assert(pillSheetTypeRawPath != null),
        assert(fromMenstruation != null),
        assert(durationMenstruation != null),
        assert(reminderTime != null),
        assert(isOnReminder != null);

  factory Setting.fromJson(Map<String, dynamic> json) =>
      _$SettingFromJson(json);
  Map<String, dynamic> toJson() => _$SettingToJson(this);

  PillSheetType get pillSheetType =>
      PillSheetTypeFunctions.fromRawPath(pillSheetTypeRawPath);

  Future<Setting> save() {
    return FirebaseFirestore.instance
        .collection(User.path)
        .doc(AppState.shared.user.documentID)
        .set(
      {
        UserFirestoreFieldKeys.settings: toJson(),
      },
      SetOptions(merge: true),
    ).then((_) => this);
  }

  DateTime reminderDateTime() {
    var t = DateTime.now().toLocal();
    return DateTime(t.year, t.month, t.day, reminderTime.hour,
        reminderTime.minute, t.second, t.millisecond, t.microsecond);
  }
}
