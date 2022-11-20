import 'package:flutter/material.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/error/error_alert.dart';
import 'package:pilll/native/health_care.dart';
import 'package:url_launcher/url_launcher.dart';

class HealthCareRow extends StatelessWidget {
  final DateTime? trialDeadlineDate;

  const HealthCareRow({
    Key? key,
    required this.trialDeadlineDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 9,
      title: Row(
        children: const [
          Text("ヘルスケア連携",
              style: const TextStyle(
                fontFamily: FontFamily.roboto,
                fontWeight: FontWeight.w300,
                fontSize: 16,
              )),
        ],
      ),
      subtitle: const Text("Pilllで記録した生理記録を自動でヘルスケアに記録できます"),
      onTap: () async {
        analytics.logEvent(
          name: "did_select_health_care_row",
        );

        try {
          if (await isAuthorizedReadAndShareToHealthKitData()) {
            launchUrl(Uri.parse("https://pilll.wraptas.site/9f689858e2a34cf6bc7c08ab85a192cf"));
          } else {
            if (await shouldRequestForAccessToHealthKitData()) {
              await requestWriteMenstrualFlowHealthKitDataPermission();
            }
          }
        } catch (error) {
          showErrorAlert(context, error);
        }
      },
    );
  }
}
