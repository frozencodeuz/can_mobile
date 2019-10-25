import 'package:can_mobile/kits/toolkits.dart';
import 'package:can_mobile/kits/user_cache.dart';
import 'package:can_mobile/users/other_user_data_page.dart';
import 'package:flutter/cupertino.dart';

class UserHead extends StatelessWidget {
  final BuildContext parentContext;
  final UserCache userCache;
  final String name;
  final Widget head;
  UserHead(this.parentContext, this.userCache, this.name, this.head);
  @override
  Widget build(BuildContext buildContext) {
    return GestureDetector(
      child: ClipOval(
        child: head,
      ),
      onTap: () {
        push(parentContext, OtherUserDataPage(userCache, name));
      },
    );
  }
}