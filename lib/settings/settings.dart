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

class SettingListTitleAndSubTitleRowModel extends SettingListRowModel {
  final String title;
  final String subTitle;

  SettingListTitleAndSubTitleRowModel({this.title, this.subTitle});
  @override
  Widget widget() {
    return ListTile(
      title: Text(title),
      subtitle: Text(subTitle),
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
    );
  }
}

class SettingsListDatePickerRowModel extends SettingListRowModel {
  final String title;
  final String subTitle;

  SettingsListDatePickerRowModel({this.title, this.subTitle});
  @override
  Widget widget() {
    return ListTile(
      title: Text(title),
      subtitle: Text(subTitle),
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

  // ignore: missing_return
  Widget _sectionTitle(SettingSection section) {
    switch (section) {
      case SettingSection.pill:
        return ListTile(title: Text("ピルの設定"));
      case SettingSection.menstruation:
        return ListTile(title: Text("生理"));
      case SettingSection.notification:
        return ListTile(title: Text("通知"));
      case SettingSection.other:
        return ListTile(title: Text("その他"));
    }
  }

  // ignore: missing_return
  List<SettingListRowModel> _rowModels(SettingSection section) {
    switch (section) {
      case SettingSection.pill:
        return [
          SettingListTitleAndSubTitleRowModel(
              title: "種類", subTitle: "28錠タイプ(7錠偽薬)"),
        ];
      case SettingSection.menstruation:
        return [
          SettingListTitleRowModel(title: "生理について"),
        ];
      case SettingSection.notification:
        return [
          SettingsListSwitchRowModel(title: "ピルの服用通知", value: false),
          SettingsListDatePickerRowModel(title: "通知時刻", subTitle: "02:03"),
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
      height: 10,
      color: Colors.orange,
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
