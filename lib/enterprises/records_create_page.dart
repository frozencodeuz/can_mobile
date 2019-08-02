import 'dart:io';

import 'package:can_mobile/kits/toolkits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'client_viewer_page.dart';
import 'client.dart';
import '../kits/user_cache.dart';

class RecordsCreatePage extends StatefulWidget {
  UserCache userCache;
  ClientViewerState parent;
  RecordsCreatePage(this.userCache, this.parent);
  @override
  _RecordsCreateState createState() => _RecordsCreateState(userCache, parent);
}

class _RecordsCreateState extends State<RecordsCreatePage> {
  UserCache userCache;
  ClientViewerState parent;
  _RecordsCreateState(this.userCache, this.parent);
  final map = Map<int, String>();
  TextField field(String label, IconData iconData, int key, [bool cross = false]) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(iconData),
      ),
      maxLines: cross?5:null,
      onChanged: (text) {
        map[key] = text;
      },
    );
  }
  final now = DateTime.now().toString();
  final contactItems = List<DropdownMenuItem>();
  final recordStates = <DropdownMenuItem>[
    DropdownMenuItem(value: "初次拜访", child: Text("初次拜访"),),
    DropdownMenuItem(value: "二次拜访", child: Text("二次拜访"),),
    DropdownMenuItem(value: "三次拜访", child: Text("三次拜访"),),
  ];
  final recordMethods = <DropdownMenuItem>[
    DropdownMenuItem(value: "电话", child: Text("电话"),),
    DropdownMenuItem(value: "微信", child: Text("微信"),),
    DropdownMenuItem(value: "邮件", child: Text("邮件"),),
  ];
  @override
  void initState() {
    super.initState();
    final contacts = parent.client.contacts;
    if (contacts.isEmpty) {
      contactItems.add(DropdownMenuItem(value: null, child: Text("还没有联系人,请返回创建一个"),));
    }
    for (final i in contacts) {
      contactItems.add(DropdownMenuItem(value: i.name, child: Text(i.name),));
    }
    map[1] = now;
    map[2] = contactItems[0].value;
    map[3] = recordStates[0].value;
    map[4] = recordMethods[0].value;
    map[5] = now;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("写跟进")
      ),
      body: Column(
        children: <Widget>[
          field("内容", Icons.content_paste, 0, true),
          ListTile(
            title: Text(map[1]!=null?map[1]:"请选择时间"),
            subtitle: Text("时间"),
            onTap: () {
              DatePicker.showDateTimePicker(
                context,
                showTitleActions: true,
                currentTime: DateTime.now(),
                locale: LocaleType.zh,
                onConfirm: (DateTime time) {
                  setState(() {
                    map[1] = time.toString();
                  });
                },
              );
            },
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 15),
              ),
              Text("联系人"),
              Padding(
                padding: EdgeInsets.only(right: 15),
              ),
              DropdownButton(
                value: map[2],
                items: contactItems,
                onChanged: (value) {
                  setState(() {
                    map[2] = value;
                  });
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 15),
              ),
              Text("状态"),
              Padding(
                padding: EdgeInsets.only(right: 15),
              ),
              DropdownButton(
                value: map[3],
                items: recordStates,
                onChanged: (value) {
                  setState(() {
                    map[3] = value;
                  });
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 15),
              ),
              Text("跟进方式"),
              Padding(
                padding: EdgeInsets.only(right: 15),
              ),
              DropdownButton(
                value: map[4],
                items: recordMethods,
                onChanged: (value) {
                  setState(() {
                    map[4] = value;
                  });
                },
              ),
            ],
          ),
          ListTile(
            title: Text(map[5]),
            subtitle: Text("下次拜访时间"),
            onTap: () {
              DatePicker.showDateTimePicker(
                context,
                showTitleActions: true,
                currentTime: DateTime.now(),
                locale: LocaleType.zh,
                onConfirm: (DateTime time) {
                  setState(() {
                    map[5] = time.toString();
                  });
                },
              );
            },
          ),
          Row(
            children: <Widget>[
              FlatButton(
                  child: Text("创建"),
                  onPressed: () {
                    if (map[2]==null) {
                      tipsDialog(context, "您还没有联系人, 请返回创建一个");
                    } else {
                      parent.client.records.insert(0, Record(
                        content: map[0],
                        time: map[1],
                        contact: map[2],
                        state: map[3],
                        method: map[4],
                        nextTime: map[5],
                      ));
                      parent.parent.save();
                      Navigator.pop(context);
                    }
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