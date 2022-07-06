import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUser {
  final String userID;
  final String username;
  final String chatRoomId;
  String? imagePath;
  // final LoginUser? firebaseUser;

  ChatUser({
    required this.userID,
    required this.username,
    required this.chatRoomId,
    required this.imagePath,
  });

  factory ChatUser.fromDocument(DocumentSnapshot doc) {
    return ChatUser(
      userID: doc['id'],
      username: doc['username'],
      chatRoomId: doc['chatRoomId'],
      imagePath: doc['imagePath'],
    );
  }

  // convert json to TheUser
  static ChatUser fromJson(Map<String, dynamic> json) => ChatUser(
    userID: json['id'],
    username: json['username'],
    chatRoomId: json['chatRoomId'],
    imagePath: json['imagePath'],
  );

  // // convert profile info to Map (json)
  // Map<String, dynamic> toJson() => {
  //   'imagePath': imagePath,
  //   'name': username,
  //   'email': email,
  //   'about': about,
  // };
}