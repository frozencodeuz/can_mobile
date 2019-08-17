import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as notification;

import 'kits/user_cache.dart';
import 'message/send_page.dart';
import 'message/message.dart';
import 'kits/toolkits.dart';
import 'message/talk_page.dart';
import 'fragments/message_page.dart';
import 'fragments/world_page.dart';
import 'fragments/personal_page.dart';

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
      appBar: AppBar(
        title: Text(appBarTitle),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: (() {
                push(context, SendPage(userCache));
              }),
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
