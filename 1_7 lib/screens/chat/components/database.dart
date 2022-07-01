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

  getChats(String chatRoomId) async{
    return chatsRef
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  addMessage(String chatRoomId, chatMessageData){
    chatsRef
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData).catchError((e){
      print(e.toString());
    });
  }

  getUserChats(String userID) async {
    return chatsRef
        .where('users', arrayContains: userID)
        .snapshots();
  }
}