import 'dart:io';

import 'package:async_value_group/async_value_group.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/settings/components/rows/debug_row.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/features/settings/components/rows/creating_new_pillsheet.dart';
import 'package:pilll/features/settings/components/rows/health_care.dart';
import 'package:pilll/features/settings/components/rows/menstruation.dart';
import 'package:pilll/features/settings/components/rows/account_link.dart';
import 'package:pilll/features/settings/components/rows/list_explain.dart';
import 'package:pilll/features/settings/components/rows/reminder_notification_customize_word.dart';
import 'package:pilll/features/settings/components/rows/notification_in_rest_duration.dart';
import 'package:pilll/features/settings/components/rows/notification_time.dart';
import 'package:pilll/features/settings/components/rows/pill_sheet_remove.dart';
import 'package:pilll/features/settings/components/rows/premium_introduction.dart';
import 'package:pilll/features/settings/components/rows/quick_record.dart';
import 'package:pilll/features/settings/components/rows/toggle_reminder_notification.dart';
import 'package:pilll/features/settings/components/rows/today_pill_number.dart';
import 'package:pilll/features/settings/components/rows/update_from_132.dart';
import 'package:pilll/features/settings/components/setting_section_title.dart';
import 'package:pilll/features/settings/provider.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/error/universal_error_page.dart';
import 'package:pilll/features/settings/components/inquiry/inquiry.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/root.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/provider/shared_preferences.dart';
import 'package:pilll/utils/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/rows/about_churn.dart';
import 'components/rows/toggle_local_notification.dart';

enum SettingSection { account, premium, pill, notification, menstruation, other }

class SettingPage extends HookConsumerWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive(wantKeepAlive: true);

    final sharedPreferences = ref.watch(sharedPreferencesProvider);
    return AsyncValueGroup.group4(
      ref.watch(userProvider),
      ref.watch(settingProvider),
      ref.watch(latestPillSheetGroupProvider),
      ref.watch(isHealthDataAvailableProvider),
    ).when(
      data: (data) {
        final userIsMigratedFrom132 =
            sharedPreferences.containsKey(StringKey.salvagedOldStartTakenDate) && sharedPreferences.containsKey(StringKey.salvagedOldLastTakenDate);
        return SettingPageBody(
          user: data.t1,
          setting: data.t2,
          latestPillSheetGroup: data.t3,
          isHealthDataAvailable: data.t4,
          userIsUpdatedFrom132: userIsMigratedFrom132,
        );
      },
      error: (error, _) => UniversalErrorPage(
        error: error,
        child: null,
        reload: () => ref.refresh(refreshAppProvider),
      ),
      loading: () => const ScaffoldIndicator(),
    );
  }
}

class SettingPageBody extends StatelessWidget {
  final User user;
  final Setting setting;
  final PillSheetGroup? latestPillSheetGroup;
  final bool isHealthDataAvailable;
  final bool userIsUpdatedFrom132;

