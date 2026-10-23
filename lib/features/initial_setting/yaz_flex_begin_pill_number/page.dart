import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/picker/picker_toolbar.dart';
import 'package:pilll/features/initial_setting/initial_setting_state_notifier.dart';
import 'package:pilll/features/initial_setting/yaz_flex/pill_sheet_group_preview.dart';
import 'package:pilll/features/initial_setting/yaz_flex_rest_duration/page.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';

/// 開始番号として選べる最大の日数
/// ヤーズフレックスの連続服用は最長120日で休薬に入るため、シートを始めた日が休薬明けから120日目を超えることはない
const _maxBeginPillNumber = 120;

/// ヤーズフレックス向けの初期設定で、開始番号 (1枚目の1番は休薬明けから何日目か) を入力するページ
/// ピルシートグループのプレビューの1枚目の1番に印を付け、選んだ番号をプレビューの服用日数にそのまま反映する。入力後は前回の休薬のページへ進む
class InitialSettingYazFlexBeginPillNumberPage extends ConsumerWidget {
  const InitialSettingYazFlexBeginPillNumberPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(initialSettingStateNotifierProvider.notifier);
    final state = ref.watch(initialSettingStateNotifierProvider);
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
                      L.yazFlexBeginPillNumberPageTitle,
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
                        markedPill: (pageIndex: 0, pillNumberInPillSheet: 1),
                        initialPageIndex: 0,
                      ),
                    const SizedBox(height: 24),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          analytics.logEvent(name: 'yaz_flex_begin_pill_number_tapped');
                          _showPicker(context, store: store, beginPillNumber: state.yazFlexBeginPillNumber);
                        },
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
                              L.withDay('${state.yazFlexBeginPillNumber}'),
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
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              L.yazFlexNextInputIsRestDuration,
              style: const TextStyle(
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w300,
                fontSize: 12,
                color: TextColor.gray,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 180,
              child: PrimaryButton(
                text: L.next,
                onPressed: pillSheetGroup == null
                    ? null
                    : () async {
                        analytics.logEvent(
                          name: 'done_yaz_flex_begin_pill_number',
                          parameters: {'begin_pill_number': state.yazFlexBeginPillNumber},
                        );
                        Navigator.of(context).push(InitialSettingYazFlexRestDurationPageRoute.route());
                      },
              ),
            ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }

  void _showPicker(
    BuildContext context, {
    required InitialSettingStateNotifier store,
    required int beginPillNumber,
  }) {
    var selectedBeginPillNumber = beginPillNumber;
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
                  name: 'yaz_flex_begin_pill_number_selected',
                  parameters: {'begin_pill_number': selectedBeginPillNumber},
                );
                store.setYazFlexBeginPillNumber(yazFlexBeginPillNumber: selectedBeginPillNumber);
                Navigator.pop(context);
              },
              cancel: () {
                analytics.logEvent(name: 'yaz_flex_begin_pill_number_cancel');
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: 200,
              child: CupertinoPicker(
                itemExtent: 40,
                onSelectedItemChanged: (index) {
                  selectedBeginPillNumber = index + 1;
                },
                scrollController: FixedExtentScrollController(initialItem: beginPillNumber - 1),
                children: List.generate(_maxBeginPillNumber, (index) => Text(L.withDay('${index + 1}'))),
              ),
            ),
          ],
        );
      },
    );
  }
}

extension InitialSettingYazFlexBeginPillNumberPageRoute on InitialSettingYazFlexBeginPillNumberPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(
        name: 'InitialSettingYazFlexBeginPillNumberPage',
      ),
      builder: (_) => const InitialSettingYazFlexBeginPillNumberPage(),
    );
  }
}
