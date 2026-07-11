import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/features/ended_pill_sheet_dialog/components/history_blur_teaser.dart';
import 'package:pilll/features/ended_pill_sheet_dialog/components/summary_stats_teaser.dart';
import 'package:pilll/features/ended_pill_sheet_dialog/ended_pill_sheet_dialog_variant.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/emoji/emoji.dart';

/// ピルシート終了時に free ユーザー向けに表示する課金転換ダイアログ。
/// variant に応じて履歴ぼかし(A) / 集計メッセージ(B) のティーザーを出し分け、CTA から paywall を開く。
/// 表示・CTA・dismiss を analytics に variant 付きで記録する。
Future<void> showEndedPillSheetDialog(
  BuildContext context, {
  required EndedPillSheetDialogVariant variant,
  required PillSheetGroup pillSheetGroup,
}) async {
  analytics.logEvent(
    name: 'ended_sheet_dialog_shown',
    parameters: {'variant': variant.value},
  );

  final isCTATapped = await showDialog<bool>(
        context: context,
        builder: (_) => EndedPillSheetDialog(variant: variant, pillSheetGroup: pillSheetGroup),
      ) ??
      false;

  if (isCTATapped) {
    analytics.logEvent(
      name: 'ended_sheet_dialog_cta_tapped',
      parameters: {'variant': variant.value},
    );
    if (context.mounted) {
      showPremiumIntroductionSheet(context, source: variant.paywallSource);
    }
  } else {
    analytics.logEvent(
      name: 'ended_sheet_dialog_dismissed',
      parameters: {'variant': variant.value},
    );
  }
}

/// [showEndedPillSheetDialog] が表示するダイアログ本体。
/// CTA 押下時は pop(true)、閉じる/外タップ時は pop(false) を返し、呼び出し側で paywall 表示と計測を分岐する。
class EndedPillSheetDialog extends StatelessWidget {
  final EndedPillSheetDialogVariant variant;
  final PillSheetGroup pillSheetGroup;

  const EndedPillSheetDialog({
    super.key,
    required this.variant,
    required this.pillSheetGroup,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: TextColor.gray),
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ),
            switch (variant) {
              EndedPillSheetDialogVariant.historyBlur => HistoryBlurTeaser(pillSheetGroup: pillSheetGroup),
              EndedPillSheetDialogVariant.summaryStats => SummaryStatsTeaser(pillSheetGroup: pillSheetGroup),
            },
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(lockEmoji, style: TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text(
                  L.takingHistoryIsPremiumFeature,
                  style: const TextStyle(
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: TextColor.main,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AppOutlinedButton(
              text: L.viewMoreDetails,
              onPressed: () async => Navigator.of(context).pop(true),
            ),
          ],
        ),
      ),
    );
  }
}
