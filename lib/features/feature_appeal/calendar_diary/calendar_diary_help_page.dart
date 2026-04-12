import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/home/page.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';

/// カレンダー・日記 (無料機能) の説明と「実際に試す」導線を持つヘルプページ。
class CalendarDiaryHelpPage extends ConsumerWidget {
  const CalendarDiaryHelpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(L.calendarDiaryFeatureAppealTitle),
        backgroundColor: AppColors.background,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SvgPicture.asset(
                'images/tab_icon_calendar_enable.svg',
                width: 80,
                height: 80,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              L.calendarDiaryFeatureAppealHeadline,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                fontFamily: FontFamily.japanese,
                color: TextColor.main,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              L.calendarDiaryFeatureAppealBody,
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
                fontFamily: FontFamily.japanese,
                color: TextColor.main,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: PrimaryButton(
              text: L.featureAppealTryFeature,
              onPressed: () async {
                analytics.logEvent(
                  name: 'feature_appeal_try_tapped',
                  parameters: {
                    'feature_key': 'calendar_diary',
                    'feature_type': 'free',
                    'is_paywall_shown': 0,
                  },
                );
                final tabController = ref.read(homeTabControllerProvider);
                Navigator.of(context).popUntil((r) => r.isFirst);
                tabController?.animateTo(HomePageTabType.calendar.index);
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// FirebaseAnalyticsObserver が自動で screen_view を送信するため、
/// RouteSettings.name は必ず設定する (lib/app.dart で MaterialApp に登録済み)。
extension CalendarDiaryHelpPageRoute on CalendarDiaryHelpPage {
  static Route<dynamic> route() => MaterialPageRoute(
        settings: const RouteSettings(name: 'CalendarDiaryHelpPage'),
        builder: (_) => const CalendarDiaryHelpPage(),
      );
}
