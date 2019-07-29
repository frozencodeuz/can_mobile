import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as notification;

import 'enterprises/clients_management_page.dart';
import 'enterprises/enterprise_management_page.dart';
import 'kits/user_cache.dart';
import 'message/send_page.dart';
import 'kits/message.dart';
import 'kits/touch_callback.dart';
import 'kits/im_item.dart';
import 'kits/toolkits.dart';
import 'main.dart';
import 'search_page.dart';
import 'users/person_data_page.dart';
import 'message/talk_page.dart';
import 'applications/about_can.dart';

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
  VideoPage videoPage;
  EnterprisePage enterprisePage;
  PersonalPage personalPage;
  @override
  void initState() {
    super.initState();
    messagePage = MessagePage(userCache);
    videoPage = VideoPage(userCache);
    enterprisePage = EnterprisePage(userCache);
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
          GestureDetector(
            onTap: (() {
              push(context, SearchPage(userCache));
            }),
            child: Icon(Icons.search),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: GestureDetector(
              onTap: (() {
                push(context, SendPage(userCache));
              }),
              child: Icon(Icons.chat),
            )
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
            title: Text("视频"),
            icon: Icon(Icons.videocam),
          ),
          BottomNavigationBarItem(
            title: Text("企业"),
            icon: Icon(Icons.business_center),
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
        return videoPage;
      case 2:
        return enterprisePage;
      case 3:
        return personalPage;
    }
  }
  getIndexName() {
    switch(_currentIndex) {
      case 0:
        return "消息";
      case 1:
        return "视频";
      case 2:
        return "企业";
      case 3:
        return "我";
    }
  }
}

class MessagePage extends StatefulWidget {
  UserCache userCache;
  MessagePage(this.userCache);
  @override
  _MessageState createState() => _MessageState(userCache);
}

class _MessageState extends State<MessagePage> {
  UserCache userCache;
  _MessageState(this.userCache);
  List<Widget> msgshowers = List();
  List<VoidCallback> pushToMessagePage = List();
  @override
  initState() {
    super.initState();
    receiveMessages();
  }
  void receiveMessages() async {
    final contacts = List<MessageList>();
    userCache.conn1.callBack = (data) => receiveImpl(data, contacts);
    userCache.conn1.query("get allmsgsaboutme");
  }
  bool allMsg = true;
  void receiveImpl(String data, List<MessageList> contacts) {
    if (data=="[]") {
      Future.delayed(Duration(milliseconds: 500), () {
        try {
          if (allMsg) {
            allMsg = false;
            userCache.conn1.query("get unreceivedmsgsaboutme");
          } else {
            userCache.conn1.query("get unreceivedmsgsaboutme");
          }
        } catch (e) {
        }
      });
      return;
    }
    List<dynamic> parsed;
    try {
      parsed = json.decode(data);
    } catch (e) {
      if (allMsg) {
        userCache.conn1.query("get allmsgsaboutme");
      } else {
        userCache.conn1.query("get unreceivedmsgsaboutme");
      }
      return;
    }
    final messages = List<Message>();
    for (var i in parsed) {
      final Map<String, dynamic> map = i;
      messages.add(Message(
        map['content'],
        map['sender'],
        map['receiver'],
        map['isWithdrew']=="true",
        map['time'],
      ));
    }
    if (!allMsg) {
      for (var msg in messages) {
        if (msg.from==userCache.un) {
          continue;
        }
        var platformChannelSpecifics = notification.NotificationDetails(
            notification.AndroidNotificationDetails(
                userCache.notificationId.toString(), msg.to, msg.content,
                importance: notification.Importance.Max, priority: notification.Priority.High, ticker: "ticker"), notification.IOSNotificationDetails());
        userCache.notification.show(userCache.notificationId, msg.from, msg.content, platformChannelSpecifics, payload: "msg ${msg.from} ${msg.to}");
        userCache.notificationId++;
      }
    }
    var found = false;
    for (var msg in messages) {
      for (var contact in contacts) {
        if ((contact.from==msg.from&&contact.to==msg.to)||(contact.from==msg.to&&contact.to==msg.from)) {
          contact.contents.add(msg.content);
          contact.isWithdrews.add(msg.isWithdrew);
          contact.times.add(msg.time);
          found = true;
          break;
        }
      }
      if (found) {
        found = false;
        continue;
      } else {
        contacts.add(
            MessageList(
                makeListWithFirstElementSet(msg.content),
                msg.from,
                msg.to,
                makeListWithFirstElementSet(msg.isWithdrew),
                makeListWithFirstElementSet(msg.time),
            )
        );
      }
    }
    msgshowers.clear();
    for (var msgl in contacts) {
      msgshowers.add(Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                msgl.from==userCache.un?msgl.to:msgl.from,
                style: TextStyle(
                    fontSize: 30
                ),
              ),
            ],
          ),
          Text(msgl.contents[msgl.contents.length-1]),
          Text(msgl.times[msgl.times.length-1]),
        ],
      ));
      pushToMessagePage.add(() {
        push(context, TalkPage(TalkSettings(msgl.from, msgl.to), userCache));
      });
    }
    if (allMsg) {
      allMsg = false;
    }
    try {
      setState((){});
    } catch (e) {}
    Future.delayed(Duration(milliseconds: 500), () {
      try {
        userCache.conn1.query("get unreceivedmsgsaboutme");
      } catch (e) {
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: msgshowers.length,
        itemBuilder: (context, index) {
          return ListTile(
              leading: Image.asset("images/defaultusericon.png"),
              title: msgshowers[index],
              onTap: pushToMessagePage[index]
          );
        }
    );
  }
}
class VideoPage extends StatelessWidget {
  UserCache userCache;
  VideoPage(this.userCache);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text("Video")
        ],
      ),
    );
  }
}

