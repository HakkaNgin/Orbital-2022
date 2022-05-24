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
      body: Center(
          child: Column(
            children:<Widget> [
              SizedBox(height: 200),
              Text(
                "Welcome",
                style: TextStyle (
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrangeAccent
                )
              ),
              SizedBox(height: 200),
              Row (
                children: <Widget> [
                  SizedBox(width: 180),
                  RaisedButton (
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
                  SizedBox(width: 100),
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
            ],
          )
      ),
    );
  }
}