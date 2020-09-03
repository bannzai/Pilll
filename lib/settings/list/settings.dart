import 'package:Pilll/settings/list/model.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return _section(
          SettingSection.values[index],
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return _separatorItem();
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

  Widget _section(SettingSection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(section),
        ..._rowModels(section).map((e) => e.widget()),
      ],
    );
  }

  Widget _separatorItem() {
    return Container(
      height: 1,
      color: PilllColors.border,
    );
  }
}
