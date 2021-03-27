import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:flutter/material.dart';

enum SettingSection { pill, notification, menstruation, other }
enum SettingRowType { title, date }

abstract class SettingListRowModel {
  Widget widget();
}

class SettingListTitleRowModel extends SettingListRowModel {
  final String title;
  final VoidCallback onTap;

  SettingListTitleRowModel({required this.title, required this.onTap});

  @override
  Widget widget() {
    return ListTile(
      title: Text(title, style: FontType.listRow),
      onTap: onTap,
    );
  }
}

class SettingListTitleAndContentRowModel extends SettingListRowModel {
  final String title;
  final String content;
  final VoidCallback onTap;

  SettingListTitleAndContentRowModel(
      {required this.title, required this.content, required this.onTap});
  @override
  Widget widget() {
    return ListTile(
      title: Text(title, style: FontType.listRow),
      subtitle: Text(content),
      onTap: onTap,
    );
  }
}

class SettingsListSwitchRowModel extends SettingListRowModel {
  final String title;
  final String? subtitle;
  final bool value;
  final VoidCallback onTap;

  SettingsListSwitchRowModel(
      {required this.title,
      this.subtitle,
      required this.value,
      required this.onTap});
  @override
  Widget widget() {
    return SwitchListTile(
      title: Text(title, style: FontType.listRow),
      subtitle:
          subtitle != null ? Text(subtitle!, style: FontType.assisting) : null,
      activeColor: PilllColors.primary,
      onChanged: (bool value) {
        this.onTap();
      },
      value: this.value,
      // NOTE: when configured subtitle, the space between elements becomes very narrow
      contentPadding: EdgeInsets.fromLTRB(
          14, subtitle == null ? 0 : 8, 6, subtitle == null ? 0 : 8),
    );
  }
}

class SettingsListDatePickerRowModel extends SettingListRowModel {
  final String title;
  final String content;
  final VoidCallback onTap;

  SettingsListDatePickerRowModel(
      {required this.title, required this.content, required this.onTap});
  @override
  Widget widget() {
    return ListTile(
      title: Text(title, style: FontType.listRow),
      subtitle: Text(content),
      onTap: onTap,
    );
  }
}
