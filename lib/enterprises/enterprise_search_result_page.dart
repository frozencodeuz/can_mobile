import 'dart:convert';
import 'dart:io';

import 'package:can_mobile/kits/user_cache.dart';
import 'package:can_mobile/kits/toolkits.dart';
import 'package:flutter/material.dart';
import 'enterprise_info_page.dart';
import 'enterprise.dart';

class EnterpriseSearchResultPage extends StatefulWidget {
  UserCache userCache;
  String gen;
  EnterpriseSearchResultPage(this.gen, this.userCache);
  @override
  _EnterpriseSearchResultState createState() => _EnterpriseSearchResultState(gen, userCache);
}

class _EnterpriseSearchResultState extends State<EnterpriseSearchResultPage> {
  UserCache userCache;
  String gen;
  _EnterpriseSearchResultState(this.gen, this.userCache);
  List<Widget> widgets = List();
  List<Enterprise> enterprises = List();
  @override
  void initState() {
    super.initState();
    init();
  }
  void init() async {
    userCache.conn.callBack = (data) {
      List<dynamic> parsed = json.decode(data);
      for (var i in parsed) {
        final Map<String, dynamic> map = i;
        widgets.add(Column(
          children: <Widget>[
            Text(map['name'], style: TextStyle(fontSize: 30),),
            Row(
              children: <Widget>[
                Icon(Icons.place),
                Text(map['local']),
                Icon(Platform.isAndroid?Icons.phone_android:Icons.phone_iphone),
                Text(map['phone']),
              ],
            ),
            Text("企业管理员: ${map['leader']}")
          ],
        ));
        enterprises.add(Enterprise(
            name: map['name'],
            location: map['local'],
            phone: map['phone'],
            leader: map['leader'],
            members: map['members']
        ));
      }
      setState(() {});
    };
    userCache.conn.query("search enterprises $gen");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("'$gen'的搜索结果"),
      ),
      body: ListView.builder(
        itemCount: widgets.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.message),
            title: widgets[index],
            onTap: () {
              push(context, EnterpriseInfoPage(enterprises[index], userCache));
            }
          );
        }
      ),
    );
  }
}