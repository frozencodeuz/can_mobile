class DataStack {
  final _data = StringBuffer();

  void append(String data) => _data.write(data);

  String nextData() {
    final cache = _data.toString();
    final split = cache.split("\n");
    if (cache.endsWith("\n")) {
      _data.clear();
      return split[split.length-2];
    } else if (cache.split("\n").length==2) {
      final data = split[0];
      _data.clear();
      _data.write(_list2string(split..removeAt(0), "\n"));
      return data;
    }
    return null;
  }

  String _list2string(List<String> list, String split) {
    final buff = StringBuffer();
    for (final i in list) {
      buff.write(i);
      buff.write(split);
    }
    return buff.toString().substring(0, buff.length-1);
  }
}