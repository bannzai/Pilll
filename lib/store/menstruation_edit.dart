import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/service/menstruation.dart';
import 'package:pilll/service/setting.dart';
import 'package:pilll/state/menstruation_edit.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

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
      menstruation.beginDate,
      DateTime(
          menstruation.beginDate.year, menstruation.beginDate.month + 1, 1),
    ];
  } else {
    final t = today();
    return [
      t,
      DateTime(t.year, t.month + 1, 1),
    ];
  }
}

class MenstruationEditStore extends StateNotifier<MenstruationEditState> {
  late Menstruation? initialMenstruation;
  final MenstruationService service;
  final SettingService settingService;
  List<Menstruation> allMenstruation = [];
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
      allMenstruation = await service.fetchAll();
    });
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

  bool _containsRangeForExistsMenstruation(Menstruation menstruation) {
    return allMenstruation
        .where((element) =>
            menstruation.id != element.id &&
            (element.dateRange.inRange(menstruation.beginDate) ||
                element.dateRange.inRange(menstruation.endDate)))
        .isNotEmpty;
  }

  _setMenstruationOrInvalidMessage(Menstruation? menstruation) {
    if (menstruation != null &&
        _containsRangeForExistsMenstruation(menstruation)) {
      final begin = DateTimeFormatter.monthAndDay(menstruation.beginDate);
      final end = DateTimeFormatter.monthAndDay(menstruation.endDate);
      state = state.copyWith(invalidMessage: "$begin-$endの期間にすでに生理が記録されています");
      return;
    }

    state = state.copyWith(menstruation: menstruation);
  }

  tappedDate(DateTime date) async {
    final menstruation = state.menstruation;
    state = state.copyWith(invalidMessage: null);
    if (date.isAfter(today()) && menstruation == null) {
      state = state.copyWith(invalidMessage: "未来の日付は選択できません");
      return;
    }

    if (menstruation == null) {
      try {
        final setting = await settingService.fetch();
        final menstruation = Menstruation(
          beginDate: date,
          endDate: date.add(Duration(days: setting.durationMenstruation - 1)),
          isNotYetUserEdited: false,
          createdAt: now(),
        );
        _setMenstruationOrInvalidMessage(menstruation);
        return;
      } catch (error) {
        throw error;
      }
    }

    state = state.copyWith(invalidMessage: null);

    if (isSameDay(menstruation.beginDate, date) &&
        isSameDay(menstruation.endDate, date)) {
      _setMenstruationOrInvalidMessage(null);
      return;
    }

    if (date.isBefore(menstruation.beginDate)) {
      _setMenstruationOrInvalidMessage(menstruation.copyWith(beginDate: date));
      return;
    }
    if (date.isAfter(menstruation.endDate)) {
      _setMenstruationOrInvalidMessage(menstruation.copyWith(endDate: date));
      return;
    }

    if ((isSameDay(menstruation.beginDate, date) ||
            date.isAfter(menstruation.beginDate)) &&
        date.isBefore(menstruation.endDate)) {
      _setMenstruationOrInvalidMessage(menstruation.copyWith(endDate: date));
      return;
    }

    if (isSameDay(menstruation.endDate, date)) {
      _setMenstruationOrInvalidMessage(
          menstruation.copyWith(endDate: date.subtract(Duration(days: 1))));
      return;
    }
  }
}
