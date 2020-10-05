import 'package:event/model/user.dart';
import 'homepage.dart';
import 'package:event/page/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:event/service/database.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    if (user == null) {
      return LoginPage();
    } else {
      return StreamProvider<UserData>.value(
        value: DatabaseService().streamUserData(user.uid),
        child: HomePage(),
      );
    }
  }
}
