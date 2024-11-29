import 'package:pilll/features/localizations/l.dart';

enum LinkAccountType { apple, google }

extension LinkAccountTypeExtension on LinkAccountType {
  String get loginContentName {
    switch (this) {
      case LinkAccountType.apple:
        return 'Apple';
      case LinkAccountType.google:
        return L.googleAccount;
    }
  }

  String get providerName {
    switch (this) {
      case LinkAccountType.apple:
        return 'Apple';
      case LinkAccountType.google:
        return 'Google';
    }
  }
}
