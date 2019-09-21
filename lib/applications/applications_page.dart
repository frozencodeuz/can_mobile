import 'dart:io';

import 'package:can_mobile/applications/application.dart';
import 'package:can_mobile/applications/browser_page.dart';
import 'package:can_mobile/kits/toolkits.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ApplicationsPage extends StatefulWidget {
  List<Application> apps = <Application>[];
  ApplicationsPage() {
    findApps();
  }
  void findApps() async {
    final appFolder = Directory("${await openCanFolder()}/extension");
    appFolder.listSync().forEach((e) {
      if (!e.path.endsWith(".DS_Store")) {
        if (FileSystemEntity.isFileSync(e.path)) {
          apps.add(Application(e.path.split("/").last, File(e.path).readAsStringSync(), false));
        } else {
          apps.add(Application(e.path.split("/").last, e.path+"/index.html", true));
        }
      }
    });
  }
  @override
  _ApplicationsPageState createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage> {
  @override
  Widget build(BuildContext context) {
    final apps = widget.apps;
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
                IconButton(
                  icon: Icon(Icons.blur_on, color: Colors.white,),
                  onPressed: () {
                    push(context, BrowserPage(apps[index].name, apps[index].url));
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
                child:
                IconButton(
                  icon: Icon(Icons.store, color: Colors.white,),
                  onPressed: () {
                    //TODO App Store
                  },
                ),
              ),
              Expanded(
                child: Text(""),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20),
                child:
                IconButton(
                  icon: Icon(Icons.refresh, color: Colors.white,),
                  onPressed: () {
                    //TODO Refresh
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
