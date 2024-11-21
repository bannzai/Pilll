import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutChurn extends HookConsumerWidget {
  const AboutChurn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: const Text("解約について",
          style: TextStyle(
            fontFamily: FontFamily.roboto,
            fontWeight: FontWeight.w300,
            fontSize: 16,
          )),
      onTap: () {
        analytics.logEvent(
          name: "did_select_about_churn",
        );

        launchUrl(Uri.parse("https://pilll.wraptas.site/b10fd76f1d2246d286ad5cff03f22940"), mode: LaunchMode.inAppWebView);
      },
    );
  }
}
