import 'dart:async';

import 'package:flutter/material.dart';
import 'package:log_in/screens/authenticate/InitialPage.dart';

class Register_Name extends StatefulWidget {
  @override
  Register_NameState createState() => Register_NameState();
}

class Register_NameState extends State<Register_Name> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final _formkey = GlobalKey<FormState>();
  late String username;

  submit() {
    final form = _formkey.currentState;
    // print("SSSSSSSSSSSSSSSSSSSSS _formkey.currentState");
    if (form!.validate()) {
      // print("SSSSSDSAAAAAAAAAAAAAAAAAAAAAAAAAAAAASSSD");
      form.save();
      SnackBar snackbar = SnackBar(content: Text("Welcome $username!"));
      _scaffoldkey.currentState!.showSnackBar(snackbar);
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context, username);
      });
    }
  }

  @override
  Widget build(BuildContext text) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text("Provide a Username"),
      ),
      body: Column(
        children: <Widget> [
          Padding(
            padding: EdgeInsets.fromLTRB(0,50,0,10),
            child: Text( "Register",
                style: TextStyle (
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              child: Form(
                key: _formkey,
                autovalidateMode: AutovalidateMode.always,
                child: TextFormField(
                  validator: (val) {
                    if (val!.trim().length < 3 || val.isEmpty) {
                      return 'Username too short!';
                    } else if (val.trim().length > 12) {
                      return 'Username too long';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (val) => username = val!,
                  autofocus: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                      labelText: "USERNAME",
                      labelStyle: TextStyle(fontSize: 15.0),
                      hintText: ("Must be at least 3 characters"),
                      prefixIcon: Icon(Icons.person)
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0,10,0,10),
            child: GestureDetector(
              onTap: () {
                // print("WHO PRESSED ME");
                submit();},
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(7.0),
                ),
                child: Text( "Submit",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }
}