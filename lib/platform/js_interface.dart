import 'dart:io';

import 'package:can_mobile/applications/browser_page.dart';
import 'package:can_mobile/kits/toolkits.dart';
import 'package:can_mobile/platform/error_builder.dart';
import 'package:can_mobile/platform/permission_request_dialog.dart';
import 'package:can_mobile/users/other_user_data_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void onJsMessage(String message, WebSocket webSocket, BuildContext context, BrowserPage browserPage) {
  if (message.startsWith("get-")) {
    final src = removePrefix(message, "get-");
    if (src=="username") {
      showDialog(
          context: context,
          builder: (context) {
            return PermissionRequestDialog(
                browserPage.application.name,
                "获取用户名",
                () {
                  webSocket.add("username-${browserPage.userCache.un}");
                },
                () {
                  webSocket.add("username-null");
                },
            );
          }
      );
    }
  } else if (message.startsWith("microTip-")) {
    final src = removePrefix(message, "microTip-");
    microTip(context, src);
  } else if (message.startsWith("navigation-")) {
    final src = removePrefix(message, "navigation-");
    final spl = cleanStringList(src.split("/"));
    try {
      if (spl[0]=="can") {
        if (spl[1]=="users") {
          push(context, OtherUserDataPage(browserPage.userCache, spl[2]));
        }
      }
    } catch (e) {
      buildAnError(context, "错误发生于小程序发送给应用程序的消息:\n$message\n提取后关键信息:\n$src\n错误原因:\n$e");
    }
  } else if (message.startsWith("inputBox-")) {
    final src = removePrefix(message, "inputBox-");
    try {
      showDialog(
        context: context,
        builder: (context) {
          String newText = "";
          return CupertinoAlertDialog(
            title: Text(src),
            content: Material(
              child: TextField(
                onChanged: (text) {
                  newText = text;
                },
              ),
            ),
            actions: <Widget>[
              CupertinoButton(
                child: Text("取消"),
                onPressed: () {
                  webSocket.add("inputBox-null");
                  Navigator.pop(context);
                },
              ),
              CupertinoButton(
                child: Text("好"),
                onPressed: () {
                  webSocket.add("inputBox-$newText");
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
      );
    } catch (e) {
      buildAnError(context, "错误发生于小程序发送给应用程序的消息:\n$message\n提取后关键信息:\n$src\n错误原因:\n$e");
    }
  }
}
