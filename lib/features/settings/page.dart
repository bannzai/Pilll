import 'dart:io';

import 'package:async_value_group/async_value_group.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/settings/components/rows/alarm_kit.dart';
import 'package:pilll/features/settings/components/rows/critical_alert.dart';
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
import 'package:pilll/features/settings/components/setting_section_title.dart';
import 'package:pilll/features/settings/provider.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/error/page.dart';
import 'package:pilll/features/inquiry/page.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/root.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/utils/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/rows/about_churn.dart';

enum SettingSection {
  account,
  premium,
  pill,
  notification,
  menstruation,
  other,
}

class SettingPage extends HookConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive(wantKeepAlive: true);

    return AsyncValueGroup.group4(
      ref.watch(userProvider),
      ref.watch(settingProvider),
      ref.watch(latestPillSheetGroupProvider),
      ref.watch(isHealthDataAvailableProvider),
    ).when(
      data: (data) {
        return SettingPageBody(
          user: data.$1,
          setting: data.$2,
          latestPillSheetGroup: data.$3,
          isHealthDataAvailable: data.$4,
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

  const SettingPageBody({
    super.key,
    required this.user,
    required this.setting,
    required this.latestPillSheetGroup,
    required this.isHealthDataAvailable,
  });

  @override
  Widget build(BuildContext context) {
    final pillSheetGroup = latestPillSheetGroup;
    final activePillSheet = pillSheetGroup?.activePillSheet;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(L.settings, style: const TextStyle(color: TextColor.main)),
        backgroundColor: AppColors.white,
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
                      text: L.account,
                      children: [
                        ListExplainRow(text: L.dataTransferRequiresAccount),
                        const AccountLinkRow(),
                        _separator(),
                      ],
                    );
                  case SettingSection.premium:
                    return SettingSectionTitle(
                      text: L.pillPremium,
                      children: [
                        if (user.isTrial) ...[
                          ListTile(
                            title: Text(
                              L.unlimitedFeatureDuration,
                              style: const TextStyle(
                                fontFamily: FontFamily.roboto,
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                              ),
                            ),
                            onTap: () {
                              analytics.logEvent(
                                name: 'did_select_about_trial',
                                parameters: {},
                              );
                              launchUrl(
                                Uri.parse(
                                  'https://pilll.notion.site/3abd690f501549c48f813fd310b5f242',
                                ),
                                mode: LaunchMode.inAppBrowserView,
                              );
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
                      text: L.pillSheet,
                      children: [
                        if (activePillSheet != null && pillSheetGroup != null && !pillSheetGroup.isDeactivated) ...[
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
                      text: L.notification,
                      children: [
                        ToggleReminderNotification(setting: setting),
                        _separator(),
                        NotificationTimeRow(setting: setting),
                        _separator(),
                        if (activePillSheet != null && activePillSheet.pillSheetHasRestOrFakeDuration) ...[
                          NotificationInRestDuration(
                            setting: setting,
                            pillSheet: activePillSheet,
                          ),
                          _separator(),
                        ],
                        if (!user.isPremium) ...[
                          QuickRecordRow(
                            isTrial: user.isTrial,
                            trialDeadlineDate: user.trialDeadlineDate,
                          ),
                          _separator(),
                        ],
                        if (Platform.isIOS) ...[
                          CriticalAlert(
                            setting: setting,
                            isPremium: user.isPremium,
                            isTrial: user.isTrial,
                          ),
                          _separator(),
                          AlarmKitSetting(
                            setting: setting,
                            isPremium: user.isPremium,
                            isTrial: user.isTrial,
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
                      text: L.menstruation,
                      children: [
                        MenstruationRow(setting),
                        _separator(),
                        if (Platform.isIOS && isHealthDataAvailable) ...[
                          HealthCareRow(
                            trialDeadlineDate: user.trialDeadlineDate,
                          ),
                          _separator(),
                        ],
                      ],
                    );

                  case SettingSection.other:
                    return SettingSectionTitle(
                      text: L.others,
                      children: [
                        ListTile(
                          title: Text(
                            L.shareWithFriends,
                            style: const TextStyle(
                              fontFamily: FontFamily.roboto,
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                            ),
                          ),
                          onTap: () async {
                            analytics.logEvent(
                              name: 'tap_share_to_friend',
                              parameters: {},
                            );
                            final text = '''
${L.pilllDescription}

iOS: https://onl.sc/piiY1A6
Android: https://onl.sc/c9xnQUk''';
                            Clipboard.setData(ClipboardData(text: text));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 2),
                                content: Text(L.linkCopiedToClipboard),
                              ),
                            );
                          },
                        ),
                        _separator(),
                        ListTile(
                          title: Text(
                            L.termsOfService,
                            style: const TextStyle(
                              fontFamily: FontFamily.roboto,
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                            ),
                          ),
                          onTap: () {
                            analytics.logEvent(
                              name: 'did_select_terms',
                              parameters: {},
                            );
                            launchUrl(
                              Uri.parse(
                                'https://bannzai.github.io/Pilll/Terms',
                              ),
                              mode: LaunchMode.inAppBrowserView,
                            );
                          },
                        ),
                        _separator(),
                        ListTile(
                          title: Text(
                            L.privacyPolicy,
                            style: const TextStyle(
                              fontFamily: FontFamily.roboto,
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                            ),
                          ),
                          onTap: () {
                            analytics.logEvent(
                              name: 'did_select_privacy_policy',
                              parameters: {},
                            );
                            launchUrl(
                              Uri.parse(
                                'https://bannzai.github.io/Pilll/PrivacyPolicy',
                              ),
                              mode: LaunchMode.inAppBrowserView,
                            );
                          },
                        ),
                        _separator(),
                        ListTile(
                          title: Text(
                            L.faq,
                            style: const TextStyle(
                              fontFamily: FontFamily.roboto,
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                            ),
                          ),
                          onTap: () {
                            analytics.logEvent(
                              name: 'did_select_faq',
                              parameters: {},
                            );
                            launchUrl(
                              Uri.parse(
                                'https://pilll.notion.site/bb1f49eeded64b57929b7a13e9224d69',
                              ),
                              mode: LaunchMode.inAppBrowserView,
                            );
                          },
                        ),
                        _separator(),
                        ListTile(
                          title: Text(
                            L.newFeaturesIntroduction,
                            style: const TextStyle(
                              fontFamily: FontFamily.roboto,
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                            ),
                          ),
                          onTap: () {
                            analytics.logEvent(
                              name: 'setting_did_select_release_note',
                              parameters: {},
                            );
                            launchUrl(
                              Uri.parse(
                                'https://pilll.notion.site/172cae6bced04bbabeab1d8acad91a61',
                              ),
                            );
                          },
                        ),
                        _separator(),
                        ListTile(
                          title: Text(
                            L.contactUs,
                            style: const TextStyle(
                              fontFamily: FontFamily.roboto,
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                            ),
                          ),
                          onTap: () async {
                            analytics.logEvent(
                              name: 'did_select_inquiry',
                              parameters: {},
                            );
                            await showDialog(
                              context: context,
                              builder: (dialogContext) => AlertDialog(
                                title: const Icon(
                                  Icons.help,
                                  color: AppColors.primary,
                                ),
                                content: const Text(
                                  'お問い合わせの前に、よくある質問（FAQ）をご確認ください。\n多くの疑問はFAQで解決できる可能性があります。',
                                  style: TextStyle(
                                    fontFamily: FontFamily.japanese,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                    color: TextColor.main,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop();
                                      analytics.logEvent(
                                        name: 'did_select_faq_from_inquiry_dialog',
                                        parameters: {},
                                      );
                                      launchUrl(
                                        Uri.parse(
                                          'https://pilll.notion.site/bb1f49eeded64b57929b7a13e9224d69',
                                        ),
                                        mode: LaunchMode.inAppBrowserView,
                                      );
                                    },
                                    child: const Text(
                                      'FAQを確認する',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop();
                                      Navigator.of(
                                        context,
                                      ).push(InquiryPageRoute.route());
                                    },
                                    child: const Text(
                                      'お問い合わせを続ける',
                                      style: TextStyle(
                                        color: TextColor.darkGray,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        if (Environment.isDevelopment) ...[
                          _separator(),
                          const DebugRow(),
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
      child: Container(height: 1, color: AppColors.border),
    );
  }
}