  const SettingPageBody({
    Key? key,
    required this.user,
    required this.setting,
    required this.latestPillSheetGroup,
    required this.isHealthDataAvailable,
    required this.userIsUpdatedFrom132,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pillSheetGroup = latestPillSheetGroup;
    final activePillSheet = pillSheetGroup?.activePillSheet;
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        title: const Text('設定', style: TextStyle(color: TextColor.main)),
        backgroundColor: PilllColors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20),
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
                        const ListExplainRow(text: "機種変更やスマホ紛失時など、データの引き継ぎ・復元には、アカウント登録が必要です。"),
                        const AccountLinkRow(),
                        _separator(),
                      ],
                    );
                  case SettingSection.premium:
                    return SettingSectionTitle(
                      text: "Pilllプレミアム",
                      children: [
                        if (user.isTrial) ...[
                          ListTile(
                            title: const Text("機能無制限の期間について",
                                style: TextStyle(
                                  fontFamily: FontFamily.roboto,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
                                )),
                            onTap: () {
                              analytics.logEvent(name: "did_select_about_trial", parameters: {});
                              launchUrl(Uri.parse("https://pilll.wraptas.site/3abd690f501549c48f813fd310b5f242"), mode: LaunchMode.inAppWebView);
                            },
                          ),
                          _separator(),
                        ],
                        PremiumIntroductionRow(
                          isPremium: user.isPremium,
                          trialDeadlineDate: user.trialDeadlineDate,
                        ),
                        _separator(),
                        if (user.isPremium) ...[
                          const AboutChurn(),
                          _separator(),
                        ],
                      ],
                    );
                  case SettingSection.pill:
                    return SettingSectionTitle(
                      text: "ピルシート",
                      children: [
                        if (activePillSheet != null && pillSheetGroup != null && !pillSheetGroup.isDeactived) ...[
                          TodayPllNumberRow(
                            setting: setting,
                            pillSheetGroup: pillSheetGroup,
                            activePillSheet: activePillSheet,
                          ),
                          _separator(),
                          PillSheetRemoveRow(
                            latestPillSheetGroup: pillSheetGroup,
                            activePillSheet: activePillSheet,
                          ),
                          _separator(),
                        ],
                        CreatingNewPillSheetRow(
                          setting: setting,
                          isPremium: user.isPremium,
                          isTrial: user.isTrial,
                          trialDeadlineDate: user.trialDeadlineDate,
                        ),
                        _separator(),
                      ],
                    );
                  case SettingSection.notification:
                    return SettingSectionTitle(
                      text: "通知",
                      children: [
                        ToggleLocalNotification(user: user),
                        _separator(),
                        ToggleReminderNotification(setting: setting),
                        _separator(),
                        NotificationTimeRow(setting: setting),
                        _separator(),
                        if (activePillSheet != null && activePillSheet.pillSheetHasRestOrFakeDuration) ...[
                          NotificationInRestDuration(setting: setting, pillSheet: activePillSheet),
                          _separator(),
                        ],
                        if (!user.isPremium) ...[
                          QuickRecordRow(
                            isTrial: user.isTrial,
                            trialDeadlineDate: user.trialDeadlineDate,
                          ),
                          _separator(),
                        ],
                        ReminderNotificationCustomizeWord(
                          setting: setting,
                          isTrial: user.isTrial,
                          isPremium: user.isPremium,
                          trialDeadlineDate: user.trialDeadlineDate,
                        ),
                        _separator(),
                      ],
                    );
                  case SettingSection.menstruation:
                    return SettingSectionTitle(
                      text: "生理",
                      children: [
                        MenstruationRow(setting),
                        _separator(),
                        if (Platform.isIOS && isHealthDataAvailable) ...[
                          HealthCareRow(
                            trialDeadlineDate: user.trialDeadlineDate,
                          ),
                          _separator(),
                        ]
                      ],
                    );

                  case SettingSection.other:
                    return SettingSectionTitle(
                      text: "その他",
                      children: [
                        if (userIsUpdatedFrom132) ...[
                          const UpdateFrom132Row(),
                          _separator(),
                        ],
                        ListTile(
                            title: const Text("友達に教える",
                                style: TextStyle(
                                  fontFamily: FontFamily.roboto,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
                                )),
                            onTap: () async {
                              analytics.logEvent(name: "tap_share_to_friend", parameters: {});
                              const text = '''
      Pilll ピル服用に特化したピルリマインダーアプリ
      
      iOS: https://onl.sc/piiY1A6
      Android: https://onl.sc/c9xnQUk''';
                              Clipboard.setData(const ClipboardData(text: text));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(seconds: 2),
                                  content: Text("クリップボードにリンクをコピーしました"),
                                ),
                              );
                            }),
                        _separator(),
                        ListTile(
                            title: const Text("利用規約",
                                style: TextStyle(
                                  fontFamily: FontFamily.roboto,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
                                )),
                            onTap: () {
                              analytics.logEvent(name: "did_select_terms", parameters: {});
                              launchUrl(Uri.parse("https://bannzai.github.io/Pilll/Terms"), mode: LaunchMode.inAppWebView);
                            }),
                        _separator(),
                        ListTile(
                            title: const Text("プライバシーポリシー",
                                style: TextStyle(
                                  fontFamily: FontFamily.roboto,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
                                )),
                            onTap: () {
                              analytics.logEvent(name: "did_select_privacy_policy", parameters: {});
                              launchUrl(Uri.parse("https://bannzai.github.io/Pilll/PrivacyPolicy"), mode: LaunchMode.inAppWebView);
                            }),
                        _separator(),
                        ListTile(
                            title: const Text("FAQ",
                                style: TextStyle(
                                  fontFamily: FontFamily.roboto,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
                                )),
                            onTap: () {
                              analytics.logEvent(name: "did_select_faq", parameters: {});
                              launchUrl(Uri.parse("https://pilll.wraptas.site/bb1f49eeded64b57929b7a13e9224d69"), mode: LaunchMode.inAppWebView);
                            }),
                        _separator(),
                        ListTile(
                            title: const Text("新機能紹介",
                                style: TextStyle(
                                  fontFamily: FontFamily.roboto,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
                                )),
                            onTap: () {
                              analytics.logEvent(name: "setting_did_select_release_note", parameters: {});
                              launchUrl(Uri.parse("https://pilll.wraptas.site/172cae6bced04bbabeab1d8acad91a61"));
                            }),
                        _separator(),
                        ListTile(
                            title: const Text("お問い合わせ",
                                style: TextStyle(
                                  fontFamily: FontFamily.roboto,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
                                )),
                            onTap: () {
                              analytics.logEvent(name: "did_select_inquiry", parameters: {});
                              inquiry();
                            }),
                        if (Environment.isDevelopment) ...[
                          _separator(),
                          DebugRow(),
                        ],
                      ],
                    );
                }
              },
            );
          },
          itemCount: SettingSection.values.length,
          addRepaintBoundaries: false,
        ),
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
