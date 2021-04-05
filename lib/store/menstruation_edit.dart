import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/service/menstruation.dart';
import 'package:pilll/state/menstruation_edit.dart';

final menstruationEditProvider = StateNotifierProvider.family
    .autoDispose<MenstruationEditStore, Menstruation?>((ref, menstruation) =>
        MenstruationEditStore(
            menstruation: menstruation,
            service: ref.watch(menstruationServiceProvider)));

class MenstruationEditStore extends StateNotifier<MenstruationEditState> {
  final Menstruation? menstruation;
  final MenstruationService service;
  late String? menstruationDocumentID;
  bool get isNotExistsDB => menstruationDocumentID == null;
  MenstruationEditStore({
    required this.menstruation,
    required this.service,
  }) : super(MenstruationEditState(menstruation: menstruation)) {
    menstruationDocumentID = state.menstruation?.documentID;
  }

  Future<void> save() {
    final menstruation = this.menstruation;
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
}
