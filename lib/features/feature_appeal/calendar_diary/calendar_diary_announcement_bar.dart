import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/features/feature_appeal/calendar_diary/calendar_diary_help_page.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';

/// カレンダー・日記 (無料機能) を AnnouncementBar 領域でアピールする Bar。
class CalendarDiaryAnnouncementBar extends StatelessWidget {
  /// 親 (FeatureAppealBarsContainer) が所有する dismissed フラグ。× ボタン押下で true にする。
  final ValueNotifier<bool> isClosed;
  const CalendarDiaryAnnouncementBar({super.key, required this.isClosed});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: GestureDetector(
        onTap: () {
          analytics.logEvent(
            name: 'feature_appeal_bar_tapped',
            parameters: {'feature_key': 'calendar_diary', 'feature_type': 'free'},
          );
          Navigator.of(context).push(CalendarDiaryHelpPageRoute.route());
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
                    parameters: {'feature_key': 'calendar_diary', 'feature_type': 'free'},
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
                    L.calendarDiaryFeatureAppealTitle,
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
                    L.calendarDiaryFeatureAppealShortDescription,
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
