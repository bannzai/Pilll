import 'package:firebase_analytics/firebase_analytics.dart';

final firebaseAnalytics = FirebaseAnalytics();

class Analytics {
  Future<void> logEvent(
      {required String name, Map<String, dynamic>? parameters}) async {
    assert(name.length <= 40,
        "firebase analytics log event name limit length up to 40");
    print("[INFO] logEvent name: $name, parameters: $parameters");
    return firebaseAnalytics.logEvent(name: name, parameters: parameters);
  }

  Future<void> setCurrentScreen(
      {required String screenName,
      String screenClassOverride = 'Flutter'}) async {
    firebaseAnalytics.logEvent(name: "screen_$screenName");
    return firebaseAnalytics.setCurrentScreen(
        screenName: screenName, screenClassOverride: screenClassOverride);
  }

  setUserProperties(String name, value) {
    assert(name.toLowerCase() != "age");
    assert(name.toLowerCase() != "gender");
    assert(name.toLowerCase() != "interest");

    print("[INFO] setUserProperties name: $name, value: $value");
    firebaseAnalytics.setUserProperty(name: name, value: value);
  }
}

Analytics analytics = Analytics();
