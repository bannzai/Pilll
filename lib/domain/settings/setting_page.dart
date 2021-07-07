import 'package:pilll/analytics.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/components/organisms/setting/setting_menstruation_page.dart';
import 'package:pilll/domain/settings/components/rows/account_link.dart';
import 'package:pilll/domain/settings/components/rows/list_explain.dart';
import 'package:pilll/domain/settings/components/rows/pill_sheet_appearance_mode.dart';
import 'package:pilll/domain/settings/components/rows/pill_sheet_remove.dart';
import 'package:pilll/domain/settings/components/rows/pill_sheet_type.dart';
import 'package:pilll/domain/settings/components/rows/premium_introduction.dart';
import 'package:pilll/domain/settings/components/rows/taking_pill_notification.dart';
import 'package:pilll/domain/settings/components/rows/today_pill_number.dart';
import 'package:pilll/domain/settings/components/setting_section_title.dart';
import 'package:pilll/domain/settings/information_for_before_major_update.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/domain/settings/row_model.dart';
import 'package:pilll/domain/settings/reminder_times_page.dart';
import 'package:pilll/inquiry/inquiry.dart';
import 'package:pilll/domain/settings/setting_page_store.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/util/environment.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends HookWidget {
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
            if ((index + 1) == SettingPage.itemCount) {
              if (Environment.isProduction) {
                return Container();
              }
              return Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  child: Center(
                      child: Text("COPY DEBUG INFO",
                          style: TextColorStyle.primary)),
                  onTap: () async {
                    Clipboard.setData(
                        ClipboardData(text: await debugInfo("\n")));
                  },
                  onDoubleTap: () {
                    final signOut = Environment.signOutUser;
                    if (signOut == null) {
                      return;
                    }
                    showDiscardDialog(
                      context,
                      title: "サインアウトします",
                      message: '''
これは開発用のオプションです。サインアウトあとはアプリを再起動してお試しください。初期設定から始まります
''',
                      done: () async {
                        await signOut();
                      },
                      doneText: "サインアウト",
                    );
                  },
                  onLongPress: () {
                    final deleteUser = Environment.deleteUser;
                    if (deleteUser == null) {
                      return;
                    }
                    showDiscardDialog(
                      context,
                      title: "ユーザーを削除します",
                      message: '''
これは開発用のオプションです。ユーザーを削除したあとはアプリを再起動してからやり直してください。初期設定から始まります
''',
                      done: () async {
                        await deleteUser();
                      },
                      doneText: "削除",
                    );
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
          itemCount: SettingPage.itemCount,
          addRepaintBoundaries: false,
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final state = useProvider(settingStoreProvider.state);
    final setting = state.entity;
    if (setting == null) {
      return Container();
    }
    final pillSheet = state.latestPillSheet;
    return Container(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return HookBuilder(
            builder: (BuildContext context) {
              final section = SettingSection.values[index];
              switch (section) {
                case SettingSection.account:
                  return SettingSectionTitle(
                    text: "アカウント",
                    children: [
                      ListExplainRow(
                          text: "機種変更やスマホ紛失時など、データの引き継ぎ・復元には、アカウント登録が必要です。"),
                      AccountLinkRow(),
                      PremiumIntroductionRow(),
                    ],
                  );
                case SettingSection.pill:
                  return SettingSectionTitle(
                    text: "ピルシート",
                    children: [
                      PillSheetTypeRow(settingState: state),
                      PillSheetAppearanceModeRow(setting: setting),
                      if (pillSheet != null && pillSheet.isInvalid) ...[
                        TodayPllNumberRow(setting: setting),
                        PillSheetRemoveRow(),
                      ]
                    ],
                  );
                case SettingSection.notification:
                  return SettingSectionTitle(
                    text: "通知",
                    children: [
                      TakingPillNotification(setting: setting),
                    ],
                  );
                case SettingSection.menstruation:
                  return SettingSectionTitle(
                    text: "生理",
                    children: [],
                  );
                case SettingSection.other:
                  return SettingSectionTitle(
                    text: "その他",
                    children: [],
                  );
              }
            },
          );
        },
        itemCount: SettingSection.values.length,
        addRepaintBoundaries: false,
      ),
    );
  }

  List<SettingListRowModel> _rowModels(
      BuildContext context, SettingSection section) {
    final settingStore = useProvider(settingStoreProvider);
    final settingState = useProvider(settingStoreProvider.state);
    final pillSheetEntity = settingState.latestPillSheet;
    final settingEntity = settingState.entity;
    final isShowNotifyInRestDuration = !settingState.latestPillSheetIsInvalid &&
        pillSheetEntity != null &&
        !pillSheetEntity.pillSheetType.isNotExistsNotTakenDuration;
    if (settingEntity == null) {
      return [];
    }
    switch (section) {
      case SettingSection.pill:
        return [
          ...[],
        ];
      case SettingSection.notification:
        return [
          SettingsListDatePickerRowModel(
            title: "通知時刻",
            content: settingEntity.reminderTimes
                .map((e) => DateTimeFormatter.militaryTime(e.dateTime()))
                .join(", "),
            onTap: () {
              analytics.logEvent(
                name: "did_select_changing_reminder_times",
              );
              Navigator.of(context).push(ReminderTimesPageRoute.route());
            },
          ),
          if (isShowNotifyInRestDuration && pillSheetEntity != null)
            SettingsListSwitchRowModel(
              title: "${pillSheetEntity.pillSheetType.notTakenWord}期間の通知",
              subtitle:
                  "通知オフの場合は、${pillSheetEntity.pillSheetType.notTakenWord}期間の服用記録も自動で付けられます",
              value: settingEntity.isOnNotifyInNotTakenDuration,
              onTap: () {
                analytics.logEvent(
                  name: "toggle_notify_not_taken_duration",
                );
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                settingStore
                    .modifyIsOnNotifyInNotTakenDuration(
                        !settingEntity.isOnNotifyInNotTakenDuration)
                    .then((state) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text(
                        "${pillSheetEntity.pillSheetType.notTakenWord}期間の通知を${state.entity!.isOnNotifyInNotTakenDuration ? "ON" : "OFF"}にしました",
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
              error: () {
                final message =
                    "生理開始日のピル番号をご確認ください。現在選択しているピルシートタイプには存在しないピル番号が設定されています";
                return settingEntity.pillSheetType.totalCount <
                        settingEntity.pillNumberForFromMenstruation
                    ? message
                    : "";
              }(),
              onTap: () {
                analytics.logEvent(
                  name: "did_select_changing_about_menstruation",
                );
                Navigator.of(context).push(SettingMenstruationPageRoute.route(
                  done: null,
                  doneText: null,
                  title: "生理について",
                  pillSheetTotalCount: settingEntity.pillSheetType.totalCount,
                  model: SettingMenstruationPageModel(
                    selectedFromMenstruation:
                        settingEntity.pillNumberForFromMenstruation,
                    selectedDurationMenstruation:
                        settingEntity.durationMenstruation,
                    pillSheetType: settingEntity.pillSheetType,
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
                      salvagedOldStartTakenDate: salvagedOldStartTakenDate!,
                      salvagedOldLastTakenDate: salvagedOldLastTakenDate!,
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
              title: "FAQ",
              onTap: () {
                analytics.logEvent(name: "did_select_faq", parameters: {});
                launch(
                    "https://pilll.anotion.so/bb1f49eeded64b57929b7a13e9224d69",
                    forceSafariVC: true);
              }),
          SettingListTitleRowModel(
              title: "お問い合わせ",
              onTap: () {
                analytics.logEvent(name: "did_select_inquiry", parameters: {});
                inquiry();
              }),
        ];
      case SettingSection.account:
        return [];
    }
  }

  Widget _section(BuildContext context, SettingSection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingSectionTitle(
            text: () {
              switch (section) {
                case SettingSection.pill:
                  return "ピルシート";
                case SettingSection.menstruation:
                  return "生理";
                case SettingSection.notification:
                  return "通知";
                case SettingSection.account:
                  return "アカウント";
                case SettingSection.other:
                  return "その他";
              }
            }(),
            children: [
              ...[
                ..._rowModels(context, section).map((e) {
                  if (e is SettingListExplainRowModel) {
                    return [e.widget()];
                  }
                  return [e.widget(), _separatorItem()];
                }).expand((element) => element)
              ]..add(SizedBox(height: 16)),
            ]),
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
