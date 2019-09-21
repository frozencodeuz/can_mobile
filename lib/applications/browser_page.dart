import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../platform/javascript_channels.dart';

class BrowserPage extends StatelessWidget {
  final String name;
  final String url;
  BrowserPage(this.name, this.url);
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text(name),
        ),
        body: WebView(
          initialUrl: url,
          navigationDelegate: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          onPageFinished: (url) {
          },
          onWebViewCreated: (controller) {
          },
          javascriptChannels: getChannels(context, this),
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}