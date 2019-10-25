import 'package:can_mobile/kits/toolkits.dart';
import 'package:flutter/material.dart';

import '../kits/user_cache.dart';

String nowReceiver;
String nowContent;

class SendPage extends StatelessWidget {
  final UserCache userCache;
  final String user;
  SendPage(this.userCache, {this.user = ""}) {
    if (user!="") {
      ctrlr.text = user;
    }
  }
  final ctrlr = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("发送新消息"),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person_pin_circle),
              labelText: "接收者用户名"
            ),
            controller: ctrlr,
            onChanged: (text) {
              nowReceiver = text;
            },
          ),
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.mail),
              labelText: "消息内容"
            ),
            onChanged: (text) {
              nowContent = text.replaceAll(" ", "");
            },
          ),
          FlatButton(
            child: Text("发送"),
            onPressed: () async {
              if (nowReceiver==userCache.un) {
                tipsDialog(context, "不能给自己发送信息");
              } else {
                userCache.conn.query(
                    "send ${nowContent.replaceAll(" ", "")} ${userCache.un} $nowReceiver false ${DateTime.now()} text");
                userCache.conn.callBack = (data) {};
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
    );
  }
}