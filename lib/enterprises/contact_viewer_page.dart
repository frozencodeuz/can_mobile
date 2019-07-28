import 'dart:io';

import 'client_viewer_page.dart';
import 'package:flutter/material.dart';

import 'client.dart';

class ContactViewerPage extends StatefulWidget {
  Contact contact;
  ClientViewerState parent;
  ContactViewerPage(this.contact, this.parent);
  @override
  _ContactViewerState createState() => _ContactViewerState(contact, parent);
}

class _ContactViewerState extends State<ContactViewerPage> {
  Contact contact;
  ClientViewerState parent;
  _ContactViewerState(this.contact, this.parent);
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contact.name),
        actions: <Widget>[
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
      body: Column(
        children: <Widget>[
          field("姓名", contact.name, Icons.contacts, 0),
          field("职位", contact.level, Icons.perm_identity, 1),
          field("电话", contact.phone, Platform.isAndroid?Icons.phone_android:Icons.phone_iphone, 2),
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
                  contact.name = map[0].text;
                  contact.level = map[1].text;
                  contact.phone = map[2].text;
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
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}