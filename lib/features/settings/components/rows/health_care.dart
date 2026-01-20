import 'package:flutter/material.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/native/health_care.dart';
import 'package:url_launcher/url_launcher.dart';

class HealthCareRow extends StatelessWidget {
  final DateTime? trialDeadlineDate;

  const HealthCareRow({super.key, required this.trialDeadlineDate});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 9,
      title: Row(
        children: [
          Text(
            L.healthCareIntegration,
            style: const TextStyle(
              fontFamily: FontFamily.roboto,
              fontWeight: FontWeight.w300,
              fontSize: 16,
            ),
          ),
        ],
      ),
      subtitle: Text(L.healthCareIntegrationDescription),
      onTap: () async {
        analytics.logEvent(name: 'did_select_health_care_row');

        try {
          if (await healthKitRequestAuthorizationIsUnnecessary()) {
            launchUrl(
              Uri.parse(
                'https://pilll.notion.site/9f689858e2a34cf6bc7c08ab85a192cf',
              ),
            );
          } else {
            if (await shouldRequestForAccessToHealthKitData()) {
              await requestWriteMenstrualFlowHealthKitDataPermission();
            }
          }
        } catch (error) {
          if (context.mounted) showErrorAlert(context, error);
        }
      },
    );
  }
}
