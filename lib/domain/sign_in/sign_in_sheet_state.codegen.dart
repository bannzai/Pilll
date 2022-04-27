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

  bool get isLoginMode {
    switch (context) {
      case SignInSheetStateContext.initialSetting:
        return true;
      case SignInSheetStateContext.recordPage:
        return false;
      case SignInSheetStateContext.premium:
        return false;
      case SignInSheetStateContext.setting:
        return false;
    }
  }

  String get title {
    switch (context) {
      case SignInSheetStateContext.initialSetting:
        return "ログイン";
      case SignInSheetStateContext.recordPage:
        return "アカウント登録";
      case SignInSheetStateContext.premium:
        return "プレミアム登録の前に…";
      case SignInSheetStateContext.setting:
        return "アカウント登録";
    }
  }

  String get message {
    switch (context) {
      case SignInSheetStateContext.initialSetting:
        return "Pilllにまだログインしたことが無い場合は新しくアカウントが作成されます";
      case SignInSheetStateContext.recordPage:
        return "アカウント登録するとデータの引き継ぎが可能になります";
      case SignInSheetStateContext.premium:
        return "アカウント情報を保持するため、アカウント登録をお願いします";
      case SignInSheetStateContext.setting:
        return "アカウント登録するとデータの引き継ぎが可能になります";
    }
  }

  String get appleButtonText {
    switch (context) {
      case SignInSheetStateContext.initialSetting:
        return LinkAccountType.apple.loginContentName + "でサインイン";
      case SignInSheetStateContext.recordPage:
        return LinkAccountType.apple.loginContentName + "で登録";
      case SignInSheetStateContext.premium:
        return LinkAccountType.apple.loginContentName + "で登録";
      case SignInSheetStateContext.setting:
        return LinkAccountType.apple.loginContentName + "で登録";
    }
  }

  String get googleButtonText {
    switch (context) {
      case SignInSheetStateContext.initialSetting:
        return LinkAccountType.google.loginContentName + "でサインイン";
      case SignInSheetStateContext.recordPage:
        return LinkAccountType.google.loginContentName + "で登録";
      case SignInSheetStateContext.premium:
        return LinkAccountType.google.loginContentName + "で登録";
      case SignInSheetStateContext.setting:
        return LinkAccountType.google.loginContentName + "で登録";
    }
  }
}
