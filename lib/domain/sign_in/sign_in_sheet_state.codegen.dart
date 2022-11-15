import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/link_account_type.dart';

part 'sign_in_sheet_state.codegen.freezed.dart';

enum SignInSheetStateContext { initialSetting, recordPage, premium, setting }

@freezed
class SignInSheetState with _$SignInSheetState {
  const SignInSheetState._();
  const factory SignInSheetState({
    @Default(false) bool isLoading,
    required SignInSheetStateContext context,
    Object? exception,
  }) = _SignInSheetState;
}
