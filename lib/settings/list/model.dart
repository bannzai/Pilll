import 'package:flutter/material.dart';

enum SettingSection { pill, menstruation, notification, other }
enum SettingRowType { title, date }

abstract class SettingListRowModel {
  Widget widget();
}

class SettingListTitleRowModel extends SettingListRowModel {
  final String title;
  final VoidCallback onTap;

  SettingListTitleRowModel({this.title, this.onTap});

  @override
  Widget widget() {
    return ListTile(
      title: Text(title),
      onTap: onTap,
    );
  }
}

class SettingListTitleAndContentRowModel extends SettingListRowModel {
  final String title;
  final String content;
  final VoidCallback onTap;

  SettingListTitleAndContentRowModel({this.title, this.content, this.onTap});
  @override
  Widget widget() {
    return ListTile(
      title: Text(title),
      trailing: Text(content),
      onTap: onTap,
    );
  }
}

class SettingsListSwitchRowModel extends SettingListRowModel {
  final String title;
  final bool value;
  final VoidCallback onTap;

  SettingsListSwitchRowModel({this.title, this.value, this.onTap});
  @override
  Widget widget() {
    return SwitchListTile(
      title: Text(title),
      onChanged: (bool value) {
        this.onTap();
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
  final VoidCallback onTap;

  SettingsListDatePickerRowModel({this.title, this.content, this.onTap});
  @override
  Widget widget() {
    return ListTile(
      title: Text(title),
      trailing: Text(content),
      onTap: onTap,
    );
  }
}
