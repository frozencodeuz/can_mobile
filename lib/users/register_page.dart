import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../kits/var_depository.dart';
import '../network/connection.dart';

String newUN = "";
String newPW = "";
String newPWConf = "";

class RegisterPage extends StatefulWidget {
  RegisterPage();
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  _RegisterState();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("新用户注册"),
      ),
      body: Builder(
          builder: (context) {
            return Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: "用户名"
                  ),
                  onChanged: (text) {
                    newUN = text;
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline),
                    labelText: "密码",
                  ),
                  obscureText: true,
                  onChanged: (text) {
                    newPW = text;
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: "确认密码",
                  ),
                  obscureText: true,
                  onChanged: (text) {
                    newPWConf = text;
                  },
                ),
                FlatButton(onPressed: () {
                  //TODO Register Logic
                  if (newPW!=newPWConf) {
                    VarDepository.snake("两个密码不一致", Scaffold.of(context), 2);
                    return;
                  } else if (newUN=="") {
                    VarDepository.snake("用户名不能为空", Scaffold.of(context), 2);
                    return;
                  } else if (newPW=="") {
                    VarDepository.snake("密码不能为空", Scaffold.of(context), 2);
                    return;
                  } else if (newUN.indexOf(" ")!=-1) {
                    VarDepository.snake("用户名不能包含空格", Scaffold.of(context), 2);
                  } else if (newUN.indexOf("\"")!=-1) {
                    VarDepository.snake("用户名不能包含引号", Scaffold.of(context), 2);
                  } else {
                    register(context);
                  }
                }, child: Text("注册"))
              ],
            );
          }
      )
    );
  }
  void register(BuildContext context) async {
    VarDepository.snake("正在注册...", Scaffold.of(context));
    final connection = Connection(await Socket.connect(IP, PORT));
    connection.socket.listen((bytes) {
      connection.callBack(bytes);
    });
    connection.callBack = (bytes) {
      final data = utf8.decode(bytes);
      if (data=="0\n") {
        VarDepository.tipsDialog(context, "注册完成", () {
          Navigator.pop(context);
        });
      } else if (data=="4\n") {
        VarDepository.tipsDialog(context, "您的用户名已经被使用过");
      }
    };
    connection.query("register $newUN $newPW");
    connection.close();
  }
}