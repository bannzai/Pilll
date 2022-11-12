import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:riverpod/riverpod.dart';

import 'components/calendar/month_calendar_state.codegen.dart';

part 'menstruation_edit_page_state.codegen.freezed.dart';

final menstruationEditPageStateProvider = Provider.autoDispose.family((ref, Menstruation? menstruation) {
  final premiumAndTrial = ref.watch(premiumAndTrialProvider).value!;
  final setting = ref.watch(settingProvider).requireValue;
  return MenstruationEditPageState(
    menstruation: menstruation,
    setting: setting,
    displayedDates: _displayedDates(menstruation),
    premiumAndTrial: premiumAndTrial,
  );
});

@freezed
class MenstruationEditPageState with _$MenstruationEditPageState {
  const MenstruationEditPageState._();
  const factory MenstruationEditPageState({
    @Default(false) bool isAlreadyAdjsutScrollOffset,
    required Menstruation? menstruation,
    required Setting setting,
    required List<DateTime> displayedDates,
    required PremiumAndTrial premiumAndTrial,
    String? invalidMessage,
  }) = _MenstruationEditPageState;

  MonthCalendarState monthCalendarStatuses(DateTime dateForMonth) => MonthCalendarState(dateForMonth: dateForMonth, menstruation: menstruation);
}

List<DateTime> _displayedDates(Menstruation? menstruation) {
  if (menstruation != null) {
    return [
      DateTime(menstruation.beginDate.year, menstruation.beginDate.month - 1, 1),
      menstruation.beginDate,
      DateTime(menstruation.beginDate.year, menstruation.beginDate.month + 1, 1),
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
