import 'dart:io';

String get storeName {
  return Platform.isIOS ? "App Store" : "Google Play";
}

String get accountName {
  return Platform.isIOS ? "Apple ID" : "Google アカウント";
}

String get storeURL {
  return Platform.isIOS
      ? "https://apps.apple.com/jp/app/id1405931017"
      : "https://play.google.com/store/apps/details?id=com.mizuki.Ohashi.Pilll";
}
