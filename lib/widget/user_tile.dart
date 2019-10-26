import 'dart:convert';

import 'package:can_mobile/kits/toolkits.dart';
import 'package:can_mobile/users/other_user_detail_page.dart';
import 'package:can_mobile/widget/fancy_button.dart';
import 'package:flutter/material.dart';

import '../kits/user_cache.dart';

class UserTile extends StatefulWidget {
  final UserCache userCache;
  final String userName;
  final VoidCallback onTap;
  final Map<String, dynamic> parsedJson;
  final bool isSelf;
  UserTile(this.userCache, this.userName, {this.onTap = null, this.parsedJson = null, this.isSelf = false});
  @override
  _UserTileState createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  Map<String, dynamic> map;
  @override
  void initState() {
    super.initState();
    if (widget.parsedJson==null) {
      initUser();
    } else {
      isLoading = false;
      map = widget.parsedJson;
    }
  }
  var isLoading = true;
  Future initUser() async {
    widget.userCache.conn.callBack = (data) {
      final parsedJson = json.decode(data);
      final Map<String, dynamic> map = parsedJson;
      this.map = map;
      setState(() {
        isLoading = false;
      });
    };
    widget.userCache.conn.query("visit ${widget.userName}");
  }
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipOval(
        child: Image.asset("images/defaultusericon.png"),
      ),
      title: Column(
        children: <Widget>[
          widget.isSelf?Row(
            children: <Widget>[
              Text(widget.userName)
            ],
          ):Row(
            children: <Widget>[
              Text(widget.userName),
              Expanded(
                child: Container(),
              ),
              FancyButton(
                iconData: Icons.add,
                suffix: Text("关注"),
                onPressed: () {
                  // TODO Follow
                },
              ),
              Padding(
                padding: EdgeInsets.only(left: 2, right: 2),
              ),
              FancyButton(
                iconData: Icons.assignment,
                suffix: Text("详细资料"),
                onPressed: () {
                  push(context, OtherUserDetailPage(widget.userName, map, widget.userCache));
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              GestureDetector(
                child: isLoading?CircularProgressIndicator():Text("关注"+map['followNumber']),
                onTap: () {
                  //TODO See His Follow
                },
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
              ),
              GestureDetector(
                child: isLoading?CircularProgressIndicator():Text("粉丝"+map['fanNumber']),
                onTap: () {
                  //TODO See His Fan
                },
              ),
            ],
          ),
        ],
      ),
      subtitle: isLoading?CircularProgressIndicator():(map['signature']==""?Text("TA还没有签名哦"):Text(map['signature'])),
      onTap: widget.isSelf?widget.onTap:null,
    );
  }
}