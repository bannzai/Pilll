import 'package:Pilll/main/components/pill/pill_mark.dart';
import 'package:Pilll/main/components/pill/pill_sheet.dart';
import 'package:Pilll/main/record/record_taken_information.dart';
import 'package:Pilll/style/button.dart';
import 'package:Pilll/theme/color.dart';
import 'package:flutter/material.dart';

class RecordPage extends StatefulWidget {
  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: null,
      extendBodyBehindAppBar: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // TODO: Should not use DateTime.now for beginingTakenDate and lastTakenDate
            RecordTakenInformation(
              today: DateTime.now(),
              beginingTakenDate: DateTime.now(),
              lastTakenDate: DateTime.now(),
            ),
            SizedBox(height: 24),
            PillSheet(
              isHideWeekdayLine: false,
              pillMarkTypeBuilder: (number) {
                return PillMarkType.normal;
              },
              markSelected: (number) {},
            ),
            SizedBox(height: 24),
            Container(
              height: 44,
              width: 180,
              child: PrimaryButton(
                text: "飲んだ",
                onPressed: () {},
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
