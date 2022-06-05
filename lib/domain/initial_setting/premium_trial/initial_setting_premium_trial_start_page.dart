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

    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        leading: Container(),
        backgroundColor: PilllColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 44.5,
                  ),
                  color: PilllColors.mat,
                  child: Column(
                    children: [
                      const SizedBox(height: 1),
                      Column(
                        children: [
                          const Text(
                            "\\ 通知から服用記録ができます /",
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
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 24.5, right: 24.5, top: 24),
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Image.asset(
                              "images/quick-record.gif",
                            ),
                            Positioned(
                              right: -27,
                              top: -27,
                              child: Stack(
                                alignment: AlignmentDirectional.center,
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
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '''
30日間すべての機能が使えます！
''',
                  style: TextStyle(
                    color: TextColor.main,
                    fontWeight: FontWeight.w700,
                    fontFamily: FontFamily.japanese,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
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
