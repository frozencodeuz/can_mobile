import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../kits/user_cache.dart';

class PersonDataPage extends StatefulWidget {
  UserCache userCache;
  PersonDataPage(this.userCache);
  @override
  _PersonDataState createState() => _PersonDataState(userCache);
}

class _PersonDataState extends State<PersonDataPage> {
  UserCache userCache;
  _PersonDataState(this.userCache);
  final DateTime now = DateTime.now();
  @override
  void initState() {
    super.initState();
    initUser();
  }
  Map<String, dynamic> info;
  var isLoading = true;
  void initUser() {
    widget.userCache.conn.callBack = (data) {
      final parsedJson = json.decode(data);
      final Map<String, dynamic> info = parsedJson;
      this.info = info;
      setState(() {
        isLoading = false;
      });
    };
    widget.userCache.conn.query("visit ${widget.userCache.un}");
  }
  String getDate(DateTime dateTime) => "${dateTime.year}-${dateTime.month}-${dateTime.day}";
  TextField field(String label, IconData iconData, String key, [String init, bool enabled = true]) {
    final ctrlr = TextEditingController();
    if (init!=null) ctrlr.text = init;
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(iconData),
      ),
      enabled: enabled,
      controller: ctrlr,
      onChanged: (text) {
        info[key] = text;
      },
    );
  }
  void save() {
    userCache.conn.callBack = (data) {};
    userCache.conn.query("setuserinfo {\"phone\": \"${info['phone']}\", \"signature\": \"${info['signature']}\", \"birthday\": \"${info['birthday']}\"}");
  }
  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(Platform.isAndroid?Icons.arrow_back:Icons.arrow_back_ios),
          onTap: () {
            showDialog(
              barrierDismissible: false,
              context: buildContext,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text("提示"),
                  content: Text("您还没有保存就退出了，要保存还是不保存而直接退出？"),
                  actions: <Widget>[
                    CupertinoButton(
                      child: Text("保存并退出"),
                      onPressed: () {
                        save();
                        Navigator.pop(context);
                        Navigator.pop(buildContext);
                      },
                    ),
                    CupertinoButton(
                      child: Text("不保存而直接退出"),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(buildContext);
                      },
                    ),
                  ],
                );
              }
            );
          },
        ),
        title: Text("个人资料"),
        actions: <Widget>[
          CupertinoButton(
            child: Text("保存", style: TextStyle(color: Colors.white),),
            onPressed: () {
              save();
              Navigator.pop(buildContext);
            },
          ),
        ],
      ),
      body: isLoading?CircularProgressIndicator():Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.chevron_right),
              ClipOval(
                child: Image.asset("images/defaultusericon.png", width: 100, height: 100,),
              ),
              Expanded(
                child: Text(""),
              ),
              Text("头像", style: TextStyle(
                  fontSize: 18
              ),),
              Padding(
                padding: EdgeInsets.only(right: 20),
              ),
            ],
          ),
          field("名称", Icons.text_fields, null, userCache.un, false),
          field("电话", Icons.phone, "phone", info['phone']),
          field("个性签名", Icons.format_quote, "signature", info['signature']),
          ListTile(
            leading: Text("生日"),
            title: Text(info['birthday']),
            onTap: () => DatePicker.showDatePicker(
                buildContext,
                locale: LocaleType.zh,
                currentTime: info['birthday']==""?now:info['birthday'],
                onConfirm: (date) => setState(() {
                  info['birthday'] = getDate(date);
                }),
            ),
          ),
        ],
      ),
    );
  }
}