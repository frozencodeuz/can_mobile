import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quartz_doc/quartz_doc.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:device_info/device_info.dart' as device_info;

import '../main_page.dart';
import 'user_cache.dart';

class VarDepository {
  /*
  static showDialogSample(BuildContext context) {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("提示"),
            content: Text("Can目前处于内部测试阶段\n暂时不开放注册"),
            actions: <Widget>[
              CupertinoButton(
                child: Text("好"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }
  */

  static String now() {
    final time = DateTime.now().toString().replaceAll(" ", ";");
    return time.substring(0, time.length-3);
  }/*
  static initConn(String username, String password, BuildContext loginPageContext, Translater translater, [bool isSnake = true]) async {
    if (isSnake) {
      snake("正在登录...", Scaffold.of(loginPageContext));
    }
    final connection = Connection(await Socket.connect(IP, PORT));
    connection.socket.transform(utf8.decoder).listen((data) {
      connection.count++;
      connection.actions[connection.count-1](data);
    });
    connection.actions.add((data) {
      if (data=="0\n") {
        pushAndRemove(loginPageContext, MainPage(UserCache(username, password, connection, translater)));
      } else if (data=="2\n") {
        tipsDialog(loginPageContext, "找不到该用户");
      } else if (data=="3\n") {
        tipsDialog(loginPageContext, "密码错误");
      } else print(data);
    });
    connection.query("login $username $password");
  }*/
  static String makeAListString<E>(List<E> list) {
    StringBuffer sb = StringBuffer("");
    for (var i=0;i<sb.length;i++) {
      sb.write(i);
      if (i!=sb.length-1) {
        sb.write(" ");
      }
    }
    return sb.toString();
  }
  static E run<E> (E e, void Function(E e) action) {
    action(e);
    return e;
  }
  static void runAsync<E> (E e, void Function(E e) action) async {
    action(e);
  }
  static void tipsDialog(BuildContext context, String tip, [VoidCallback onOkClicked = null]) {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("提示"),
            content: Text(tip),
            actions: <Widget>[
              CupertinoButton(
                child: Text("好"),
                onPressed: () {
                  Navigator.pop(context);
                  if (onOkClicked!=null) {
                    onOkClicked();
                  }
                },
              )
            ],
          );
        }
    );
  }
  static List<E> makeListWithFirstElementSet<E>(E firstElement) {
    final list = List<E>();
    list.add(firstElement);
    return list;
  }
  static void snake(String text, ScaffoldState scaffoldState, [int durationSecond = 4]) {
    scaffoldState.showSnackBar(SnackBar(
      content: Text(text),
      duration: Duration(seconds: durationSecond),
    ));
  }
  static pushAndRemove(BuildContext context, Widget widget) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => widget),
        (route) => route == null
    );
  }
  static jumpToMainPage(BuildContext context, UserCache userCache) async {
    VarDepository.pushAndRemove(context, MainPage(userCache));
  }
  static push(BuildContext context, Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (Context) => widget));
  }
  static Future<String> openCanFolder() async {
    if (Platform.isAndroid) {
      return "${(await path_provider.getExternalStorageDirectory()).path}/Android/org.can.can_mobile";
    } else {
      return (await path_provider.getApplicationDocumentsDirectory()).path;
    }
  }
  static Widget getCurrentMenuWidget(BuildContext context) => GestureDetector(
    child: Icon(Icons.all_inclusive),
    onTap: () async {
      final result = await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(500.0, 100.0, 10.0, 0.0),
        items: <PopupMenuItem<int>>[
          PopupMenuItem<int>(
            value: 0,
            child: Row(
              children: <Widget>[
                Icon(Icons.functions),
                Text("服务器源")
              ]
            ),
          ),
          PopupMenuItem<int>(
            value: 1,
            child: Row(
              children: <Widget>[
                Icon(Icons.update),
                Text("检查更新")
              ]
            ),
          ),
          PopupMenuItem<int>(
            value: 2,
            child: Row(
              children: <Widget>[
                Icon(Icons.folder),
                Text("文档工具")
              ]
            ),
          ),
        ],
      );
      if (result==0) {
        VarDepository.tipsDialog(context, "非常抱歉, 您的Can默认由Warpin运营, 无法修改");
      } else if (result==1) {
        VarDepository.tipsDialog(context, "非常抱歉, 暂不支持检查更新");
      } else if (result==2) {
        openCanFolder().then((folder) async {
          if (Platform.isIOS&&(double.parse((await device_info.DeviceInfoPlugin().iosInfo).systemVersion)<11)) {
            VarDepository.push(context, QuartzPage(
              workDirectory: Directory("$folder/documents/"),
              supportFilePicker: false,
            ));
          } else {
            VarDepository.push(context, QuartzPage(
              workDirectory: Directory("$folder/documents/"),
            ));
          }
        });
      }
    },
  );
}