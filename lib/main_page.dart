import 'dart:io';

import 'package:can_mobile/applications/applications_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as notification;

import 'applications/about_can.dart';
import 'kits/user_cache.dart';
import 'main.dart';
import 'message/send_page.dart';
import 'message/message.dart';
import 'kits/toolkits.dart';
import 'message/talk_page.dart';
import 'fragments/message_page.dart';
import 'fragments/world_page.dart';
import 'fragments/personal_page.dart';
import 'widget/im_item.dart';

class MainPage extends StatefulWidget {
  UserCache userCache;
  MainPage(this.userCache);
  @override
  _MainPageState createState() => _MainPageState(userCache);
}

class _MainPageState extends State<MainPage> {
  UserCache userCache;
  _MainPageState(this.userCache);
  var _currentIndex = 0;
  var appBarTitle = "消息";
  MessagePage messagePage;
  WorldPage worldPage;
  PersonalPage personalPage;
  @override
  void initState() {
    super.initState();
    messagePage = MessagePage(userCache);
    worldPage = WorldPage(userCache);
    personalPage = PersonalPage(userCache);
    openCanFolder().then((f) {
      File("$f/can.properties").writeAsStringSync("username=${userCache.un}\npassword=${userCache.pw}");
    });
    final initializationSettingsAndroid = new notification.AndroidInitializationSettings('app_icon');
    final initializationSettingsIOS = new notification.IOSInitializationSettings();
    final initializationSettings = new notification.InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    userCache.notification.initialize(initializationSettings, onSelectNotification: onSelectNotification);
  }
  Future onSelectNotification(String payload) async {
    print("Notification Clicked! payload: $payload");
    if (payload.startsWith("msg ")) {
      final split = payload.substring(4, payload.length).split(" ");
      push(context, TalkPage(TalkSettings(split[0], split[1]), userCache));
    }
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
              ),
              child: Center(
                child: SizedBox(
                  width: 60.0,
                  height: 80.0,
                  child: Column(
                    children: <Widget>[
                      ClipOval(
                        child: Image.asset("images/defaultusericon.png"),
                      ),
                      Text(userCache.un, style: TextStyle(
                          color: Colors.white,
                          fontSize: 15
                      ),),
                    ],
                  ),
                  /*
                  CircleAvatar(
                    child: Text('R'),
                  )
                  */
                ),
              ),
            ),
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
      appBar: AppBar(
        title: Text(appBarTitle),
        actions: <Widget>[
          GestureDetector(
            child: Icon(Icons.apps),
            onTap: () {
              push(context, ApplicationsPage(userCache));
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: GestureDetector(
              onTap: () {
                push(context, SendPage(userCache));
              },
              child: Icon(Icons.chat),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: ((index) {
          setState(() {
            _currentIndex = index;
            setState(() {
              appBarTitle = getIndexName();
            });
          });
        }),
        items: [
          BottomNavigationBarItem(
            title: Text("消息"),
            icon: Icon(Icons.chat),
          ),
          BottomNavigationBarItem(
            title: Text("世界"),
            icon: Icon(Icons.account_balance),
          ),
          BottomNavigationBarItem(
            title: Text("我"),
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: currentPage()
    );
  }
  currentPage() {
    switch(_currentIndex) {
      case 0:
        return messagePage;
      case 1:
        return worldPage;
      case 2:
        return personalPage;
    }
  }
  getIndexName() {
    switch(_currentIndex) {
      case 0:
        return "消息";
      case 1:
        return "世界";
      case 2:
        return "我";
    }
  }
}
