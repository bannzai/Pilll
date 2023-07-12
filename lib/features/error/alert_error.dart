class AlertError implements Exception {
  final String? title;
  final String displayedMessage;
  final String? faqLinkURL;
  AlertError(this.displayedMessage, {this.title, this.faqLinkURL});

  @override
  String toString() => displayedMessage;
}
