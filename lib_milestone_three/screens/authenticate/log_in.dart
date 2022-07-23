import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:log_in/screens/authenticate/components/verify_email.dart';
import 'package:log_in/screens/authenticate/register.dart';
import '../../models/firebase_login_user.dart';
import '../../models/user.dart';
import '../../services/auth.dart';
import '../../shared/loading.dart';
import '../home/home.dart';

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
  bool noAccount = false;

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
                padding: EdgeInsets.fromLTRB(0,25,0,10),
                child: Text( "Log In",
                    style: TextStyle (
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrangeAccent
                    )
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10,0,10,0),
                child: TextFormField(

                  // autovalidateMode: AutovalidateMode.always,
                  validator: (value) => value!.isEmpty ? 'Enter an email' : null,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "USER",
                      labelStyle: TextStyle(fontSize: 20.0),
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

                  // autovalidateMode: AutovalidateMode.always,
                  obscureText: true,
                  validator: (value) => value!.length < 6 ? 'Enter a password at least 6 characters long' : null,

                  decoration: InputDecoration(
                      labelText: "PASSWORD",
                      labelStyle: TextStyle(fontSize: 20.0),
                      prefixIcon: Icon(Icons.lock)
                  ),
                  onChanged: (value) {
                    setState(() {
                      _password = value.trim();
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: noAccount ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0,10,0,10),
                    child: RaisedButton (
                        onPressed: () async {
                          setState(() => error = '');
                          if (_formKey.currentState!.validate()) {
                            setState(() => loading = true);
                            dynamic result = await _auth.loginWithEmailAndPassword(_email, _password);
                            if (result == null) {
                              setState(() {
                                error = 'Could not sign in, please check you password';
                                loading = false;
                              });
                            } else if (result == 1) {
                              setState(() {
                                error = 'No corresponding account found';
                                noAccount = true;
                                loading = false;
                              });
                            } else { // successful login
                              bool emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
                              // if (!emailVerified) {
                              //   await Navigator.push(context, MaterialPageRoute(
                              //       builder: (context) => VerifyEmailPage()));
                              // }
                              await retrieveUserInFirestore(result);
                              loading = false;
                              // TODO NOTE pushReplacement destroys the previous screen and puts the next screen in stack
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) => HomeScreen(theCurrentUserId: currentUser.userID,))
                              );
                            }
                          }
                        },
                        color: Colors.black,
                        textColor: Colors.white,
                        child: Text(
                            "LOG IN",
                            style: TextStyle(fontSize: 20
                            )
                        )
                    ),
                  ),
                  Visibility(
                    visible: noAccount,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0,10,0,10),
                      child: RaisedButton (
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => RegisterPage())
                            );
                          },
                          color: Colors.white,
                          textColor: Colors.black,
                          child: Text(
                              "REGISTER",
                              style: TextStyle(fontSize: 20)
                          )
                      ),
                    ),
                  ),
                ],
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
    // You know that the new user doesn't exist, so you can  create a new one
    // check if user exists in users collection in database according to their ID
    final String firebaseUserID = createdUser.uid;
    final DocumentSnapshot doc = await usersRef.doc(firebaseUserID).get();

    currentUser = TheUser.fromDocument(doc);
    // get username from create account, use it to make new user document in users collection
  }
}