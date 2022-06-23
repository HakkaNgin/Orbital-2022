import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home/home.dart';
import 'initial_screen.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final TheUser user = Provider.of<TheUser>(context);
    //return InitialPage();
    bool userExists = true;
    User? userDetected = FirebaseAuth.instance.currentUser;

    checking (User? userDetected) async {
      if (userDetected == null) {
        userExists = false;
      } else { // if there's a user signed in
        userExists = true;
        // retrieve the id of the Firebase user that's signed in
        // then find the corresponding database user with the same ID
      }
    }

    checking(userDetected);
    if (userExists) return HomeScreen(theCurrentUserID: userDetected!.uid);
    else            return InitialPage();
  }
}
