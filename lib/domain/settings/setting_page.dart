import 'dart:io';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/domain/settings/components/rows/creating_new_pillsheet.dart';
import 'package:pilll/domain/settings/components/rows/health_care.dart';
import 'package:pilll/domain/settings/components/rows/menstruation.dart';
import 'package:pilll/domain/settings/components/rows/account_link.dart';
import 'package:pilll/domain/settings/components/rows/list_explain.dart';
import 'package:pilll/domain/settings/components/rows/reminder_notification_customize_word.dart';
import 'package:pilll/domain/settings/components/rows/notification_in_rest_duration.dart';
import 'package:pilll/domain/settings/components/rows/notification_time.dart';
import 'package:pilll/domain/settings/components/rows/pill_sheet_remove.dart';
import 'package:pilll/domain/settings/components/rows/premium_introduction.dart';
import 'package:pilll/domain/settings/components/rows/quick_record.dart';
import 'package:pilll/domain/settings/components/rows/taking_pill_notification.dart';
import 'package:pilll/domain/settings/components/rows/today_pill_number.dart';
import 'package:pilll/domain/settings/components/rows/update_from_132.dart';
import 'package:pilll/domain/settings/components/setting_section_title.dart';
import 'package:pilll/domain/settings/setting_page_state.codegen.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/hooks/automatic_keep_alive_client_mixin.dart';
import 'package:pilll/domain/settings/components/inquiry/inquiry.dart';
import 'package:pilll/domain/settings/setting_page_state_notifier.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/util/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

enum SettingSection {
  account,
  premium,
  pill,
  notification,
  menstruation,
  other
}

class SettingPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(settingStoreProvider.notifier);
    final state = ref.watch(settingStoreProvider);

    useAutomaticKeepAlive(wantKeepAlive: true);

    return state.when(
      data: (state) => SettingPageBody(store: store, state: state),
      error: (error, _) => UniversalErrorPage(
        error: error,
        child: null,
        reload: () => ref.refresh(settingStateProvider),
      ),
      loading: () => ScaffoldIndicator(),
    );
  }
}

class SettingPageBody extends StatelessWidget {
  final SettingStateNotifier store;
  final SettingState state;

