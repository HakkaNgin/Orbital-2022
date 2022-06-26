import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'authenticate/log_in.dart';
import 'authenticate/register.dart';

class InitialPage extends StatefulWidget {
  @override
  InitialPageState createState() => InitialPageState();
}

class InitialPageState extends State<InitialPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext text) {
    return Scaffold(
      body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 100, 0, 40),
                child: Text(
                  "Welcome",
                  style: TextStyle (
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrangeAccent
                  )
                ),
              ),
              Image.asset('assets/images/NUS_LOGO.png', width: 200),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 50, 0, 10),
                child: Row (
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RaisedButton (
                        color: Colors.white,
                        textColor: Colors.black,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder:(context) {
                            return  LogInPage();
                          }));
                        },
                        child: Text(
                            "LOG IN",
                            style: TextStyle(
                                fontSize: 20
                            ),
                        ),
                    ),
                    RaisedButton (
                      color: Colors.black,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder:(context) {
                          return RegisterPage();
                        }));
                      },
                      child: Text(
                        "REGISTER",
                        style: TextStyle(fontSize: 20)
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
      ),
    );
  }
}