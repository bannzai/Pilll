import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/features/initial_setting/initial_setting_state.codegen.dart';
import 'package:pilll/features/initial_setting/premium_trial/page.dart';
import 'package:pilll/features/initial_setting/initial_setting_state_notifier.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';
import 'package:pilll/components/picker/time_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class InitialSettingReminderTimesPage extends HookConsumerWidget {
  const InitialSettingReminderTimesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(initialSettingStateNotifierProvider.notifier);
    final state = ref.watch(initialSettingStateNotifierProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('3/3', style: TextStyle(color: TextColor.black)),
        backgroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 24),
              Text(
                L.missedPillNotification,
                style: const TextStyle(
                  fontFamily: FontFamily.japanese,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  color: TextColor.main,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 36),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return _form(context, store, state, index);
                      }),
                    ),
                  ),
                  Text(
                    L.setMultipleReminders,
                    style: const TextStyle(
                      fontFamily: FontFamily.japanese,
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                      color: TextColor.main,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        // TODO: [Localizations]
                        TextSpan(
                          text: L.privacyPolicy,
                          style: const TextStyle(
                            fontFamily: FontFamily.japanese,
                            fontWeight: FontWeight.w300,
                            fontSize: 10,
                            color: TextColor.link,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(
                                Uri.parse(
                                  'https://bannzai.github.io/Pilll/PrivacyPolicy',
                                ),
                                mode: LaunchMode.inAppBrowserView,
                              );
                            },
                        ),
                        TextSpan(
                          text: L.and,
                          style: const TextStyle(
                            fontFamily: FontFamily.japanese,
                            fontWeight: FontWeight.w300,
                            fontSize: 10,
                            color: TextColor.gray,
                          ),
                        ),
                        TextSpan(
                          text: L.termsOfService,
                          style: const TextStyle(
                            fontFamily: FontFamily.japanese,
                            fontWeight: FontWeight.w300,
                            fontSize: 10,
                            color: TextColor.link,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(
                                Uri.parse(
                                  'https://bannzai.github.io/Pilll/Terms',
                                ),
                                mode: LaunchMode.inAppBrowserView,
                              );
                            },
                        ),
                        TextSpan(
                          text: L.readAndStartUsing,
                          style: const TextStyle(
                            fontFamily: FontFamily.japanese,
                            fontWeight: FontWeight.w300,
                            fontSize: 10,
                            color: TextColor.gray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 180,
                    child: PrimaryButton(
                      text: L.next,
                      onPressed: () async {
                        analytics.logEvent(
                          name: 'next_initial_setting_reminder_times',
                        );
                        Navigator.of(context).push(
                          IntiialSettingPremiumTrialStartPageRoute.route(),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }

  void _showTimePicker(
    BuildContext context,
    int index,
    InitialSettingState state,
    InitialSettingStateNotifier store,
  ) {
    analytics.logEvent(name: 'show_initial_setting_reminder_picker');
    final reminderDateTime = state.reminderTimeOrNull(index);
    final n = now();
    DateTime initialDateTime =
        reminderDateTime ?? DateTime(n.year, n.month, n.day, n.hour, 0, 0);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return TimePicker(
          initialDateTime: initialDateTime,
          done: (dateTime) {
            analytics.logEvent(
              name: 'selected_times_initial_setting',
              parameters: {'hour': dateTime.hour, 'minute': dateTime.minute},
            );
            store.setReminderTime(
              index: index,
              hour: dateTime.hour,
              minute: dateTime.minute,
            );
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Widget _form(
    BuildContext context,
    InitialSettingStateNotifier store,
    InitialSettingState state,
    int index,
  ) {
    final reminderTime = state.reminderTimeOrNull(index);
    final formValue = reminderTime == null
        ? '--:--'
        : DateTimeFormatter.militaryTime(reminderTime);
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset('images/alerm.svg'),
              Text(
                L.notificationNumber(index + 1),
                style: const TextStyle(
                  fontFamily: FontFamily.japanese,
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                  color: TextColor.main,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _showTimePicker(context, index, state, store),
            child: Container(
              width: 81,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                border: Border.all(width: 1, color: AppColors.border),
              ),
              child: Center(
                child: Text(
                  formValue,
                  style: const TextStyle(
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: TextColor.gray,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension InitialSettingReminderTimesPageRoute
    on InitialSettingReminderTimesPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: 'InitialSettingReminderTimesPage'),
      builder: (_) => const InitialSettingReminderTimesPage(),
    );
  }
}
