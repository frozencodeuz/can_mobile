import 'package:flutter/material.dart';
import '../kits/toolkits.dart';

class AboutCanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/bg2.png"),
          fit: BoxFit.cover,
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: GestureDetector(
            child: Icon(Icons.subdirectory_arrow_left, color: Colors.black,),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          title: Text("About Can", style: TextStyle(
            color: Colors.black
          ),),
          elevation: 0,
          actions: <Widget>[
            GestureDetector(
              child: Icon(Icons.help, color: Colors.black,),
              onTap: () {
                tipsDialog(context, "帮助功能尚未开放");
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 20.0),
              child: GestureDetector(
                child: Icon(Icons.web, color: Colors.black,),
                onTap: () {
                  tipsDialog(context, "官网尚未架设");
                },
              )
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(24.0),
            child: Text("THE DRIVE TO LIVE", style: TextStyle(
              fontSize: 20
            ),),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Image.asset("images/cantitle.png"),
              Text("Can Base1 (Version 1.0.0.190713_base)", style: TextStyle(
                  fontSize: 21
              ),),
              Text("Flutter: Channel stable, v1.7.8+hotfix.3, \non Mac OS X 10.14.5 18F203, locale zh-Hans-CN", style: TextStyle(
                  fontSize: 16
              ),),
              Text("Xcode - develop for iOS and macOS (Xcode 10.2.1)", style: TextStyle(
                  fontSize: 16
              ),),
              Text("iOS tools - develop for iOS devices", style: TextStyle(
                  fontSize: 16
              ),),
              Text("Android Studio (version 3.4)", style: TextStyle(
                  fontSize: 16
              ),),
              Text("IntelliJ IDEA Ultimate Edition (version 1619.1.3)", style: TextStyle(
                  fontSize: 16
              ),),
              Text("VS Code (version 1.36.1)", style: TextStyle(
                  fontSize: 16
              ),),
            ],
          ),
        ),
      ),
    );
  }
}