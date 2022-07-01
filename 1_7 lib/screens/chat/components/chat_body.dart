import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:log_in/models/user.dart';
import 'package:log_in/screens/chat/Components/chat_body.dart';
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

  void iniState() {
    print('start');
    DatabaseMethods().getUserChats(widget.ID).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print("Get chats");
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: StreamBuilder(
                stream: chatRooms,
                builder: (context, snapshot) {
                return snapshot.hasData ?
                ListView.builder(
                    itemCount: DatabaseMethods().getUserChats(widget.ID).docs.length,
                    itemBuilder: (context, index) {
                      return ChatCard(
                        userName:(snapshot.data! as QuerySnapshot).docs[index].get('chatRoomId')
                            .toString()
                            .replaceAll("_","")
                            .replaceAll(widget.ID,''),
                        chatRoomId: (snapshot.data! as QuerySnapshot).docs[index].get('chatRoomId')
                      );
                    }) : Container();
                }
            )
        )
      ],
    );
  }
}