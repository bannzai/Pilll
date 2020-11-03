import 'package:Pilll/components/atoms/color.dart';
import 'package:flutter/material.dart';

enum SettingSection { pill, notification, menstruation, other }
enum SettingRowType { title, date }

abstract class SettingListRowModel {
  Widget widget();
}

class SettingListTitleRowModel extends SettingListRowModel {
  final String title;
  final VoidCallback onTap;

  SettingListTitleRowModel({@required this.title, @required this.onTap});

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

  SettingListTitleAndContentRowModel(
      {@required this.title, @required this.content, @required this.onTap});
  @override
  Widget widget() {
    return ListTile(
      title: Text(title),
      subtitle: Text(content),
      onTap: onTap,
    );
  }
}

class SettingsListSwitchRowModel extends SettingListRowModel {
  final String title;
  final bool value;
  final VoidCallback onTap;

  SettingsListSwitchRowModel(
      {@required this.title, @required this.value, @required this.onTap});
  @override
  Widget widget() {
    return SwitchListTile(
      title: Text(title),
      activeColor: PilllColors.primary,
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

  SettingsListDatePickerRowModel(
      {@required this.title, @required this.content, @required this.onTap});
  @override
  Widget widget() {
    return ListTile(
      title: Text(title),
      subtitle: Text(content),
      onTap: onTap,
    );
  }
}