class EnterprisePage extends StatefulWidget {
  UserCache userCache;
  EnterprisePage(this.userCache);
  @override
  _EnterpriseState createState() => _EnterpriseState(userCache);
}
class _EnterpriseState extends State<EnterprisePage> {
  UserCache userCache;
  _EnterpriseState(this.userCache);
  String nowEnterprise;
  @override
  void initState() {
    super.initState();
    init();
  }
  void init([VoidCallback after = null]) async {
    userCache.conn.callBack = (data) {
      if (data=="") {
        nowEnterprise = null;
      } else {
        nowEnterprise = data.substring(0, data.length-1).split(" ")[0];
      }
      if (after!=null) {
        after();
      }
    };
    userCache.conn.query("get joined_enterprises");
  }
  void showSnakeToAddEnterprise() => snake("您还暂未加入任何企业 您可以在'搜索'中加入企业", Scaffold.of(context), 2);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return GridView.count(
            primary: false,
            crossAxisCount: 3,
            crossAxisSpacing: 10.0,
            padding: const EdgeInsets.all(20.0),
            children: <Widget>[
              GestureDetector(
                child: Column(
                  children: <Widget>[
                    Icon(Icons.refresh),
                    Text("刷新状态")
                  ],
                ),
                onTap: () {
                  init(() {
                    snake("刷新完成", Scaffold.of(context), 2);
                  });
                },
              ),
              GestureDetector(
                child: Column(
                  children: <Widget>[
                    Icon(Icons.info_outline),
                    Text("企业信息"),
                  ],
                ),
                onTap: () {
                  if (nowEnterprise==null) {
                    showSnakeToAddEnterprise();
                  } else {}
                },
              ),
              GestureDetector(
                child: Column(
                  children: <Widget>[
                    Icon(Icons.person_pin_circle),
                    Text("客户管理"),
                  ],
                ),
                onTap: () {
                  if (nowEnterprise==null) {
                    showSnakeToAddEnterprise();
                  } else {
                    push(context, ClientsManagementPage(nowEnterprise, userCache));
                  }
                },
              ),
              GestureDetector(
                child: Column(
                  children: <Widget>[
                    Icon(Icons.book),
                    Text("请假审批"),
                  ],
                ),
                onTap: () {
                  if (nowEnterprise==null) {
                    showSnakeToAddEnterprise();
                  } else {}
                },
              ),
              GestureDetector(
                child: Column(
                  children: <Widget>[
                    Icon(Icons.business_center),
                    Text("加入的企业"),
                  ],
                ),
                onTap: () {
                  push(context, EnterpriseManagementPage(userCache));
                },
              ),
            ],
          );
        },
      )
    );
  }
}

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