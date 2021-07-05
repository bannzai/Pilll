import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/settings/row_model.dart';

class SettingSectionTitle extends StatelessWidget {
  final String text;

  const SettingSectionTitle({
    Key? key,
    required this.text,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16, left: 15, right: 16),
      child: Text(
        text,
        style: FontType.assisting.merge(TextColorStyle.primary),
      ),
    );
  }
}
