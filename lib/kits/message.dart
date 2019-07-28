class Message {
  String content;
  String from;
  String to;
  bool isWithdrew;
  String time;
  Message(
      this.content,
      this.from,
      this.to,
      this.isWithdrew,
      this.time,
      );
}

class MessageList {
  List<String> contents;
  String from;
  String to;
  List<bool> isWithdrews;
  List<String> times;
  MessageList(
      this.contents,
      this.from,
      this.to,
      this.isWithdrews,
      this.times,
      );
}

class TalkSettings {
  String from;
  String to;
  TalkSettings(
      this.from,
      this.to
      );
}