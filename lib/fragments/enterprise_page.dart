import 'package:flutter/material.dart';

import '../kits/user_cache.dart';
import '../kits/toolkits.dart';
import '../enterprises/clients_management_page.dart';
import '../enterprises/enterprise_management_page.dart';

class EnterprisePage extends StatefulWidget {
  UserCache userCache;
  EnterprisePage(this.userCache);
  @override
  _EnterpriseState createState() => _EnterpriseState(userCache);
}
class _EnterpriseState extends State<EnterprisePage> {
  UserCache userCache;
  _EnterpriseState(this.userCache);
  String nowEnterprise;
  @override
  void initState() {
    super.initState();
    init();
  }
  void init([VoidCallback after = null]) async {
    userCache.conn.callBack = (data) {
      if (data=="") {
        nowEnterprise = null;
      } else {
        nowEnterprise = data.split(" ")[0];
      }
      if (after!=null) {
        after();
      }
    };
    userCache.conn.query("get joined_enterprises");
  }
  void showSnakeToAddEnterprise() => snake("您还暂未加入任何企业 您可以在'搜索'中加入企业", Scaffold.of(context), 2);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(
          builder: (context) {
            return GridView.count(
              primary: false,
              crossAxisCount: 3,
              crossAxisSpacing: 10.0,
              padding: const EdgeInsets.all(20.0),
              children: <Widget>[
                GestureDetector(
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.refresh),
                      Text("刷新状态")
                    ],
                  ),
                  onTap: () {
                    init(() {
                      snake("刷新完成", Scaffold.of(context), 2);
                    });
                  },
                ),
                GestureDetector(
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.info_outline),
                      Text("企业信息"),
                    ],
                  ),
                  onTap: () {
                    if (nowEnterprise==null) {
                      showSnakeToAddEnterprise();
                    } else {}
                  },
                ),
                GestureDetector(
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.person_pin_circle),
                      Text("客户管理"),
                    ],
                  ),
                  onTap: () {
                    if (nowEnterprise==null) {
                      showSnakeToAddEnterprise();
                    } else {
                      push(context, ClientsManagementPage(nowEnterprise, userCache));
                    }
                  },
                ),
                GestureDetector(
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.book),
                      Text("请假审批"),
                    ],
                  ),
                  onTap: () {
                    if (nowEnterprise==null) {
                      showSnakeToAddEnterprise();
                    } else {}
                  },
                ),
                GestureDetector(
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.business_center),
                      Text("加入的企业"),
                    ],
                  ),
                  onTap: () {
                    push(context, EnterpriseManagementPage(userCache));
                  },
                ),
              ],
            );
          },
        )
    );
  }
}