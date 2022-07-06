// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class ChatMessages {
//   String idFrom;
//   String idTo;
//   String timestamp;
//   String content;
//   int type;
//
//   ChatMessages(
//       {required this.idFrom,
//         required this.idTo,
//         required this.timestamp,
//         required this.content,
//         required this.type});
//
//   Map<String, dynamic> toJson() {
//     return {
//       'idForm': idFrom,
//       'idTo': idTo,
//       'timestamp': timestamp,
//       'content': content,
//       'type': type,
//     };
//   }
//
//   factory ChatMessages.fromDocument(DocumentSnapshot doc) {
//     String idFrom = doc['idFrom'];
//     String idTo = doc['idTo'];
//     String timestamp = doc['timestamp'];
//     String content = doc['content'];
//     int type = doc['type'];
//
//     return ChatMessages(
//         idFrom: idFrom,
//         idTo: idTo,
//         timestamp: timestamp,
//         content: content,
//         type: type);
//   }
// }