import 'dart:io';

import 'package:can_mobile/applications/app_store_page.dart';
import 'package:can_mobile/applications/application.dart';
import 'package:can_mobile/applications/browser_page.dart';
import 'package:can_mobile/kits/toolkits.dart';
import 'package:can_mobile/kits/user_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ApplicationsPage extends StatefulWidget {
  final UserCache userCache;
  ApplicationsPage(this.userCache);
  @override
  _ApplicationsPageState createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage> {
  List<Application> apps = <Application>[];
  File extensionsFile;
  @override
  void initState() {
    super.initState();
    initExtensionsFile(true);
  }
  void initExtensionsFile(bool willFindApps) async {
    final appFolder = "${await openCanFolder()}/extension";
    final extensionsFile = File("$appFolder/extensions");
    if (!extensionsFile.existsSync()) {
      extensionsFile.createSync(recursive: true);
    }
    this.extensionsFile = extensionsFile;
    if (willFindApps) {
      setState(() {
        findApps();
      });
    }
  }
  void findApps() {
    final lines = extensionsFile.readAsLinesSync();
    if (lines!=null) {
      apps.clear();
      for (final ln in lines) {
        if (ln.trim()!="") {
          final spl = ln.split(" ");
          apps.add(Application(spl[0], spl[1]));
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final apps = this.apps;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/bg0.png"),
          fit: BoxFit.cover
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: Container(),
          title: Text("Applications"),
          backgroundColor: Colors.transparent,
        ),
        body: GridView.builder(
          itemCount: apps.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.blur_on, color: Colors.white,),
                  onTap: () {
                    push(context, BrowserPage(apps[index], widget.userCache));
                  },
                  onLongPress: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        final appName = apps[index].name;
                        return CupertinoAlertDialog(
                          title: Text(appName),
                          actions: <Widget>[
                            CupertinoButton(
                              child: Text("删除小程序"),
                              onPressed: () {
                                final lns = extensionsFile.readAsLinesSync();
                                final newList = lns.toList();
                                for (final ln in lns) {
                                  if (ln.split(" ")[0]==appName) {
                                    newList.remove(ln);
                                  }
                                }
                                final sb = StringBuffer();
                                for (final ln in newList) {
                                  sb.writeln(ln);
                                }
                                extensionsFile.writeAsStringSync(sb.toString());
                                setState(() {
                                  findApps();
                                });
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoButton(
                              child: Text("取消"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      }
                    );
                  },
                ),
                Text(apps[index].name, style: TextStyle(
                  color: Colors.white
                ),),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.home),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: IconButton(
                  icon: Icon(Icons.store, color: Colors.white,),
                  tooltip: "App Store",
                  onPressed: () {
                    push(context, AppStorePage());
                  },
                ),
              ),
              Expanded(
                child: Text(""),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: IconButton(
                  icon: Icon(Icons.import_export, color: Colors.white,),
                  tooltip: "添加小程序",
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        String newAppName = "";
                        String newAppUrl = "";
                        return CupertinoAlertDialog(
                          title: Text("添加小程序"),
                          content: Column(
                            children: <Widget>[
                              Material(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "小程序名",
                                    prefixIcon: Icon(Icons.text_fields),
                                  ),
                                  onChanged: (text) {
                                    newAppName = text;
                                  },
                                ),
                              ),
                              Material(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "小程序地址(URL)",
                                    prefixIcon: Icon(Icons.link),
                                  ),
                                  onChanged: (text) {
                                    newAppUrl = text;
                                  },
                                ),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            CupertinoButton(
                              child: Text("取消"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoButton(
                              child: Text("确认"),
                              onPressed: () {
                                if (newAppName.indexOf(" ")==-1&&newAppUrl.indexOf(" ")==-1) {
                                  setState(() {
                                    extensionsFile.writeAsStringSync(extensionsFile.readAsStringSync()+"\n$newAppName $newAppUrl");
                                    findApps();
                                  });
                                  Navigator.pop(context);
                                } else {
                                  microTip(context, "小程序名称以及URL中不能含有空格");
                                }
                              },
                            ),
                          ],
                        );
                      }
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
