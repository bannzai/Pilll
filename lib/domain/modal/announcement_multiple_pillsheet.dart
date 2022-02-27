import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class AnnouncementMultiplePillSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      contentPadding: const EdgeInsets.only(left: 24, right: 24, top: 16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(children: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
              padding: const EdgeInsets.only(left: 0, right: 8, top: 0, bottom: 8),
            ),
            const Spacer(),
          ]),
          const Text(
            "ピルシートを\n服用日数表示にできます",
            style: TextStyle(
                color: TextColor.main,
                fontWeight: FontWeight.w700,
                fontSize: 16,
                fontFamily: FontFamily.japanese),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Image.asset(
            "images/announcement_multiple_pill_sheet.png",
          ),
          const SizedBox(height: 24),
          const Text(
            "ヤーズフレックスなど連続服用する方におすすめです。",
            style: TextStyle(
              color: TextColor.main,
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "表示モード",
                style: TextStyle(
                  color: TextColor.main,
                  fontSize: 12,
                  fontFamily: FontFamily.japanese,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 6),
              SvgPicture.asset("images/switching_appearance_mode.svg"),
              const Text("から設定できます",
                  style: TextStyle(
                      color: TextColor.main,
                      fontSize: 14,
                      fontFamily: FontFamily.japanese,
                      fontWeight: FontWeight.w400)),
            ],
          ),
        ],
      ),
      actions: [],
    );
  }
}

showAnnouncementMultiplePillSheet(BuildContext context) async {
  showDialog(
    context: context,
    builder: (context) => AnnouncementMultiplePillSheet(),
  );
}
