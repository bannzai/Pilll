import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class RestDurationNotificationBar extends StatelessWidget {
  const RestDurationNotificationBar({
    Key? key,
    required this.restDurationNotification,
  }) : super(key: key);

  final String restDurationNotification;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(restDurationNotification,
          style: FontType.assistingBold.merge(TextColorStyle.white)),
    );
  }
}
