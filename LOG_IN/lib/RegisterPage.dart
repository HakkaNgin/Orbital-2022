import 'package:flutter/material.dart';
import 'package:log_in/LogInPage.dart';
import 'package:log_in/Register_Name.dart';

class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("REGISTER"),
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
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                  labelText: "EMAIL",
                  hintText: "EMAIL ADDRESS",
                  prefixIcon: Icon(Icons.person)
              ),
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: "PASSWORD",
                  hintText: "PASSWORD",
                  prefixIcon: Icon(Icons.lock)
              ),
              obscureText: true,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0,50,0,10),
              child: RaisedButton (
                color: Colors.white,
                textColor: Colors.black,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder:(context) {
                    return  Register_Name();
                  }));
                },
                child: Text(
                    "NEXT",
                    style: TextStyle(fontSize: 20
                    )
                )
              ),
            ),
          ],
      )
    );
  }
}