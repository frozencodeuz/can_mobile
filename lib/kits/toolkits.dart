import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quartz_doc/quartz_doc.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:device_info/device_info.dart' as device_info;

import '../main_page.dart';
import 'user_cache.dart';

String makeAListString<E>(List<E> list) {
  StringBuffer sb = StringBuffer("");
  for (var i=0;i<sb.length;i++) {
    sb.write(i);
    if (i!=sb.length-1) {
      sb.write(" ");
    }
  }
  return sb.toString();
}
void tipsDialog(BuildContext context, String tip, [VoidCallback onOkClicked = null]) {
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
List<E> makeListWithFirstElementSet<E>(E firstElement) {
  final list = List<E>();
  list.add(firstElement);
  return list;
}
void snake(String text, ScaffoldState scaffoldState, [int durationSecond = 4]) {
  scaffoldState.showSnackBar(SnackBar(
    content: Text(text),
    duration: Duration(seconds: durationSecond),
  ));
}
pushAndRemove(BuildContext context, Widget widget) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
          (route) => route == null
  );
}
push(BuildContext context, Widget widget) {
  Navigator.push(context, MaterialPageRoute(builder: (Context) => widget));
}
Future<String> openCanFolder() async {
  if (Platform.isAndroid) {
    return "${(await path_provider.getExternalStorageDirectory()).path}/Android/org.can.can_mobile";
  } else {
    return (await path_provider.getApplicationDocumentsDirectory()).path;
  }
}
Widget getCurrentMenuWidget(BuildContext context) => GestureDetector(
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
                Icon(Icons.update),
                Text("检查更新")
              ]
          ),
        ),
        PopupMenuItem<int>(
          value: 1,
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
      tipsDialog(context, "非常抱歉, 暂不支持检查更新");
    } else if (result==1) {
      openCanFolder().then((folder) async {
        if (Platform.isIOS&&(double.parse((await device_info.DeviceInfoPlugin().iosInfo).systemVersion)<11)) {
          push(context, QuartzPage(
            workDirectory: Directory("$folder/documents/"),
            supportFilePicker: false,
          ));
        } else {
          push(context, QuartzPage(
            workDirectory: Directory("$folder/documents/"),
          ));
        }
      });
    }
  },
);