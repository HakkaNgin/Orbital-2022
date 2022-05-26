import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:log_in/services/auth.dart';
import 'package:log_in/shared/loading.dart';

import '../home/home.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  late String _email, _password;
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        title: Text("REGISTER"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0,10,0,5),
                child: Text( "Register",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue
                  )
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10,0,10,0),
                child: TextFormField(
                  // validator: (String? value) => value!.isEmpty ? 'Enter an email' : null,
                  validator: (String? value) {
                    if (value != null && value.isEmpty) {
                      return "Username can't be empty";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "EMAIL",
                      hintText: "EMAIL ADDRESS",
                      prefixIcon: Icon(Icons.person)
                  ),
                  onChanged: (value) {
                    setState(() {
                      _email = value.trim();
                    });
                  },
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.fromLTRB(8,0,8,0),
              //   child: TextField(
              //     autofocus: true,
              //     decoration: InputDecoration(
              //         labelText: "USER NAME",
              //         prefixIcon: Icon(Icons.person)
              //     ),
              //     onChanged: (value) {
              //       setState(() {
              //         _username = value.trim();
              //       });
              //     },
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.fromLTRB(10,0,10,0),
                child: TextFormField(
                  validator: (value) => value!.length < 6 ? 'Enter a password at least 6 characters long' : null,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "PASSWORD",
                      hintText: "PASSWORD",
                      prefixIcon: Icon(Icons.lock)
                  ),
                  onChanged: (value) {
                    setState(() {
                      _password = value.trim();
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0,10,0,10),
                child: RaisedButton (
                  color: Colors.white,
                  textColor: Colors.black,
                  child: Text(
                      "REGISTER",
                      style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () async {
                    setState(() => error = '');
                    if (_formKey.currentState!.validate()) {
                      setState(() => loading = true);
                      dynamic result = await _auth.registerWithEmailAndPassword(_email, _password);

                      if (result == null) {
                        setState(() {
                          error = 'please supply a valid email';
                          loading = false;
                        });
                      } else if (result == 1) {
                        setState(() {
                          error = 'The email is already in use';
                          loading = false;
                        });
                      } else {
                        loading = false;
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => Home())
                        );
                      }

                      // if (result == null) {
                      //   setState(() => error = 'please supply a valid email');
                      // } else if (result == 1) {
                      //   setState(() => error = 'The email is already in use');
                      // }

                    }
                  }),
              ),
              SizedBox(height: 5),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            ],
        ),
      )
    );
  }
}