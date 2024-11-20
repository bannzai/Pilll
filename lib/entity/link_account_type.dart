import 'package:pilll/features/root/localization/l.dart';  // Lクラスをインポート

enum LinkAccountType { apple, google }

extension LinkAccountTypeExtension on LinkAccountType {
  String get loginContentName {
    switch (this) {
      case LinkAccountType.apple:
        return L.appleLogin;
      case LinkAccountType.google:
        return L.googleLogin;
    }
  }

  String get providerName {
    switch (this) {
      case LinkAccountType.apple:
        return L.appleProvider;
      case LinkAccountType.google:
        return L.googleProvider;
    }
  }
}
