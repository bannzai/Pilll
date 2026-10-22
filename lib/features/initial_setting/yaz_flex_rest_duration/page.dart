import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/initial_setting/initial_setting_state_notifier.dart';
import 'package:pilll/features/initial_setting/reminder_times/page.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/datetime/date_add.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

/// 休薬の開始日として選べる最も古い日の、今日からの日数
/// ヤーズフレックスの連続服用は最長120日で休薬に入るため、前回の休薬は1年以内に収まる
const _selectableRestDurationDays = 365;

/// ヤーズフレックス向けの初期設定で、前回の休薬の開始日・終了日 (または「休薬はまだしていない」) と開始番号を入力するページ
/// 入力後は服用タイミングのページへ進む
class InitialSettingYazFlexRestDurationPage extends ConsumerWidget {
  const InitialSettingYazFlexRestDurationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(initialSettingStateNotifierProvider.notifier);
    final state = ref.watch(initialSettingStateNotifierProvider);
    final restDurationBeginDate = state.yazFlexLastRestDurationBeginDate;
    final restDurationEndDate = state.yazFlexLastRestDurationEndDate;
    final beginPillNumber = state.yazFlexBeginPillNumber ?? state.yazFlexDefaultBeginPillNumber;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                children: [
                  const SizedBox(height: 24),
                  Text(
                    L.yazFlexLastRestDurationTitle,
                    style: const TextStyle(
                      fontFamily: FontFamily.japanese,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: TextColor.main,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: AppColors.primary,
                    value: state.yazFlexHasNotRestedYet,
                    title: Text(
                      L.yazFlexHasNotRestedYet,
                      style: const TextStyle(
                        fontFamily: FontFamily.japanese,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: TextColor.main,
                      ),
                    ),
                    onChanged: (value) {
                      analytics.logEvent(
                        name: 'yaz_flex_has_not_rested_yet',
                        parameters: {'value': value},
                      );
                      store.setYazFlexHasNotRestedYet(yazFlexHasNotRestedYet: value ?? false);
                    },
                  ),
                  if (!state.yazFlexHasNotRestedYet) ...[
                    const SizedBox(height: 16),
                    YazFlexRestDurationDateRow(
                      label: L.yazFlexLastRestDurationBeginDate,
                      date: restDurationBeginDate,
                      onTap: () async {
                        analytics.logEvent(name: 'yaz_flex_rest_begin_date_tapped');
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: restDurationBeginDate ?? today().subtract(const Duration(days: 1)),
                          firstDate: today().subtract(const Duration(days: _selectableRestDurationDays)),
                          // 休薬は今日までに終わっている (再開日が今日以前) ので、開始日は昨日まで
                          lastDate: today().subtract(const Duration(days: 1)),
                        );
                        if (selectedDate == null) {
                          analytics.logEvent(name: 'yaz_flex_rest_begin_date_cancel');
                          return;
                        }
                        analytics.logEvent(name: 'yaz_flex_rest_begin_date_selected');
                        store.setYazFlexLastRestDurationBeginDate(yazFlexLastRestDurationBeginDate: selectedDate);
                      },
                    ),
                    const SizedBox(height: 16),
                    YazFlexRestDurationDateRow(
                      label: L.yazFlexLastRestDurationEndDate,
                      date: restDurationEndDate,
                      onTap: restDurationBeginDate == null
                          ? null
                          : () async {
                              analytics.logEvent(name: 'yaz_flex_rest_end_date_tapped');
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: restDurationEndDate ?? today(),
                                firstDate: restDurationBeginDate.addDays(1),
                                lastDate: today(),
                              );
                              if (selectedDate == null) {
                                analytics.logEvent(name: 'yaz_flex_rest_end_date_cancel');
                                return;
                              }
                              analytics.logEvent(name: 'yaz_flex_rest_end_date_selected');
                              store.setYazFlexLastRestDurationEndDate(yazFlexLastRestDurationEndDate: selectedDate);
                            },
                    ),
                  ],
                  const SizedBox(height: 32),
                  Text(
                    L.yazFlexBeginPillNumberTitle,
                    style: const TextStyle(
                      fontFamily: FontFamily.japanese,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: TextColor.main,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        color: AppColors.primary,
                        onPressed: beginPillNumber <= 1
                            ? null
                            : () {
                                analytics.logEvent(
                                  name: 'yaz_flex_begin_pill_number_minus',
                                  parameters: {'begin_pill_number': beginPillNumber},
                                );
                                store.setYazFlexBeginPillNumber(yazFlexBeginPillNumber: beginPillNumber - 1);
                              },
                      ),
                      SizedBox(
                        width: 80,
                        child: Text(
                          L.withDay('$beginPillNumber'),
                          style: const TextStyle(
                            fontFamily: FontFamily.number,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: TextColor.main,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        color: AppColors.primary,
                        onPressed: () {
                          analytics.logEvent(
                            name: 'yaz_flex_begin_pill_number_plus',
                            parameters: {'begin_pill_number': beginPillNumber},
                          );
                          store.setYazFlexBeginPillNumber(yazFlexBeginPillNumber: beginPillNumber + 1);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 180,
              child: PrimaryButton(
                text: L.next,
                onPressed: state.yazFlexHasNotRestedYet || (restDurationBeginDate != null && restDurationEndDate != null)
                    ? () async {
                        analytics.logEvent(
                          name: 'done_yaz_flex_rest_duration',
                          parameters: {
                            'yaz_flex_has_not_rested_yet': state.yazFlexHasNotRestedYet,
                            'begin_pill_number': beginPillNumber,
                          },
                        );
                        Navigator.of(context).push(InitialSettingReminderTimesPageRoute.route());
                      }
                    : null,
              ),
            ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}

/// 前回の休薬の開始日・終了日の入力欄。[onTap] が null の時は選択できない
/// 開始日と終了日で DatePicker の範囲と更新する値が異なるため、タップ時の処理はコールバックで親から渡す
class YazFlexRestDurationDateRow extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback? onTap;

  const YazFlexRestDurationDateRow({
    super.key,
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final date = this.date;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: TextColor.main,
            ),
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            date == null ? L.yazFlexSelectDate : DateTimeFormatter.yearAndMonthAndDay(date),
            style: const TextStyle(
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

extension InitialSettingYazFlexRestDurationPageRoute on InitialSettingYazFlexRestDurationPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(
        name: 'InitialSettingYazFlexRestDurationPage',
      ),
      builder: (_) => const InitialSettingYazFlexRestDurationPage(),
    );
  }
}
