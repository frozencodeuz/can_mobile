import 'dart:io';

import 'package:can_mobile/kits/toolkits.dart';

void checkForDirectories() async {
  final appPath = await openCanFolder();
  final appDir = Directory(appPath);
  if (appDir.existsSync()) {
    appDir.createSync();
  }

  // Can properties
  createFile(File("$appPath/can.properties"));

  // Directories
  createDir(Directory("$appPath/cache"));
  createDir(Directory("$appPath/documents"));
  createDir(Directory("$appPath/extension"));
  createDir(Directory("$appPath/sandbox"));
  createDir(Directory("$appPath/fs"));
}

void createFile(File file) {
  if (!file.existsSync()) {
    file.createSync(recursive: true);
  }
}

void createDir(Directory dir) {
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }
}