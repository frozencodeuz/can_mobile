import 'dart:convert';

import 'package:flutter/material.dart';

import '../kits/user_cache.dart';

class UserTile extends StatefulWidget {
  final UserCache userCache;
  final String userName;
  final VoidCallback onTap;
  UserTile(this.userCache, this.userName, this.onTap);
  @override
  _UserTileState createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  @override
  void initState() {
    super.initState();
    initUser();
  }
  Map<String, dynamic> map;
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
          Row(
            children: <Widget>[
              Text(widget.userName)
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
      onTap: widget.onTap,
    );
  }
}