import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suberui/screens/authenticate/authenticate.dart';
import 'mainApp/home.dart';
import 'package:suberui/models/user.dart';


class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user= Provider.of<User>(context);
    if (user == null){
      return Authenticate();
    }
    else {
      return Home();
    }
  }
}
