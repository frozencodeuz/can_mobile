import 'package:flutter/material.dart';

import '../kits/user_cache.dart';
import '../kits/var_depository.dart';

String nowReceiver;
String nowContent;

class SendPage extends StatelessWidget {
  UserCache userCache;
  SendPage(this.userCache);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("发送陌生消息"),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person_pin_circle),
              labelText: "接收者用户名"
            ),
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
              userCache.conn.query(
              "send ${nowContent.replaceAll(" ", "")} ${userCache.un} $nowReceiver false ${VarDepository.now()} text");
              userCache.conn.callBack = (bytes) {};
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}