import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:log_in/models/user.dart';
import 'package:log_in/screens/chat/components/chat_body.dart';
import 'chat.dart';
import 'chat_card.dart';
import 'database.dart';

class ChatBody extends StatefulWidget {
  final String ID;
  ChatBody({required this.ID});

  @override
  _ChatBodyState createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  Stream? chatRooms;

  @override
  void initState() {
    super.initState();
    print('start');
    loading();
    setState((){});
  }

  loading() async {
    Stream temp = await DatabaseMethods().getUserChats(widget.ID);
    setState(() {
      chatRooms = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: StreamBuilder(
                stream: chatRooms,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<ChatCard> conversations = [];
                    // conversations.add(chatRooms.runtimeType.toString());
                    QuerySnapshot chats = snapshot.data as QuerySnapshot;
                    chats.docs.forEach((doc) {
                      String otherUsername = doc['id'];
                      String chatRoomId = doc['id'];
                      Timestamp timeStamp = doc['timeStamp'];
                      ChatCard newConversation = ChatCard(userName: otherUsername, chatRoomId: chatRoomId, timeStamp: timeStamp);
                      conversations.add(newConversation);
                    });
                    // snapshot.data.forEach((QuerySnapshot conversation) { // each element of the Stream, i.e. each user
                    //   conversation.docs.forEach((QueryDocumentSnapshot queryDocumentSnapshot) {
                    //     ChatUser chatUser = ChatUser.fromDocument(queryDocumentSnapshot);
                    //     ChatCard newConversation = ChatCard(userName: chatUser.username, chatRoomId: chatUser.chatRoomId);
                    //     conversations.add(newConversation);
                    //     // print("New chat added");
                    //     // print(conversations);
                    //   });
                    // });
                    print(conversations);
                    var docs = snapshot.data.runtimeType;
                    return ListView(children: conversations,);
                    // cnt() {
                    //   return chatRooms?.length as int;
                    // }
                    // return ListView.builder(
                    //     // itemCount: DatabaseMethods().getUserChats(widget.ID).docs.length,
                    //
                    //     itemCount: 0,
                    //     itemBuilder: (context, index) {
                    //       return ChatCard(
                    //           userName:(snapshot.data! as QuerySnapshot).docs[index].get('chatRoomId')
                    //               .toString()
                    //               .replaceAll("_","")
                    //               .replaceAll(widget.ID,''),
                    //           chatRoomId: (snapshot.data! as QuerySnapshot).docs[index].get('chatRoomId')
                    //       );
                    //     });
                  } else {
                    return Container();
                  }
                }
            )
        )
      ],
    );
  }
}