import 'dart:async';
import 'package:flutter/material.dart';

class Add_Acad_Info extends StatefulWidget {
  @override
  Add_Acad_InfoState createState() => Add_Acad_InfoState();
}

class Add_Acad_InfoState extends State<Add_Acad_Info> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final _formkey = GlobalKey<FormState>();
  late String acad_info;

  submit() {
    final form = _formkey.currentState;
    if (form!.validate()) {
      form.save();
      SnackBar snackbar = SnackBar(content: Text("Academic info added successfully!"));
      _scaffoldkey.currentState!.showSnackBar(snackbar);
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context, acad_info);
      });
    }
  }

  @override
  Widget build(BuildContext text) {
    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Academic Info"),
        ),
        body: Column(
          children: <Widget> [
            Padding(
              padding: EdgeInsets.fromLTRB(0,30,0,20),
              child: Text( "Academic Info",
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
                      if (val!.trim().length < 2 || val.isEmpty) {
                        return 'Too short!';
                      } else if (val.trim().length > 30) {
                        return 'Too long';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) => acad_info = val!,
                    autofocus: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Your course/ major/ programme",
                        labelStyle: TextStyle(fontSize: 20.0),
                        hintText: ("Must be at least 2 characters"),
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