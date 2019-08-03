import 'package:flutter/material.dart';

import '../kits/toolkits.dart';
import '../kits/im_item.dart';
import '../kits/user_cache.dart';
import '../kits/touch_callback.dart';
import '../users/person_data_page.dart';
import '../applications/about_can.dart';
import '../main.dart';

class PersonalPage extends StatefulWidget {
  UserCache userCache;
  PersonalPage(this.userCache);
  @override
  _PersonalState createState() => _PersonalState(userCache);
}

class _PersonalState extends State<PersonalPage> {
  UserCache userCache;
  _PersonalState(this.userCache);
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            color: Colors.white,
            height: 80.0,
            child: TouchCallBack(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(left: 12.0, right: 15.0),
                    child: Image.asset("images/defaultusericon.png"),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          userCache.un,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Color(0xFF353535),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              onPressed: () {
                push(context, PersonDataPage(userCache));
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            color: Colors.white,
            child: ImItem(
              title: '好友动态',
              icon: Icon(Icons.star),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                ImItem(
                  icon: Icon(Icons.insert_drive_file),
                  title: '我的文件',
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Divider(
                    height: 0.5,
                    color: Color(0xFFd9d9d9),
                  ),
                ),
                ImItem(
                  icon: Icon(Icons.update),
                  title: '检查更新',
                  onPressed: () {
                    userCache.conn.callBack = (data) {
                      tipsDialog(context, data);
                    };
                    userCache.conn.query("verinfo");
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Divider(
                    height: 0.5,
                    color: Color(0xFFd9d9d9),
                  ),
                ),
                ImItem(
                  icon: Icon(Icons.change_history),
                  title: '关于 Can',
                  onPressed: () {
                    push(context, AboutCanPage());
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Divider(
                    height: 0.5,
                    color: Color(0xFFd9d9d9),
                  ),
                ),
                ImItem(
                  icon: Icon(Icons.exit_to_app),
                  title: '退出登录',
                  onPressed: () {
                    pushAndRemove(context, LoginPage());
                    userCache.conn.query("close");
                    userCache.conn.close();
                    userCache.conn1.query("close");
                    userCache.conn1.close();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}