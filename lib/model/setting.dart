import 'package:Pilll/model/pill_sheet.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'setting.freezed.dart';
part 'setting.g.dart';

@freezed
abstract class ReminderTime with _$ReminderTime {
  factory ReminderTime({
    @required int hour,
    @required int minute,
  }) = _Reminder;

  factory ReminderTime.fromJson(Map<String, dynamic> json) =>
      _$ReminderTimeFromJson(json);
  Map<String, dynamic> toJson() => _$_$_ReminderToJson(this);
}

@freezed
abstract class Setting with _$Setting {
  @late
  PillSheetType get pillSheetType =>
      PillSheetTypeFunctions.fromRawPath(pillSheetTypeRawPath);
  factory Setting({
    @nullable @required String pillSheetTypeRawPath,
    @nullable @required int fromMenstruation,
    @nullable @required int durationMenstruation,
    @nullable @required ReminderTime reminderTime,
    @Default(false) bool isOnReminder,
  }) = _Setting;

  factory Setting.fromJson(Map<String, dynamic> json) =>
      _$SettingFromJson(json);
  Map<String, dynamic> toJson() => _$_$_SettingToJson(this);

  Future<Setting> save() {
    return User.fetch().then((value) {
      return FirebaseFirestore.instance
          .collection(User.path)
          .doc(value.documentID)
          .set(
        {
          UserFirestoreFieldKeys.settings: toJson(),
        },
        SetOptions(merge: true),
      );
    }).then((_) => this);
  }

  DateTime reminderDateTime() {
    var t = DateTime.now().toLocal();
    return DateTime(t.year, t.month, t.day, reminderTime.hour,
        reminderTime.minute, t.second, t.millisecond, t.microsecond);
  }
}
