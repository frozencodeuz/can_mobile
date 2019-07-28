import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'client_viewer_page.dart';
import '../kits/user_cache.dart';
import 'client.dart';

class ClientEditPage extends StatefulWidget {
  Client client;
  UserCache userCache;
  ClientViewerState parent;
  ClientEditPage(this.client, this.userCache, this.parent);
  @override
  _ClientEditState createState() => _ClientEditState(client, userCache, parent);
}

class _ClientEditState extends State<ClientEditPage> {
  Client client;
  UserCache userCache;
  ClientViewerState parent;
  _ClientEditState(this.client, this.userCache, this.parent);
  final map = Map<int, TextEditingController>();
  TextField field(String label, String text, IconData iconData, int key) {
    final ctrlr = TextEditingController();
    ctrlr.text = text;
    map[key] = ctrlr;
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(iconData),
      ),
      controller: ctrlr,
    );
  }
  List<Widget> widgets;
  @override
  void initState() {
    super.initState();
    widgets = <Widget>[
      field("名称", client.name, Icons.perm_identity, 0),
      field("位置", client.local ,Icons.place, 1),
      field("联系电话", client.phone, Platform.isAndroid?Icons.phone_android:Icons.phone_iphone, 2),
      field("产品类型", client.type, Icons.merge_type, 3),
      field("规模", client.scale, Icons.linear_scale, 4),
    ];
    int count = 0;
    while (count<client.custom.length) {
      final i = client.custom[count];
      widgets.add(field(i.key, i.value, Icons.build, 5+count));
      count++;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(client.name),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: widgets.length,
              itemBuilder: (context, index) => widgets[index],
            ),
          ),
          Row(
            children: <Widget>[
              FlatButton(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.save),
                    Text("保存"),
                  ],
                ),
                onPressed: () {
                  client.name = map[0].text;
                  client.local = map[1].text;
                  client.phone = map[2].text;
                  client.type = map[3].text;
                  client.scale = map[4].text;
                  List<Custom> custom = List();
                  int count = 0;
                  while (count<client.custom.length) {
                    final i = client.custom[count];
                    custom.add(Custom(
                      key: i.key,
                      value: map[5+count].text
                    ));
                    count++;
                  }
                  client.custom = custom;
                  parent.parent.save();
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app),
                      Text("取消"),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }
              ),
            ],
          ),
        ],
      ),
    );
  }
}