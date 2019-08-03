import 'package:flutter/material.dart';

import '../kits/user_cache.dart';

class WorldPage extends StatelessWidget {
  UserCache userCache;
  WorldPage(this.userCache);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text("World")
        ],
      ),
    );
  }
}