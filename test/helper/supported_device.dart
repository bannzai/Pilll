import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

enum SupportedDeviceType { iPhone5SE2nd }

extension SupportedDeviceTypeExtension on SupportedDeviceType {
  // ignore: missing_return
  Size get size {
    switch (this) {
      case SupportedDeviceType.iPhone5SE2nd:
        return const Size(375, 667);
    }
  }

  // ignore: missing_return
  double get devicePixelRatio {
    switch (this) {
      case SupportedDeviceType.iPhone5SE2nd:
        return 2.0;
    }
  }

  double get textScaleFactor {
    /* 
    NOTE: flutter test use test font named Ahem. Ahem is larger font than other application font.
    This is hacking to multiply with value of 0.8 means less than normal(1.0) factor.
    However, this is quick fix. So, it is not correct way that load font when before exec test. 
    But it is enough now. I wait supported to use other font for flutter/flutter.
    Reference: https://stackoverflow.com/questions/62447898/flutter-widget-test-cannot-emulate-different-screen-size-properly/62460566#62460566
    */
    return 0.8;
  }

  Size get physicalSize =>
      Size(size.width * devicePixelRatio, size.height * devicePixelRatio);

  void binding(TestWindow window) {
    window.devicePixelRatioTestValue = devicePixelRatio;
    window.platformDispatcher.textScaleFactorTestValue = textScaleFactor;
    window.physicalSizeTestValue = physicalSize;
  }
}
