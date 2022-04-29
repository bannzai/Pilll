import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/domain/menstruation/menstruation_card.dart';
import 'package:pilll/domain/menstruation/menstruation_history_card.dart';
import 'package:pilll/domain/menstruation/menstruation_store.dart';

class MenstruationCardList extends StatelessWidget {
  const MenstruationCardList({
    Key? key,
    required this.store,
  }) : super(key: key);

  final MenstruationStore store;

  @override
  Widget build(BuildContext context) {
    final cardState = store.cardState();
    final historyCardState = store.historyCardState();
    return Container(
      color: PilllColors.background,
      child: ListView(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        scrollDirection: Axis.vertical,
        children: [
          if (cardState != null) ...[
            MenstruationCard(cardState),
            const SizedBox(height: 24),
          ],
          if (historyCardState != null)
            MenstruationHistoryCard(state: historyCardState),
        ],
      ),
    );
  }
}
