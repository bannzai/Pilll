import 'package:flutter/material.dart';

enum SettingSection { pill, menstruation, notification, other }
enum SettingRowType { title, date }
typedef SettingsSelectedRow = void Function(SettingSection section, int row);

abstract class SettingListRowModel {
  Widget widget();
}

class SettingListTitleRowModel extends SettingListRowModel {
  final String title;

  SettingListTitleRowModel({this.title});
  @override
  Widget widget() {
    return ListTile(
      title: Text(title),
    );
  }
}

class SettingListTitleAndContentRowModel extends SettingListRowModel {
  final String title;
  final String content;

  SettingListTitleAndContentRowModel({this.title, this.content});
  @override
  Widget widget() {
    return ListTile(
      title: Text(title),
      trailing: Text(content),
    );
  }
}

class SettingsListSwitchRowModel extends SettingListRowModel {
  final String title;
  bool value;

  SettingsListSwitchRowModel({this.title, this.value});
  @override
  Widget widget() {
    return SwitchListTile(
      title: Text(title),
      onChanged: (bool value) {
        this.value = value;
      },
      value: this.value,
      // NOTE: Alignment to ListTile
      contentPadding: EdgeInsets.fromLTRB(14, 0, 6, 0),
    );
  }
}

class SettingsListDatePickerRowModel extends SettingListRowModel {
  final String title;
  final String content;

  SettingsListDatePickerRowModel({this.title, this.content});
  @override
  Widget widget() {
    return ListTile(
      title: Text(title),
      trailing: Text(content),
    );
  }
}
