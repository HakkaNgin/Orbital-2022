import 'package:flutter/material.dart';
import 'RegisterPage.dart';
import 'LogInPage.dart';

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext text) {
    return Scaffold(
      body: Column(
            children:<Widget> [
              Padding (
                padding: EdgeInsets.fromLTRB(0,50,0,40),
                child: Text (
                    "Welcome",
                    style: TextStyle (
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrangeAccent
                    )
                ),
              ),
              Image.asset('assets/images/NUS_LOGO.png'),
              Padding (
                padding: EdgeInsets.fromLTRB(0,100,0,10),
                child: Row ( children: <Widget> [
                    Padding (
                      padding: EdgeInsets.fromLTRB(175,0,150,0),
                      child: RaisedButton (
                          color: Colors.white,
                          textColor: Colors.black,
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder:(context) {
                              return  LogInPage();
                            }));
                          },
                          child: Text(
                              "LOG IN",
                              style: TextStyle(fontSize: 20
                              )
                          )
                      ),
                    ),
                    RaisedButton (
                      color: Colors.black,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder:(context) {
                          return  RegisterPage();
                        }));
                      },
                      child: Text(
                          "REGISTER",
                          style: TextStyle(fontSize: 20
                          )
                      )
                    )
                  ],
                )
              )
            ],
          )
    );
  }
}