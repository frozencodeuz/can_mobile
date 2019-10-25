import 'dart:io';

import 'package:can_mobile/applications/application.dart';
import 'package:can_mobile/kits/user_cache.dart';
import 'package:can_mobile/platform/js_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrowserPage extends StatefulWidget {
  final Application application;
  final UserCache userCache;
  BrowserPage(this.application, this.userCache);
  @override
  _BrowserPageState createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  HttpServer httpServer;
  @override
  void initState() {
    super.initState();
    initWebSocketServer();
  }
  void initWebSocketServer() async {
    HttpServer.bind(InternetAddress.loopbackIPv4, 8190).then((server) {
      httpServer = server;
      server.listen((request) {
        WebSocketTransformer.upgrade(request).then((socket) {
          socket.listen((data) {
            onJsMessage(data, socket, context, widget);
          });
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.application.name),
        actions: <Widget>[
          Padding(
            child: Icon(Icons.assignment),
            padding: EdgeInsets.only(right: 20),
          ),
          Padding(
            child: Icon(Icons.blur_circular),
            padding: EdgeInsets.only(right: 20),
          ),
        ],
      ),
      body: WebView(
        initialUrl: widget.application.url+"?port=8190",
        navigationDelegate: (NavigationRequest request) {
          return NavigationDecision.navigate;
        },
        onPageFinished: (url) {
        },
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
  @override
  void dispose() {
    if (httpServer!=null) {
      httpServer.close();
    }
    super.dispose();
  }
}