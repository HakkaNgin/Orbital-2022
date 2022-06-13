import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:log_in/models/firebase_login_user.dart';

class TheUser {
  final String userID;
  final String username;
  final String email;
  final String bio;

  String? imagePath;
  String? link1;
  String? link2;
  String? link3;
  String? tag1;
  String? tag2;
  String? tag3;

  // final LoginUser? firebaseUser;

  TheUser({
    required this.userID,
    required this.username,
    required this.email,
    required this.bio,
  });

  factory TheUser.fromDocument(DocumentSnapshot doc) {
    return TheUser(
      userID: doc['id'],
      username: doc['username'],
      email: doc['email'],
      bio: doc['bio'],
      // photoUrl: doc['photoUrl'],
    );
  }

  // TheUser copy({
  //   String? imagePath,
  //   String? name,
  //   String? email,
  //   String? about,
  // }) =>
  //     TheUser( // only updates corresponding value if there's new value in constructor
  //     // else, use old value
  //       imagePath: imagePath ?? this.imagePath,
  //       username: name ?? this.username,
  //       email: email ?? this.email,
  //       // about: about ?? this.about,
  //     );

  // convert json to TheUser
  // static TheUser fromJson(Map<String, dynamic> json) => TheUser(
  //   imagePath: json['imagePath'],
  //   username: json['name'],
  //   email: json['email'],
  //   // about: json['about'],
  // );

  // convert profile info to Map (json)
  // Map<String, dynamic> toJson() => {
  //   'imagePath': imagePath,
  //   'name': username,
  //   'email': email,
  //   'about': about,
  // };

}