import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
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

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return _section(SettingSection.values[index], (section, row) {});
      },
      separatorBuilder: (BuildContext context, int index) {
        return separatorItem();
      },
      itemCount: SettingSection.values.length,
      addRepaintBoundaries: false,
    );
  }

  Widget _sectionTitle(SettingSection section) {
    String text;
    switch (section) {
      case SettingSection.pill:
        text = "ピルの設定";
        break;
      case SettingSection.menstruation:
        text = "生理";
        break;
      case SettingSection.notification:
        text = "通知";
        break;
      case SettingSection.other:
        text = "その他";
        break;
    }
    return ListTile(
        title:
            Text(text, style: FontType.assisting.merge(TextColorStyle.gray)));
  }

  // ignore: missing_return
  List<SettingListRowModel> _rowModels(SettingSection section) {
    switch (section) {
      case SettingSection.pill:
        return [
          SettingListTitleAndContentRowModel(
              title: "種類", content: "28錠タイプ(7錠偽薬)"),
        ];
      case SettingSection.menstruation:
        return [
          SettingListTitleRowModel(title: "生理について"),
        ];
      case SettingSection.notification:
        return [
          SettingsListSwitchRowModel(title: "ピルの服用通知", value: false),
          SettingsListDatePickerRowModel(title: "通知時刻", content: "02:03"),
        ];
      case SettingSection.other:
        return [
          SettingListTitleRowModel(title: "利用規約"),
          SettingListTitleRowModel(title: "プライバシーポリシー"),
          SettingListTitleRowModel(title: "お問い合わせ"),
        ];
    }
  }

  Widget _section(SettingSection section, SettingsSelectedRow callback) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(section),
        ..._rowModels(section).map((e) => e.widget()),
      ],
    );
  }

  Widget separatorItem() {
    return Container(
      height: 1,
      color: PilllColors.border,
    );
  }

  Widget _messageItem(String title) {
    return Container(
      decoration: new BoxDecoration(
          border:
              new Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ),
        onTap: () {
          print("onTap called.");
        }, // タップ
        onLongPress: () {
          print("onLongTap called.");
        }, // 長押し
      ),
    );
  }
}
