import 'package:flutter/services.dart';

abstract class AppTextFieldFormatter {
  static final greaterThanZero =
      TextInputFormatter.withFunction((oldValue, newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    try {
      final n = int.parse(newValue.text);
      if (n > 0) {
        return newValue;
      } else {
        return oldValue;
      }
    } catch (_) {
      return oldValue;
    }
  });
}
