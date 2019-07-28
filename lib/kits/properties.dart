import 'dart:io';

class Properties {
  List<PropertyRow> data = List();
  Properties(String content) {
    for (var row in content.split("\n")) {
      final rowsp = row.split("=");
      data.add(PropertyRow(rowsp[0], rowsp[1]));
    }
  }
  String read(String key) {
    for (var row in data) {
      if (row.key==key) {
        return row.value;
      }
    }
    return null;
  }
  void write(String key, String value) {
    for (var row in data) {
      if (row.key==key) {
        row.value = value;
        return;
      }
    }
  }
  @override
  String toString() {
    StringBuffer buffer = StringBuffer();
    for (var row in data) {
      buffer.writeln(row.key+"="+row.value);
    }
    return buffer.toString();
  }
}

class PropertyRow{
  String key;
  String value;
  PropertyRow(this.key, this.value);
}