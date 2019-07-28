class Client {
  String name;
  String local;
  String phone;
  String type;
  String scale;
  List<Custom> custom;
  List<Contact> contacts;
  Client({this.name, this.local, this.phone, this.type, this.scale, this.custom, this.contacts});
  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      name: json['name'],
      local: json['local'],
      phone: json['phone'],
      type: json['type'],
      scale: json['scale'],
      custom: List<Custom>.from(json['custom'].map((i) => Custom.fromJson(i)).toList()),
      contacts: List<Contact>.from(json['contacts'].map((i) => Contact.fromJson(i)).toList()),
    );
  }
  String toJSONString() {
    final buffco = StringBuffer("");
    for (var i in contacts) {
      buffco.write(i.toJSONString());
      buffco.write(", ");
    }
    final buffstrco = buffco.toString();
    final buffcu = StringBuffer("");
    for (var i in custom) {
      buffcu.write(i.toJSONString());
      buffcu.write(", ");
    }
    final buffstrcu = buffcu.toString();
    return "{\"name\": \"$name\", \"local\": \"$local\", \"phone\": \"$phone\", \"type\": \"$type\", \"scale\": \"$scale\", \"custom\":[${buffstrcu==""?"":buffstrcu.substring(0, buffstrcu.length-2)}], \"contacts\": [${buffstrco==""?"":buffstrco.substring(0, buffstrco.length-2)}]}";
  }
}

class Contact {
  String name;
  String level;
  String phone;
  Contact({this.name, this.level, this.phone});
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'],
      level: json['level'],
      phone: json['phone'],
    );
  }
  String toJSONString() => "{\"name\": \"$name\", \"level\": \"$level\", \"phone\": \"$phone\"}";
}

class Custom {
  String key;
  String value;
  Custom({this.key, this.value});
  factory Custom.fromJson(Map<String, dynamic> json) {
    return Custom(
      key: json['key'],
      value: json['value'],
    );
  }
  String toJSONString() => "{\"key\": \"$key\", \"value\": \"$value\"}";
}

String clients2jsonString(List<Client> clients) {
  final buff = StringBuffer("");
  for (var i in clients) {
    buff.write(i.toJSONString());
    buff.write(", ");
  }
  final buffstr = buff.toString();
  return "[${buffstr==""?"":buffstr.substring(0, buffstr.length-2)}]";
}