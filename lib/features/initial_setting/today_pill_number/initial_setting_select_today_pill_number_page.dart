import 'package:pilll/util/analytics.dart';
import 'package:pilll/features/initial_setting/initial_setting_state_notifier.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/initial_setting/reminder_times/initial_setting_reminder_times_page.dart';
import 'package:pilll/features/initial_setting/today_pill_number/explain_label.dart';
import 'package:pilll/features/initial_setting/today_pill_number/select_today_pill_number_pill_sheet_list.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class InitialSettingSelectTodayPillNumberPage extends HookConsumerWidget {
  const InitialSettingSelectTodayPillNumberPage({Key? key}) : super(key: key);

  String todayString() {
    return DateFormat.yMEd('ja').format(today());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(initialSettingStateNotifierProvider.notifier);
    final state = ref.watch(initialSettingStateNotifierProvider);
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "2/3",
          style: TextStyle(color: TextColor.black),
        ),
        backgroundColor: PilllColors.white,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      "今日(${todayString()})\n飲む・飲んだピルの番号をタップ",
                      style: const TextStyle(
                        fontFamily: FontFamily.japanese,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: TextColor.main,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 44),
                    Center(
                      child: SelectTodayPillNumberPillSheetList(
                        state: state,
                        store: store,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ExplainPillNumber(today: todayString()),
                    const SizedBox(height: 16),
                    InconspicuousButton(
                      onPressed: () async {
                        store.unsetTodayPillNumber();
                        analytics.logEvent(name: "unknown_number_initial_setting");
                        Navigator.of(context).push(InitialSettingReminderTimesPageRoute.route());
                      },
                      text: "まだ分からない",
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 180,
                    child: PrimaryButton(
                      text: "次へ",
                      onPressed: state.todayPillNumber == null
                          ? null
                          : () async {
                              analytics.logEvent(name: "done_today_number_initial_setting");
                              Navigator.of(context).push(InitialSettingReminderTimesPageRoute.route());
                            },
                    ),
                  ),
                  const SizedBox(height: 35),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension InitialSettingSelectTodayPillNumberPageRoute on InitialSettingSelectTodayPillNumberPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: "InitialSettingSelectTodayPillNumberPage"),
      builder: (_) => const InitialSettingSelectTodayPillNumberPage(),
    );
  }
}
