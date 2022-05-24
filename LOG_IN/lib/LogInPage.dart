import 'package:flutter/material.dart';

class LogInPage extends StatefulWidget {
  @override
  LogInPageState createState() => LogInPageState();
}

class LogInPageState extends State<LogInPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("LOG IN"),
        ),
        body: Column(
          children: <Widget> [
            Padding(
              padding: EdgeInsets.fromLTRB(0,50,0,10),
              child: Text( "Log In",
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
                  labelText: "USER",
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
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder:(context) {
                      return  LogInPage();
                    }));
                  },
                  color: Colors.white,
                  textColor: Colors.black,
                  child: Text(
                      "LOG IN",
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