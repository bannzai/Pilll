import 'package:pilll/domain/demography/demography_page_state.dart';
import 'package:pilll/entity/demographic.dart';
import 'package:pilll/service/user.dart';
import 'package:riverpod/riverpod.dart';

final demographyPageStoreProvider = StateNotifierProvider(
    (ref) => DemographyPageStore(ref.watch(userServiceProvider)));

class DemographyPageStore extends StateNotifier<DemographyPageState> {
  final UserService _userService;
  DemographyPageStore(
    this._userService,
  ) : super(DemographyPageState(purpose2: DemographyPageDataSource.unknown));

  setPurpose1(String value) {
    state = state.copyWith(purpose1: value);
  }

  setPurpose2(String value) {
    state = state.copyWith(purpose2: value);
  }

  setPrescription(String value) {
    state = state.copyWith(prescription: value);
  }

  setBirthYear(String value) {
    state = state.copyWith(birthYear: value);
  }

  setJob(String value) {
    state = state.copyWith(job: value);
  }

  register(Demographic demographic) async {
    return _userService.postDemographic(demographic);
  }
}
