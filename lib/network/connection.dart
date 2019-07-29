import 'dart:convert';
import 'dart:io';

import 'package:can_mobile/network/data_stack.dart';

const String IP = "barrels277.e2.luyouxia.net";
const int PORT = 27641;

class Connection {
  dynamic host;
  int port;
  Connection(this.host, this.port);
  Function(String data) callBack = (data) {};
  Socket _socket;
  DataStack _stack = DataStack();
  void query(String command) {
    _socket.writeln(command);
  }
  Future init() async {
    _socket = await Socket.connect(host, port);
    _socket.transform(utf8.decoder).listen((data) {
      // 压栈
      _stack.append(data);
      // 计算是否有新消息
      final next = _stack.nextData();
      if (next!=null) {
        callBack(next);
      }
    });
  }
  void close() => _socket.close();
}