import 'package:flutter/material.dart';

class PermissionRequestDialog extends Dialog {
  final String appName;
  final String permission;
  final VoidCallback okCallback;
  final VoidCallback cancelCallback;
  PermissionRequestDialog(this.appName, this.permission, this.okCallback, this.cancelCallback);
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: SizedBox(
          width: 350.0,
          height: 400.0,
          child: new Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: Text("权限申请", style: TextStyle(
                    fontSize: 25,
                  ),),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text("$appName申请获得以下权限:", style: TextStyle(
                    fontSize: 20,
                  ),),
                ),
                Divider(indent: 50, endIndent: 50,),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 60),
                      child: Text("●     $permission"),
                    ),
                  ],
                ),
                Expanded(child: Container(),),
                SizedBox(
                  width: 320,
                  child: FlatButton(
                    textColor: Colors.white,
                    color: Colors.green,
                    child: Text("允许"),
                    onPressed: () {
                      okCallback();
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(
                  width: 320,
                  child: FlatButton(
                    textColor: Colors.white,
                    color: Colors.green,
                    child: Text("不允许"),
                    onPressed: () {
                      cancelCallback();
                      Navigator.pop(context);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}