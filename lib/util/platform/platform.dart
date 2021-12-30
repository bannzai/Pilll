import 'dart:io';

String get storeName {
  return Platform.isIOS ? "App Store" : "Google Play";
}

String get accountName {
  return Platform.isIOS ? "Apple ID" : "Google アカウント";
}

String get storeURL {
  return Platform.isIOS
      ? "https://apps.apple.com/jp/app/pilll-%E3%83%94%E3%83%AB%E3%83%AA%E3%83%9E%E3%82%A4%E3%83%B3%E3%83%80%E3%83%BC%E3%81%B4%E3%82%8B%E3%82%8B/id1405931017"
      : "https://play.google.com/store/apps/details?id=com.mizuki.Ohashi.Pilll";
}
