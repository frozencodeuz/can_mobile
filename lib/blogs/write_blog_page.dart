import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../kits/toolkits.dart';
import '../kits/user_cache.dart';

class WriteBlogPage extends StatelessWidget {
  UserCache userCache;
  String content = "";
  WriteBlogPage(this.userCache);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("新日志"),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: CupertinoButton(
              child: Text("发送", style: TextStyle(
                color: Colors.white
              ),),
              onPressed: () {
                if (content=="") {
                  tipsDialog(context, "内容不能为空哦");
                } else if (content.indexOf("\n")!=-1) {
                  tipsDialog(context, "内容不要有换行哦");
                } else {
                  userCache.conn.callBack = (data) {};
                  userCache.conn.query("blog $content");
                  Navigator.pop(context);
                }
              },
            ),
          )
        ],
      ),
      body: TextField(
        decoration: InputDecoration(
          labelText: "写下你此时的想法吧💡"
        ),
        maxLines: 6,
        onChanged: (text) => content = text,
      ),
    );
  }
}