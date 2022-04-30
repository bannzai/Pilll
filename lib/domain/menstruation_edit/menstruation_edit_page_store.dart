import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/domain/menstruation_edit/menstruation_edit_page_async_action.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/domain/menstruation_edit/menstruation_edit_page_state.codegen.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/util/datetime/day.dart';

final menstruationEditProvider = StateNotifierProvider.family.autoDispose<
    MenstruationEditPageStore, MenstruationEditPageState, Menstruation?>(
  (ref, menstruation) => MenstruationEditPageStore(
      asyncAction: ref.watch(menstruationEditPageAsyncActionProvider),
      initialState: ref.watch(menstruationEditPageStateProvider(menstruation))),
);

class MenstruationEditPageStore
    extends StateNotifier<MenstruationEditPageState> {
  final MenstruationEditPageAsyncAction asyncAction;
  final MenstruationEditPageState initialState;

  MenstruationEditPageStore({
    required this.asyncAction,
    required this.initialState,
  }) : super(initialState);

  Menstruation? get initialMenstruation => initialState.menstruation;
  bool shouldShowDiscardDialog() =>
      state.menstruation == null && initialMenstruation != null;
  bool isDismissWhenSaveButtonPressed() =>
      !shouldShowDiscardDialog() && state.menstruation == null;

  void tappedDate(DateTime date, Setting setting) async {
    final menstruation = state.menstruation;
    if (date.isAfter(today()) && menstruation == null) {
      state = state.copyWith(invalidMessage: "未来の日付は選択できません");
      return;
    }
    state = state.copyWith(invalidMessage: null);

    if (menstruation == null) {
      final begin = date;
      final end =
          date.add(Duration(days: max(setting.durationMenstruation - 1, 0)));
      late final Menstruation menstruation;
      final initialMenstruation = this.initialMenstruation;
      if (initialMenstruation != null) {
        menstruation = initialMenstruation.copyWith(
          beginDate: date,
          endDate: end,
        );
      } else {
        menstruation = Menstruation(
          beginDate: begin,
          endDate: end,
          createdAt: now(),
        );
      }
      state = state.copyWith(menstruation: menstruation);
      return;
    }

    if (isSameDay(menstruation.beginDate, date) &&
        isSameDay(menstruation.endDate, date)) {
      state = state.copyWith(menstruation: null);
      return;
    }

    if (date.isBefore(menstruation.beginDate)) {
      state =
          state.copyWith(menstruation: menstruation.copyWith(beginDate: date));
      return;
    }
    if (date.isAfter(menstruation.endDate)) {
      state =
          state.copyWith(menstruation: menstruation.copyWith(endDate: date));
      return;
    }

    if ((isSameDay(menstruation.beginDate, date) ||
            date.isAfter(menstruation.beginDate)) &&
        date.isBefore(menstruation.endDate)) {
      state =
          state.copyWith(menstruation: menstruation.copyWith(endDate: date));
      return;
    }

    if (isSameDay(menstruation.endDate, date)) {
      state = state.copyWith(
          menstruation: menstruation.copyWith(
              endDate: date.subtract(const Duration(days: 1))));
      return;
    }
  }

  void adjustedScrollOffset() {
    state = state.copyWith(isAlreadyAdjsutScrollOffset: true);
  }
}
