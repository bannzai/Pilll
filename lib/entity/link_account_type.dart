enum LinkAccountType { apple, google }

extension LinkAccountTypeExtension on LinkAccountType {
  String get providerName {
    switch (this) {
      case LinkAccountType.apple:
        return "Apple ID";
      case LinkAccountType.google:
        return "Google アカウント";
    }
  }
}
