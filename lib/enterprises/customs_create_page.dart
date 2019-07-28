import 'dart:io';

import 'package:flutter/material.dart';

import 'client_viewer_page.dart';
import 'client.dart';
import '../kits/user_cache.dart';

class CustomsCreatePage extends StatelessWidget {
  UserCache userCache;
  ClientViewerState parent;
  CustomsCreatePage(this.userCache, this.parent);
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
          title: Text("自定义项创建")
      ),
      body: Column(
        children: <Widget>[
          field("名", Icons.text_fields, 0),
          field("值", Icons.perm_identity, 1),
          Row(
            children: <Widget>[
              FlatButton(
                  child: Text("创建"),
                  onPressed: () {
                    parent.client.custom.add(Custom(
                        key: map[0],
                        value: map[1],
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