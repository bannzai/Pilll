import 'package:firebase_auth/firebase_auth.dart';
import 'package:pilll/auth/apple.dart' as apple;
import 'package:pilll/auth/google.dart' as google;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting_account_cooperation_list_page_state.freezed.dart';

@freezed
class SettingAccountCooperationListState
    with _$SettingAccountCooperationListState {
  SettingAccountCooperationListState._();
  const factory SettingAccountCooperationListState({
    required User? user,
    @Default(false) bool isLoading,
    Object? exception,
  }) = _SettingAccountCooperationListState;

  bool get isLinkedApple {
    final user = this.user;
    if (user == null) {
      return false;
    }
    return apple.isLinkedAppleFor(user);
  }

  bool get isLinkedGoogle {
    final user = this.user;
    if (user == null) {
      return false;
    }
    return google.isLinkedGoogleFor(user);
  }

  bool get isLinkedAnyProvider => isLinkedApple || isLinkedGoogle;
}
