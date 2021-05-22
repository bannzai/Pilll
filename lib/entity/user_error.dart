class UserDisplayedError extends Error {
  late String _displayedMessage;
  UserDisplayedError(String displayedMessage) {
    this._displayedMessage = displayedMessage;
  }

  @override
  String toString() => _displayedMessage;
}
