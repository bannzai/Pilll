import 'package:Pilll/main/components/pill_sheet_type_select_page.dart';
import 'package:Pilll/main/components/setting_menstruation_page.dart';
import 'package:Pilll/model/setting.dart';
import 'package:Pilll/model/user.dart';
import 'package:Pilll/settings/list/model.dart';
import 'package:Pilll/settings/list/modifing_pill_number.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:Pilll/util/formatter/date_time_formatter.dart';
import 'package:Pilll/util/shared_preference/toolbar/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    var setting = context.watch<User>().setting;
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        title: Text('Pilll'),
        backgroundColor: PilllColors.primary,
      ),
      body: Container(
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return _section(
              setting,
              SettingSection.values[index],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return _separatorItem();
          },
          itemCount: SettingSection.values.length,
          addRepaintBoundaries: false,
        ),
      ),
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
        title: Text(text,
            style: FontType.assisting.merge(TextColorStyle.primary)));
  }

  List<SettingListRowModel> _rowModels(
    Setting setting,
    SettingSection section,
  ) {
    switch (section) {
      case SettingSection.pill:
        return [
          SettingListTitleAndContentRowModel(
            title: "種類",
            content: setting.pillSheetType.name,
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return PillSheetTypeSelectPage(
                  title: "種類",
                  callback: (type) {
                    setState(() {
                      Navigator.pop(context);
                      setting
                          .notifyWith((model) =>
                              model.pillSheetTypeRawPath = type.rawPath)
                          .then((value) => value.save())
                          .then((value) => User.user().setting = value);
                    });
                  },
                  selectedPillSheetType: setting.pillSheetType,
                );
              }));
            },
          ),
          SettingListTitleRowModel(
              title: "今日飲むピル番号の変更",
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return ModifingPillNumber();
                }));
              }),
          SettingListTitleRowModel(title: "ピルシートの破棄", onTap: () {}),
        ];
      case SettingSection.notification:
        return [
          SettingsListSwitchRowModel(
            title: "ピルの服用通知",
            value: setting.isOnReminder,
            onTap: () {
              setState(() => setting
                  .notifyWith(
                      (model) => model.isOnReminder = !setting.isOnReminder)
                  .then((value) => value.save())
                  .then((value) => User.user().setting = value));
            },
          ),
          SettingsListDatePickerRowModel(
            title: "通知時刻",
            content: DateTimeFormatter.militaryTime(setting.reminderDateTime()),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return DateTimePicker(
                    initialDateTime: setting.reminderDateTime(),
                    done: (dateTime) {
                      setState(() {
                        setting
                            .notifyWith(
                              (model) => model.reminderTime = ReminderTime(
                                  hour: dateTime.hour, minute: dateTime.minute),
                            )
                            .then((value) => value.save())
                            .then((value) => User.user().setting = value);
                        Navigator.pop(context);
                      });
                    },
                  );
                },
              );
            },
          ),
        ];
      case SettingSection.menstruation:
        return [
          SettingListTitleRowModel(
              title: "生理について",
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return SettingMenstruationPage(
                      done: null,
                      doneText: null,
                      skip: null,
                      title: "生理について",
                      selectedFromMenstruation: setting.fromMenstruation,
                      fromMenstructionDidDecide: (selectedFromMenstruction) {
                        setState(() {
                          setting
                              .notifyWith((model) => model.fromMenstruation =
                                  selectedFromMenstruction)
                              .then((value) => value.save())
                              .then((value) => User.user().setting = value);
                          Navigator.pop(context);
                        });
                      },
                      selectedDurationMenstruation:
                          setting.durationMenstruation,
                      durationMenstructionDidDecide:
                          (selectedDurationMenstruation) {
                        setState(() {
                          setting
                              .notifyWith((model) =>
                                  model.durationMenstruation =
                                      selectedDurationMenstruation)
                              .then((value) => value.save())
                              .then((value) => User.user().setting = value);
                          Navigator.pop(context);
                        });
                      },
                    );
                  },
                ));
              }),
        ];
      case SettingSection.other:
        return [
          SettingListTitleRowModel(
              title: "利用規約",
              onTap: () {
                launch("https://bannzai.github.io/Pilll/Terms",
                    forceSafariVC: true);
              }),
          SettingListTitleRowModel(
              title: "プライバシーポリシー",
              onTap: () {
                launch("https://bannzai.github.io/Pilll/PrivacyPolicy",
                    forceSafariVC: true);
              }),
          SettingListTitleRowModel(
              title: "お問い合わせ",
              onTap: () {
                PackageInfo.fromPlatform().then((value) {
                  var version = value.version;
                  launch(
                      "https://docs.google.com/forms/d/e/1FAIpQLSdLX5lLdOSr2B2mwzCptH1kjsJUYy8cKFSYguxl9yvep5b7ig/viewform?usp=pp_url&entry.2066946565=$version",
                      forceSafariVC: true);
                });
              }),
        ];
      default:
        assert(false);
        return null;
    }
  }

  Widget _section(Setting setting, SettingSection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(section),
        ..._rowModels(setting, section).map((e) => e.widget()),
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
