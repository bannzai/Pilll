import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/initial_setting/initial_setting_store.dart';
import 'package:pilll/error/error_alert.dart';
import 'package:pilll/router/router.dart';

class IntiialSettingPremiumTrialStartPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(initialSettingStoreProvider.notifier);
    final state = ref.watch(initialSettingStoreProvider);

    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SvgPicture.asset("images/premium_trial_ribbon.svg"),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 26,
                  ),
                  color: PilllColors.mat,
                  child: Column(
                    children: [
                      const Text(
                        "PRESENT",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: TextColor.primaryDarkBlue,
                          fontFamily: FontFamily.alphabet,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Column(
                        children: [
                          const Text(
                            "プレミアム体験プレゼント中",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: TextColor.black,
                              fontFamily: FontFamily.japanese,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                      Stack(
                        children: [
                          Image.asset(
                            "images/quick-record.gif",
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Stack(
                              children: [
                                SvgPicture.asset("images/yellow_spike.svg"),
                                const Text(
                                  "人気の\n機能",
                                  style: TextStyle(
                                    color: TextColor.primaryDarkBlue,
                                    fontSize: 10,
                                    fontFamily: FontFamily.japanese,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '''
通知を長押しすると服用記録ができます
ぜひお試しください
''',
                        style: TextStyle(
                          color: TextColor.main,
                          fontSize: 14,
                          fontFamily: FontFamily.japanese,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '''
自動課金はされません。安心してお使いください
30日後、自動で無料版に移行します
''',
                  style: TextStyle(
                    color: TextColor.main,
                    fontWeight: FontWeight.bold,
                    fontFamily: FontFamily.japanese,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 39,
              ),
              child: AppOutlinedButton(
                text: "アプリをはじめる",
                onPressed: () async {
                  analytics.logEvent(name: "pressed_start_app_preiun_trial");
                  try {
                    await store.register();
                    AppRouter.endInitialSetting(context);
                  } catch (error) {
                    showErrorAlert(context, message: error.toString());
                  }
                },
              ),
            ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}

extension IntiialSettingPremiumTrialStartPageRoute
    on IntiialSettingPremiumTrialStartPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings:
          const RouteSettings(name: "IntiialSettingPremiumTrialStartPage"),
      builder: (_) => IntiialSettingPremiumTrialStartPage(),
    );
  }
}
