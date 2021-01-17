import 'package:Pilll/analytics.dart';
import 'package:Pilll/database/database.dart';
import 'package:Pilll/components/organisms/pill/pill_sheet_type_select_page.dart';
import 'package:Pilll/components/organisms/setting/setting_menstruation_page.dart';
import 'package:Pilll/entity/pill_sheet.dart';
import 'package:Pilll/entity/pill_sheet_type.dart';
import 'package:Pilll/entity/user.dart';
import 'package:Pilll/domain/settings/row_model.dart';
import 'package:Pilll/domain/settings/modifing_pill_number_page.dart';
import 'package:Pilll/domain/settings/reminder_times_page.dart';
import 'package:Pilll/error/error_alert.dart';
import 'package:Pilll/inquiry/inquiry.dart';
import 'package:Pilll/service/pill_sheet.dart';
import 'package:Pilll/store/pill_sheet.dart';
import 'package:Pilll/store/setting.dart';
import 'package:Pilll/components/atoms/buttons.dart';
import 'package:Pilll/components/atoms/color.dart';
import 'package:Pilll/components/atoms/font.dart';
import 'package:Pilll/components/atoms/text_color.dart';
import 'package:Pilll/store/user.dart';
import 'package:Pilll/util/environment.dart';
import 'package:Pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:url_launcher/url_launcher.dart';

class _TransactionModifier {
  final DatabaseConnection _database;
  final Reader reader;

  _TransactionModifier(
    this._database, {
    @required this.reader,
  });

  Future<void> modifyPillSheetType(PillSheetType type) {
    final pillSheetStore = reader(pillSheetStoreProvider);
    final settingStore = reader(settingStoreProvider);
    final pillSheetState = reader(pillSheetStoreProvider.state);
    final settingState = reader(settingStoreProvider.state);
    assert(pillSheetState.entity.documentID != null);
    return _database.transaction((transaction) {
      transaction.update(
          _database.pillSheetReference(pillSheetState.entity.documentID), {
        PillSheetFirestoreKey.typeInfo: type.typeInfo.toJson(),
      });
      transaction.update(_database.userReference(), {
        UserFirestoreFieldKeys.settings: settingState.entity
            .copyWith(pillSheetTypeRawPath: type.rawPath)
            .toJson(),
      });
      return;
    }).then((_) {
      pillSheetStore
          .update(pillSheetState.entity.copyWith(typeInfo: type.typeInfo));
      settingStore.update(
          settingState.entity.copyWith(pillSheetTypeRawPath: type.rawPath));
    });
  }
}

final transactionModifierProvider = Provider((ref) =>
    _TransactionModifier(ref.watch(databaseProvider), reader: ref.read));

