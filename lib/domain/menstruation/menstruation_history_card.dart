import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/app_card.dart';
import 'package:pilll/domain/menstruation/menstruation_history_row.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:flutter/material.dart';

class MenstruationHistoryCardState {
  final List<Menstruation> menstruations;

  MenstruationHistoryCardState({
    required this.menstruations,
  });
}

class MenstruationHistoryCard extends StatelessWidget {
  final MenstruationHistoryCardState state;

  const MenstruationHistoryCard({Key? key, required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 16, left: 16, bottom: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("生理記録", style: FontType.sBigTitle.merge(TextColorStyle.main)),
            SizedBox(height: 32),
            Column(
              mainAxisSize: MainAxisSize.max,
              children:
                  _rows().map((e) => [MenstruationHistoryRow(state: e), SizedBox(height: 20)]).expand((e) => e).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SecondaryButton(text: "もっと見る", onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
