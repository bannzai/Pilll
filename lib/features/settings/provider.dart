import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:pilll/native/health_care.dart';
import 'package:riverpod/riverpod.dart';

final isHealthDataAvailableProvider = FutureProvider((ref) => isHealthDataAvailable());
final deviceTimezoneNameProvider = FutureProvider((ref) async => (await FlutterTimezone.getLocalTimezone()).identifier);
