import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/app_card.dart';
import 'package:pilll/components/molecules/premium_badge.dart';
import 'package:pilll/domain/calendar/calendar_store.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_more_button.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_list.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_list_header.dart';
import 'package:pilll/domain/pill_sheet_modified_history/pill_sheet_modified_history_state.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_modified_history.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

class CalendarPillSheetModifiedHistoryCardState {
  static final pillSheetModifiedHistoriesThreshold = 6;
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

  bool get moreButtonIsShown =>
      (isPremium || isTrial) &&
      _allPillSheetModifiedHistories.length >
          CalendarPillSheetModifiedHistoryCardState
              .pillSheetModifiedHistoriesThreshold;
  List<PillSheetModifiedHistory> get pillSheetModifiedHistories {
    if (_allPillSheetModifiedHistories.length >
        CalendarPillSheetModifiedHistoryCardState
            .pillSheetModifiedHistoriesThreshold) {
      final copied = List.from(_allPillSheetModifiedHistories);
      copied.removeRange(
        CalendarPillSheetModifiedHistoryCardState
                .pillSheetModifiedHistoriesThreshold -
            1,
        copied.length,
      );
      return copied.cast();
    } else {
      return _allPillSheetModifiedHistories;
    }
  }
}

class CalendarPillSheetModifiedHistoryCard extends StatelessWidget {
  final CalendarPillSheetModifiedHistoryCardState state;
  final CalendarPageStateStore store;

  const CalendarPillSheetModifiedHistoryCard({
    Key? key,
    required this.state,
    required this.store,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Container(
        padding: EdgeInsets.only(left: 16, top: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "服用履歴",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: FontFamily.japanese,
                    fontSize: 20,
                    color: TextColor.main,
                  ),
                ),
                SizedBox(width: 8),
                PremiumBadge(),
              ],
            ),
            SizedBox(height: 16),
            Text(
              "28日連続服用記録中👏",
              style: TextStyle(
                color: TextColor.main,
                fontFamily: FontFamily.japanese,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 16),
            PillSheetModifiedHisotiryListHeader(),
            SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: _list(state),
            ),
            if (state.moreButtonIsShown)
              PillSheetModifiedHistoryMoreButton(state: state),
          ],
        ),
      ),
    );
  }

  Widget _list(CalendarPillSheetModifiedHistoryCardState state) {
    if (state.isPremium || state.isTrial) {
      return CalendarPillSheetModifiedHistoryList(
        padding: null,
        scrollPhysics: NeverScrollableScrollPhysics(),
        pillSheetModifiedHistories: state.pillSheetModifiedHistories,
      );
    } else {
      return Container(
        height: 135,
        child: Stack(
          children: [
            CalendarPillSheetModifiedHistoryList(
              padding: const EdgeInsets.only(left: 8, right: 8),
              scrollPhysics: NeverScrollableScrollPhysics(),
              pillSheetModifiedHistories: List.generate(
                3,
                (index) => PillSheetModifiedHistory(
                  id: "1",
                  actionType: "takenPill",
                  userID: "1",
                  value: PillSheetModifiedHistoryValue(
                    takenPill: TakenPillValue(
                        afterLastTakenDate: DateTime.now(),
                        afterLastTakenPillNumber: 10,
                        beforeLastTakenDate: DateTime.now(),
                        beforeLastTakenPillNumber: 9),
                  ),
                  after: PillSheet.create(PillSheetType.pillsheet_21),
                  estimatedEventCausingDate: DateTime.now(),
                ),
              ),
            ),
            Container(
              height: 135,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.black.withOpacity(0),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
