import 'package:can_mobile/applications/browser_page.dart';
import 'package:can_mobile/kits/toolkits.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

Set<JavascriptChannel> getChannels(BuildContext context, BrowserPage browserPage) => <JavascriptChannel>[
  JavascriptChannel(
    name: "microtip",
    onMessageReceived: (JavascriptMessage message) {
      microTip(context, message.message);
    }
  ),
  JavascriptChannel(
      name: "snack",
      onMessageReceived: (JavascriptMessage message) {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text(message.message),));
      }
  ),
  JavascriptChannel(
      name: "makedialog",
      onMessageReceived: (JavascriptMessage message) {
      }
  ),
  JavascriptChannel(
    name: "socket",
    onMessageReceived: (JavascriptMessage message) {
    }
  ),
  JavascriptChannel(
    name: "sandbox",
    onMessageReceived: (JavascriptMessage message) {
    }
  ),
].toSet();