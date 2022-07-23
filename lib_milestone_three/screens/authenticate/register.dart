import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:log_in/screens/authenticate/components/upload_profile_pic.dart';
import 'package:log_in/screens/authenticate/components/verify_email.dart';
import 'package:log_in/screens/authenticate/log_in.dart';
import '../../models/firebase_login_user.dart';
import '../../models/user.dart';
import '../../services/auth.dart';
import '../../shared/loading.dart';
import '../home/home.dart';
import 'components/acad_info.dart';
import 'components/media_links.dart';
import 'components/tags.dart';
import 'components/username.dart';
import 'components/write_bio.dart';

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
  bool accountExists = false;

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
                padding: EdgeInsets.fromLTRB(0,25,0,10),
                child: Text( "Register",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrangeAccent
                  )
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10,0,10,0),
                child: TextFormField(
                  validator: (String? value) {
                    String nusStudentIdentity = "@u.nus.edu";
                    String nusStaffIdentity = "@nus.edu";
                    String nusDukeIdentity = "@u.duke.nus.edu";
                    String yaleNusIdentity = "@u.yale-nus.edu";
                    if (value != null && value.isEmpty) {
                      return "Email can't be empty";
                    }
                    else if ((!value!.contains(nusStudentIdentity))
                        && (!value.contains(nusStaffIdentity))
                        && (!value.contains(nusDukeIdentity))
                        && (!value.contains(yaleNusIdentity)) ) {
                      return "Only NUS email allowed";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "EMAIL ADDRESS",
                      labelStyle: TextStyle(fontSize: 18.0),
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
                  validator: (value) => value!.length < 6
                      ? 'Enter a password at least 6 characters long' : null,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "PASSWORD",
                      labelStyle: TextStyle(fontSize: 18.0),
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
                mainAxisAlignment: accountExists ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
                children: [
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
                          dynamic result = await _auth.registerWithEmailAndPassword(_email, _password);

                          if (result == null) {
                            setState(() {
                              error = 'please supply a valid email';
                              loading = false;
                            });
                          } else if (result == 1) {
                            setState(() {
                              error = 'The email is already in use';
                              accountExists = true;
                              loading = false;
                            });
                          } else { // Firebase auth account registered
                            // set default values to blank first
                            LoginUser registeredFirebaseUser = result as LoginUser;
                            usersRef.doc(registeredFirebaseUser.uid).set({
                              "id" : registeredFirebaseUser.uid,
                              "email" : _email,
                              "username": "",
                              "username_lowercase": "",
                              "timestamp": timestamp,
                              "acad_info": "",
                              "acad_info_lowercase": "",
                              "bio": "",
                              // "bio_lowercase": bio.toLowerCase(),
                              "tag1": "",
                              "tag1_lowercase": "",
                              "tag2": "",
                              "tag2_lowercase": "",
                              "tag3": "",
                              "tag3_lowercase": "",
                              "link1": "",
                              "link2": "",
                              "link3": "",
                              "imagePath": "",
                            });
                            // print("SSDSADFWEFESFDFZDGSDGSGSDFGSDFSDFEFFEF");
                            await Navigator.push(context, MaterialPageRoute(
                                builder: (context) => VerifyEmailPage()));

                            await createUserInFirestore(result); // create corresponding user in firestore
                            loading = false;
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => HomeScreen(theCurrentUserId: currentUser.userID,))
                            );
                          }
                        }
                      }
                    ),
                  ),
                  Visibility(
                    visible: accountExists,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0,10,0,10),
                      child: RaisedButton (
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => LogInPage())
                            );
                          },
                          color: Colors.black,
                          textColor: Colors.white,
                          child: Text(
                              "LOG IN",
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

  createUserInFirestore(LoginUser createdUser) async {
    // You know that the new user doesn't exist
    // So you can just create a new one

    // check if user exists in users collection in databse according to their ID
    final String firebaseUserID = createdUser.uid;
    // final DocumentSnapshot doc = await usersRef.doc(firebaseUserID).get();

    // move to the register username page to retrieve username
    final String userName = await Navigator.push(context, MaterialPageRoute(
        builder: (context) => Register_Name()));

    final String imagePath = await Navigator.push(context, MaterialPageRoute(
        builder: (context) => UploadProfilePicture(profileUserID: firebaseUserID)));

    final String acadInfo = await Navigator.push(context, MaterialPageRoute(
        builder: (context) => Add_Acad_Info()));

    final List<String> tags = await Navigator.push(context, MaterialPageRoute(
        builder: (context) => Add_Tags()));

    final String bio = await Navigator.push(context, MaterialPageRoute(
        builder: (context) => Write_Bio()));

    final List<String> links = await Navigator.push(context, MaterialPageRoute(
        builder: (context) => Add_Links()));

    // set the following info for the new user
    usersRef.doc(firebaseUserID).set({
      "id" : firebaseUserID,
      "email" : _email,
      "username": userName,
      "username_lowercase": userName.toLowerCase(),
      "timestamp": timestamp,
      "acad_info": acadInfo,
      "acad_info_lowercase": acadInfo.toLowerCase(),
      "bio": bio,
      // "bio_lowercase": bio.toLowerCase(),
      "tag1": tags.elementAt(0),
      "tag1_lowercase": tags.elementAt(0).toLowerCase(),
      "tag2": tags.elementAt(1),
      "tag2_lowercase": tags.elementAt(1).toLowerCase(),
      "tag3": tags.elementAt(2),
      "tag3_lowercase": tags.elementAt(2).toLowerCase(),
      "link1": links.elementAt(0),
      "link2": links.elementAt(1),
      "link3": links.elementAt(2),
      "imagePath": imagePath,
    });

    // After new user is configured, set current user to newly registered user
    DocumentSnapshot doc = await usersRef.doc(firebaseUserID).get();
    currentUser = TheUser.fromDocument(doc);
    // if the user doesn't exist, then we need them to create account
    // get username from create account, use it to make new user document in users collection
  }

}