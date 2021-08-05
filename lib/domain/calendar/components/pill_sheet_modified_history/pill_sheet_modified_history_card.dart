import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/app_card.dart';
import 'package:pilll/components/molecules/premium_badge.dart';

class CalendarPillSheetModifiedHistoryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "服用履歴",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: FontFamily.japanese,
                  fontSize: 20,
                  color: TextColor.main,
                ),
              ),
              PremiumBadge(),
            ],
          ),
          Text(
            "28日連続服用記録中👏",
            style: TextStyle(
                color: TextColor.main,
                fontFamily: FontFamily.japanese,
                fontSize: 14,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
