import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../kits/toolkits.dart';

class AndroidStoragePermissionRequestPage extends StatelessWidget {
  AndroidStoragePermissionRequestPage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("", style: TextStyle(fontSize: 100),),
          Text("您好, 我们需要您给予我们存储权限", style: TextStyle(fontSize: 30),),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(""),
              ),
              FlatButton(
                child: Text("给予"),
                onPressed: () async {
                  Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
                  PermissionStatus status = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
                  if (status == PermissionStatus.granted) {
                    Navigator.pop(context);
                  } else {
                    tipsDialog(context, "好像出了点问题, 请您再来一遍");
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}