

import 'dart:async';

import 'package:pilll/domain/~/ghq/github.com/bannzai/pilll/lib/domain/record/components/add_pill_sheet_group/state.dart';
import 'package:pilll/service/user.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final addPillSheetGroupStateStoreProvider = StateNotifierProvider<AddPillSheetGroupStateStore, AddPillSheetGroupState>(
(ref) => AddPillSheetGroupStateStore(
ref.watch(userServiceProvider),
),
);

class AddPillSheetGroupStateStore extends StateNotifier<AddPillSheetGroupState> {
final UserService _userService;
AddPillSheetGroupStateStore(
this._userService,
) : super(AddPillSheetGroupState()) {
setup();
}

void setup() {
state = state.copyWith(isLoading: true);
Future(() async {
final storage = await SharedPreferences.getInstance();
final user = await _userService.fetch();
this.state = AddPillSheetGroupState(
isPremium: user.isPremium,
isTrial: user.isTrial,
beginTrialDate: user.beginTrialDate,
isLoading: false,
isFirstLoadEnded: true,
);
_subscribe();
});
}

StreamSubscription? _userSubscribeCanceller;
void _subscribe() {
_userSubscribeCanceller?.cancel();
_userSubscribeCanceller = _userService.subscribe().listen((event) {
state = state.copyWith(isPremium: event.isPremium, isTrial: event.isTrial, beginTrialDate: event.beginTrialDate);
});
}

@override
void dispose() {
_userSubscribeCanceller?.cancel();
super.dispose();
}
}