import 'dart:io';

import 'package:flutter/material.dart';

import 'client_viewer_page.dart';
import 'client.dart';
import '../kits/user_cache.dart';

class RecordsCreatePage extends StatelessWidget {
  UserCache userCache;
  ClientViewerState parent;
  RecordsCreatePage(this.userCache, this.parent);
  final map = Map<int, String>();
  TextField field(String label, IconData iconData, int key) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(iconData),
      ),
      onChanged: (text) {
        map[key] = text;
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("写跟进")
      ),
      body: Column(
        children: <Widget>[
          field("内容", Icons.content_paste, 0),
          field("时间", Icons.timer, 1),
          field("方式", Icons.functions, 2),
          field("联系人", Icons.contacts, 3),
          field("状态", Icons.storage, 4),
          field("下次跟进时间", Icons.timeline, 5),
          Row(
            children: <Widget>[
              FlatButton(
                  child: Text("创建"),
                  onPressed: () {
                    parent.client.records.add(Record(
                      content: map[0],
                      time: map[1],
                      method: map[2],
                      contact: map[3],
                      state: map[4],
                      nextTime: map[5],
                    ));
                    parent.parent.save();
                    Navigator.pop(context);
                  }
              ),
              FlatButton(
                  child: Text("取消"),
                  onPressed: () {
                    Navigator.pop(context);
                  }
              ),
            ],
          )
        ],
      ),
    );
  }
}