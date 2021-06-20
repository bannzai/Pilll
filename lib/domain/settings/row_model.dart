import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/auth/apple.dart';
import 'package:pilll/auth/google.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/text_color.dart';

enum SettingSection { account, pill, notification, menstruation, other }
enum SettingRowType { title, date }

abstract class SettingListRowModel {
  Widget widget();
}

class SettingListTitleRowModel extends SettingListRowModel {
  final String title;
  final String error;
  final VoidCallback onTap;

  SettingListTitleRowModel(
      {required this.title, this.error = "", required this.onTap});

  @override
  Widget widget() {
    if (error.isEmpty) {
      return ListTile(
        title: Text(title, style: FontType.listRow),
        onTap: onTap,
      );
    } else {
      return ListTile(
        title: Row(
          children: [
            Text(title, style: FontType.listRow),
            SizedBox(width: 8),
            SvgPicture.asset("images/alert_24.svg", width: 24, height: 24),
          ],
        ),
        subtitle: Text(error),
        onTap: onTap,
      );
    }
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
    final subtitle = this.subtitle;
    return SwitchListTile(
      title: Text(title, style: FontType.listRow),
      subtitle:
          subtitle != null ? Text(subtitle, style: FontType.assisting) : null,
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

class SettingListExplainRowModel extends SettingListRowModel {
  final String content;

  SettingListExplainRowModel(this.content);
  @override
  Widget widget() {
    return ListTile(
      title: Text(content,
          style: FontType.assisting.merge(TextColorStyle.darkGray)),
    );
  }
}

class SettingListAccountLinkRowModel extends SettingListRowModel {
  final VoidCallback onTap;

  SettingListAccountLinkRowModel({required this.onTap});

  bool get _isLinked => isLinkedApple() || isLinkedGoogle();
  Widget _subtitle() {
    if (_isLinked) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset("images/checkmark_green.svg"),
          SizedBox(width: 6),
          Text("登録済み",
              style: FontType.assisting.merge(TextColorStyle.darkGray)),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset("images/alert_24.svg"),
          SizedBox(width: 6),
          Text("未登録", style: FontType.assisting.merge(TextColorStyle.darkGray)),
        ],
      );
    }
  }

  @override
  Widget widget() {
    return ListTile(
      title: Text("アカウント設定", style: FontType.listRow),
      trailing: _subtitle(),
      onTap: onTap,
    );
  }
}

class SettingListPremiumRowModel extends SettingListRowModel {
  final VoidCallback onTap;

  SettingListPremiumRowModel(this.onTap);
  @override
  Widget widget() {
    return ListTile(
      onTap: onTap,
      leading: Image.asset("images/pilll_icon.png", width: 32, height: 32),
      title: Align(
        alignment: Alignment(-1.1, 0),
        child: Text("Pilllプレミアム",
            style: FontType.assisting.merge(TextColorStyle.black)),
      ),
    );
  }
}
