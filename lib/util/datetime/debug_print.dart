import 'package:flutter/foundation.dart';

void overrideDebugPrint() {
  debugPrint = printWrapped;
}

void printWrapped(String? _message, {int? wrapWidth}) {
  final message = _message;

  if (kDebugMode) {
    if (message == null) {
      debugPrint("null");
    } else {
      final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
      pattern
          .allMatches(message)
          .forEach((match) => debugPrint(match.group(0)));
    }
  }
}
