import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/domain/menstruation/menstruation_state.dart';
import 'package:pilll/domain/menstruation_edit/menstruation_edit_state_parameter.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/service/menstruation.dart';
import 'package:pilll/service/setting.dart';
import 'package:pilll/domain/menstruation_edit/menstruation_edit_state.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/util/datetime/day.dart';

final menstruationEditProvider = StateNotifierProvider.family.autoDispose<
    MenstruationEditStore,
    MenstruationEditState,
    MenstruationEditStateParameter>(
  (ref, parameter) => MenstruationEditStore(
    menstruation: parameter.menstruation,
    setting: parameter.setting,
    menstruationService: ref.watch(menstruationServiceProvider),
    settingService: ref.watch(settingServiceProvider),
  ),
);

List<DateTime> displayedDates(Menstruation? menstruation) {
  if (menstruation != null) {
    return [
      DateTime(
          menstruation.beginDate.year, menstruation.beginDate.month - 1, 1),
      menstruation.beginDate,
      DateTime(
          menstruation.beginDate.year, menstruation.beginDate.month + 1, 1),
    ];
  } else {
    final t = today();
    return [
      DateTime(t.year, t.month - 1, 1),
      t,
      DateTime(t.year, t.month + 1, 1),
    ];
  }
}

class MenstruationEditStore extends StateNotifier<MenstruationEditState> {
  late Menstruation? initialMenstruation;
  final MenstruationService menstruationService;
  final SettingService settingService;

  MenstruationEditStore({
    Menstruation? menstruation,
    required Setting? setting,
    required this.menstruationService,
    required this.settingService,
  }) : super(
          MenstruationEditState(
            menstruation: menstruation,
            setting: setting,
            displayedDates: displayedDates(menstruation),
          ),
        ) {
    initialMenstruation = menstruation;
  }

  bool shouldShowDiscardDialog() {
    return (state.menstruation == null && initialMenstruation != null);
  }

  bool isDismissWhenSaveButtonPressed() =>
      !shouldShowDiscardDialog() && state.menstruation == null;

  Future<void> delete() {
    final initialMenstruation = this.initialMenstruation;
    if (initialMenstruation == null) {
      throw FormatException("menstruation is not exists from db when delete");
    }
    final documentID = initialMenstruation.documentID;
    if (documentID == null) {
      throw FormatException(
          "menstruation is not exists document id from db when delete");
    }
    if (state.menstruation != null) {
      throw FormatException(
          "missing condition about state.menstruation is exists when delete. state.menstruation should flushed on edit page");
    }
    return menstruationService.update(
        documentID, initialMenstruation.copyWith(deletedAt: now()));
  }

  Future<Menstruation> save() async {
    final menstruation = state.menstruation;
    if (menstruation == null) {
      throw FormatException("menstruation is not exists when save");
    }
    final documentID = initialMenstruation?.documentID;
    if (documentID == null) {
      final result = await menstruationService.create(menstruation);
      return result;
    } else {
      return menstruationService.update(documentID, menstruation);
    }
  }

  tappedDate(DateTime date) async {
    final menstruation = state.menstruation;
    if (date.isAfter(today()) && menstruation == null) {
      state = state.copyWith(invalidMessage: "未来の日付は選択できません");
      return;
    }
    state = state.copyWith(invalidMessage: null);

    if (menstruation == null) {
      final Setting setting;
      try {
        setting = await settingService.fetch();
      } catch (error) {
        throw error;
      }

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
          menstruation:
              menstruation.copyWith(endDate: date.subtract(Duration(days: 1))));
      return;
    }
  }

  void adjustedScrollOffset() {
    state = state.copyWith(isAlreadyAdjsutScrollOffset: true);
  }
}
