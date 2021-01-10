import 'package:flutter/foundation.dart';

class UserDisplayedError extends Error {
  final String displayedMessage;
  UserDisplayedError({@required this.displayedMessage});

  @override
  String toString() => displayedMessage;
}
