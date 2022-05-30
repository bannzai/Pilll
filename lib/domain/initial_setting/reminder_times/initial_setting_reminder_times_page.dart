import 'package:pilll/analytics.dart';
import 'package:pilll/domain/initial_setting/initial_setting_state.codegen.dart';
import 'package:pilll/domain/initial_setting/premium_trial/initial_setting_premium_trial_start_page.dart';
import 'package:pilll/domain/initial_setting/initial_setting_store.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:pilll/util/toolbar/time_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class InitialSettingReminderTimesPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(initialSettingStoreProvider.notifier);
    final state = ref.watch(initialSettingStoreProvider);
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "3/3",
          style: TextStyle(color: TextColor.black),
        ),
        backgroundColor: PilllColors.white,
      ),
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 24),
                Text(
                  "ピルの飲み忘れ通知",
                  style: FontType.title.merge(TextColorStyle.main),
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
                          })),
                    ),
                    Text("複数設定しておく事で飲み忘れを防げます",
                        style: FontType.assisting.merge(TextColorStyle.main)),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "プライバシーポリシー",
                            style: FontType.sSmallSentence
                                .merge(TextColorStyle.link),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launch(
                                    "https://bannzai.github.io/Pilll/PrivacyPolicy",
                                    forceSafariVC: true);
                              },
                          ),
                          TextSpan(
                            text: "と",
                            style: FontType.sSmallSentence
                                .merge(TextColorStyle.gray),
                          ),
                          TextSpan(
                            text: "利用規約",
                            style: FontType.sSmallSentence
                                .merge(TextColorStyle.link),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launch("https://bannzai.github.io/Pilll/Terms",
                                    forceSafariVC: true);
                              },
                          ),
                          TextSpan(
                            text: "を読んで\n利用をはじめてください",
                            style: FontType.sSmallSentence
                                .merge(TextColorStyle.gray),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      text: "次へ",
                      onPressed: () async {
                        analytics.logEvent(
                            name: "next_initial_setting_reminder_times");
                        Navigator.of(context).push(
                            IntiialSettingPremiumTrialStartPageRoute.route());
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 35),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTimePicker(
    BuildContext context,
    int index,
    InitialSettingState state,
    InitialSettingStateStore store,
  ) {
    analytics.logEvent(name: "show_initial_setting_reminder_picker");
    final reminderDateTime = state.reminderTimeOrNull(index);
    final n = now();
    DateTime initialDateTime = reminderDateTime != null
        ? reminderDateTime
        : DateTime(n.year, n.month, n.day, 22, 0, 0);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return TimePicker(
          initialDateTime: initialDateTime,
          done: (dateTime) {
            analytics.logEvent(
                name: "selected_times_initial_setting",
                parameters: {"hour": dateTime.hour, "minute": dateTime.minute});
            store.setReminderTime(
                index: index, hour: dateTime.hour, minute: dateTime.minute);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Widget _form(
    BuildContext context,
    InitialSettingStateStore store,
    InitialSettingState state,
    int index,
  ) {
    final reminderTime = state.reminderTimeOrNull(index);
    final formValue = reminderTime == null
        ? "--:--"
        : DateTimeFormatter.militaryTime(reminderTime);
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset("images/alerm.svg"),
              Text("通知${index + 1}",
                  style: FontType.assisting.merge(TextColorStyle.main))
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
                border: Border.all(
                  width: 1,
                  color: PilllColors.border,
                ),
              ),
              child: Center(
                child: Text(formValue,
                    style: FontType.inputNumber.merge(TextColorStyle.gray)),
              ),
            ),
          )
        ],
      ),
    );
  }
}

extension InitialSettingReminderTimesPageRoute
    on InitialSettingReminderTimesPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: "InitialSettingReminderTimesPage"),
      builder: (_) => InitialSettingReminderTimesPage(),
    );
  }
}
