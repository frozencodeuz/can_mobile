import 'dart:io';

import 'package:can_mobile/kits/fancy_button.dart';
import 'package:can_mobile/kits/toolkits.dart';
import 'package:flutter/cupertino.dart';

import 'clients_management_page.dart';
import 'package:flutter/material.dart';

import 'client.dart';
import '../kits/user_cache.dart';

class ClientsCreatePage extends StatefulWidget {
  String enterprise;
  UserCache userCache;
  ClientsManagementState parent;
  ClientsCreatePage(this.enterprise, this.userCache, this.parent);
  @override
  _ClientsCreateState createState() => _ClientsCreateState(enterprise, userCache, parent);
}

class _ClientsCreateState extends State<ClientsCreatePage> {
  String enterprise;
  UserCache userCache;
  ClientsManagementState parent;
  List<Contact> contacts = List();
  List<Custom> customs = List();
  _ClientsCreateState(this.enterprise, this.userCache, this.parent);
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
        title: Text("客户创建"),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              child: Icon(Icons.refresh),
              onTap: () {
                setState(() {});
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          field("名称", Icons.text_fields, 0),
          field("地址", Icons.place, 1),
          field("联系电话", Platform.isAndroid?Icons.phone_android:Icons.phone_iphone, 2),
          field("产品类型", Icons.merge_type, 3),
          field("规模", Icons.linear_scale, 4),
          Row(
            children: <Widget>[
              FlatButton(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.create_new_folder),
                    Text("创建"),
                  ],
                ),
                onPressed: () {
                  parent.clients.add(Client(
                    name: map[0],
                    local: map[1],
                    phone: map[2],
                    type: map[3],
                    scale: map[4],
                    custom: customs,
                    contacts: contacts,
                  ));
                  parent.save();
                  Navigator.pop(context);
                }
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
          Expanded(
            child: ListView.builder(
              itemCount: customs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(customs[index].key),
                  subtitle: Text(customs[index].value),
                  trailing: GestureDetector(
                    child: Icon(Icons.delete_sweep),
                    onTap: () {
                      showDialog<void>(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text("提示"),
                              content: Text("您确定要删除这个自定义项吗?"),
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
                                    setState(() {
                                      customs.removeAt(index);
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          }
                      );
                    },
                  ),
                );
              },
            ),
          ),
          ButtonBar(
            children: <Widget>[
              FancyButton(
                iconData: Icons.build,
                suffix: Text("创建自定义项"),
                onPressed: () => push(context, _CreateCustomSimplePage(customs)),
              ),
              FancyButton(
                iconData: Icons.contacts,
                suffix: Text("创建联系人"),
                onPressed: () => push(context, _CreateContactSimplePage(contacts)),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    children: <Widget>[
                      Icon(Icons.contacts),
                      Text(contacts[index].name),
                    ],
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      Icon(Icons.perm_identity),
                      Text(contacts[index].level),
                      Icon(Platform.isAndroid?Icons.phone_android:Icons.phone_iphone),
                      Text(contacts[index].phone),
                    ],
                  ),
                  trailing: GestureDetector(
                    child: Icon(Icons.delete_sweep),
                    onTap: () {
                      showDialog<void>(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text("提示"),
                              content: Text("您确定要删除这个联系人吗?"),
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
                                    setState(() {
                                      contacts.removeAt(index);
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          }
                      );
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class _CreateContactSimplePage extends StatelessWidget {
  final List<Contact> contacts;
  _CreateContactSimplePage(this.contacts);
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
                    contacts.add(Contact(
                        name: map[0],
                        level: map[1],
                        phone: map[2]
                    ));
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

class _CreateCustomSimplePage extends StatelessWidget {
  final List<Custom> customs;
  _CreateCustomSimplePage(this.customs);
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
          field("值", Icons.translate, 1),
          Row(
            children: <Widget>[
              FlatButton(
                  child: Text("创建"),
                  onPressed: () {
                    customs.add(Custom(
                      key: map[0],
                      value: map[1],
                    ));
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