import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnnouncementMultiplePillSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      contentPadding: EdgeInsets.only(left: 24, right: 24, top: 32),
      actionsPadding: EdgeInsets.only(left: 24, right: 24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(children: [
            IconButton(
              icon: Icon(Icons.close, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Spacer(),
          ]),
          Text("ピルシートを連番表示にできます",
              style: FontType.subTitle.merge(TextColorStyle.main)),
          SizedBox(height: 24),
          Image.asset(
            "images/announcement_multiple_pill_sheet.png",
          ),
          SizedBox(height: 24),
          Text(
            "ヤーズフレックスなど連続服用する方に\nおすすめです。",
            style: TextStyle(
              color: TextColor.main,
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 24),
          Row(children: [
            Text(
              "表示モード",
              style: TextStyle(
                color: TextColor.main,
                fontSize: 12,
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 6),
            SvgPicture.asset("images/switching_appearance_mode.svg"),
          ]),
        ],
      ),
      actions: [],
    );
  }
}

showAnnouncementMultiplePillSheet(BuildContext context) async {
  final sharedPreferences = await SharedPreferences.getInstance();
//  if (sharedPreferences.getBool(
//          BoolKey.isAlreadyShowAnnouncementSupportedMultilplePillSheet) ??
//      false) {
//    return;
//  }
  sharedPreferences.setBool(
      BoolKey.isAlreadyShowAnnouncementSupportedMultilplePillSheet, true);
  showDialog(
    context: context,
    builder: (context) => AnnouncementMultiplePillSheet(),
  );
}
