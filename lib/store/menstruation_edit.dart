import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/service/menstruation.dart';
import 'package:pilll/state/menstruation_edit.dart';

final menstruationEditProvider = StateNotifierProvider.family
    .autoDispose<MenstruationEditStore, Menstruation>((ref, menstruation) =>
        MenstruationEditStore(
            menstruation: menstruation,
            service: ref.watch(menstruationServiceProvider)));

class MenstruationEditStore extends StateNotifier<MenstruationEditState> {
  final Menstruation menstruation;
  final MenstruationService service;
  MenstruationEditStore({
    required this.menstruation,
    required this.service,
  }) : super(MenstruationEditState()) {
    _reset();
  }

  void _reset() {
    final documentID = menstruation.documentID;
    if (documentID == null) {
      return;
    }
    Future(() async {
      state = state.copyWith(entity: await service.fetch(documentID));
    });
  }
}
