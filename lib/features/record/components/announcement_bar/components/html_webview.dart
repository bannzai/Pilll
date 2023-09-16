import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HTMLWebView extends StatefulWidget {
  final String html;

  const HTMLWebView({
    Key? key,
    required this.html,
  }) : super(key: key);

  @override
  State<HTMLWebView> createState() => _HTMLWebViewState();
}

class _HTMLWebViewState extends State<HTMLWebView> {
  late WebViewController webViewController;

  @override
  void initState() {
    super.initState();
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(widget.html);
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: webViewController,
    );
  }
}
