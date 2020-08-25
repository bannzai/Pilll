import 'package:flutter/material.dart';

enum SettingSection { first, second }
enum SettingRowType { title, date }
typedef SettingsSelectedRow = void Function(SettingSection section, int row);

abstract class SettingListRowModel {
  Widget widget();
}

class SettingsListTitleRowModel extends SettingListRowModel {
  final String text;

  SettingsListTitleRowModel(this.text);
  @override
  Widget widget() {
    return ListTile(title: Text(text));
  }
}

class SettingsListDateRowModel extends SettingListRowModel {
  @override
  Widget widget() {
    return Text("TODO:");
  }
}

class Settings extends StatelessWidget {
  Map<SettingSection, String> dataSource = {};
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
    return ListTile(title: Text("sectin titile $section"));
  }

  List<SettingListRowModel> _rowModels(SettingSection section) {
    switch (section) {
      case SettingSection.first:
        return [SettingsListTitleRowModel("abc")];
      case SettingSection.second:
        return [];
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
