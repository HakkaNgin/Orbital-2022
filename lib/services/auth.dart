import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:log_in/models/User.dart';
import 'package:log_in/screens/authenticate/InitialPage.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on FireBaseUser
  MyUser? _userFromFirebaseUser(User? user) {
    return user != null ? MyUser(uid: user.uid): null;
  }

  // auth change user stream
  Stream<MyUser?> get user {
    // return _auth.authStateChanges()
    // //.map((User? user) => _userFromFirebaseUser(user));
    //     .map(_userFromFirebaseUser);

    return _auth.authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user));

  }

  // sign in with email and password
  Future loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result
      = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {

      // print(e.toString());
      if (e.toString() == "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
        print("No corresponding account found");
        return 1;
      }
      else {
        // print(e.toString());
        return null;
      }
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {

      print (e.toString());
      if (e.toString() == "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
        print("The email address is already in use!!!");
        return 1;
      }
      else {
        // print(e.toString());
        return null;
      }
    }
  }

  // sign out
  Future authSignOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      // print(e.toString());
      return null;
    }
  }

}