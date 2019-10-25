import 'dart:convert';

import 'package:can_mobile/message/send_page.dart';
import 'package:can_mobile/widget/user_head.dart';

import '../blogs/write_blog_page.dart';
import '../kits/toolkits.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../kits/user_cache.dart';
import '../blogs/blog.dart';

class WorldPage extends StatefulWidget {
  UserCache userCache;
  WorldPage(this.userCache);
  @override
  _WorldState createState() => _WorldState();
}

class _WorldState extends State<WorldPage> {
  @override
  void initState() {
    super.initState();
    initBlogs();
  }
  var blogs = List<Blog>();
  Future<void> initBlogs() async {
    widget.userCache.conn.callBack = (data) {
      final parsedJson = json.decode(data);
      blogs = List<Blog>.from(parsedJson.map((i) => Blog.fromJson(i)).toList());
      setState(() {});
      return;
    };
    widget.userCache.conn.query("get blogs");
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    body: RefreshIndicator(
      onRefresh: initBlogs,
      child: ListView.builder(
        itemCount: blogs.length,
        itemBuilder: (context, index) {
          final i = blogs[index];
          return Card(
            color: Colors.orange,
            elevation: 3.0,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    UserHead(
                      context,
                      widget.userCache,
                      i.owner,
                      Image.asset("images/defaultusericon.png", width: 50, height: 50,),
                    ),
                    Column(
                      children: <Widget>[
                        Text(i.owner),
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              child: ClipOval(
                                child: Container(
                                  child: Icon(Icons.add, color: Colors.white,),
                                  color: Colors.red,
                                ),
                              ),
                              onTap: () {
                                //TODO Follow Him
                              },
                            ),
                            GestureDetector(
                              child: ClipOval(
                                child: Container(
                                  child: Icon(Icons.message, color: Colors.white,),
                                  color: Colors.red,
                                ),
                              ),
                              onTap: () {
                                push(context, SendPage(widget.userCache, user: i.owner));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: Text(""),
                    ),
                    blogs[index].owner==widget.userCache.un?Row(
                      children: <Widget>[
                        GestureDetector(
                          child: Icon(Icons.delete),
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: Text("真的要删除这条日志吗？"),
                                  content: Text("一旦删除，无法恢复"),
                                  actions: <Widget>[
                                    CupertinoButton(
                                      child: Text("不了"),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    CupertinoButton(
                                      child: Text("好"),
                                      onPressed: () {
                                        widget.userCache.conn.callBack = (data) {
                                          initBlogs();
                                        };
                                        widget.userCache.conn.query("del blog ${blogs[index].id}");
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              }
                            );
                          },
                        )
                      ],
                    ):Container()
                  ],
                ),
                Text(i.content),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.favorite),
                          Text("赞")
                        ],
                      ),
                      onTap: () {
                      },
                    ),
                    GestureDetector(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.comment),
                          Text("评论"),
                        ],
                      ),
                      onTap: () {
                      },
                    ),
                    Expanded(
                      child: Text(""),
                    ),
                    GestureDetector(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.add_comment),
                          Text("添加评论...")
                        ],
                      ),
                      onTap: () {
                        //TODO Add Comment
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    ),
    floatingActionButton: FloatingActionButton(
      child: Icon(Icons.edit),
      onPressed: () => push(context, WriteBlogPage(widget.userCache)),
    ),
  );
}