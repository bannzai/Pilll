import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/link_account_type.dart';

part 'signin_sheet_state.freezed.dart';

enum SigninSheetStateContext { initialSetting, recordPage, premium }

@freezed
class SigninSheetState with _$SigninSheetState {
  const SigninSheetState._();
  const factory SigninSheetState({
    @Default(false) bool isLoading,
    required SigninSheetStateContext context,
    Object? exception,
  }) = _SigninSheetState;

  bool get isLoginMode {
    switch (context) {
      case SigninSheetStateContext.initialSetting:
        return true;
      case SigninSheetStateContext.recordPage:
        return false;
      case SigninSheetStateContext.premium:
        return false;
    }
  }

  String get title {
    switch (context) {
      case SigninSheetStateContext.initialSetting:
        return "ログイン";
      case SigninSheetStateContext.recordPage:
        return "アカウント登録";
      case SigninSheetStateContext.premium:
        return "プレミアム登録の前に…";
    }
  }

  String get message {
    switch (context) {
      case SigninSheetStateContext.initialSetting:
        return "Pilllにまだログインしたことが無い場合は新しくアカウントが作成されます";
      case SigninSheetStateContext.recordPage:
        return "アカウント登録するとデータの引き継ぎが可能になります";
      case SigninSheetStateContext.premium:
        return "アカウント情報を保持するため、アカウント登録をお願いします";
    }
  }

  String get appleButtonText {
    switch (context) {
      case SigninSheetStateContext.initialSetting:
        return LinkAccountType.apple.providerName + "でサインイン";
      case SigninSheetStateContext.recordPage:
        return LinkAccountType.apple.providerName + "で登録";
      case SigninSheetStateContext.premium:
        return LinkAccountType.apple.providerName + "で登録";
    }
  }

  String get googleButtonText {
    switch (context) {
      case SigninSheetStateContext.initialSetting:
        return LinkAccountType.google.providerName + "でサインイン";
      case SigninSheetStateContext.recordPage:
        return LinkAccountType.google.providerName + "で登録";
      case SigninSheetStateContext.premium:
        return LinkAccountType.google.providerName + "で登録";
    }
  }
}
