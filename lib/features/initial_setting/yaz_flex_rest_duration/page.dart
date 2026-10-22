import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/initial_setting/initial_setting_state_notifier.dart';
import 'package:pilll/features/initial_setting/reminder_times/page.dart';
import 'package:pilll/features/initial_setting/yaz_flex/pill_sheet_group_preview.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/datetime/date_add.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

/// 休薬の開始日として選べる最も古い日の、今日からの日数
/// ヤーズフレックスの連続服用は最長120日で休薬に入るため、前回の休薬は1年以内に収まる
const _selectableRestDurationDays = 365;

/// ヤーズフレックス向けの初期設定で、前回の休薬の開始日・終了日 (または「休薬はまだしていない」「まだ服用を再開していない」) を入力するページ
/// 開始番号のページで入力した服用日数を反映したピルシートグループのプレビューを見せ、休薬の入力もプレビューにそのまま反映する。入力後は服用タイミングのページへ進む
class InitialSettingYazFlexRestDurationPage extends ConsumerWidget {
  const InitialSettingYazFlexRestDurationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(initialSettingStateNotifierProvider.notifier);
    final state = ref.watch(initialSettingStateNotifierProvider);
    final restDurationBeginDate = state.yazFlexLastRestDurationBeginDate;
    final restDurationEndDate = state.yazFlexLastRestDurationEndDate;
    final pillSheetGroup = state.buildPillSheetGroup();
    final resumedPillPosition = state.yazFlexResumedPillPosition;

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
              child: SingleChildScrollView(
                child: Column(
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
                    if (pillSheetGroup != null)
                      YazFlexPillSheetGroupPreview(
                        pillSheetGroup: pillSheetGroup,
                        markedPill: resumedPillPosition,
                        // 再開したピルがプレビューに無い時は、今日飲むピルのピルシートを開いて今の位置を見せる
                        initialPageIndex: resumedPillPosition?.pageIndex ?? state.todayPillNumber?.pageIndex ?? 0,
                      ),
                    const SizedBox(height: 24),
                    YazFlexRestDurationCheckbox(
                      label: L.yazFlexHasNotRestedYet,
                      value: state.yazFlexHasNotRestedYet,
                      onChanged: (value) {
                        analytics.logEvent(
                          name: 'yaz_flex_has_not_rested_yet',
                          parameters: {'value': value},
                        );
                        store.setYazFlexHasNotRestedYet(yazFlexHasNotRestedYet: value);
                      },
                    ),
                    if (!state.yazFlexHasNotRestedYet) ...[
                      const SizedBox(height: 16),
                      YazFlexRestDurationDateField(
                        label: L.yazFlexLastRestDurationBeginDate,
                        date: restDurationBeginDate,
                        onTap: () async {
                          analytics.logEvent(name: 'yaz_flex_rest_begin_date_tapped');
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: restDurationBeginDate ?? today().subtract(const Duration(days: 1)),
                            firstDate: today().subtract(const Duration(days: _selectableRestDurationDays)),
                            // 休薬中 (まだ服用を再開していない) は今日から休薬を始めた場合もあるので、今日まで選べる
                            lastDate: today(),
                          );
                          if (selectedDate == null) {
                            analytics.logEvent(name: 'yaz_flex_rest_begin_date_cancel');
                            return;
                          }
                          analytics.logEvent(name: 'yaz_flex_rest_begin_date_selected');
                          store.setYazFlexLastRestDurationBeginDate(yazFlexLastRestDurationBeginDate: selectedDate);
                        },
                      ),
                      if (!state.yazFlexHasNotResumedYet) ...[
                        const SizedBox(height: 16),
                        YazFlexRestDurationDateField(
                          label: L.yazFlexLastRestDurationEndDate,
                          date: restDurationEndDate,
                          // 服用を再開した日は休薬が始まった日の翌日以降なので、始まった日が今日の時は選べる日が無い
                          onTap: restDurationBeginDate == null || !restDurationBeginDate.date().isBefore(today())
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
                      const SizedBox(height: 16),
                      YazFlexRestDurationCheckbox(
                        label: L.yazFlexHasNotResumedYet,
                        value: state.yazFlexHasNotResumedYet,
                        onChanged: (value) {
                          analytics.logEvent(
                            name: 'yaz_flex_has_not_resumed_yet',
                            parameters: {'value': value},
                          );
                          store.setYazFlexHasNotResumedYet(yazFlexHasNotResumedYet: value);
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 180,
              child: PrimaryButton(
                text: L.next,
                onPressed:
                    state.yazFlexHasNotRestedYet || (restDurationBeginDate != null && (restDurationEndDate != null || state.yazFlexHasNotResumedYet))
                        ? () async {
                            analytics.logEvent(
                              name: 'done_yaz_flex_rest_duration',
                              parameters: {
                                'yaz_flex_has_not_rested_yet': state.yazFlexHasNotRestedYet,
                                'yaz_flex_has_not_resumed_yet': state.yazFlexHasNotResumedYet,
                                'begin_pill_number': state.yazFlexBeginPillNumber,
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

/// 前回の休薬の入力で「休薬はまだしていない」「まだ服用を再開していない」を選ぶ、画面の中央に寄せたチェックボックス
/// 選ぶ・外すで消す入力値が項目ごとに異なるため、変更時の処理はコールバックで親から渡す
class YazFlexRestDurationCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final void Function(bool value) onChanged;

  const YazFlexRestDurationCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () => onChanged(!value),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              activeColor: AppColors.primary,
              value: value,
              onChanged: (value) => onChanged(value ?? false),
            ),
            Text(
              label,
              style: const TextStyle(
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: TextColor.main,
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

/// 前回の休薬の開始日・終了日の入力欄。ラベルの下に、選んだ日付か未選択のプレースホルダーを枠で囲って画面の中央に寄せて出す
/// [onTap] が null の時は選択できない。開始日と終了日で DatePicker の範囲と更新する値が異なるため、タップ時の処理はコールバックで親から渡す
class YazFlexRestDurationDateField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback? onTap;

  const YazFlexRestDurationDateField({
    super.key,
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final date = this.date;
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: FontFamily.japanese,
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: TextColor.main,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              border: Border.all(width: 1, color: AppColors.border),
            ),
            child: Center(
              child: Text(
                date == null ? L.yazFlexSelectDate : DateTimeFormatter.yearAndMonthAndDay(date),
                style: TextStyle(
                  fontFamily: FontFamily.japanese,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: onTap == null
                      ? TextColor.lightGray
                      : date == null
                          ? TextColor.gray
                          : TextColor.main,
                ),
              ),
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
