import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/localizations/l.dart';

class PremiumUserThanksRow extends StatelessWidget {
  const PremiumUserThanksRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          L.youArePremiumMember,
          style: const TextStyle(
            fontFamily: FontFamily.japanese,
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: TextColor.main,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        SvgPicture.asset('images/jewel.svg'),
        const SizedBox(height: 24),
        Text(
          L.thankYouMessage,
          style: const TextStyle(
            fontFamily: FontFamily.japanese,
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: TextColor.main,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
