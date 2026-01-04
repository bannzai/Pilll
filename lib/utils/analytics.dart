import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:timezone/timezone.dart';

final firebaseAnalytics = FirebaseAnalytics.instance;

var analyticsDebugIsEnabled = false;

class Analytics {
  void debug({required String name, Map<String, Object?>? parameters}) async {
    if (analyticsDebugIsEnabled) {
      logEvent(name: name, parameters: parameters);
    }
  }

  void logEvent({required String name, Map<String, Object?>? parameters}) async {
    assert(name.length <= 40, 'firebase analytics log event name limit length up to 40');
    if (kDebugMode) {
      print('[INFO] logEvent name: $name, parameters: $parameters');
    }

    // The dictionary of event parameters. Passing null indicates that the event has no parameters. Parameter names can be up to 40 characters long and must start with an alphabetic character and contain only alphanumeric characters and underscores.
    // Only String, Int, and Double parameter types are supported.
    // String parameter values can be up to 100 characters long for standard Google Analytics properties, and up to 500 characters long for Google Analytics 360 properties.
    // The “firebase_”, “google_”, and “ga_” prefixes are reserved and should not be used for parameter names.
    // ref: https://firebase.google.com/docs/reference/swift/firebaseanalytics/api/reference/Classes/Analytics#logevent_:parameters

    Map<String, Object>? params = parameters != null ? {} : null;
    if (parameters != null) {
      for (final key in parameters.keys) {
        assert(key.length <= 40, 'firebase analytics log event parameter name limit length up to 40');
        assert(!key.startsWith('firebase_'), 'firebase analytics log event parameter name must not start with "firebase_"');
        assert(!key.startsWith('google_'), 'firebase analytics log event parameter name must not start with "google_"');
        assert(!key.startsWith('ga_'), 'firebase analytics log event parameter name must not start with "ga_"');

        final param = parameters[key];
        if (param == null) {
          params?[key] = 'null';
        } else if (param is DateTime) {
          params?[key] = param.toIso8601String();
        } else if (param is TZDateTime) {
          params?[key] = param.toIso8601String();
        } else if (param is bool) {
          params?[key] = param ? 'true' : 'false';
        } else {
          params?[key] = param;
        }
      }
    }
    try {
      await firebaseAnalytics.logEvent(name: name, parameters: params);
    } catch (e) {
      debugPrint('analytics error: $e');
    }
  }

  void logScreenView({required String screenName, String screenClass = 'Flutter'}) async {
    unawaited(firebaseAnalytics.logEvent(name: 'screen_$screenName'));
    return firebaseAnalytics.logScreenView(screenName: screenName, screenClass: screenClass);
  }

  /// Up to 25 user property names are supported.
  // The "firebase_" prefix is reserved and should not be used for
  /// user property names.
  void setUserProperties(String name, value) {
    assert(name.toLowerCase() != 'age');
    assert(name.toLowerCase() != 'gender');
    assert(name.toLowerCase() != 'interest');
    assert(name.length < 25, 'firebase setUserProperties name limit length up to 25');
    assert(!name.startsWith('firebase_'));

    if (kDebugMode) {
      print('[INFO] setUserProperties name: $name, value: $value');
    }
    firebaseAnalytics.setUserProperty(name: name, value: value);
  }
}

Analytics analytics = Analytics();
