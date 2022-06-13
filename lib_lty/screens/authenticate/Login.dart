import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:log_in/models/firebase_login_user.dart';
import 'package:log_in/screens/authenticate/InitialPage.dart';
import 'package:log_in/screens/home/home.dart';
import 'package:log_in/services/auth.dart';
import 'package:log_in/shared/loading.dart';
import '../../models/user.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
late TheUser currentUser;

class LogInPage extends StatefulWidget {
  @override
  LogInPageState createState() => LogInPageState();
}

class LogInPageState extends State<LogInPage> {

  late String _email, _password;
  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
        appBar: AppBar(
          title: Text("LOG IN"),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0,10,0,5),
                child: Text( "Log In",
                    style: TextStyle (
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue
                    )
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10,0,10,0),
                child: TextFormField(
                  validator: (value) => value!.isEmpty ? 'Enter an email' : null,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "USER",
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
              Padding(
                padding: EdgeInsets.fromLTRB(10,0,10,0),
                child: TextFormField(
                  obscureText: true,
                  validator: (value) => value!.length < 6 ? 'Enter a password at least 6 characters long' : null,
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

                  // ElevatedButton(
                  //   child: Text('Sign in'),
                  //   style: ButtonStyle(
                  //       backgroundColor:
                  //       MaterialStateProperty.all(Colors.pink[400]),
                  //       textStyle: MaterialStateProperty.all(
                  //           TextStyle(color: Colors.white))),
                  //   onPressed: () async {},
                  // )

                child: RaisedButton (
                    onPressed: () async {
                      setState(() => error = '');
                      if (_formKey.currentState!.validate()) {
                        setState(() => loading = true);
                        dynamic result = await _auth.loginWithEmailAndPassword(_email, _password);
                        print(result);

                        if (result == null) {
                          setState(() {
                            error = 'Could not sign in';
                            loading = false;
                          });
                        } else if (result == 1) {
                          setState(() {
                            error = 'No corresponding account found';
                            loading = false;
                          });
                        } else {
                          // print("RESULTTTTTTTT");
                          await retrieveUserInFirestore(result);
                          loading = false;
                          // TODO NOTE pushReplacement destroys the previous screen and puts the next screen in stack
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => HomeScreen(theCurrentUser: currentUser,))
                          );
                        }

                      // if (result == null) {
                      //   setState(() => error = 'Could not sign in');
                      // } else if (result == 1) {
                      //   setState(() => error = 'No corresponding account found');
                      // }

                    }

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

  retrieveUserInFirestore(LoginUser createdUser) async {

    // You know that the new user doesn't exist
    // So you can just create a new one

    // check if user exists in users collection in databse according to their ID
    final String firebaseUserID = createdUser.uid;
    final DocumentSnapshot doc = await usersRef.doc(firebaseUserID).get();

    currentUser = TheUser.fromDocument(doc);

    // get username from create account, use it to make new user document in users collection
  }

}