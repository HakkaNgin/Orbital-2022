import 'package:cloud_firestore/cloud_firestore.dart';

class FollowerFollowingUser {
  final String userID;
  final String username;
  final String imagePath;
  // final LoginUser? firebaseUser;

  FollowerFollowingUser({
    required this.userID,
    required this.username,
    required this.imagePath,
  });

  factory FollowerFollowingUser.fromDocument(DocumentSnapshot doc) {
    return FollowerFollowingUser(
      userID: doc['id'],
      username: doc['username'],
      imagePath: doc['imagePath'],
    );
  }
}