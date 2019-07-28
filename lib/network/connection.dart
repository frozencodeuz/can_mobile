import 'dart:io';

const String IP = "server.natappfree.cc";
const int PORT = 43342;

class Connection {
  Socket socket;
  Connection(this.socket);
  Function(List<int> bytes) callBack = (bytes) {};
  void query(String command) {
    socket.writeln(command);
  }
  void close() {
    socket.close();
  }
}