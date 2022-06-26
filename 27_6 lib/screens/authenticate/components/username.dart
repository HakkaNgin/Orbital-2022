import 'dart:async';
import 'package:flutter/material.dart';

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
    if (form!.validate()) {
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
        automaticallyImplyLeading: false,
        title: Text("Username"),
      ),
      body: Column(
        children: <Widget> [
          Padding(
            padding: EdgeInsets.fromLTRB(0,30,0,20),
            child: Text( "Username",
                style: TextStyle (
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrangeAccent
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: Form(
                key: _formkey,
                autovalidateMode: AutovalidateMode.always,
                child: TextFormField(
                  validator: (val) {
                    if (val!.trim().length < 3 || val.isEmpty) {
                      return 'Username too short!';
                    } else if (val.trim().length > 30) {
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
                      labelStyle: TextStyle(fontSize: 20.0),
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
                submit();},
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(7.0),
                ),
                child: Text( "SUBMIT",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
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