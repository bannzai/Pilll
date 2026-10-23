import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/components/picker/picker_toolbar.dart';
import 'package:pilll/features/initial_setting/initial_setting_state_notifier.dart';
import 'package:pilll/features/initial_setting/reminder_times/page.dart';
import 'package:pilll/features/initial_setting/yaz_flex/pill_sheet_group_preview.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';

/// 休薬の日数として選べる最大の日数
/// ヤーズフレックスの休薬は 4 日間が原則で、飲み忘れ等で延びても 1 か月を超えることは想定しない
const _maxRestDurationDays = 30;

/// ヤーズフレックス向けの初期設定で、前回の休薬を「休薬に入る直前に飲んだピル」のタップと休薬の日数で入力するページ
/// 開始番号のページで入力した服用日数を反映したピルシートグループのプレビューの上でピルをタップし、選んだピルの次のピルから 1 に戻る表示をそのまま見せる
/// 休薬の入力自体をスキップして服用タイミングのページへ進むこともできる
class InitialSettingYazFlexRestDurationPage extends ConsumerWidget {
  const InitialSettingYazFlexRestDurationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(initialSettingStateNotifierProvider.notifier);
    final state = ref.watch(initialSettingStateNotifierProvider);
    final lastTakenPillNumberBeforeRest = state.yazFlexLastTakenPillNumberBeforeRest;
    final pillSheetGroup = state.buildPillSheetGroup();

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
                    const SizedBox(height: 8),
                    Text(
                      L.yazFlexLastRestDurationNote,
                      style: const TextStyle(
                        fontFamily: FontFamily.japanese,
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                        color: TextColor.gray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    if (pillSheetGroup != null)
                      YazFlexPillSheetGroupPreview(
                        pillSheetGroup: pillSheetGroup,
                        markedPill: lastTakenPillNumberBeforeRest == null
                            ? null
                            : (
                                pageIndex: lastTakenPillNumberBeforeRest.pageIndex,
                                pillNumberInPillSheet: lastTakenPillNumberBeforeRest.pillNumberInPillSheet
                              ),
                        onPillTap: ({required pageIndex, required pillNumberInPillSheet}) {
                          analytics.logEvent(
                            name: 'yaz_flex_rest_pill_tapped',
                            parameters: {'page_index': pageIndex, 'pill_number_in_pill_sheet': pillNumberInPillSheet},
                          );
                          store.setYazFlexLastTakenPillNumberBeforeRest(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet);
                        },
                        // 選んだピルが無い時は今日飲むピルのピルシートを開き、休薬のピルを探しやすくする
                        initialPageIndex: lastTakenPillNumberBeforeRest?.pageIndex ?? state.todayPillNumber?.pageIndex ?? 0,
                      ),
                    const SizedBox(height: 24),
                    if (lastTakenPillNumberBeforeRest != null) ...[
                      YazFlexRestDurationDaysField(
                        restDurationDays: state.yazFlexRestDurationDays,
                        onTap: () {
                          analytics.logEvent(name: 'yaz_flex_rest_duration_days_tapped');
                          _showDaysPicker(context, store: store, restDurationDays: state.yazFlexRestDurationDays);
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                    InconspicuousButton(
                      text: L.yazFlexSkipRestDuration,
                      onPressed: () async {
                        analytics.logEvent(name: 'yaz_flex_skip_rest_duration_tapped');
                        showDiscardDialog(
                          context,
                          title: L.yazFlexSkipRestDurationDialogTitle,
                          message: L.yazFlexSkipRestDurationDialogMessage,
                          actions: [
                            AlertButton(
                              text: L.cancel,
                              onPressed: () async {
                                analytics.logEvent(name: 'yaz_flex_skip_rest_duration_cancel');
                                Navigator.of(context).pop();
                              },
                            ),
                            AlertButton(
                              text: L.yazFlexSkipRestDurationDialogSkip,
                              onPressed: () async {
                                analytics.logEvent(
                                  name: 'yaz_flex_skip_rest_duration',
                                  parameters: {'begin_pill_number': state.yazFlexBeginPillNumber},
                                );
                                store.setYazFlexHasNotRestedYet(yazFlexHasNotRestedYet: true);
                                Navigator.of(context).pop();
                                Navigator.of(context).push(InitialSettingReminderTimesPageRoute.route());
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 180,
              child: PrimaryButton(
                text: L.next,
                onPressed: lastTakenPillNumberBeforeRest == null
                    ? null
                    : () async {
                        analytics.logEvent(
                          name: 'done_yaz_flex_rest_duration',
                          parameters: {
                            'rest_duration_days': state.yazFlexRestDurationDays,
                            'begin_pill_number': state.yazFlexBeginPillNumber,
                          },
                        );
                        store.setYazFlexHasNotRestedYet(yazFlexHasNotRestedYet: false);
                        Navigator.of(context).push(InitialSettingReminderTimesPageRoute.route());
                      },
              ),
            ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }

  void _showDaysPicker(
    BuildContext context, {
    required InitialSettingStateNotifier store,
    required int restDurationDays,
  }) {
    var selectedRestDurationDays = restDurationDays;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PickerToolbar(
              done: () {
                analytics.logEvent(
                  name: 'yaz_flex_rest_duration_days_selected',
                  parameters: {'rest_duration_days': selectedRestDurationDays},
                );
                store.setYazFlexRestDurationDays(yazFlexRestDurationDays: selectedRestDurationDays);
                Navigator.pop(context);
              },
              cancel: () {
                analytics.logEvent(name: 'yaz_flex_rest_duration_days_cancel');
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: 200,
              child: CupertinoPicker(
                itemExtent: 40,
                onSelectedItemChanged: (index) {
                  selectedRestDurationDays = index + 1;
                },
                scrollController: FixedExtentScrollController(initialItem: restDurationDays - 1),
                children: List.generate(_maxRestDurationDays, (index) => Text(L.yazFlexRestDurationDaysValue('${index + 1}'))),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// 前回の休薬の日数の欄。ラベルの下に「4日間」のような日数を枠で囲って出し、タップでピッカーを開く
/// 日数は初期設定の状態 (InitialSettingStateNotifier) に入れるため、タップ時の処理はコールバックで親から渡す
class YazFlexRestDurationDaysField extends StatelessWidget {
  final int restDurationDays;
  final VoidCallback onTap;

  const YazFlexRestDurationDaysField({
    super.key,
    required this.restDurationDays,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          L.yazFlexRestDurationDaysLabel,
          style: const TextStyle(
            fontFamily: FontFamily.japanese,
            fontWeight: FontWeight.w300,
            fontSize: 14,
            color: TextColor.main,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Center(
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              height: 48,
              // 選んだ日数の文字に合わせた幅にし、短い文字でも押しやすいよう最低限の幅を確保する
              constraints: const BoxConstraints(minWidth: 120),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                border: Border.all(width: 1, color: AppColors.border),
              ),
              child: Align(
                widthFactor: 1,
                child: Text(
                  L.yazFlexRestDurationDaysValue('$restDurationDays'),
                  style: const TextStyle(
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: TextColor.main,
                  ),
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
