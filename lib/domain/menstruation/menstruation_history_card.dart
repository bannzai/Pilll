import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
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
    return Column(
      children: [
        Text("生理記録", style: FontType.sBigTitle.merge(TextColorStyle.main)),
        Column(
          children:
              _rows().map((e) => MenstruationHistoryRow(state: e)).toList(),
        ),
        SecondaryButton(text: "もっと見る", onPressed: () {}),
      ],
    );
  }

  List<MenstruationHistoryRowState> _rows() {
    final menstruations = state.menstruations;
    menstruations.sort((a, b) => a.beginDate.compareTo(b.beginDate));
    return menstruations
        .map((element) => MenstruationHistoryRowState(element))
        .toList()
        .reversed
        .fold<List<MenstruationHistoryRowState>>([], (value, element) {
          if (value.isEmpty) {
            return [element];
          }
          return value
            ..last.menstruationDuration =
                MenstruationHistoryRowState.diff(value.last, element)
            ..add(element);
        })
        .reversed
        .toList();
  }
}
