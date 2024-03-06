import 'package:pilll/native/health_care.dart';
import 'package:riverpod/riverpod.dart';

final isHealthDataAvailableProvider = FutureProvider((ref) => isHealthDataAvailable());
