import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: ListView(
                  padding: EdgeInsets.only(top: 60),
                  children: [
                    Text(
                      "あなたについて\n少しだけ教えて下さい",
                      style: FontType.sBigTitle.merge(TextColorStyle.main),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 36),
                    _layout(
                        "ピルを服用している目的/理由",
                        Text("選択してください",
                            style: FontType.assisting
                                .merge(TextColorStyle.black))),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 44),
              child: PrimaryButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                text: "完了",
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _columnWidht() => MediaQuery.of(context).size.width - 39 * 2;

  Widget _layout(String title, Widget form) {
    return Center(
      child: Container(
        width: _columnWidht(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: FontType.assisting.merge(TextColorStyle.black)),
            SizedBox(height: 10),
            Container(
              width: _columnWidht(),
              padding: EdgeInsets.only(top: 16, bottom: 16, left: 16),
              decoration: BoxDecoration(
                  border: Border.all(color: PilllColors.border),
                  borderRadius: BorderRadius.circular(4)),
              child: form,
            ),
          ],
        ),
      ),
    );
  }
}

extension DemographyPageRoute on DemographyPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: "DemographyPage"),
      builder: (_) => DemographyPage(),
    );
  }
}
