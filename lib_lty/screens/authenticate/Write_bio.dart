import 'dart:async';

import 'package:flutter/material.dart';
import 'package:log_in/screens/authenticate/InitialPage.dart';

class Write_Bio extends StatefulWidget {
  @override
  Write_BioState createState() => Write_BioState();
}

class Write_BioState extends State<Write_Bio> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final _formkey = GlobalKey<FormState>();
  late String bio;

  submit() {
    final form = _formkey.currentState;
    // print("SSSSSSSSSSSSSSSSSSSSS _formkey.currentState");
    if (form!.validate()) {
      // print("SSSSSDSAAAAAAAAAAAAAAAAAAAAAAAAAAAAASSSD");
      form.save();
      SnackBar snackbar = SnackBar(content: Text("Your bio is completed!"));
      _scaffoldkey.currentState!.showSnackBar(snackbar);
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context, bio);
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
              child: Text( "Enter Your Bio",
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
                      if (val!.trim().length < 2 || val.isEmpty) {
                        return 'Bio too short!';
                      } else if (val.trim().length > 100) {
                        return 'Bio longer than 100 characters';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) => bio = val!,
                    autofocus: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Your bio",
                        labelStyle: TextStyle(fontSize: 15.0),
                        hintText: ("Must be at least 2 characters"),
                        prefixIcon: Icon(Icons.person),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0,50,0,10),
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