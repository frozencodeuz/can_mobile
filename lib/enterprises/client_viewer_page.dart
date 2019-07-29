import 'dart:io';

import 'package:can_mobile/enterprises/client_edit_page.dart';

import 'clients_management_page.dart';
import 'contact_viewer_page.dart';
import 'contacts_create_page.dart';
import 'client.dart';
import '../kits/user_cache.dart';
import '../kits/toolkits.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../kits/fancy_button.dart';
import 'customs_create_page.dart';

class ClientViewerPage extends StatefulWidget {
  Client client;
  UserCache userCache;
  ClientsManagementState parent;
  ClientViewerPage(this.client, this.userCache, this.parent);
  @override
  ClientViewerState createState() => ClientViewerState(client, userCache, parent);
}

class ClientViewerState extends State<ClientViewerPage> {
  Client client;
  UserCache userCache;
  ClientsManagementState parent;
  ClientViewerState(this.client, this.userCache, this.parent);
  TextEditingController ctrlr = TextEditingController();
  void searchContacts(String text) {
    final clist = List<Contact>();
    client.contacts.forEach((e) {
      if (e.name.indexOf(text)!=-1) {
        clist.add(e);
      }
    });
    push(context, Scaffold(
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
                      Row(
                        children: <Widget>[
                          Icon(Icons.contacts),
                          Text(clist[index].name),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.perm_identity),
                          Text(clist[index].level),
                          Icon(Platform.isAndroid?Icons.phone_android:Icons.phone_iphone),
                          Text(clist[index].phone),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    GestureDetector(
                      child: Icon(Icons.edit),
                      onTap: () {
                        push(context, ContactViewerPage(clist[index], this));
                      },
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
                                      clist.removeAt(index);
                                      parent.save();
                                      setState(() {});
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
              ],
            ),
          );
        },
      ),
    ));
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(client.name),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.dashboard), text: "基础信息",),
              Tab(icon: Icon(Icons.contacts), text: "联系人",),
              Tab(icon: Icon(Icons.fiber_smart_record), text: "跟踪记录",),
            ],
          ),
          actions: <Widget>[
            GestureDetector(
              child: Icon(Icons.edit),
              onTap: () => push(context, ClientEditPage(client, userCache, this)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 20.0),
              child: GestureDetector(
                child: Icon(Icons.refresh),
                onTap: () {
                  setState(() {});
                },
              ),
            ),
          ],
        ),
        floatingActionButton: ButtonBar(
          children: <Widget>[
            FancyButton(
              iconData: Icons.add,
              suffix: Text("创建自定义项"),
              onPressed: () {
                push(context, CustomsCreatePage(userCache, this));
              },
            ),
            FancyButton(
              iconData: Icons.add,
              suffix: Text("创建联系人"),
              onPressed: () {
                push(context, ContactsCreatePage(userCache, this));
              },
            ),
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(children: <Widget>[Padding(padding: EdgeInsets.only(right: 15),), Icon(Icons.place), Text(client.local)],),
                Row(children: <Widget>[Padding(padding: EdgeInsets.only(right: 15),), Icon(Platform.isAndroid?Icons.phone_android:Icons.phone_iphone), Text(client.phone)],),
                Row(children: <Widget>[Padding(padding: EdgeInsets.only(right: 15),), Icon(Icons.merge_type), Text(client.type)],),
                Row(children: <Widget>[Padding(padding: EdgeInsets.only(right: 15),), Icon(Icons.linear_scale), Text(client.scale)],),
                Expanded(
                  child: ListView.builder(
                    itemCount: client.custom.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(client.custom[index].key),
                        subtitle: Text(client.custom[index].value),
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
                                            client.custom.removeAt(index);
                                            parent.save();
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
              ],
            ),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            labelText: "搜索联系人",
                            prefixIcon: Icon(Icons.contact_phone)
                        ),
                        controller: ctrlr,
                        onSubmitted: (text) {
                          searchContacts(text);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 20),
                      child: GestureDetector(
                        child: Icon(Icons.search),
                        onTap: () {
                          searchContacts(ctrlr.text);
                        },
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: client.contacts.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Row(
                          children: <Widget>[
                            Icon(Icons.contacts),
                            Text(client.contacts[index].name),
                          ],
                        ),
                        subtitle: Row(
                          children: <Widget>[
                            Icon(Icons.perm_identity),
                            Text(client.contacts[index].level),
                            Icon(Platform.isAndroid?Icons.phone_android:Icons.phone_iphone),
                            Text(client.contacts[index].phone),
                          ],
                        ),
                        trailing:
                        Column(
                          children: <Widget>[
                            GestureDetector(
                              child: Icon(Icons.edit),
                              onTap: () {
                                push(context, ContactViewerPage(client.contacts[index], this));
                              },
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
                                              client.contacts.removeAt(index);
                                              parent.save();
                                              setState(() {});
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
                      );
                    },
                  ),
                ),
              ],
            ),
            Text("跟踪记录"),
          ],
        ),
      ),
    );
  }
}