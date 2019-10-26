import 'package:can_mobile/kits/user_cache.dart';
import 'package:flutter/material.dart';

class OtherUserDetailPage extends StatefulWidget {
  final String username;
  final Map<String, dynamic> parsedJson;
  final UserCache userCache;
  OtherUserDetailPage(this.username, this.parsedJson, this.userCache);
  @override
  _OtherUserDetailState createState() => _OtherUserDetailState();
}

class _OtherUserDetailState extends State<OtherUserDetailPage> {
  @override
  Widget build(BuildContext context) {
    final phone = widget.parsedJson['phone'] as String;
    final birthday = widget.parsedJson['birthday'] as String;
    return Scaffold(
      appBar: AppBar(
        title: Text("'${widget.username}'的详细资料"),
      ),
      body: Card(
        child: Column(
          children: <Widget>[
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("电话"),
                VerticalDivider(),
                Text(phone.isEmpty?"无":birthday),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("生日"),
                VerticalDivider(),
                Text(birthday.isEmpty?"无":birthday),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
