import 'package:flutter_svg/svg.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:pilll/features/localizations/l.dart';

class ReminderPushNotificationPreview extends StatelessWidget {
  final String word;
  final String message;
  final bool isInVisibleReminderDate;
  final bool isInvisiblePillNumber;
  final bool isInvisibleDescription;

  const ReminderPushNotificationPreview({
    super.key,
    required this.word,
    required this.message,
    required this.isInVisibleReminderDate,
    required this.isInvisiblePillNumber,
    required this.isInvisibleDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset('images/pilll_icon.svg'),
              const SizedBox(width: 8),
              const Text(
                'Pilll',
                style: TextStyle(
                  fontFamily: FontFamily.japanese,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: TextColor.lightGray2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "$word${isInVisibleReminderDate ? "" : " 1/7"}${isInvisiblePillNumber ? "" : " ${L.beginToEndNumbers(5, 8)}"}",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontFamily: FontFamily.japanese,
              color: TextColor.black,
            ),
          ),
          if (!isInvisibleDescription || message.isEmpty)
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: FontFamily.japanese,
                color: TextColor.black,
              ),
            ),
        ],
      ),
    );
  }
}
