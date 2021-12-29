class UserDisplayedError with Exception {
  final String? title;
  final String displayedMessage;
  final String? faqLinkURL;
  UserDisplayedError(this.displayedMessage, {this.title, this.faqLinkURL});

  @override
  String toString() => displayedMessage;
}
