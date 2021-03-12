import 'package:flutter/foundation.dart';

class UserDisplayedError extends Error {
  late String _displayedMessage;
  UserDisplayedError({required String displayedMessage}) {
    this._displayedMessage = displayedMessage;
  }

  @override
  String toString() => _displayedMessage;
}
