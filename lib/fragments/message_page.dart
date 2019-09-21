import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as notification;

import '../message/talk_page.dart';
import '../kits/user_cache.dart';
import '../kits/toolkits.dart';
import '../message/message.dart';

class MessagePage extends StatefulWidget {
  UserCache userCache;
  MessagePage(this.userCache);
  final contacts = List<MessageList>();
  bool isLoaded = false;
  bool allMsg = true;
  @override
  _MessageState createState() => _MessageState(userCache);
}

class _MessageState extends State<MessagePage> {
  UserCache userCache;
  _MessageState(this.userCache);
  List<Widget> msgshowers = List();
  List<VoidCallback> pushToMessagePage = List();
  @override
  void initState() {
    super.initState();
    if (!widget.isLoaded) {
      receiveMessages();
      widget.isLoaded = true;
    } else {
      setState(() {
        updateMessageShowers();
      });
    }
  }
  void receiveMessages() async {
    userCache.conn1.callBack = (data) => receiveImpl(data);
    userCache.conn1.query("get allmsgsaboutme");
  }
  void receiveImpl(String data) {
    if (data=="[]") {
      Future.delayed(Duration(milliseconds: 500), () {
        try {
          if (widget.allMsg) {
            widget.allMsg = false;
            userCache.conn1.query("get unreceivedmsgsaboutme");
          } else {
            userCache.conn1.query("get unreceivedmsgsaboutme");
          }
        } catch (e) {
        }
      });
      return;
    }
    List<dynamic> parsed;
    try {
      parsed = json.decode(data);
    } catch (e) {
      if (widget.allMsg) {
        userCache.conn1.query("get allmsgsaboutme");
      } else {
        userCache.conn1.query("get unreceivedmsgsaboutme");
      }
      return;
    }
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
    if (!widget.allMsg) {
      for (var msg in messages) {
        if (msg.from==userCache.un) {
          continue;
        }
        var platformChannelSpecifics = notification.NotificationDetails(
            notification.AndroidNotificationDetails(
                userCache.notificationId.toString(), msg.to, msg.content,
                importance: notification.Importance.Max, priority: notification.Priority.High, ticker: "ticker"), notification.IOSNotificationDetails());
        userCache.notification.show(userCache.notificationId, msg.from, msg.content, platformChannelSpecifics, payload: "msg ${msg.from} ${msg.to}");
        userCache.notificationId++;
      }
    }
    var found = false;
    for (var msg in messages) {
      for (var contact in widget.contacts) {
        if ((contact.from==msg.from&&contact.to==msg.to)||(contact.from==msg.to&&contact.to==msg.from)) {
          contact.contents.add(msg.content);
          contact.isWithdrews.add(msg.isWithdrew);
          contact.times.add(msg.time);
          found = true;
          break;
        }
      }
      if (found) {
        found = false;
        continue;
      } else {
        widget.contacts.add(
            MessageList(
              makeListWithFirstElementSet(msg.content),
              msg.from,
              msg.to,
              makeListWithFirstElementSet(msg.isWithdrew),
              makeListWithFirstElementSet(msg.time),
            )
        );
      }
    }
    updateMessageShowers();
    if (widget.allMsg) {
      widget.allMsg = false;
    }
    try {
      setState((){
      });
    } catch (e) {}
    Future.delayed(Duration(milliseconds: 500), () {
      try {
        userCache.conn1.query("get unreceivedmsgsaboutme");
      } catch (e) {
      }
    });
  }
  void updateMessageShowers() {
    msgshowers.clear();
    for (var msgl in widget.contacts) {
      msgshowers.add(Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                msgl.from==userCache.un?msgl.to:msgl.from,
                style: TextStyle(
                    fontSize: 30
                ),
              ),
            ],
          ),
          Text(msgl.contents[msgl.contents.length-1]),
          Text(msgl.times[msgl.times.length-1]),
        ],
      ));
      pushToMessagePage.add(() {
        push(context, TalkPage(TalkSettings(msgl.from, msgl.to), userCache));
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: msgshowers.length,
        itemBuilder: (context, index) {
          return ListTile(
              leading: Image.asset("images/defaultusericon.png"),
              title: msgshowers[index],
              onTap: pushToMessagePage[index]
          );
        }
    );
  }
}