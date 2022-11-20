import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pilll/util/analytics.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/app_card.dart';
import 'package:pilll/components/molecules/premium_badge.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_more_button.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_list.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_list_header.dart';
import 'package:pilll/features/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/util/emoji/emoji.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';

class CalendarPillSheetModifiedHistoryCardState {
  static const pillSheetModifiedHistoriesThreshold = 6;
  final List<PillSheetModifiedHistory> _allPillSheetModifiedHistories;
  final bool isPremium;
  final bool isTrial;
  final DateTime? trialDeadlineDate;

  CalendarPillSheetModifiedHistoryCardState(
    this._allPillSheetModifiedHistories, {
    required this.isPremium,
    required this.isTrial,
    required this.trialDeadlineDate,
  });

  bool get moreButtonIsShown => _allPillSheetModifiedHistories.length > CalendarPillSheetModifiedHistoryCardState.pillSheetModifiedHistoriesThreshold;
  List<PillSheetModifiedHistory> get pillSheetModifiedHistories {
    if (_allPillSheetModifiedHistories.length > CalendarPillSheetModifiedHistoryCardState.pillSheetModifiedHistoriesThreshold) {
      final copied = [..._allPillSheetModifiedHistories];
      copied.removeRange(
        CalendarPillSheetModifiedHistoryCardState.pillSheetModifiedHistoriesThreshold - 1,
        copied.length,
      );
      return copied;
    } else {
      return _allPillSheetModifiedHistories;
    }
  }
}

class CalendarPillSheetModifiedHistoryCard extends StatelessWidget {
  final List<PillSheetModifiedHistory> histories;
  final PremiumAndTrial premiumAndTrial;

  const CalendarPillSheetModifiedHistoryCard({
    Key? key,
    required this.histories,
    required this.premiumAndTrial,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Container(
        padding: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "服用履歴",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: FontFamily.japanese,
                    fontSize: 20,
                    color: TextColor.main,
                  ),
                ),
                if (!premiumAndTrial.isPremium) ...[
                  const SizedBox(width: 8),
                  const PremiumBadge(),
                ],
              ],
            ),
            const SizedBox(height: 16),
            const PillSheetModifiedHisotiryListHeader(),
            const SizedBox(height: 4),
            ...() {
              if (premiumAndTrial.isPremium || premiumAndTrial.isTrial) {
                return [
                  PillSheetModifiedHistoryList(
                    padding: null,
                    scrollPhysics: const NeverScrollableScrollPhysics(),
                    pillSheetModifiedHistories: histories,
                    premiumAndTrial: premiumAndTrial,
                  ),
                  if (histories.length > CalendarPillSheetModifiedHistoryCardState.pillSheetModifiedHistoriesThreshold)
                    PillSheetModifiedHistoryMoreButton(premiumAndTrial: premiumAndTrial),
                ];
              } else {
                return [
                  Stack(
                    children: [
                      PillSheetModifiedHistoryList(
                        padding: null,
                        scrollPhysics: const NeverScrollableScrollPhysics(),
                        pillSheetModifiedHistories: histories,
                        premiumAndTrial: premiumAndTrial,
                      ),
                      Positioned.fill(
                        child: ClipRect(
                          child: Stack(
                            children: [
                              BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                child: Container(
                                  color: Colors.black.withOpacity(0),
                                ),
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(lockEmoji, style: TextStyle(fontSize: 40)),
                                    const SizedBox(height: 12),
                                    const Text(
                                      "服用履歴はプレミアム機能です",
                                      style: TextStyle(
                                        color: TextColor.main,
                                        fontSize: 14,
                                        fontFamily: FontFamily.japanese,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    SizedBox(
                                      width: 204,
                                      child: AppOutlinedButton(
                                        text: "くわしくみる",
                                        onPressed: () async {
                                          analytics.logEvent(
                                            name: "pressed_show_detail_pill_sheet_history",
                                          );
                                          showPremiumIntroductionSheet(context);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ];
              }
            }(),
          ],
        ),
      ),
    );
  }
}
