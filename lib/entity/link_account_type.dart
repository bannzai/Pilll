enum LinkAccountType { apple, google }

extension LinkAccountTypeExtension on LinkAccountType {
  String get providerName {
    switch (this) {
      case LinkAccountType.apple:
        return "Apple";
      case LinkAccountType.google:
        return "Google アカウント";
    }
  }
}
