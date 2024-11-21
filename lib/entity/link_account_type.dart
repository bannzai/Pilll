import 'package:pilll/features/root/localization/l.dart'; // Lクラスをインポート

enum LinkAccountType { apple, google }

extension LinkAccountTypeExtension on LinkAccountType {
  String get loginContentName {
    switch (this) {
      case LinkAccountType.apple:
        return L.signInWithApple; // Appleを翻訳
      case LinkAccountType.google:
        return L.signInWithGoogle; // Googleを翻訳
    }
  }

  String get providerName {
    switch (this) {
      case LinkAccountType.apple:
        return 'Apple'; // プロバイダー名は翻訳しない
      case LinkAccountType.google:
        return 'Google'; // プロバイダー名は翻訳しない
    }
  }
}