  const SettingPageBody({
    Key? key,
    required this.store,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final setting = state.setting;
    final pillSheetGroup = state.latestPillSheetGroup;
    final activedPillSheet = pillSheetGroup?.activedPillSheet;
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
                      const ListExplainRow(
                          text: "機種変更やスマホ紛失時など、データの引き継ぎ・復元には、アカウント登録が必要です。"),
                      AccountLinkRow(),
                      _separator(),
                    ],
                  );
                case SettingSection.premium:
                  return SettingSectionTitle(text: "Pilllプレミアム", children: [
                    if (state.premiumAndTrial.isTrial) ...[
                      ListTile(
                        title: const Text("プレミアムお試し体験について",
                            style: FontType.listRow),
                        onTap: () {
                          analytics.logEvent(
                              name: "did_select_about_trial", parameters: {});
                          launch(
                              "https://pilll.wraptas.site/3abd690f501549c48f813fd310b5f242",
                              forceSafariVC: true);
                        },
                      ),
                      _separator(),
                    ],
                    PremiumIntroductionRow(
                      isPremium: state.premiumAndTrial.isPremium,
                      trialDeadlineDate:
                          state.premiumAndTrial.trialDeadlineDate,
                    ),
                    _separator(),
                  ]);
                case SettingSection.pill:
                  return SettingSectionTitle(
                    text: "ピルシート",
                    children: [
                      if (activedPillSheet != null &&
                          pillSheetGroup != null &&
                          !pillSheetGroup.isDeactived) ...[
                        TodayPllNumberRow(
                          setting: setting,
                          pillSheetGroup: pillSheetGroup,
                          activedPillSheet: activedPillSheet,
                        ),
                        _separator(),
                        PillSheetRemoveRow(
                          latestPillSheetGroup: pillSheetGroup,
                          activedPillSheet: activedPillSheet,
                        ),
                        _separator(),
                      ],
                      CreatingNewPillSheetRow(
                        setting: setting,
                        isPremium: state.premiumAndTrial.isPremium,
                        isTrial: state.premiumAndTrial.isTrial,
                        trialDeadlineDate:
                            state.premiumAndTrial.trialDeadlineDate,
                      ),
                      _separator(),
                    ],
                  );
                case SettingSection.notification:
                  return SettingSectionTitle(
                    text: "通知",
                    children: [
                      TakingPillNotification(setting: setting),
                      _separator(),
                      NotificationTimeRow(store: store, state: state),
                      _separator(),
                      if (activedPillSheet != null &&
                          activedPillSheet.pillSheetHasRestOrFakeDuration) ...[
                        NotificationInRestDuration(
                            setting: setting, pillSheet: activedPillSheet),
                        _separator(),
                      ],
                      if (!state.premiumAndTrial.isPremium) ...[
                        QuickRecordRow(
                          isTrial: state.premiumAndTrial.isTrial,
                          trialDeadlineDate:
                              state.premiumAndTrial.trialDeadlineDate,
                        ),
                        _separator(),
                      ],
                      ReminderNotificationCustomizeWord(
                        setting: setting,
                        isTrial: state.premiumAndTrial.isTrial,
                        isPremium: state.premiumAndTrial.isPremium,
                        trialDeadlineDate:
                            state.premiumAndTrial.trialDeadlineDate,
                      ),
                      _separator(),
                    ],
                  );
                case SettingSection.menstruation:
                  return SettingSectionTitle(
                    text: "生理",
                    children: [
                      MenstruationRow(store, setting),
                      _separator(),
                      if (Platform.isIOS && state.isHealthDataAvailable) ...[
                        HealthCareRow(
                          trialDeadlineDate:
                              state.premiumAndTrial.trialDeadlineDate,
                        ),
                        _separator(),
                      ]
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
                          title: const Text("利用規約", style: FontType.listRow),
                          onTap: () {
                            analytics.logEvent(
                                name: "did_select_terms", parameters: {});
                            launch("https://bannzai.github.io/Pilll/Terms",
                                forceSafariVC: true);
                          }),
                      _separator(),
                      ListTile(
                          title:
                              const Text("プライバシーポリシー", style: FontType.listRow),
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
                          title: const Text("FAQ", style: FontType.listRow),
                          onTap: () {
                            analytics.logEvent(
                                name: "did_select_faq", parameters: {});
                            launch(
                                "https://pilll.wraptas.site/bb1f49eeded64b57929b7a13e9224d69",
                                forceSafariVC: true);
                          }),
                      _separator(),
                      ListTile(
                          title: const Text("新機能紹介", style: FontType.listRow),
                          onTap: () {
                            analytics.logEvent(
                                name: "setting_did_select_release_note",
                                parameters: {});
                            launch(
                                "https://pilll.wraptas.site/172cae6bced04bbabeab1d8acad91a61");
                          }),
                      _separator(),
                      ListTile(
                          title: const Text("お問い合わせ", style: FontType.listRow),
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
        child: const Center(
            child: Text("COPY DEBUG INFO", style: TextColorStyle.primary)),
        onTap: () async {
          Clipboard.setData(ClipboardData(text: await debugInfo("\n")));
        },
        onDoubleTap: () {
          final signOut = Environment.signOutUser;
          if (signOut == null) {
            return;
          }
          showDiscardDialog(context, title: "サインアウトします", message: '''
これは開発用のオプションです。サインアウトあとはアプリを再起動してお試しください。初期設定から始まります
''', actions: [
            AlertButton(
              text: "キャンセル",
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
            AlertButton(
              text: "サインアウト",
              onPressed: () async {
                await signOut();
                Navigator.of(context).pop();
              },
            ),
          ]);
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
            actions: [
              AlertButton(
                text: "キャンセル",
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
              AlertButton(
                text: "削除",
                onPressed: () async {
                  await deleteUser();
                  Navigator.of(context).pop();
                },
              ),
            ],
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
