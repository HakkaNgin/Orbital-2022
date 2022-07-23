import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:log_in/models/user.dart';
import 'package:log_in/screens/chat/components/chat_body.dart';
import 'package:log_in/screens/home/home.dart';
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
    print('start');
    getConversations();
    super.initState();
  }

  getConversations() async {
    Stream conversation = DatabaseMethods().getUserConversations(widget.ID);
    setState(() {
      chatRooms = conversation;
      print("Get chats");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: chatRooms,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                    itemBuilder: (context, index) {
                      return ChatCard(
                        userName: (snapshot.data! as QuerySnapshot)
                            .docs[index].get('name')
                            .replaceAll("_", "").replaceAll(
                            homeCurrentUser.username, ''),
                        chatRoomId: (snapshot.data! as QuerySnapshot)
                            .docs[index].get('chatRoomId'),
                        imagePath: (snapshot.data! as QuerySnapshot)
                            .docs[index].get('imagePath')
                            .replaceAll("_", "").replaceAll(
                            homeCurrentUser.imagePath, ''),
                        lastMessage: (snapshot.data! as QuerySnapshot)
                            .docs[index].get('lastMessage'),
                        timestamp: (snapshot.data! as QuerySnapshot)
                            .docs[index].get('lastMessageTimestamp'),
                      );
                    }
                  );
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