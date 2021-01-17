import 'dart:async';

import 'package:Pilll/service/user.dart';
import 'package:Pilll/state/user.dart';
import 'package:riverpod/riverpod.dart';

final userStoreProvider =
    StateNotifierProvider((ref) => UserStore(ref.watch(userServiceProvider)));

class UserStore extends StateNotifier<UserState> {
  final UserServiceInterface _service;
  UserStore(this._service) : super(UserState()) {
    _reset();
  }

  void _reset() {
    _service
        .fetch()
        .then((entity) => UserState(entity: entity))
        .then((state) => this.state = state)
        .then((_) => _subscribe());
  }

  StreamSubscription canceller;
  void _subscribe() {
    canceller?.cancel();
    canceller = _service.subscribe().listen((event) {
      assert(event != null, "User could not null on subscribe");
      if (event == null) return;
      state = UserState(entity: event);
    });
  }

  @override
  void dispose() {
    canceller?.cancel();
    super.dispose();
  }
}
