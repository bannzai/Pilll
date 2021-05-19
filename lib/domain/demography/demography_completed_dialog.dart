import 'package:flutter_svg/svg.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DemographyCompletedDialog extends StatelessWidget {
  const DemographyCompletedDialog({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          width: MediaQuery.of(context).size.width - 30 * 2,
          height: 287,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Spacer(),
              Text(
                "Thank you!",
                style: FontType.subTitle.merge(TextColorStyle.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              SvgPicture.asset("images/mug.svg"),
              SizedBox(height: 24),
              Text(
                "回答ありがとうございます。\nこれで登録完了です！",
                style: FontType.assisting.merge(TextColorStyle.black),
                textAlign: TextAlign.center,
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

void showDemographyCompletedDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) {
      return DemographyCompletedDialog();
    },
  );
}
