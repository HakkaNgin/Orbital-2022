import 'dart:async';
import 'package:flutter/material.dart';

class Add_Tags extends StatefulWidget {
  @override
  Add_TagsState createState() => Add_TagsState();
}

class Add_TagsState extends State<Add_Tags> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final _formkey1 = GlobalKey<FormState>();
  final _formkey2 = GlobalKey<FormState>();
  final _formkey3 = GlobalKey<FormState>();
  String? tag1;
  String? tag2;
  String? tag3;
  List<String> tags = [];

  submit() {
    final form1 = _formkey1.currentState;
    final form2 = _formkey2.currentState;
    final form3 = _formkey3.currentState;
    if (form1!.validate() && form2!.validate() && form3!.validate()) {
      form1.save();
      form2.save();
      form3.save();
      print(tag1);
      print(tag2);
      print(tag3);
      tag1 == null ? tags.add("") : tags.add(tag1!);
      tag2 == null ? tags.add("") : tags.add(tag2!);
      tag3 == null ? tags.add("") : tags.add(tag3!);
      SnackBar snackbar = SnackBar(content: Text("Added tags successfully!"));
      _scaffoldkey.currentState!.showSnackBar(snackbar);
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context, tags);
      });
    }
  }

  @override
  Widget build(BuildContext text) {
    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Tags"),
        ),

        body: Column(
          children: <Widget> [
            Padding(
              padding: EdgeInsets.fromLTRB(0,30,0,20),
              child: Text( "Your Tags",
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
                    onSaved: (val) => tag1 = val,
                    autofocus: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Tag1",
                      labelStyle: TextStyle(fontSize: 15.0),
                      hintText: ("Something that describes you!"),
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
                    onSaved: (val) => tag2 = val,
                    autofocus: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Tag2",
                      labelStyle: TextStyle(fontSize: 15.0),
                      hintText: ("Something that describes you!"),
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
                    onSaved: (val) => tag3 = val,
                    autofocus: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Tag3",
                      labelStyle: TextStyle(fontSize: 15.0),
                      hintText: ("Something that describes you!"),
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
                  // print("WHO PRESSED ME");
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