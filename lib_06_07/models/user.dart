import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:log_in/models/firebase_login_user.dart';

class TheUser {
  final String userID;
  final String username;
  final String username_lowercase;
  final String email;

  final String acadInfo;

  final String tag1;
  final String tag1_lowercase;
  final String tag2;
  final String tag2_lowercase;
  final String tag3;
  final String tag3_lowercase;
  final String bio;
  // final String bio_lowercase;

  final String link1;
  final String link2;
  final String link3;

  String? imagePath;
  // final LoginUser? firebaseUser;

  TheUser({
    required this.userID,
    required this.username,
    required this.username_lowercase,
    required this.email,
    required this.acadInfo,
    required this.bio,
    // required this.bio_lowercase,
    required this.tag1,
    required this.tag1_lowercase,
    required this.tag2,
    required this.tag2_lowercase,
    required this.tag3,
    required this.tag3_lowercase,
    required this.link1,
    required this.link2,
    required this.link3,
    required this.imagePath,
  });

  factory TheUser.fromDocument(DocumentSnapshot doc) {
    return TheUser(
      userID: doc['id'],
      username: doc['username'],
      username_lowercase: doc['username_lowercase'],
      email: doc['email'],
      acadInfo: doc['acad_info'],
      bio: doc['bio'],
      // bio_lowercase: doc['bio_lowercase'],
      tag1: doc['tag1'],
      tag1_lowercase: doc['tag1_lowercase'],
      tag2: doc['tag2'],
      tag2_lowercase: doc['tag2_lowercase'],
      tag3: doc['tag3'],
      tag3_lowercase: doc['tag3_lowercase'],
      // photoUrl: doc['photoUrl'],
      link1: doc['link1'],
      link2: doc['link2'],
      link3: doc['link3'],
      imagePath: doc['imagePath'],
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