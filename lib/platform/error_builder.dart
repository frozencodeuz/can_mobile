import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void buildAnError(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text("错误报告"),
        content: Text(message),
        actions: <Widget>[
          CupertinoButton(
            child: Text("好"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    }
  );
}