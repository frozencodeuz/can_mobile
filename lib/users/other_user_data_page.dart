import 'dart:convert';

import 'package:can_mobile/kits/user_cache.dart';
import 'package:can_mobile/widget/user_tile.dart';
import 'package:flutter/material.dart';

class OtherUserDataPage extends StatefulWidget {
  final UserCache userCache;
  final String name;
  OtherUserDataPage(this.userCache, this.name);
  @override
  _OtherUserDataPageState createState() => _OtherUserDataPageState();
}

class _OtherUserDataPageState extends State<OtherUserDataPage> {
  var isLoading = true;
  var isVisible = true;
  Map<String, dynamic> parsedJson;
  @override
  void initState() {
    super.initState();
    widget.userCache.conn.callBack = (data) {
      if (data!="2") {
        setState(() {
          isLoading = false;
          parsedJson = json.decode(data);
        });
      } else {
        setState(() {
          isVisible = false;
          isLoading = false;
        });
      }
    };
    widget.userCache.conn.query("visit ${widget.name}");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: isLoading?CircularProgressIndicator():
      (isVisible?Column(
        children: <Widget>[
          UserTile(widget.userCache, widget.name, onTap: () {}, parsedJson: parsedJson, isSelf: false,),

        ],
      ):Center(
        child: Text("该用户不存在"),
      )),
    );
  }
}
