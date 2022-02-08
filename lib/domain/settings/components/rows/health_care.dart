import 'package:flutter/material.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/entity/user_error.dart';
import 'package:pilll/error/error_alert.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/native/health_care.dart';

class HealthCareRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text("ヘルスケア", style: FontType.listRow),
        ],
      ),
      onTap: () async {
        analytics.logEvent(
          name: "did_select_health_care_row",
        );

        try {
          if (await shouldRequestForAccessToHealthKitData()) {
            await requestWriteMenstrualFlowHealthKitDataPermission();
          }
        } catch (error) {
          if (error is UserDisplayedError) {
            showErrorAlertWithError(context, error);
          } else {
            UniversalErrorPage.of(context).showError(error);
          }
        }
      },
    );
  }
}
