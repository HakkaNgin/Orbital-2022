// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:log_in/screens/chat/NewChat (Ignore)/chat_messages.dart';
//
// class Chatprovider {
//   UploadTask uploadImageFile(File image, String filename) {
//     Reference reference = firebaseStorage.ref().child(filename);
//     UploadTask uploadTask = reference.putFile(image);
//     return uploadTask;
//   }
//
//   Future<void> updateFirestoreData(
//       String collectionPath, String docPath, Map<String, dynamic> dataUpdate) {
//     return firebaseFirestore
//         .collection(collectionPath)
//         .doc(docPath)
//         .update(dataUpdate);
//   }
//
//   Stream<QuerySnapshot> getChatMessage(String groupChatId, int limit) {
//     return firebaseFirestore
//         .collection(FirestoreConstants.pathMessageCollection)
//         .doc(groupChatId)
//         .collection(groupChatId)
//         .orderBy(FirestoreConstants.timestamp, descending: true)
//         .limit(limit)
//         .snapshots();
//   }
//
//   void sendChatMessage(String content, int type, String groupChatId,
//       String currentUserId, String peerId) {
//     DocumentReference documentReference = firebaseFirestore
//         .collection(FirestoreConstants.pathMessageCollection)
//         .doc(groupChatId)
//         .collection(groupChatId)
//         .doc(DateTime.now().millisecondsSinceEpoch.toString());
//     ChatMessages chatMessages = ChatMessages(
//         idFrom: currentUserId,
//         idTo: peerId,
//         timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
//         content: content,
//         type: type);
//
//     FirebaseFirestore.instance.runTransaction((transaction) async {
//       transaction.set(documentReference, chatMessages.toJson());
//     });
//   }
// }