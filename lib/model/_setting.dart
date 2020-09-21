import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class SettingFirestoreFieldyKeys {
  static final String beginingMenstruationFromAfterFakePeriod =
      "beginingMenstruationFromAfterFakePeriod";
  static final String durationMenstruation = "durationMenstruation";
  static final String reminderTime = "reminderTime";
  static final String reminderTimeHour = "hour";
  static final String reminderTimeMinute = "minute";
  static final String isOnReminder = "isOnReminder";
  static final String pillSheetTypeRawPath = "pillSheetTypeRawPath";
}

class Setting extends Equatable {
  final PillSheetType pillSheetType;
  final int fromMenstruation;
  final int durationMenstruation;
  final int reminderHour;
  final int reminderMinute;
  final bool isOnReminder;

  @override
  List<Object> get props => [];

  factory Setting(Map<String, dynamic> firestoreRowData) {
    assert(firestoreRowData != null);
    String pillSheetTypeRawPath =
        firestoreRowData[SettingFirestoreFieldyKeys.pillSheetTypeRawPath];
    return Setting._(
      pillSheetType: pillSheetTypeRawPath == null
          ? null
          : PillSheetTypeFunctions.fromName(pillSheetTypeRawPath),
      fromMenstruation: firestoreRowData[
          SettingFirestoreFieldyKeys.beginingMenstruationFromAfterFakePeriod],
      durationMenstruation:
          firestoreRowData[SettingFirestoreFieldyKeys.durationMenstruation],
      reminderHour: firestoreRowData[SettingFirestoreFieldyKeys.reminderTime]
          [SettingFirestoreFieldyKeys.reminderTimeHour],
      reminderMinute: firestoreRowData[SettingFirestoreFieldyKeys.reminderTime]
          [SettingFirestoreFieldyKeys.reminderTimeMinute],
      isOnReminder:
          firestoreRowData[SettingFirestoreFieldyKeys.isOnReminder] ?? false,
    );
  }
  Setting._({
    @required this.pillSheetType,
    @required this.fromMenstruation,
    @required this.durationMenstruation,
    @required this.reminderHour,
    @required this.reminderMinute,
    @required this.isOnReminder,
  }) : assert(isOnReminder != null);

  Map<String, dynamic> get firestoreRowData {
    var rowData = Map<String, dynamic>();
    if (fromMenstruation != null)
      rowData[SettingFirestoreFieldyKeys
          .beginingMenstruationFromAfterFakePeriod] = fromMenstruation;
    if (durationMenstruation != null)
      rowData[SettingFirestoreFieldyKeys.durationMenstruation] =
          durationMenstruation;
    if (reminderHour != null || reminderMinute != null)
      rowData[SettingFirestoreFieldyKeys.reminderTime] = {};
    if (reminderHour != null)
      rowData[SettingFirestoreFieldyKeys.reminderTime]
          [SettingFirestoreFieldyKeys.reminderTimeHour] = reminderHour;
    if (reminderMinute != null)
      rowData[SettingFirestoreFieldyKeys.reminderTime]
          [SettingFirestoreFieldyKeys.reminderTimeMinute] = reminderMinute;
    rowData[SettingFirestoreFieldyKeys.isOnReminder] = isOnReminder ?? false;
    if (pillSheetType != null)
      rowData[SettingFirestoreFieldyKeys.pillSheetTypeRawPath] =
          pillSheetType.name;
    return rowData;
  }

  Future<void> save() {
    return User.fetch().then((value) {
      return FirebaseFirestore.instance
          .collection(User.path)
          .doc(value.documentID)
          .set(
        {
          UserFirestoreFieldKeys.settings: firestoreRowData,
        },
        SetOptions(merge: true),
      );
    });
  }

  DateTime reminderDateTime() {
    var t = DateTime.now().toLocal();
    return DateTime(t.year, t.month, t.day, reminderHour, reminderMinute,
        t.second, t.millisecond, t.microsecond);
  }
}
