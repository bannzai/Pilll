import 'dart:io';
import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/native/menstruation.dart';
import 'package:pilll/service/menstruation.dart';
import 'package:pilll/service/setting.dart';
import 'package:pilll/domain/menstruation_edit/menstruation_edit_state.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/util/datetime/day.dart';

final menstruationEditProvider = StateNotifierProvider.family
    .autoDispose<MenstruationEditStore, MenstruationEditState, Menstruation?>(
  (ref, menstruation) => MenstruationEditStore(
    menstruation: menstruation,
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
    required this.menstruationService,
    required this.settingService,
  }) : super(MenstruationEditState(
            menstruation: menstruation,
            displayedDates: displayedDates(menstruation))) {
    initialMenstruation = menstruation;
  }

  bool shouldShowDiscardDialog() {
    return (state.menstruation == null && initialMenstruation != null);
  }

  bool isDismissWhenSaveButtonPressed() =>
      !shouldShowDiscardDialog() && state.menstruation == null;

  Future<void> delete() async {
    var menstruation = this.initialMenstruation;
    if (menstruation == null) {
      throw FormatException("menstruation is not exists from db when delete");
    }
    final documentID = menstruation.documentID;
    if (documentID == null) {
      throw FormatException(
          "menstruation is not exists document id from db when delete");
    }
    if (state.menstruation != null) {
      throw FormatException(
          "missing condition about state.menstruation is exists when delete. state.menstruation should flushed on edit page");
    }

    if (Platform.isIOS) {
      if (await isHealthDataAvailable()) {
        await deleteMenstruationFlowHealthKitData(menstruation);
        menstruation = menstruation.copyWith(healthKitSampleDataUUID: null);
      }
    }

    await menstruationService.update(
        documentID, menstruation.copyWith(deletedAt: now()));
  }

  Future<Menstruation> save() async {
    var menstruation = state.menstruation;
    if (menstruation == null) {
      throw FormatException("menstruation is not exists when save");
    }
    final documentID = initialMenstruation?.documentID;
    if (documentID == null) {
      if (Platform.isIOS) {
        if (await isHealthDataAvailable()) {
          final healthKitSampleDataUUID =
              await addMenstruationFlowHealthKitData(menstruation);
          menstruation = menstruation.copyWith(
              healthKitSampleDataUUID: healthKitSampleDataUUID);
        }
      }

      return menstruationService.create(menstruation);
    } else {
      if (Platform.isIOS) {
        if (await isHealthDataAvailable()) {
          final healthKitSampleDataUUID =
              await updateOrAddMenstruationFlowHealthKitData(menstruation);
          menstruation = menstruation.copyWith(
              healthKitSampleDataUUID: healthKitSampleDataUUID);
        }
      }
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
