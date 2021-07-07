import 'package:pilll/analytics.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/domain/settings/components/rows/menstruation.dart';
import 'package:pilll/domain/settings/components/rows/account_link.dart';
import 'package:pilll/domain/settings/components/rows/list_explain.dart';
import 'package:pilll/domain/settings/components/rows/notification_in_rest_duration.dart';
import 'package:pilll/domain/settings/components/rows/notification_time.dart';
import 'package:pilll/domain/settings/components/rows/pill_sheet_appearance_mode.dart';
import 'package:pilll/domain/settings/components/rows/pill_sheet_remove.dart';
import 'package:pilll/domain/settings/components/rows/pill_sheet_type.dart';
import 'package:pilll/domain/settings/components/rows/premium_introduction.dart';
import 'package:pilll/domain/settings/components/rows/taking_pill_notification.dart';
import 'package:pilll/domain/settings/components/rows/today_pill_number.dart';
import 'package:pilll/domain/settings/components/rows/update_from_132.dart';
import 'package:pilll/domain/settings/components/setting_section_title.dart';
import 'package:pilll/domain/settings/information_for_before_major_update.dart';
import 'package:pilll/domain/settings/row_model.dart';
import 'package:pilll/inquiry/inquiry.dart';
import 'package:pilll/domain/settings/setting_page_store.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/util/environment.dart';
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
                      NotificationTimeRow(setting: setting),
                      if (pillSheet != null && pillSheet.hasRestDuration)
                        NotificationInRestDuration(
                            setting: setting, pillSheet: pillSheet),
                    ],
                  );
                case SettingSection.menstruation:
                  return SettingSectionTitle(
                    text: "生理",
                    children: [
                      MenstruationRow(setting),
                    ],
                  );
                case SettingSection.other:
                  return SettingSectionTitle(
                    text: "その他",
                    children: [
                      if (state.userIsUpdatedFrom132) UpdateFrom132Row()
                    ],
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
    if (settingEntity == null) {
      return [];
    }
    switch (section) {
      case SettingSection.pill:
        return [
          ...[],
        ];
      case SettingSection.notification:
        return [];
      case SettingSection.menstruation:
        return [];
      case SettingSection.other:
        return [
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
