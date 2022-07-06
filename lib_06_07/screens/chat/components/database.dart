import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseMethods {
  final chatsRef = FirebaseFirestore.instance.collection('ChatRoom');

  addChatRoom(chatRoom, chatRoomId) {
    chatsRef
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  Stream<QuerySnapshot> getChats(String chatRoomId) {
    return chatsRef
        .doc(chatRoomId)
        .collection("messages")
        .orderBy('timeStamp')
        .snapshots();
  }

  addMessage(String chatRoomId, chatMessageData) {
    chatsRef
        .doc(chatRoomId)
        .collection("messages")
        .add(chatMessageData).catchError((e){
      print(e.toString());
    });
  }

Stream<QuerySnapshot> getUsersChats(String userID) {
    return chatsRef
        .where('users', arrayContains: userID)
        .snapshots();
        // .get();
  }
}