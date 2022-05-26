import 'package:firebase_auth/firebase_auth.dart';
import 'package:log_in/models/user.dart';
import 'package:log_in/screens/authenticate/InitialPage.dart';
import 'package:log_in/screens/authenticate/Login.dart';
import 'package:log_in/screens/authenticate/Register.dart';
import 'package:flutter/material.dart';
import 'package:log_in/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<MyUser?>(context);

    // return either Home or InitialPage
    // return Home();
    if (user == null) {
      //print("ssssssssssss");
      return InitialPage();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => InitialPage())
      );

    } else {
      // print("sddddddddddd");
      return Home();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Home())
      );
    }
  }
}
