import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/domain/settings/components/rows/menstruation.dart';
import 'package:pilll/domain/settings/components/rows/account_link.dart';
import 'package:pilll/domain/settings/components/rows/list_explain.dart';
import 'package:pilll/domain/settings/components/rows/notification_in_rest_duration.dart';
import 'package:pilll/domain/settings/components/rows/notification_time.dart';
import 'package:pilll/domain/settings/components/rows/pill_sheet_appearance_mode.dart';
import 'package:pilll/domain/settings/components/rows/pill_sheet_remove.dart';
import 'package:pilll/domain/settings/components/rows/pill_sheet_type.dart';
import 'package:pilll/domain/settings/components/rows/quick_record.dart';
import 'package:pilll/domain/settings/components/rows/taking_pill_notification.dart';
import 'package:pilll/domain/settings/components/rows/today_pill_number.dart';
import 'package:pilll/domain/settings/components/rows/update_from_132.dart';
import 'package:pilll/domain/settings/components/setting_section_title.dart';
import 'package:pilll/inquiry/inquiry.dart';
import 'package:pilll/domain/settings/setting_page_store.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/util/environment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

enum SettingSection { account, pill, notification, menstruation, other }

class SettingPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        title: Text('設定', style: TextColorStyle.main),
        backgroundColor: PilllColors.white,
      ),
      body: Container(child: _body(context)),
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
                      _separator(),
                    ],
                  );
                case SettingSection.pill:
                  return SettingSectionTitle(
                    text: "ピルシート",
                    children: [
                      PillSheetTypeRow(settingState: state),
                      _separator(),
                      PillSheetAppearanceModeRow(setting: setting),
                      _separator(),
                      if (pillSheet != null && !pillSheet.isInvalid) ...[
                        TodayPllNumberRow(setting: setting),
                        _separator(),
                        PillSheetRemoveRow(),
                        _separator(),
                      ]
                    ],
                  );
                case SettingSection.notification:
                  return SettingSectionTitle(
                    text: "通知",
                    children: [
                      TakingPillNotification(setting: setting),
                      _separator(),
                      NotificationTimeRow(setting: setting),
                      _separator(),
                      if (pillSheet != null && pillSheet.hasRestDuration) ...[
                        NotificationInRestDuration(
                            setting: setting, pillSheet: pillSheet),
                        _separator(),
                      ],
                      if (!state.isPremium)
                        QuickRecordRow(isTrial: state.isTrial),
                    ],
                  );
                case SettingSection.menstruation:
                  return SettingSectionTitle(
                    text: "生理",
                    children: [
                      MenstruationRow(setting),
                      _separator(),
                    ],
                  );
                case SettingSection.other:
                  return SettingSectionTitle(
                    text: "その他",
                    children: [
                      if (state.userIsUpdatedFrom132) ...[
                        UpdateFrom132Row(),
                        _separator(),
                      ],
                      ListTile(
                          title: Text("利用規約", style: FontType.listRow),
                          onTap: () {
                            analytics.logEvent(
                                name: "did_select_terms", parameters: {});
                            launch("https://bannzai.github.io/Pilll/Terms",
                                forceSafariVC: true);
                          }),
                      _separator(),
                      ListTile(
                          title: Text("プライバシーポリシー", style: FontType.listRow),
                          onTap: () {
                            analytics.logEvent(
                                name: "did_select_privacy_policy",
                                parameters: {});
                            launch(
                                "https://bannzai.github.io/Pilll/PrivacyPolicy",
                                forceSafariVC: true);
                          }),
                      _separator(),
                      ListTile(
                          title: Text("FAQ", style: FontType.listRow),
                          onTap: () {
                            analytics.logEvent(
                                name: "did_select_faq", parameters: {});
                            launch(
                                "https://pilll.anotion.so/bb1f49eeded64b57929b7a13e9224d69",
                                forceSafariVC: true);
                          }),
                      _separator(),
                      ListTile(
                          title: Text("お問い合わせ", style: FontType.listRow),
                          onTap: () {
                            analytics.logEvent(
                                name: "did_select_inquiry", parameters: {});
                            inquiry();
                          }),
                      _separator(),
                      if (Environment.isDevelopment) _debug(context),
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

  Widget _debug(BuildContext context) {
    if (Environment.isProduction) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 20),
      child: GestureDetector(
        child: Center(
            child: Text("COPY DEBUG INFO", style: TextColorStyle.primary)),
        onTap: () async {
          Clipboard.setData(ClipboardData(text: await debugInfo("\n")));
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

  Widget _separator() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Container(
        height: 1,
        color: PilllColors.border,
      ),
    );
  }
}
