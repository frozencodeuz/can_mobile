import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'client_viewer_page.dart';
import 'clients_create_page.dart';
import 'client.dart';
import '../kits/fancy_button.dart';
import '../kits/user_cache.dart';
import '../kits/var_depository.dart';

class ClientsManagementPage extends StatefulWidget {
  String enterprise;
  UserCache userCache;
  ClientsManagementPage(this.enterprise, this.userCache);
  @override
  ClientsManagementState createState() => ClientsManagementState(enterprise, userCache);
}

class ClientsManagementState extends State<ClientsManagementPage> {
  String enterprise;
  UserCache userCache;
  List<Widget> widgets = List();
  List<Client> clients = List();
  ClientsManagementState(this.enterprise, this.userCache);
  @override
  void initState() {
    super.initState();
    init();
  }
  Future<void> init() async {
    userCache.conn.callBack = (bytes) {
      final data = utf8.decode(bytes);
      var parsedJson = json.decode(data);
      clients = List<Client>.from(parsedJson.map((i) => Client.fromJson(i)).toList());
      widgets.clear();
      for (var i in clients) {
        widgets.add(Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Text(i.name),
                  Row(
                    children: <Widget>[
                      Icon(Icons.place),
                      Text(i.local),
                      Icon(Platform.isAndroid?Icons.phone_android:Icons.phone_iphone),
                      Text(i.phone),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.merge_type),
                      Text(i.type),
                      Icon(Icons.linear_scale),
                      Text(i.scale),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              child: Icon(Icons.delete_sweep),
              onTap: () {
                showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("提示"),
                        content: Text("您确定要删除这个客户吗?"),
                        actions: <Widget>[
                          CupertinoButton(
                            child: Text("不了"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          CupertinoButton(
                            child: Text("好"),
                            onPressed: () {
                              clients.remove(i);
                              save();
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    }
                );
              },
            )
          ],
        ));
      }
      try {
        setState(() {});
      } catch (e) {}
      return;
    };
    userCache.conn.query("get enterprise_clients $enterprise");
  }
  Future<void> save() async {
    userCache.conn.callBack = (bytes) {
      return;
    };
    userCache.conn.query("set enterprise_clients $enterprise ${clients2jsonString(clients)}");
  }
  void search(String text) {
    if (text=="") {
      VarDepository.tipsDialog(context, "搜索内容不能为空");
    } else {
      final clist = List<Client>();
      clients.forEach((client) {
        if (client.name.indexOf(text)!=-1) {
          clist.add(client);
        }
      });
      VarDepository.push(context, Scaffold(
        appBar: AppBar(
          title: Text("'$text'的搜索结果"),
        ),
        body: ListView.builder(
          itemCount: clist.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(clist[index].name),
                        Row(
                          children: <Widget>[
                            Icon(Icons.place),
                            Text(clist[index].local),
                            Icon(Platform.isAndroid?Icons.phone_android:Icons.phone_iphone),
                            Text(clist[index].phone),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.merge_type),
                            Text(clist[index].type),
                            Icon(Icons.linear_scale),
                            Text(clist[index].scale),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    child: Icon(Icons.delete_sweep),
                    onTap: () {
                      showDialog<void>(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text("提示"),
                              content: Text("您确定要删除这个客户吗?"),
                              actions: <Widget>[
                                CupertinoButton(
                                  child: Text("不了"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                CupertinoButton(
                                  child: Text("好"),
                                  onPressed: () {
                                    clients.remove(clist[index]);
                                    save();
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          }
                      );
                    },
                  )
                ],
              ),
              onTap: () => VarDepository.push(context, ClientViewerPage(clist[index], userCache, this)),
            );
          },
        ),
      ));
    }
  }
  TextEditingController ctrlr = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 60.0),
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: "搜索客户",
              ),
              controller: ctrlr,
              onSubmitted: (text) {
                search(text);
              },
            ),
          ),
          GestureDetector(
            child: Icon(Icons.search),
            onTap: () {
              search(ctrlr.text);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 20.0),
            child: GestureDetector(
              child: Icon(Icons.refresh),
              onTap: () {
                init();
              },
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widgets.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.business_center),
            title: widgets[index],
            onTap: () => VarDepository.push(context, ClientViewerPage(clients[index], userCache, this)),
          );
        },
      ),
      floatingActionButton: FancyButton(
        suffix: Text("创建客户"),
        iconData: Icons.add,
        onPressed: () {
          VarDepository.push(context, ClientsCreatePage(enterprise, userCache, this));
        },
      ),
    );
  }
}