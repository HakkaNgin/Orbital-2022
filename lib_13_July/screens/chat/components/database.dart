import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseMethods {
  final chatsRef = FirebaseFirestore.instance.collection('ChatRoom');

  addChatRoom(chatRoom, chatRoomId) async {
    await chatsRef
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  getChats(String chatRoomId) async {
    return await chatsRef
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  addMessage(String chatRoomId, chatMessageData) async {
    await chatsRef
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData).catchError((e){
      print(e.toString());
    });
  }

  Future<Stream<QuerySnapshot<Object?>>> getUserChats(String userID) async {
    return await chatsRef
        .where('users', arrayContains: userID)
        .orderBy('timeStamp', descending: true) // order by the latest chat on top
        .snapshots();
  }
}