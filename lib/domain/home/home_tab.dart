import 'package:flutter/material.dart';
import 'package:pilll/domain/calendar/calendar_page.dart';
import 'package:pilll/domain/record/record_page.dart';
import 'package:pilll/domain/settings/settings_page.dart';

enum HomePageTab { record, calendar, settings }

extension HomePageTabFunctions on HomePageTab {
  Widget widget() {
    switch (this) {
      case HomePageTab.record:
        return RecordPage();
      case HomePageTab.calendar:
        return CalendarPage();
      case HomePageTab.settings:
        return SettingsPage();
    }
  }

  String get screenName {
    switch (this) {
      case HomePageTab.record:
        return "RecordPage";
      case HomePageTab.calendar:
        return "CalendarPage";
      case HomePageTab.settings:
        return "SettingsPage";
    }
  }
}
