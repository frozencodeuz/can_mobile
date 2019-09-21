import 'package:flutter/material.dart';

class AppStorePage extends StatefulWidget {
  @override
  _AppStoreState createState() => _AppStoreState();
}

class _AppStoreState extends State<AppStorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App Store"),
      ),
    );
  }
}