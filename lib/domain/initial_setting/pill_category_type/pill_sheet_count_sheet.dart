import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class PillSheetCountSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const Text("処方されるシート数は？",
              style: TextStyle(
                color: TextColor.main,
                fontSize: 16,
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.bold,
              )),
          Row(
            children: [
              ...List.generate(6, (index) => index + 1).map((number) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.5, vertical: 11),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: PilllColors.secondary,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(46),
                  ),
                  child: Text("$number",
                      style: const TextStyle(
                        color: TextColor.main,
                        fontSize: 16,
                        fontFamily: FontFamily.number,
                        fontWeight: FontWeight.bold,
                      )),
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }
}
