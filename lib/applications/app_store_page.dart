import 'package:flutter/material.dart';

class AppStorePage extends StatefulWidget {
  @override
  _AppStoreState createState() => _AppStoreState();
}

class _AppStoreState extends State<AppStorePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("App Store"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: "全部", icon: Icon(Icons.all_out),),
              Tab(text: "搜索", icon: Icon(Icons.insert_invitation),),
              Tab(text: "开发者", icon: Icon(Icons.developer_board),),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Text("全部"),
            Text("搜索"),
            Text("开发者"),
          ],
        ),
      ),
    );
  }
}