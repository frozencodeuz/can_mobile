import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'enterprise.dart';
import '../kits/user_cache.dart';
import '../kits/var_depository.dart';

class EnterpriseInfoPage extends StatelessWidget {
  Enterprise enterprise;
  UserCache userCache;
  EnterpriseInfoPage(this.enterprise, this.userCache);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(enterprise.name),
        actions: <Widget>[
          CupertinoButton(
            child: Text("加入", style: TextStyle(color: Colors.white),),
            onPressed: () async {
              userCache.conn.callBack = (bytes) {
                final data = utf8.decode(bytes);
                if (data=="\n") {
                  userCache.conn.callBack = (bytes) {};
                  userCache.conn.query("set joined_enterprises ${enterprise.name}");
                } else {
                  userCache.conn.callBack = (bytes) {};
                  userCache.conn.query("set joined_enterprises $data ${enterprise.name}");
                }
                VarDepository.tipsDialog(context, "您已成功加入该企业", () {
                  Navigator.pop(context);
                });
              };
              userCache.conn.query("get joined_enterprises");
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Text(enterprise.name, style: TextStyle(fontSize: 30)),
          Text("地址: ${enterprise.location}"),
          Text("电话: ${enterprise.phone}"),
          Text("企业管理员: ${enterprise.leader}"),
          enterprise.members==null?Text("该企业暂时没有成员"):Text("企业成员: \n${enterprise.members.replaceAll(" ", "\n")}"),
        ],
      ),
    );
  }
}