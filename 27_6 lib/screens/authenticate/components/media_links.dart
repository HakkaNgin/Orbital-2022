import 'dart:async';
import 'package:flutter/material.dart';

class Add_Links extends StatefulWidget {
  @override
  Add_LinksState createState() => Add_LinksState();
}

class Add_LinksState extends State<Add_Links> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final _formkey1 = GlobalKey<FormState>();
  final _formkey2 = GlobalKey<FormState>();
  final _formkey3 = GlobalKey<FormState>();
  String? link1;
  String? link2;
  String? link3;
  List<String> links = [];

  submit() {
    final form1 = _formkey1.currentState;
    final form2 = _formkey2.currentState;
    final form3 = _formkey3.currentState;
    if (form1!.validate() && form2!.validate() && form3!.validate()) {
      form1.save();
      form2.save();
      form3.save();
      link1 == null ? links.add("") : links.add(link1!);
      link2 == null ? links.add("") : links.add(link2!);
      link3 == null ? links.add("") : links.add(link3!);
      SnackBar snackbar = SnackBar(content: Text("Added links successfully!"));
      _scaffoldkey.currentState!.showSnackBar(snackbar);
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context, links);
      });
    }
  }

  @override
  Widget build(BuildContext text) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Link other social media",),
      ),

      body: Column(
        children: <Widget> [
          Padding(
            padding: EdgeInsets.fromLTRB(0,30,0,20),
            child: Text( "Other Social Media",
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
                key: _formkey1,
                autovalidateMode: AutovalidateMode.always,
                child: TextFormField(
                  onSaved: (val) => link1 = val,
                  autofocus: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Account 1",
                    labelStyle: TextStyle(fontSize: 15.0),
                    hintText: ("URL Preferred"),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: Form(
                key: _formkey2,
                autovalidateMode: AutovalidateMode.always,
                child: TextFormField(
                  onSaved: (val) => link2 = val,
                  autofocus: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Account 2",
                    labelStyle: TextStyle(fontSize: 15.0),
                    hintText: ("URL Preferred"),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: Form(
                key: _formkey3,
                autovalidateMode: AutovalidateMode.always,
                child: TextFormField(
                  onSaved: (val) => link3 = val,
                  autofocus: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Account 3",
                    labelStyle: TextStyle(fontSize: 15.0),
                    hintText: ("URL Preferred"),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(0,10,0,10),
            child: GestureDetector(
              onTap: () {
                submit();
              },
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