import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/molecules/premium_badge.dart';
import 'package:pilll/features/premium_introduction/paywall_source.dart';
import 'package:pilll/features/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/provider/setting.dart';

class CreatingNewPillSheetRow extends HookConsumerWidget {
  final Setting setting;
  final bool isTrial;
  final bool isPremium;
  final DateTime? trialDeadlineDate;

  const CreatingNewPillSheetRow({
    super.key,
    required this.setting,
    required this.isTrial,
    required this.isPremium,
    required this.trialDeadlineDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setSetting = ref.watch(setSettingProvider);
    return SwitchListTile(
      // iPhone Duo の外側ディスプレイ (幅 382pt) や訳の長い言語 (de 等) では文言とバッジが 1 行に収まらないため、文言を折り返す。
      // Row で並べると文言が 2 行になった時にバッジが 2 行の間の高さに浮くため、バッジを文言の末尾に続けて置く
      title: Text.rich(
        TextSpan(
          text: L.autoAddPillSheetGroup,
          children: [
            if (!isPremium) ...[
              const WidgetSpan(child: SizedBox(width: 8)),
              // WidgetSpan は子を文字の拡大率で拡大するため、バッジの中の Text には拡大率を掛けない (掛けると二重に拡大される)
              WidgetSpan(alignment: PlaceholderAlignment.middle, child: MediaQuery.withNoTextScaling(child: const PremiumBadge())),
            ],
          ],
        ),
        style: const TextStyle(
          fontFamily: FontFamily.roboto,
          fontWeight: FontWeight.w300,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        L.autoAddNewSheetAfterCurrentEnds,
        style: const TextStyle(
          fontFamily: FontFamily.japanese,
          fontWeight: FontWeight.w300,
          fontSize: 14,
        ),
      ),
      activeThumbColor: AppColors.secondary,
      onChanged: (bool value) async {
        analytics.logEvent(name: 'toggle_creating_new_pillsheet');
        if (isPremium || isTrial) {
          final messenger = ScaffoldMessenger.of(context);
          messenger.hideCurrentSnackBar();
          await setSetting(
            setting.copyWith(isAutomaticallyCreatePillSheet: value),
          );
          messenger.showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 2),
              content: Text("ピルシートグループの自動追加を${value ? "ON" : "OFF"}にしました"),
            ),
          );
        } else if (!isPremium) {
          showPremiumIntroductionSheet(context, source: PaywallSource.settingsCreatingNewPillSheetRow);
        }
      },
      value: setting.isAutomaticallyCreatePillSheet && (isPremium || isTrial),
      contentPadding: const EdgeInsets.fromLTRB(14, 8, 6, 8),
    );
  }
}
