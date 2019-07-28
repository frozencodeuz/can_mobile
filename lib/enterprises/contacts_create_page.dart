import 'dart:io';

import 'package:flutter/material.dart';

import 'client_viewer_page.dart';
import 'client.dart';
import '../kits/user_cache.dart';

class ContactsCreatePage extends StatelessWidget {
  UserCache userCache;
  ClientViewerState parent;
  ContactsCreatePage(this.userCache, this.parent);
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
          title: Text("联系人创建")
      ),
      body: Column(
        children: <Widget>[
          field("名称", Icons.text_fields, 0),
          field("职位", Icons.perm_identity, 1),
          field("电话", Platform.isAndroid?Icons.phone_android:Icons.phone_iphone, 2),
          Row(
            children: <Widget>[
              FlatButton(
                  child: Text("创建"),
                  onPressed: () {
                    parent.client.contacts.add(Contact(
                      name: map[0],
                      level: map[1],
                      phone: map[2]
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