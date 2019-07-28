import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'kits/user_cache.dart';
import 'kits/var_depository.dart';
import 'enterprises/enterprise_search_result_page.dart';

class SearchPage extends StatefulWidget {
  UserCache userCache;
  SearchPage(this.userCache);
  @override
  _SearchState createState() => _SearchState(userCache);
}

class _SearchState extends State<SearchPage> {
  UserCache userCache;
  _SearchState(this.userCache);
  Color _users_color = Colors.black;
  Color _texts_color = Colors.black;
  Color _videos_color = Colors.black;
  Color _enterprises_color = Colors.black;
  Color _officiallyaccounts_color = Colors.black;
  Color _all_color = Colors.blue;
  String labelText = "搜索";
  void colorsAllBlack() {
    _users_color = Colors.black;
    _texts_color = Colors.black;
    _videos_color = Colors.black;
    _enterprises_color = Colors.black;
    _officiallyaccounts_color = Colors.black;
    _all_color = Colors.black;
  }
  TextEditingController ctrlr = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          child: Icon(Platform.isAndroid?Icons.arrow_back:Icons.arrow_back_ios, color: Colors.black, ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 60.0),
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: labelText
              ),
              controller: ctrlr,
              onSubmitted: ((text) {
                search(text);
              }),
            )
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 20),
            child: GestureDetector(
              child: Icon(Icons.search, color: Colors.black,),
              onTap: () {
                search(ctrlr.text);
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 40),
          ),
          Text("搜索指定内容"),
          Expanded (
            flex: 5,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: FlatButton(child: Text("用户", style: TextStyle(color: _users_color)), onPressed: () {
                      setState(() {
                        colorsAllBlack();
                        _users_color = Colors.blue;
                        labelText = "搜索用户";
                      });
                    },),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: FlatButton(child: Text("文章", style: TextStyle(color: _texts_color)), onPressed: () {
                      setState(() {
                        colorsAllBlack();
                        _texts_color = Colors.blue;
                        labelText = "搜索文章";
                      });
                    },),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: FlatButton(child: Text("视频", style: TextStyle(color: _videos_color)), onPressed: () {
                      setState(() {
                        colorsAllBlack();
                        _videos_color = Colors.blue;
                        labelText = "搜索视频";
                      });
                    },),
                  ),
                ),
              ],
            ),
          ),
          Expanded (
            flex: 50,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: FlatButton(child: Text("企业", style: TextStyle(color: _enterprises_color)), onPressed: () {
                      setState(() {
                        colorsAllBlack();
                        _enterprises_color = Colors.blue;
                        labelText = "搜索企业";
                      });
                    },),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: FlatButton(child: Text("公众号", style: TextStyle(color: _officiallyaccounts_color)), onPressed: () {
                      setState(() {
                        colorsAllBlack();
                        _officiallyaccounts_color = Colors.blue;
                        labelText = "搜索公众号";
                      });
                    },),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: FlatButton(child: Text("全部", style: TextStyle(color: _all_color)), onPressed: () {
                      setState(() {
                        colorsAllBlack();
                        _all_color = Colors.blue;
                        labelText = "搜索";
                      });
                    },),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void search(String text) {
    if (text!="") {
      if (_users_color==Colors.blue) {
        VarDepository.tipsDialog(context, "暂不支持搜索用户");
      } else if (_texts_color==Colors.blue) {
        VarDepository.tipsDialog(context, "暂不支持搜索文章");
      } else if (_videos_color==Colors.blue) {
        VarDepository.tipsDialog(context, "暂不支持搜索视频");
      } else if (_enterprises_color==Colors.blue) {
        VarDepository.push(context, EnterpriseSearchResultPage(text, userCache));
      } else if (_officiallyaccounts_color==Colors.blue) {
        VarDepository.tipsDialog(context, "暂不支持搜索公众号");
      } else if (_all_color==Colors.blue) {
        VarDepository.tipsDialog(context, "暂不支持搜索全部");
      }
    } else {
      VarDepository.tipsDialog(context, "搜索内容不能为空");
    }
  }
}