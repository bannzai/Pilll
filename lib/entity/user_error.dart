class UserDisplayedError implements Exception {
  final String? title;
  final String displayedMessage;
  UserDisplayedError(this.displayedMessage, {this.title});

  @override
  String toString() => displayedMessage;
}
