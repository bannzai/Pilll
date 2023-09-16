import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppWebViewPage extends StatelessWidget {
  final String title;
  final String url;

  const AppWebViewPage({
    Key? key,
    required this.title,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.black, fontSize: 14)),
        elevation: 2,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: AppWebView(url: url),
    );
  }
}

class AppWebView extends StatefulWidget {
  final String url;

  const AppWebView({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  State<AppWebView> createState() => _AppWebViewState();
}

class _AppWebViewState extends State<AppWebView> {
  late WebViewController webViewController;

  @override
  void initState() {
    super.initState();
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: webViewController,
    );
  }
}

extension WebViewPageRoute on AppWebViewPage {
  static Route<dynamic> route({
    required String title,
    required String url,
  }) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: "WebViewPage"),
      builder: (_) => AppWebViewPage(title: title, url: url),
    );
  }
}
