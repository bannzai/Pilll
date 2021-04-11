import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/service/menstruation.dart';
import 'package:pilll/service/setting.dart';
import 'package:pilll/state/menstruation_edit.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/util/datetime/day.dart';

final menstruationEditProvider = StateNotifierProvider.family
    .autoDispose<MenstruationEditStore, Menstruation?>(
  (ref, menstruation) => MenstruationEditStore(
    menstruation: menstruation,
    service: ref.watch(menstruationServiceProvider),
    settingService: ref.watch(settingServiceProvider),
  ),
);

List<DateTime> displaedDates(Menstruation? menstruation) {
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
  final MenstruationService service;
  final SettingService settingService;
  bool get isExistsDB => initialMenstruation != null;
  MenstruationEditStore({
    Menstruation? menstruation,
    required this.service,
    required this.settingService,
  }) : super(MenstruationEditState(
            menstruation: menstruation,
            displayedDates: displaedDates(menstruation))) {
    initialMenstruation = menstruation;
  }

  bool shouldShowDiscardDialog() {
    return (state.menstruation == null && isExistsDB);
  }

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
    return service.update(
        documentID, initialMenstruation.copyWith(deletedAt: now()));
  }

  Future<Menstruation> save() {
    final menstruation =
        state.menstruation?.copyWith(isNotYetUserEdited: false);
    if (menstruation == null) {
      throw FormatException("menstruation is not exists when save");
    }
    final documentID = initialMenstruation?.documentID;
    if (documentID == null) {
      return service.create(menstruation);
    } else {
      return service.update(documentID, menstruation);
    }
  }

  tappedDate(DateTime date) {
    final menstruation = state.menstruation;
    if (menstruation == null) {
      settingService.fetch().then((setting) {
        state = state.copyWith(
          menstruation: Menstruation(
            beginDate: date,
            endDate: date.add(Duration(days: setting.durationMenstruation - 1)),
            isNotYetUserEdited: false,
            createdAt: now(),
          ),
        );
      });
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
}
