import 'package:flutter/material.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';

class RestDurationButton extends StatelessWidget {
  RestDurationButton();
  Widget build(BuildContext context) {
    return TertiaryButton(
      text: "休薬中",
      onPressed: () {
        analytics.logEvent(name: "rest_duration_button_pressed");
      },
    );
  }
}