class SettingsPage extends HookWidget {
  static final int itemCount = SettingSection.values.length + 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        title: Text('Pilll', style: TextColorStyle.main),
        backgroundColor: PilllColors.white,
      ),
      body: Container(
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            if ((index + 1) == SettingsPage.itemCount) {
              if (Environment.isProduction) {
                return Container();
              }
              return Padding(
                padding: const EdgeInsets.all(10),
                child: FlatButton(
                  child: Text("COPY DEBUG INFO"),
                  onPressed: () async {
                    Clipboard.setData(
                        ClipboardData(text: await debugInfo("\n")));
                  },
                ),
              );
            }
            return HookBuilder(
              builder: (BuildContext context) {
                return _section(
                  context,
                  SettingSection.values[index],
                );
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return _separatorItem();
          },
          itemCount: SettingsPage.itemCount,
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
    final userState = useProvider(userStoreProvider.state);
    switch (section) {
      case SettingSection.pill:
        return [
          () {
            return SettingListTitleAndContentRowModel(
              title: "種類",
              content: settingState.entity.pillSheetType.name,
              onTap: () {
                analytics.logEvent(
                    name: "setting_did_select_changing_pill_sheet_type",
                    parameters: {
                      "current_pill_sheet_type":
                          settingState.entity.pillSheetType.rawPath
                    });
                Navigator.of(context).push(
                  PillSheetTypeSelectPageRoute.route(
                    title: "種類",
                    backButtonIsHidden: false,
                    selected: (type) {
                      if (!pillSheetState.isInvalid)
                        transactionModifier.modifyPillSheetType(type);
                      else
                        settingStore.modifyType(type);
                      Navigator.pop(context);
                    },
                    done: null,
                    doneButtonText: "",
                    selectedPillSheetType: settingState.entity.pillSheetType,
                  ),
                );
              },
            );
          }(),
          if (!pillSheetState.isInvalid) ...[
            SettingListTitleRowModel(
                title: "今日飲むピル番号の変更",
                onTap: () {
                  analytics.logEvent(
                      name: "setting_did_select_changing_pill_number",
                      parameters: {
                        "current_pill_sheet_type":
                            settingState.entity.pillSheetType.rawPath,
                        "today_pill_number":
                            pillSheetState.entity.todayPillNumber,
                      });
                  Navigator.of(context).push(
                    ModifingPillNumberPageRoute.route(
                      markSelected: (number) {
                        Navigator.pop(context);
                        pillSheetStore.modifyBeginingDate(number);
                      },
                    ),
                  );
                }),
            SettingListTitleRowModel(
                title: "ピルシートの破棄",
                onTap: () {
                  analytics.logEvent(
                      name: "setting_did_select_removing_pill_sheet",
                      parameters: {
                        "current_pill_sheet_type":
                            settingState.entity.pillSheetType.rawPath,
                        "today_pill_number":
                            pillSheetState.entity.todayPillNumber,
                      });
                  showDialog(
                    context: context,
                    builder: (_) {
                      return ConfirmDeletePillSheet(onDelete: () {
                        pillSheetStore.delete().catchError((error) {
                          showErrorAlert(context,
                              message:
                                  "ピルシートがすでに削除されています。表示等に問題がある場合は設定タブから「お問い合わせ」ください");
                        }, test: (error) => error is PillSheetIsNotExists);
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
              analytics.logEvent(
                  name: "setting_did_select_toggle_reminder",
                  parameters: {
                    "current_pill_sheet_type":
                        settingState.entity.pillSheetType.rawPath,
                    "is_on_reminder": settingState.entity.isOnReminder,
                    "today_pill_number": pillSheetState.entity.todayPillNumber,
                  });
              settingStore
                  .modifyIsOnReminder(!settingState.entity.isOnReminder);
            },
          ),
          if (userState.entity.isSubscribed &&
              settingState.entity.isAutomaticallyCreatePillSheet)
            SettingsListSwitchRowModel(
              title: "自動でピルシートを作成",
              value: settingState.entity.isOnReminder,
              onTap: () {
                analytics.logEvent(
                    name:
                        "setting_did_select_toggle_automatically_create_pill_sheet",
                    parameters: {
                      "current_pill_sheet_type":
                          settingState.entity.pillSheetType.rawPath,
                      "is_automatically_create_pill_sheet":
                          settingState.entity.isAutomaticallyCreatePillSheet,
                      "today_pill_number":
                          pillSheetState.entity.todayPillNumber,
                      "is_on_reminder": settingState.entity.isOnReminder,
                    });
                settingStore.modifyIsAutomaticallyCreatePillSheet(
                    !settingState.entity.isAutomaticallyCreatePillSheet);
              },
            ),
          SettingsListDatePickerRowModel(
            title: "通知時刻",
            content: settingState.entity.reminderTimes
                .map((e) => DateTimeFormatter.militaryTime(e.dateTime()))
                .join(", "),
            onTap: () {
              analytics.logEvent(
                  name: "setting_did_select_changing_reminder_times",
                  parameters: {
                    "current_pill_sheet_type":
                        settingState.entity.pillSheetType.rawPath,
                    "is_on_reminder": settingState.entity.isOnReminder,
                    "today_pill_number": pillSheetState.entity.todayPillNumber,
                  });
              Navigator.of(context).push(ReminderTimesPageRoute.route());
            },
          ),
        ];
      case SettingSection.menstruation:
        return [
          SettingListTitleRowModel(
              title: "生理について",
              onTap: () {
                analytics.logEvent(
                    name: "setting_did_select_changing_about_menstruation",
                    parameters: {
                      "from_menstruation": settingState.entity.fromMenstruation,
                      "duration_menstruation":
                          settingState.entity.durationMenstruation,
                      "today_pill_number":
                          pillSheetState.entity.todayPillNumber,
                    });
                Navigator.of(context).push(SettingMenstruationPageRoute.route(
                  done: null,
                  doneText: null,
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
                ));
              }),
        ];
      case SettingSection.other:
        return [
          SettingListTitleRowModel(
              title: "利用規約",
              onTap: () {
                analytics
                    .logEvent(name: "setting_did_select_terms", parameters: {});
                launch("https://bannzai.github.io/Pilll/Terms",
                    forceSafariVC: true);
              }),
          SettingListTitleRowModel(
              title: "プライバシーポリシー",
              onTap: () {
                analytics.logEvent(
                    name: "setting_did_select_privacy_policy", parameters: {});
                launch("https://bannzai.github.io/Pilll/PrivacyPolicy",
                    forceSafariVC: true);
              }),
          SettingListTitleRowModel(
              title: "お問い合わせ",
              onTap: () {
                analytics.logEvent(
                    name: "setting_did_select_inquiry", parameters: {});
                inquiry();
              }),
        ];
      default:
        assert(false);
        return null;
    }
  }

  Widget _section(BuildContext context, SettingSection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(section),
        ..._rowModels(context, section).map((e) => e.widget()),
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
