import 'package:pilll/analytics.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/components/organisms/pill/pill_sheet_type_select_page.dart';
import 'package:pilll/components/organisms/setting/setting_menstruation_page.dart';
import 'package:pilll/domain/settings/information_for_before_major_update.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/user.dart';
import 'package:pilll/domain/settings/row_model.dart';
import 'package:pilll/domain/settings/modifing_pill_number_page.dart';
import 'package:pilll/domain/settings/reminder_times_page.dart';
import 'package:pilll/error/error_alert.dart';
import 'package:pilll/inquiry/inquiry.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:pilll/store/pill_sheet.dart';
import 'package:pilll/store/setting.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/util/environment.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class _TransactionModifier {
  final DatabaseConnection? _database;
  final Reader reader;

  _TransactionModifier(
    this._database, {
    required this.reader,
  });

  Future<void> modifyPillSheetType(PillSheetType type) {
    final database = _database;
    if (database == null) {
      throw FormatException("_database is necessary");
    }
    final pillSheetStore = reader(pillSheetStoreProvider);
    final settingStore = reader(settingStoreProvider);
    final pillSheetState = reader(pillSheetStoreProvider.state);
    final settingState = reader(settingStoreProvider.state);
    final pillSheetEntity = pillSheetState.entity;
    final settingEntity = settingState.entity;
    if (pillSheetEntity == null) {
      throw FormatException("pillSheetEntity is necessary");
    }
    if (settingEntity == null) {
      throw FormatException("settingEntity is necessary");
    }
    return database.transaction((transaction) {
      return Future.wait(
        [
          transaction
              .get(database.pillSheetReference(pillSheetEntity.documentID!))
              .then((pillSheetDocument) {
            transaction.update(pillSheetDocument.reference,
                {PillSheetFirestoreKey.typeInfo: type.typeInfo.toJson()});
          }),
          transaction.get(database.userReference()).then((userDocument) {
            transaction.update(userDocument.reference, {
              UserFirestoreFieldKeys.settings: settingEntity
                  .copyWith(pillSheetTypeRawPath: type.rawPath)
                  .toJson(),
            });
          })
        ],
      );
    }).then((_) {
      pillSheetStore.update(pillSheetEntity.copyWith(typeInfo: type.typeInfo));
      settingStore
          .update(settingEntity.copyWith(pillSheetTypeRawPath: type.rawPath));
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
        title: Text('設定', style: TextColorStyle.main),
        backgroundColor: PilllColors.white,
      ),
      body: Container(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            if ((index + 1) == SettingsPage.itemCount) {
              if (Environment.isProduction) {
                return Container();
              }
              return Padding(
                padding: const EdgeInsets.all(10),
                child: TextButton(
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
          itemCount: SettingsPage.itemCount,
          addRepaintBoundaries: false,
        ),
      ),
    );
  }

  Widget _sectionTitle(SettingSection section) {
    late String text;
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
    return Container(
      padding: EdgeInsets.only(top: 16, left: 15, right: 16),
      child: Text(
        text,
        style: FontType.assisting.merge(TextColorStyle.primary),
      ),
    );
  }

  List<SettingListRowModel>? _rowModels(
      BuildContext context, SettingSection section) {
    final pillSheetStore = useProvider(pillSheetStoreProvider);
    final pillSheetState = useProvider(pillSheetStoreProvider.state);
    final settingStore = useProvider(settingStoreProvider);
    final settingState = useProvider(settingStoreProvider.state);
    final transactionModifier = useProvider(transactionModifierProvider);
    switch (section) {
      case SettingSection.pill:
        return [
          () {
            return SettingListTitleAndContentRowModel(
              title: "種類",
              content: settingState.entity?.pillSheetType.fullName,
              onTap: () {
                analytics.logEvent(
                  name: "did_select_changing_pill_sheet_type",
                );
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
                    selectedPillSheetType: settingState.entity?.pillSheetType,
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
                    name: "did_select_changing_pill_number",
                  );
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
                    name: "did_select_removing_pill_sheet",
                  );
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
            subtitle: "通知時間までに服用した場合は通知はきません",
            value: settingState.entity?.isOnReminder,
            onTap: () {
              analytics.logEvent(
                name: "did_select_toggle_reminder",
              );
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              settingStore
                  .modifyIsOnReminder(!settingState.entity?.isOnReminder)
                  .then((state) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text(
                      "服用通知を${state.entity?.isOnReminder ? "ON" : "OFF"}にしました",
                    ),
                  ),
                );
              });
            },
          ),
          SettingsListDatePickerRowModel(
            title: "通知時刻",
            content: settingState.entity?.reminderTimes
                .map((e) => DateTimeFormatter.militaryTime(e.dateTime()))
                .join(", "),
            onTap: () {
              analytics.logEvent(
                name: "did_select_changing_reminder_times",
              );
              Navigator.of(context).push(ReminderTimesPageRoute.route());
            },
          ),
          if (!pillSheetState.isInvalid &&
              !pillSheetState.entity?.pillSheetType.isNotExistsNotTakenDuration)
            SettingsListSwitchRowModel(
              title:
                  "${pillSheetState.entity?.pillSheetType.notTakenWord}期間の通知",
              subtitle:
                  "通知オフの場合は、${pillSheetState.entity?.pillSheetType.notTakenWord}期間の服用記録も自動で付けられます",
              value: settingState.entity?.isOnNotifyInNotTakenDuration,
              onTap: () {
                analytics.logEvent(
                  name: "toggle_notify_not_taken_duration",
                );
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                settingStore
                    .modifyIsOnNotifyInNotTakenDuration(
                        !settingState.entity?.isOnNotifyInNotTakenDuration)
                    .then((state) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text(
                        "${pillSheetState.entity?.pillSheetType.notTakenWord}期間の通知を${state.entity?.isOnNotifyInNotTakenDuration ? "ON" : "OFF"}にしました",
                      ),
                    ),
                  );
                });
              },
            ),
        ];
      case SettingSection.menstruation:
        return [
          SettingListTitleRowModel(
              title: "生理について",
              onTap: () {
                analytics.logEvent(
                  name: "did_select_changing_about_menstruation",
                );
                Navigator.of(context).push(SettingMenstruationPageRoute.route(
                  done: null,
                  doneText: null,
                  title: "生理について",
                  pillSheetTotalCount:
                      settingState.entity?.pillSheetType.totalCount,
                  model: SettingMenstruationPageModel(
                    selectedFromMenstruation:
                        settingState.entity?.pillNumberForFromMenstruation,
                    selectedDurationMenstruation:
                        settingState.entity?.durationMenstruation,
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
          if (settingState.userIsUpdatedFrom132)
            SettingListTitleRowModel(
                title: "大型アップデート前の情報",
                onTap: () {
                  analytics
                      .logEvent(name: "did_select_migrate_132", parameters: {});
                  SharedPreferences.getInstance().then((storage) {
                    final salvagedOldStartTakenDate =
                        storage.getString(StringKey.salvagedOldStartTakenDate);
                    final salvagedOldLastTakenDate =
                        storage.getString(StringKey.salvagedOldLastTakenDate);
                    Navigator.of(context)
                        .push(InformationForBeforeMigrate132Route.route(
                      salvagedOldStartTakenDate: salvagedOldStartTakenDate,
                      salvagedOldLastTakenDate: salvagedOldLastTakenDate,
                    ));
                  });
                }),
          SettingListTitleRowModel(
              title: "利用規約",
              onTap: () {
                analytics.logEvent(name: "did_select_terms", parameters: {});
                launch("https://bannzai.github.io/Pilll/Terms",
                    forceSafariVC: true);
              }),
          SettingListTitleRowModel(
              title: "プライバシーポリシー",
              onTap: () {
                analytics.logEvent(
                    name: "did_select_privacy_policy", parameters: {});
                launch("https://bannzai.github.io/Pilll/PrivacyPolicy",
                    forceSafariVC: true);
              }),
          SettingListTitleRowModel(
              title: "お問い合わせ",
              onTap: () {
                analytics.logEvent(name: "did_select_inquiry", parameters: {});
                inquiry();
              }),
        ];
      default:
        throw ArgumentError.notNull("");
    }
  }

  Widget _section(BuildContext context, SettingSection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(section),
        ...[
          ..._rowModels(context, section)!.map((e) {
            return [e.widget(), _separatorItem()];
          }).expand((element) => element)
        ]..add(SizedBox(height: 16)),
      ],
    );
  }

  Widget _separatorItem() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Container(
        height: 1,
        color: PilllColors.border,
      ),
    );
  }
}

class ConfirmDeletePillSheet extends StatelessWidget {
  final Function() onDelete;

  const ConfirmDeletePillSheet({Key? key, required this.onDelete})
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
                style: FontType.subTitle.merge(TextColorStyle.main)),
            SizedBox(
              height: 15,
            ),
            Text("現在、服用記録をしているピルシートを削除します。",
                style: FontType.assisting.merge(TextColorStyle.main)),
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
