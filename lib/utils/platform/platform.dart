import 'dart:io';

String get storeName {
  return Platform.isIOS ? "App Store" : "Google Play";
}

String get accountName {
  return Platform.isIOS ? "Apple ID" : "Google アカウント";
}

String get forceUpdateStoreURL {
  return Platform.isIOS
      ? "https://apps.apple.com/app/apple-store/id1405931017?pt=97327896&ct=force_update&mt=8"
      : "https://play.google.com/store/apps/details?id=com.mizuki.Ohashi.Pilll&utm_source=force_update&utm_campaign=force_update&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1";
}
