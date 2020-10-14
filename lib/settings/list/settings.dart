import 'package:Pilll/database/database.dart';
import 'package:Pilll/main/components/pill_sheet_type_select_page.dart';
import 'package:Pilll/main/components/setting_menstruation_page.dart';
import 'package:Pilll/model/pill_mark_type.dart';
import 'package:Pilll/model/pill_sheet.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/model/setting.dart';
import 'package:Pilll/model/user.dart';
import 'package:Pilll/provider/auth.dart';
import 'package:Pilll/settings/list/model.dart';
import 'package:Pilll/settings/list/modifing_pill_number.dart';
import 'package:Pilll/store/pill_sheet.dart';
import 'package:Pilll/store/setting.dart';
import 'package:Pilll/style/button.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:Pilll/util/formatter/date_time_formatter.dart';
import 'package:Pilll/util/shared_preference/toolbar/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class _TransactionModifier {
  final Reader reader;

  _TransactionModifier(this.reader);
  DatabaseConnection get _database => reader(databaseProvider);

  Future<void> modifyPillSheetType(PillSheetType type) {
    final pillSheetStore = reader(pillSheetStoreProvider);
    final settingStore = reader(settingStoreProvider);
    final pillSheetState = reader(pillSheetStoreProvider.state);
    final settingState = reader(settingStoreProvider.state);
    return _database.transaction((transaction) {
      transaction.update(
          _database.pillSheetReference(pillSheetState.entity.documentID), {
        PillSheetFirestoreKey.typeInfo: type.typeInfo.toJson(),
      });
      transaction.update(_database.userReference(), {
        UserFirestoreFieldKeys.settings: settingState.entity
          ..copyWith(pillSheetTypeRawPath: type.rawPath).toJson(),
      });
      return;
    }).then((_) {
      pillSheetStore
          .update(pillSheetState.entity..copyWith(typeInfo: type.typeInfo));
      settingStore.update(
          settingState.entity..copyWith(pillSheetTypeRawPath: type.rawPath));
    });
  }
}

final transactionModifierProvider =
    Provider((ref) => _TransactionModifier(ref.read));

class Settings extends HookWidget {
  @override
  Widget build(BuildContext context) {
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
      BuildContext context, SettingSection section) {
    final pillSheetStore = useProvider(pillSheetStoreProvider);
    final pillSheetState = useProvider(pillSheetStoreProvider.state);
    final settingStore = useProvider(settingStoreProvider);
    final settingState = useProvider(settingStoreProvider.state);
    final transactionModifier = useProvider(transactionModifierProvider);
    switch (section) {
      case SettingSection.pill:
        return [
          SettingListTitleAndContentRowModel(
            title: "種類",
            content: settingState.entity.pillSheetType.name,
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return PillSheetTypeSelectPage(
                  title: "種類",
                  callback: (type) {
                    Navigator.pop(context);
                    if (pillSheetState.entity != null)
                      transactionModifier.modifyPillSheetType(type);
                    else
                      settingStore.modifyType(type);
                  },
                  selectedPillSheetType: settingState.entity.pillSheetType,
                );
              }));
            },
          ),
          if (pillSheetState.entity != null) ...[
            SettingListTitleRowModel(
                title: "今日飲むピル番号の変更",
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return ModifingPillNumberPage(
                      markSelected: (number) {
                        Navigator.pop(context);
                        var currentPillSheet = pillSheetState.entity;
                        pillSheetStore.modifyBeginingDate(currentPillSheet
                            .calcBeginingDateFromNextTodayPillNumber(number));
                      },
                      pillMarkTypeBuilder: (number) {
                        return PillMarkType.normal;
                      },
                    );
                  }));
                }),
            SettingListTitleRowModel(
                title: "ピルシートの破棄",
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return ConfirmDeletePillSheet(onDelete: () {
                        pillSheetStore.delete();
                      });
                    },
                  );
                }),
          ],
        ];
      case SettingSection.notification:
        return [
          SettingsListSwitchRowModel(
            title: "ピルの服用通知",
            value: settingState.entity.isOnReminder,
            onTap: () {
              settingStore
                  .modifyIsOnReminder(!settingState.entity.isOnReminder);
            },
          ),
          SettingsListDatePickerRowModel(
            title: "通知時刻",
            content: DateTimeFormatter.militaryTime(
                settingState.entity.reminderDateTime()),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return DateTimePicker(
                    initialDateTime: settingState.entity.reminderDateTime(),
                    done: (dateTime) {
                      Navigator.pop(context);
                      settingStore.modifyReminderTime(
                        ReminderTime(
                            hour: dateTime.hour, minute: dateTime.minute),
                      );
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
                      model: SettingMenstruationPageModel(
                        selectedFromMenstruation:
                            settingState.entity.fromMenstruation,
                        selectedDurationMenstruation:
                            settingState.entity.durationMenstruation,
                      ),
                      fromMenstructionDidDecide: (selectedFromMenstruction) =>
                          settingStore
                              .modifyFromMenstruation(selectedFromMenstruction),
                      durationMenstructionDidDecide:
                          (selectedDurationMenstruation) =>
                              settingStore.modifyDurationMenstruation(
                                  selectedDurationMenstruation),
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

class ConfirmDeletePillSheet extends StatelessWidget {
  final Function() onDelete;

  const ConfirmDeletePillSheet({Key key, @required this.onDelete})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: SvgPicture.asset("images/alert_24.svg"),
      content: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("ピルシートを破棄しますか？",
                style: FontType.subTitle.merge(TextColorStyle.black)),
            SizedBox(
              height: 15,
            ),
            Text("現在、服用記録をしているピルシートを削除します。",
                style: FontType.assisting.merge(TextColorStyle.lightGray)),
          ],
        ),
      ),
      actions: <Widget>[
        SecondaryButton(
          text: "キャンセル",
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        SecondaryButton(
          text: "破棄する",
          onPressed: () {
            onDelete();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
