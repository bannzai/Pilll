import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/features/initial_setting/initial_setting_state_notifier.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/initial_setting/reminder_times/page.dart';
import 'package:pilll/features/initial_setting/today_pill_number/explain_label.dart';
import 'package:pilll/features/initial_setting/today_pill_number/select_today_pill_number_pill_sheet_list.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class InitialSettingSelectTodayPillNumberPage extends HookConsumerWidget {
  const InitialSettingSelectTodayPillNumberPage({super.key});

  String todayString() {
    return DateFormat.MEd().format(today());
  }

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
        title: const Text('2/3', style: TextStyle(color: TextColor.black)),
        backgroundColor: AppColors.white,
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
                      L.selectTodayPillNumber(todayString()),
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
                        analytics.logEvent(
                          name: 'unknown_number_initial_setting',
                        );
                        Navigator.of(
                          context,
                        ).push(InitialSettingReminderTimesPageRoute.route());
                      },
                      text: L.notYetKnown,
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
                      text: L.next,
                      onPressed: state.todayPillNumber == null
                          ? null
                          : () async {
                              analytics.logEvent(
                                name: 'done_today_number_initial_setting',
                              );
                              Navigator.of(context).push(
                                InitialSettingReminderTimesPageRoute.route(),
                              );
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
      settings: const RouteSettings(
        name: 'InitialSettingSelectTodayPillNumberPage',
      ),
      builder: (_) => const InitialSettingSelectTodayPillNumberPage(),
    );
  }
}
