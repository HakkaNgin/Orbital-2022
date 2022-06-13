import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:log_in/models/firebase_login_user.dart';
import 'package:log_in/models/user.dart';
import 'package:log_in/screens/authenticate/Register_username.dart';
import 'package:log_in/screens/authenticate/Write_bio.dart';
import 'package:log_in/services/auth.dart';
import 'package:log_in/shared/loading.dart';

import '../home/home.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final DateTime timestamp = DateTime.now();
late TheUser currentUser;

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
                      LoginUser result = await _auth.registerWithEmailAndPassword(_email, _password);

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
                      } else { // account registered
                        await createUserInFirestore(result); // create corresponding user in firestore
                        loading = false;
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => HomeScreen(theCurrentUser: currentUser,))
                        );
                      }
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

  createUserInFirestore(LoginUser createdUser) async {

    // You know that the new user doesn't exist
    // So you can just create a new one

    // check if user exists in users collection in databse according to their ID
    final String firebaseUserID = createdUser.uid;
    // final DocumentSnapshot doc = await usersRef.doc(firebaseUserID).get();

    // move to the register username page to retrieve username
    final userName = await Navigator.push(context, MaterialPageRoute(
        builder: (context) => Register_Name()));

    final bio = await Navigator.push(context, MaterialPageRoute(
        builder: (context) => Write_Bio()));

    // set the following info for the new user
    usersRef.doc(firebaseUserID).set({
      "id" : firebaseUserID,
      "email" : _email,
      "username": userName,
      "timestamp": timestamp,
      "bio": bio,
    });

    // After new user is configured, set current user to newly registered user
    DocumentSnapshot doc = await usersRef.doc(firebaseUserID).get();
    currentUser = TheUser.fromDocument(doc);
    // if the user doesn't exist, then we need them to create account

    // get username from create account, use it to make new user document in users collection
  }

}