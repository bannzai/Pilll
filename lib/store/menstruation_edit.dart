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

class MenstruationEditStore extends StateNotifier<MenstruationEditState> {
  final MenstruationService service;
  final SettingService settingService;
  late String? menstruationDocumentID;
  bool get isNotExistsDB => menstruationDocumentID == null;
  MenstruationEditStore({
    Menstruation? menstruation,
    required this.service,
    required this.settingService,
  }) : super(MenstruationEditState(menstruation: menstruation)) {
    menstruationDocumentID = state.menstruation?.documentID;
  }

  Future<void> save() {
    final menstruation = this.state.menstruation;
    if (menstruation == null) {
      throw FormatException("menstruation is not exists when save");
    }
    final documentID = menstruationDocumentID;
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
