import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PremiumIntroductionHeader extends StatelessWidget {
  final bool shouldShowDismiss;

  const PremiumIntroductionHeader({Key? key, required this.shouldShowDismiss})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 111,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          if (shouldShowDismiss)
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          Center(child: SvgPicture.asset("images/pillll_premium_logo.svg")),
        ],
      ),
    );
  }
}
