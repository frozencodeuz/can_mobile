import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../kits/user_cache.dart';
import '../kits/var_depository.dart';

class EnterpriseManagementPage extends StatefulWidget {
  UserCache userCache;
  EnterpriseManagementPage(this.userCache);
  @override
  _EnterpriseManagementState createState() => _EnterpriseManagementState(userCache);
}

class _EnterpriseManagementState extends State<EnterpriseManagementPage> {
  UserCache userCache;
  _EnterpriseManagementState(this.userCache);
  List<Widget> enterprises = List();
  List<VoidCallback> actions = List();
  @override
  void initState() {
    super.initState();
    init();
  }
  void init() async {
    userCache.conn.callBack = (bytes) {
      final data = utf8.decode(bytes);
      if (data=="null\n"||data==" \n") {
        enterprises.add(Text("您还暂未加入任何企业 您可以在'搜索'中加入企业"));
        actions.add(() {});
        try {
          setState(() {});
        } catch (e) {
        }
      } else {
        for (var enterprise in data.split(" ")) {
          enterprises.add(Text(enterprise));
          actions.add(() {
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text(enterprise),
                  content: Text("您要执行什么操作?"),
                  actions: <Widget>[
                    CupertinoButton(
                      child: Text("切换到这个企业"),
                      onPressed: () {
                        Navigator.pop(context);
                        VarDepository.tipsDialog(context, "目前还不支持这个操作");
                      },
                    ),
                    CupertinoButton(
                      child: Text("离开这个企业"),
                      onPressed: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text("真的要离开吗?"),
                              content: Text("请再次确认是否要离开这家企业"),
                              actions: <Widget>[
                                CupertinoButton(
                                  child: Text("好"),
                                  onPressed: () async {
                                      final rsbuff = VarDepository.makeAListString(VarDepository.run<List<String>>(
                                        data.substring(0, data.length-1).split(" "),
                                        (it) {
                                          it.remove(enterprise);
                                        }
                                      ));
                                      userCache.conn.query("set joined_enterprises $rsbuff");
                                      userCache.conn.callBack = (bytes) {};
                                      Navigator.pop(context);
                                      setState(() {});
                                  },
                                ),
                                CupertinoButton(
                                  child: Text("不了"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          }
                        );
                      },
                    ),
                  ],
                );
              }
            );
          });
        }
        try {
          setState(() {});
        } catch (e) {
        }
      }
    };
    userCache.conn.query("get joined_enterprises");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("加入的企业"),
      ),
      body: ListView.builder(
        itemCount: enterprises.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: enterprises[index],
            onTap: actions[index],
          );
        }
      ),
    );
  }
}