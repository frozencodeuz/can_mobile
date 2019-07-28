import '../network/connection.dart';

class UserCache {
  String un = "";
  String pw = "";
  Connection conn;
  Connection conn1;
  UserCache(this.un, this.pw, this.conn, this.conn1);
}