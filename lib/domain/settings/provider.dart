import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:pilll/native/health_care.dart';
import 'package:riverpod/riverpod.dart';

final isHealthDataAvailableProvider = FutureProvider((ref) => isHealthDataAvailable());
final deviceTimezoneNameProvider = FutureProvider((ref) => FlutterNativeTimezone.getLocalTimezone());
