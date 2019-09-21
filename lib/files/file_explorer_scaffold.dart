import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FileExplorerScaffold extends StatefulWidget {
  final Directory currentDir;
  FileExplorerScaffold(this.currentDir);
  @override
  _FileExplorerScaffoldState createState() => _FileExplorerScaffoldState();
}

class _FileExplorerScaffoldState extends State<FileExplorerScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}