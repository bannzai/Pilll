import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class ListExplainRow extends StatelessWidget {
  final String text;

  const ListExplainRow({
    Key? key,
    required this.text,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title:
          Text(text, style: FontType.assisting.merge(TextColorStyle.darkGray)),
    );
  }
}
