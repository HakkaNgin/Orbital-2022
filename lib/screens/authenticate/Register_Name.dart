import 'package:flutter/material.dart';
import 'package:log_in/screens/authenticate/InitialPage.dart';

class Register_Name extends StatefulWidget {
  @override
  Register_NameState createState() => Register_NameState();
}

class Register_NameState extends State<Register_Name> {

  @override
  Widget build(BuildContext text) {
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
                  labelText: "USER NAME",
                  prefixIcon: Icon(Icons.person)
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0,50,0,10),
              child: RaisedButton (
                  color: Colors.white,
                  textColor: Colors.black,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder:(context) {
                      return  InitialPage();
                    }));
                  },
                  child: Text(
                      "SIGN UP",
                      style: TextStyle(fontSize: 25
                      )
                  )
              ),
            ),
          ],
        )
    );
  }
}