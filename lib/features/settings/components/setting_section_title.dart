import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class SettingSectionTitle extends StatelessWidget {
  final String text;
  final List<Widget> children;

  const SettingSectionTitle({
    super.key,
    required this.text,
    required this.children,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _section(),
        ...children,
      ],
    );
  }

  Widget _section() {
    return Container(
      padding: const EdgeInsets.only(top: 32, left: 15, right: 16),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: FontFamily.japanese,
          fontWeight: FontWeight.w300,
          fontSize: 14,
          color: TextColor.main,
        ),
      ),
    );
  }
}
