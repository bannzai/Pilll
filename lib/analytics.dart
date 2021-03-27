import 'package:firebase_analytics/firebase_analytics.dart';

abstract class AbstractAnalytics {
  Future<void> logEvent(
      {required String name, Map<String, dynamic>? parameters});
  Future<void> setCurrentScreen(
      {required String screenName, String screenClassOverride = 'Flutter'});
}

final firebaseAnalytics = FirebaseAnalytics();

class Analytics extends AbstractAnalytics {
  @override
  Future<void> logEvent(
      {required String name, Map<String, dynamic>? parameters}) async {
    return firebaseAnalytics.logEvent(name: name, parameters: parameters);
  }

  @override
  Future<void> setCurrentScreen(
      {required String screenName,
      String screenClassOverride = 'Flutter'}) async {
    return firebaseAnalytics.setCurrentScreen(
        screenName: screenName, screenClassOverride: screenClassOverride);
  }
}

AbstractAnalytics analytics = Analytics();
