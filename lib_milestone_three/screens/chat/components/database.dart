import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:log_in/screens/authenticate/register.dart';
import 'package:log_in/screens/home/home.dart';

class DatabaseMethods {
  final chatsRef = FirebaseFirestore.instance.collection('ChatRoom');

  addChatRoom(String otherUserID, String otherName, String otherPath) {
    String chatRoomID = homeCurrentUser.userID + '_' + otherUserID;
    chatsRef
        .doc(chatRoomID)
        .set({
      'lastMessage':'',
      'lastMessageTimestamp':'',
      'chatRoomId': chatRoomID,
      'name': [
        homeCurrentUser.username,
        otherName ],
      'imagePath': [
        homeCurrentUser.imagePath,
        otherPath ],
      'users': [
          homeCurrentUser.userID,
          otherUserID ],
    }).catchError((e) {
      print(e);
    });
  }

  chatExists(String chatRoomId) async {
    DocumentSnapshot<Object?> chatRoom = await chatsRef.doc(chatRoomId).get();
    return chatRoom.exists;
  }

  getChats(String chatRoomId) async{
    return chatsRef
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  addMessage(String chatRoomId, Map<String, dynamic> chatMessageData) async {
    await chatsRef
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData).catchError((e){
      print(e.toString());
    });

    updateLastMessage(chatRoomId);
  }

  updateLastMessage (String chatRoomId) async {
  //  chatsRef.doc(chatRoomId).collection('chats').orderBy('time').limit(1).get().then((value) => null)
    String lastMessage = 'FAULT';
    Timestamp? lastMessageTime;

    await chatsRef.doc(chatRoomId).collection("chats").orderBy('time').get().then((QuerySnapshot querySnapshot) => {
      //print(querySnapshot.docs[0].get('message'))
      lastMessage = querySnapshot.docs.last.get('message'),
      lastMessageTime = querySnapshot.docs.last.get('time') as Timestamp,
    });

    chatsRef.doc(chatRoomId).update({
      'lastMessage': lastMessage,
      'lastMessageTimestamp': lastMessageTime,
    });
  }

  getUserConversations(String userID) {
    // await chatsRef
    //   .where('users', arrayContains: userID)
    //   .orderBy('lastMessageTimestamp', descending: true)
    //     .get(); // LATEST MSGS ON TOP
      // .snapshots().forEach((QuerySnapshot conversations) { // every snapshpt is a new series of conversations
      //   // conversations.docs.sort((a, b) => a.times.compareTo(b.length));
      //   for (var convo in conversations.docs) { // for every conversation this user has
      //     updateLastMessage(convo.get('chatRoomId'));
      //   }
      // });

    return chatsRef
        .where('users', arrayContains: userID)
        .orderBy('lastMessageTimestamp', descending: true) // LATEST MSGS ON TOP
        .snapshots();
  }
}