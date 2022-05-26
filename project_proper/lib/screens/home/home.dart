import 'package:flutter/material.dart';
import 'package:log_in/screens/authenticate/InitialPage.dart';
import 'package:log_in/services/auth.dart';

class Home extends StatelessWidget {
  // const Home({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text('HOME PAGE'),
        backgroundColor: Colors.brown[400],
        elevation: 0,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('LOG OUT'),
            onPressed: () async {
              await _auth.authSignOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => InitialPage())
              );
            },
          ),
        ],
      ),
    );
  }
}
