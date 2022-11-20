import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';

final errorLogger = ErrorLogger();

class ErrorLogger {
  recordError(
    dynamic exception,
    StackTrace? stack,
  ) {
    unawaited(FirebaseCrashlytics.instance.recordError(exception, stack));
  }

  log(String message) {
    unawaited(FirebaseCrashlytics.instance.log(message));
  }
}
