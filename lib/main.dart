import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'applications/about_can.dart';
import 'applications/android_storage_permission_request_page.dart';
import 'kits/user_cache.dart';
import 'kits/var_depository.dart';
import 'network/connection.dart';
import 'users/register_page.dart';

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
  ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) {
    //print(flutterErrorDetails.toString());
    return Center(
      child: Text("您的 Can 遇到错误, 需要重新启动"),
    );
  };
  runApp(MyApp());
  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  _LoginState();
  @override
  void initState() {
    super.initState();
    createFiles();
  }
  void createFiles() async {
    try {
      final candir = await VarDepository.openCanFolder();
      final cache = Directory("$candir/cache");
      final properties = File("$candir/properties.can");
      if (!cache.existsSync()) {
        cache.createSync(recursive: true);
      }
      if (!properties.existsSync()) {
        properties.createSync(recursive: true);
      }
    } catch (e) {
      VarDepository.push(context, AndroidStoragePermissionRequestPage());
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
              VarDepository.push(context, AboutCanPage());
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: <Widget>[
            VarDepository.getCurrentMenuWidget(context),
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
                          VarDepository.snake("正在登录...", Scaffold.of(context));
                          final connection = Connection(await Socket.connect(IP, PORT));
                          connection.socket.listen((bytes) {
                            connection.callBack(bytes);
                          });
                          final connection1 = Connection(await Socket.connect(IP, PORT));
                          connection1.socket.listen((bytes) {
                            connection1.callBack(bytes);
                          });
                          connection1.callBack = (bytes) {
                            VarDepository.jumpToMainPage(context, UserCache(nowUN, nowPW, connection, connection1));
                          };
                          connection.callBack = (bytes) {
                            final data = utf8.decode(bytes);
                            if (data=="0\n") {
                              connection1.query("sublogin $nowUN $nowPW");
                            } else if (data=="2\n") {
                              VarDepository.tipsDialog(context, "用户名不存在");
                            } else if (data=="3\n") {
                              VarDepository.tipsDialog(context, "密码错误");
                            } else print(data);
                          };
                          connection.query("login $nowUN $nowPW");
                        }
                    ),
                    FlatButton(
                        child: Text("注册"),
                        textColor: Colors.blue,
                        onPressed: () {
                          VarDepository.push(context, RegisterPage());
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