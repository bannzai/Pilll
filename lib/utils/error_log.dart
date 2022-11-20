import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';

ErrorLogger errorLogger = ErrorLogger();

class ErrorLogger {
  void recordError(
    dynamic exception,
    StackTrace? stack,
  ) {
    unawaited(FirebaseCrashlytics.instance.recordError(exception, stack));
  }

  void log(String message) {
    unawaited(FirebaseCrashlytics.instance.log(message));
  }
}
