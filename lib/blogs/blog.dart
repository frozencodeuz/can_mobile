class Blog {
  int id;
  String owner;
  String content;
  Blog({this.owner, this.content, this.id});
  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: int.parse(json['id']),
      owner: json['owner'],
      content: json['content'],
    );
  }
}