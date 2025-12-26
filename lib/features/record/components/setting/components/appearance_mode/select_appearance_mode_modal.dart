import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/premium_badge.dart';
import 'package:pilll/components/molecules/select_circle.dart';
import 'package:pilll/features/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/utils/local_notification.dart';

class SelectAppearanceModeModal extends HookConsumerWidget {
  final User user;

  const SelectAppearanceModeModal({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setting = ref.watch(settingProvider).requireValue;
    final pillSheetGroup = ref.watch(latestPillSheetGroupProvider).asData?.value;
    final setPillSheetGroup = ref.watch(setPillSheetGroupProvider);
    final registerReminderLocalNotification = ref.watch(registerReminderLocalNotificationProvider);

    if (pillSheetGroup == null) {
      return const SizedBox();
    }
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 20, top: 24, left: 16, right: 16),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              L.displayMode,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: FontFamily.japanese,
                color: TextColor.main,
              ),
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                _row(
                  context,
                  setting: setting,
                  pillSheetGroup: pillSheetGroup,
                  setPillSheetGroup: setPillSheetGroup,
                  registerReminderLocalNotification: registerReminderLocalNotification,
                  user: user,
                  mode: PillSheetAppearanceMode.date,
                  text: L.dateDisplay,
                  isPremiumFunction: true,
                ),
                _row(
                  context,
                  setting: setting,
                  pillSheetGroup: pillSheetGroup,
                  setPillSheetGroup: setPillSheetGroup,
                  registerReminderLocalNotification: registerReminderLocalNotification,
                  user: user,
                  mode: PillSheetAppearanceMode.number,
                  text: L.pillNumber,
                  isPremiumFunction: false,
                ),
                _row(
                  context,
                  setting: setting,
                  pillSheetGroup: pillSheetGroup,
                  setPillSheetGroup: setPillSheetGroup,
                  registerReminderLocalNotification: registerReminderLocalNotification,
                  user: user,
                  mode: PillSheetAppearanceMode.cyclicSequential,
                  text: L.pillDaysCycle,
                  isPremiumFunction: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(
    BuildContext context, {
    required SetPillSheetGroup setPillSheetGroup,
    required RegisterReminderLocalNotification registerReminderLocalNotification,
    required Setting setting,
    required PillSheetGroup pillSheetGroup,
    required User user,
    required PillSheetAppearanceMode mode,
    required String text,
    required bool isPremiumFunction,
  }) {
    return GestureDetector(
      onTap: () async {
        analytics.logEvent(
          name: 'did_select_pill_sheet_appearance',
          parameters: {'mode': mode.toString(), 'isPremiumFunction': isPremiumFunction},
        );

        if (user.isPremium || user.isTrial) {
          await setPillSheetGroup(pillSheetGroup.copyWith(pillSheetAppearanceMode: mode));
          await registerReminderLocalNotification();
        } else if (isPremiumFunction) {
          showPremiumIntroductionSheet(context);
        } else {
          // User selected non premium function mode
          await setPillSheetGroup(pillSheetGroup.copyWith(pillSheetAppearanceMode: mode));
          await registerReminderLocalNotification();
        }
      },
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            SelectCircle(isSelected: mode == pillSheetGroup.pillSheetAppearanceMode),
            const SizedBox(width: 34),
            Text(
              text,
              style: const TextStyle(
                color: TextColor.main,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            if (isPremiumFunction) ...[
              const SizedBox(width: 12),
              const PremiumBadge(),
            ]
          ],
        ),
      ),
    );
  }
}

void showSelectAppearanceModeModal(
  BuildContext context, {
  required User user,
  required PillSheetGroup pillSheetGroup,
}) {
  analytics.logScreenView(screenName: 'SelectAppearanceModeModal');
  showModalBottomSheet(
    context: context,
    builder: (context) => SelectAppearanceModeModal(
      user: user,
    ),
    backgroundColor: Colors.transparent,
  );
}
