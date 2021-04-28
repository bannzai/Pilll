import 'dart:math';

import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/app_card.dart';
import 'package:pilll/domain/menstruation/menstruation_history_row.dart';
import 'package:pilll/domain/menstruation/menstruation_list_page.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:flutter/material.dart';
import 'package:pilll/store/menstruation.dart';
import 'package:pilll/util/datetime/day.dart';

class MenstruationHistoryCardState {
  final List<Menstruation> _allMenstruations;

  MenstruationHistoryCardState(
    this._allMenstruations,
  );

  bool get _latestPillSheetIntoToday {
    if (_allMenstruations.isEmpty) {
      return false;
    }
    return _allMenstruations.last.dateRange.inRange(today());
  }

  bool get moreButtonIsHidden => _latestPillSheetIntoToday
      ? _allMenstruations.length <= 3
      : _allMenstruations.length <= 2;
  List<MenstruationHistoryRowState> get rows {
    if (_allMenstruations.isEmpty) {
      return [];
    }
    var menstruations = dropLatestMenstruationIfNeeded(_allMenstruations);
    if (menstruations.isEmpty) {
      return [];
    }
    final rows = MenstruationHistoryRowState.rows(menstruations);
    final length = min(2, rows.length);
    return rows.sublist(0, length);
  }
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
            Text("生理履歴", style: FontType.sBigTitle.merge(TextColorStyle.main)),
            SizedBox(height: 32),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: state.rows
                  .map((e) =>
                      [MenstruationHistoryRow(state: e), SizedBox(height: 20)])
                  .expand((e) => e)
                  .toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!state.moreButtonIsHidden)
                  SecondaryButton(
                      text: "もっと見る",
                      onPressed: () {
                        analytics.logEvent(
                            name: "menstruation_more_button_pressed");
                        Navigator.of(context)
                            .push(MenstruationListPageRoute.route());
                      }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
