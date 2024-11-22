import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/localizations/l.dart';

class PremiumIntroductionFeatures extends StatelessWidget {
  const PremiumIntroductionFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.topEnd,
      children: [
        Image.asset(
          Platform.isIOS ? 'images/ios-quick-record.gif' : 'images/android-quick-record.gif',
        ),
        Positioned(
          right: -27,
          top: -27,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              SvgPicture.asset('images/yellow_spike.svg'),
              Text(
                L.popularFeatures,
                style: const TextStyle(
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
    );
  }
}
