import 'dart:io';

import 'package:riverpod/riverpod.dart';

final localeNameProvider = Provider.autoDispose((_) => Platform.localeName);
final isJaLocaleProvider = Provider.autoDispose((ref) => Platform.localeName.contains("_JP"));
