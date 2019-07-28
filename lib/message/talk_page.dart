import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../kits/message.dart';
import '../kits/user_cache.dart';
import '../kits/var_depository.dart';
import '../network/connection.dart';

class TalkPage extends StatefulWidget {
  UserCache userCache;
  TalkSettings talkSettings;
  TalkPage(this.talkSettings, this.userCache);
  @override
  _TalkState createState() => _TalkState(talkSettings, userCache);
}

String nowMsg = "";

class _TalkState extends State<TalkPage> {
  TalkSettings talkSettings;
  UserCache userCache;
  _TalkState(this.talkSettings, this.userCache);
  List<Widget> talkshowers = List();
  final _scrlCtrlr = ScrollController();
  Connection msgConn;
  @override
  void initState() {
    super.initState();
    init();
  }
  void init() async {
    msgConn = Connection(await Socket.connect(IP, PORT));
    loadMessages();
    Timer(Duration(milliseconds: 300), () => _scrlCtrlr.jumpTo(_scrlCtrlr.position.maxScrollExtent));
  }
  @override
  void dispose() {
    super.dispose();
    msgConn.query("close");
    msgConn.close();
  }
  void loadMessages() async {
    msgConn.socket.listen((bytes) {
      msgConn.callBack(bytes);
    });
    msgConn.callBack = (bytes) => loadImpl(bytes);
    msgConn.query("sublogin ${userCache.un} ${userCache.pw}");
    msgConn.query("get allmsgsaboutthem ${talkSettings.to} ${talkSettings.from}");
  }
  void loadImpl(List<int> bytes) {
    var data = utf8.decode(bytes);
    if (data=="0\n") return;
    if (data=="[]\n") return;
    List<dynamic> parsed;
    try {
      parsed = json.decode(data);
    } catch (e) {
      msgConn.query("get allmsgsaboutthem ${talkSettings.to} ${talkSettings.from}");
      return;
    }
    talkshowers.clear();
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
    for (var i in messages) {
      talkshowers.add(Column(
        crossAxisAlignment: (i.to==userCache.un)?CrossAxisAlignment.start:CrossAxisAlignment.end,
        children: <Widget>[
          Text(i.content),
          Text(
            i.time,
            style: TextStyle(
                fontSize: 8
            ),
          )
        ],
      ));
    }
    try {
      setState(() {});
    } catch (e) {
    }
    Future.delayed(Duration(milliseconds: 500), () {
      try {
        msgConn.query("get allmsgsaboutthem ${talkSettings.to} ${talkSettings.from}");
      } catch(e) {
      }
    });
  }
  void send(String text) async {
    userCache.conn.callBack = (bytes) {};
    userCache.conn.query("send ${text.replaceAll("\"", "").replaceAll(" ", "")} ${userCache.un} ${talkSettings.from==userCache.un?talkSettings.to:talkSettings.from} false ${VarDepository.now()} text");
  }
  TextEditingController tec = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(talkSettings.from==userCache.un?talkSettings.to:talkSettings.from)),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: _scrlCtrlr,
              itemCount: talkshowers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: talkshowers[index],
                );
              }
            )
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.message),
                        labelText: "消息内容"
                    ),
                    controller: tec,
                    onChanged: (text) {
                      nowMsg = text;
                    },
                    onSubmitted: (text) {
                      if (text=="") {
                        VarDepository.tipsDialog(context, "消息内容不能为空");
                      } else {
                        send(text);
                        tec.clear();
                      }
                    }
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15),
                child: GestureDetector(
                  child: Icon(Icons.send),
                  onTap: () {
                    if (tec.text=="") {
                      VarDepository.tipsDialog(context, "消息内容不能为空");
                    } else {
                      send(tec.text);
                      tec.clear();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}