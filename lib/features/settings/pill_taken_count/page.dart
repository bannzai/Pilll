import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/provider/change_pill_taken_count.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:flutter/material.dart';

class SettingPillTakenCountPage extends HookConsumerWidget {
  final PillSheetGroup pillSheetGroup;
  final PillSheet activePillSheet;

  const SettingPillTakenCountPage({
    super.key,
    required this.pillSheetGroup,
    required this.activePillSheet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPillTakenCount = useState(activePillSheet.pillTakenCount);
    final changePillTakenCount = ref.watch(changePillTakenCountProvider);
    final navigator = Navigator.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '服用錠数設定',
          style: TextStyle(color: TextColor.black),
        ),
        backgroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              ListView(
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    '1回に服用する錠数を選択',
                    style: TextStyle(
                      fontFamily: FontFamily.japanese,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: TextColor.main,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      '2錠飲みを選択すると、1つのピルに対して2回服用記録が必要になります。',
                      style: TextStyle(
                        fontFamily: FontFamily.japanese,
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                        color: TextColor.darkGray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildPillTakenCountSelector(selectedPillTakenCount),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 180,
                      child: PrimaryButton(
                        onPressed: selectedPillTakenCount.value == activePillSheet.pillTakenCount
                            ? null
                            : () async {
                                analytics.logEvent(
                                  name: 'changed_pill_taken_count',
                                  parameters: {
                                    'before': activePillSheet.pillTakenCount,
                                    'after': selectedPillTakenCount.value,
                                  },
                                );
                                await changePillTakenCount(
                                  pillSheetGroup: pillSheetGroup,
                                  pillTakenCount: selectedPillTakenCount.value,
                                );
                                navigator.pop();
                              },
                        text: '変更',
                      ),
                    ),
                    const SizedBox(height: 35),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPillTakenCountSelector(ValueNotifier<int> selectedPillTakenCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          _buildOption(
            selectedPillTakenCount: selectedPillTakenCount,
            value: 1,
            label: '1錠',
            description: '1回の服用で1錠ずつ記録',
          ),
          const SizedBox(height: 16),
          _buildOption(
            selectedPillTakenCount: selectedPillTakenCount,
            value: 2,
            label: '2錠',
            description: '1回の服用で2回の記録が必要',
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required ValueNotifier<int> selectedPillTakenCount,
    required int value,
    required String label,
    required String description,
  }) {
    final isSelected = selectedPillTakenCount.value == value;
    return GestureDetector(
      onTap: () => selectedPillTakenCount.value = value,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.blueBackground : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: 2,
                ),
                color: isSelected ? AppColors.primary : AppColors.white,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: AppColors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: FontFamily.japanese,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: isSelected ? AppColors.primary : TextColor.main,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontFamily: FontFamily.japanese,
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                      color: TextColor.darkGray,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension SettingPillTakenCountPageRoute on SettingPillTakenCountPage {
  static Route<dynamic> route({
    required PillSheetGroup pillSheetGroup,
    required PillSheet activePillSheet,
  }) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: 'SettingPillTakenCountPage'),
      builder: (_) => SettingPillTakenCountPage(
        pillSheetGroup: pillSheetGroup,
        activePillSheet: activePillSheet,
      ),
    );
  }
}
