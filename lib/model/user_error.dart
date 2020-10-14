import 'package:flutter/foundation.dart';

class UserDisplayedError implements Exception {
  final dynamic error;
  final String displayedMessage;
  UserDisplayedError({@required this.error, @required this.displayedMessage});
}
