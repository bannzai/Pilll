import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class DemographyPage extends StatefulWidget {
  @override
  _DemographyPageState createState() => _DemographyPageState();
}

class _DemographyPageState extends State<DemographyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: ListView(
        children: [
          Text("あなたについて\n少しだけ教えて下さい",
              style: FontType.sBigTitle.merge(TextColorStyle.main)),
          PrimaryButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            text: "完了",
          ),
        ],
      ),
    );
  }
}
