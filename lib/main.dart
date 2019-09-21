import 'dart:io';

import 'package:can_mobile/files/files.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'applications/about_can.dart';
import 'applications/android_storage_permission_request_page.dart';
import 'kits/user_cache.dart';
import 'kits/toolkits.dart';
import 'network/connection.dart';
import 'users/register_page.dart';
import 'constraints.dart';
import 'main_page.dart';

var nowUN = "";
var nowPW = "";

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Can",
      home: LoginPage(),
    );
  }
}

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("您的 Can 遇到错误, 需要重新启动"),
        ],
      ),
    );
  };
  runApp(MyApp());
  __loginState.autoLogin();
  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

_LoginState __loginState;

class _LoginState extends State<LoginPage> {
  _LoginState();
  @override
  void initState() {
    super.initState();
    try {
      checkForDirectories();
    } catch (e) {
      if (Platform.isAndroid) {
        push(context, AndroidStoragePermissionRequestPage());
      }
    }
    __loginState = this;
  }
  void autoLogin() async {
    String un;
    String pw;
    try {
      final candir = await openCanFolder();
      final read = File("$candir/can.properties").readAsLinesSync();
      if (read.isNotEmpty) {
        for (final ln in read) {
          final sp = ln.split("=");
          switch (sp[0]) {
            case "username":un=sp[1];break;
            case "password":pw=sp[1];break;
          }
        }
      }
    } catch (e) {
      if (Platform.isAndroid) {
        push(context, AndroidStoragePermissionRequestPage());
      }
    }
    if (un!=null&&pw!=null) {
      microTip(context, "正在登录...");
      final connection = Connection(IP, PORT);
      await connection.init();
      final connection1 = Connection(IP, PORT);
      await connection1.init();
      connection1.callBack = (data) async {
        pushAndRemove(context, MainPage(UserCache(un, pw, connection, connection1)));
      };
      connection.callBack = (data) {
        if (data=="0") {
          connection1.query("sublogin $un $pw");
        } else if (data=="2") {
          tipsDialog(context, "用户名不存在");
        } else if (data=="3") {
          tipsDialog(context, "密码错误");
        } else print(data);
      };
      connection.query("login $un $pw");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/bg1.png"),
          fit: BoxFit.cover,
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: GestureDetector(
            child: Icon(Icons.change_history),
            onTap: () {
              push(context, AboutCanPage());
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: <Widget>[
            getCurrentMenuWidget(context),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 20.0),
              child: Icon(Icons.format_align_center)
            ),
          ],
        ),
        body: Builder(
          builder: (context) {
            return Column(
              children: <Widget>[
                Text("", style: TextStyle(fontSize: 80),),
                Text("Can", style: TextStyle(fontSize: 50),),
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: "用户名",
                  ),
                  onChanged: (text) {
                    nowUN = text;
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: "密码",
                  ),
                  obscureText: true,
                  onChanged: (text) {
                    nowPW = text;
                  },
                ),
                Row(
                  children: <Widget>[
                    FlatButton(
                        child: Text("登录"),
                        textColor: Colors.blue,
                        onPressed: () async {
                          snake("正在登录...", Scaffold.of(context));
                          final connection = Connection(IP, PORT);
                          await connection.init();
                          final connection1 = Connection(IP, PORT);
                          await connection1.init();
                          connection1.callBack = (data) async {
                            pushAndRemove(context, MainPage(UserCache(nowUN, nowPW, connection, connection1)));
                          };
                          connection.callBack = (data) {
                            if (data=="0") {
                              connection1.query("sublogin $nowUN $nowPW");
                            } else if (data=="2") {
                              tipsDialog(context, "用户名不存在");
                            } else if (data=="3") {
                              tipsDialog(context, "密码错误");
                            } else print(data);
                          };
                          connection.query("login $nowUN $nowPW");
                        }
                    ),
                    FlatButton(
                        child: Text("注册"),
                        textColor: Colors.blue,
                        onPressed: () {
                          push(context, RegisterPage());
                        }
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}