import 'package:can_mobile/widget/user_tile.dart';
import 'package:flutter/material.dart';

import '../kits/toolkits.dart';
import '../kits/user_cache.dart';
import '../users/person_data_page.dart';

class PersonalPage extends StatefulWidget {
  UserCache userCache;
  PersonalPage(this.userCache);
  @override
  _PersonalState createState() => _PersonalState(userCache);
}

class _PersonalState extends State<PersonalPage> {
  UserCache userCache;
  _PersonalState(this.userCache);
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 15),
          ),
          UserTile(
            userCache,
            userCache.un,
            onTap: () => push(context, PersonDataPage(userCache)),
            isSelf: true,
          ),
        ],
      ),
    );
  }
}