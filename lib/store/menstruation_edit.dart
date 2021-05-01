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
  List<Menstruation> _allMenstruation = [];
  bool get isExistsDB => initialMenstruation != null;
  MenstruationEditStore({
    Menstruation? menstruation,
    required this.service,
    required this.settingService,
  }) : super(MenstruationEditState(
            menstruation: menstruation,
            displayedDates: displaedDates(menstruation))) {
    initialMenstruation = menstruation;
    _reset();
  }

  void _reset() {
    Future(() async {
      _allMenstruation = await service.fetchAll();
      _allMenstruation = _allMenstruation
          .where((element) => element.id != initialMenstruation?.id)
          .toList();
    });
  }

  bool shouldShowDiscardDialog() {
    return (state.menstruation == null && isExistsDB);
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
    return service.update(
        documentID, initialMenstruation.copyWith(deletedAt: now()));
  }

  Future<Menstruation> save() {
    final menstruation = state.menstruation;
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

  tappedDate(DateTime date) async {
    final menstruation = state.menstruation;
    if (date.isAfter(today()) && menstruation == null) {
      state = state.copyWith(invalidMessage: "未来の日付は選択できません");
      return;
    }
    state = state.copyWith(invalidMessage: null);

    if (menstruation == null) {
      try {
        final setting = await settingService.fetch();
        final begin = date;
        final end = date.add(Duration(days: setting.durationMenstruation - 1));
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
      } catch (error) {
        throw error;
      }
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
