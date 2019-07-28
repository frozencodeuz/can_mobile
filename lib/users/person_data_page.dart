import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../kits/user_cache.dart';

class PersonDataPage extends StatefulWidget {
  UserCache userCache;
  PersonDataPage(this.userCache);
  @override
  _PersonDataState createState() => _PersonDataState(userCache);
}

class _PersonDataState extends State<PersonDataPage> {
  UserCache userCache;
  _PersonDataState(this.userCache);
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("个人资料"),
      ),
      body: Builder(
        builder: (context) {
          return Text("暂未开放");
        },
      ),
    );
  }
}