import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../network/connection.dart';

class UserCache {
  String un = "";
  String pw = "";
  Connection conn;
  Connection conn1;
  FlutterLocalNotificationsPlugin notification = FlutterLocalNotificationsPlugin();
  int notificationId = 0;
  UserCache(this.un, this.pw, this.conn, this.conn1);
}