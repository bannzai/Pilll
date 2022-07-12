import 'package:flutter/foundation.dart';

void overrideDebugPrint() {
  debugPrint = printWrapped;
}

void printWrapped(String? _message, {int? wrapWidth}) {
  final message = _message;

  if (kDebugMode) {
    if (message == null) {
      print("null");
    } else {
      final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
      pattern.allMatches(message).forEach((match) => print(match.group(0)));
    }
  }
}
