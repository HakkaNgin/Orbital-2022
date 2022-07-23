import 'package:firebase_auth/firebase_auth.dart';
import '../models/firebase_login_user.dart';

abstract class BaseAuth {
  Future loginWithEmailAndPassword(String email, String password);
  Future registerWithEmailAndPassword(String email, String password);
  Stream<LoginUser?>? get user;
  Future authSignOut();
}

class AuthService implements BaseAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on FireBaseUser
  LoginUser? _userFromFirebaseUser(User? user) {
    return user != null ? LoginUser(uid: user.uid): null;
  }

  // auth change user stream
  Stream<LoginUser?> get user {
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
      print(e);
      if (e.toString() == "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
        return 1;
      } else if (e.toString() == "[firebase_auth/invalid-email] The email address is badly formatted."){
        return 2;
      } else {
        return null;
      }
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      if (e.toString() == "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
        return 1;
      } else {
        return null;
      }
    }
  }

  // sign out
  Future authSignOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}