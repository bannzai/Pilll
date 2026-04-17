import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/features/feature_appeal/alarm_kit/alarm_kit_help_page.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';

/// AlarmKit (Premium機能: iOS 26+) を AnnouncementBar 領域でアピールする Bar。
/// iOS 26 未満・Android にも表示するが、HelpPage 内で利用条件を明示している。
class AlarmKitAnnouncementBar extends StatelessWidget {
  /// 親 (FeatureAppealBarsContainer) が所有する dismissed フラグ。× ボタン押下で true にする。
  final ValueNotifier<bool> isClosed;
  const AlarmKitAnnouncementBar({super.key, required this.isClosed});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: GestureDetector(
        onTap: () {
          analytics.logEvent(
            name: 'feature_appeal_bar_tapped',
            parameters: {'feature_key': 'alarm_kit', 'feature_type': 'premium'},
          );
          Navigator.of(context).push(AlarmKitHelpPageRoute.route());
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Semantics(
              identifier: 'feature_appeal_dismiss_button',
              child: IconButton(
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                icon: const Icon(Icons.close, color: Colors.white, size: 24),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  analytics.logEvent(
                    name: 'feature_appeal_bar_dismissed',
                    parameters: {'feature_key': 'alarm_kit', 'feature_type': 'premium'},
                  );
                  isClosed.value = true;
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    L.alarmKitFeatureAppealTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: FontFamily.japanese,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    L.alarmKitFeatureAppealShortDescription,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontFamily: FontFamily.japanese,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            SvgPicture.asset(
              'images/arrow_right.svg',
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              height: 16,
              width: 16,
            ),
          ],
        ),
      ),
    );
  }
}
