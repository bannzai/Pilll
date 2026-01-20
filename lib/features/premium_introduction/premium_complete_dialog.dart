import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/localizations/l.dart';

class PremiumCompleteDialog extends StatelessWidget {
  final VoidCallback onClose;

  const PremiumCompleteDialog({super.key, required this.onClose});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            L.premiumRegistrationComplete,
            style: const TextStyle(
              color: TextColor.main,
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SvgPicture.asset('images/jewel.svg'),
          const SizedBox(height: 24),
          Text(
            L.thankYouForRegistration,
            style: const TextStyle(
              color: TextColor.main,
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 180,
            child: PrimaryButton(
              onPressed: () async {
                Navigator.of(context).pop();
                onClose();
              },
              text: L.oK,
            ),
          ),
        ],
      ),
    );
  }
}
