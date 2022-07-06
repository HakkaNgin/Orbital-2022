import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:log_in/models/user.dart';
import 'package:log_in/screens/chat/Components/chat_screen_body.dart';
import 'package:log_in/screens/chat/components/chat_user.dart';
import '../../profile/profile_screen.dart';
import 'chat_room.dart';
import 'chat_card.dart';
import 'database.dart';

class ChatScreenBody extends StatefulWidget {
  final String currentUserId;
  ChatScreenBody({required this.currentUserId});

  @override
  _ChatScreenBodyState createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<ChatScreenBody> {
  Stream<QuerySnapshot>? chatRooms;
  int? chatRoomNumbers;
  List<ChatCard> conversations = [];

  @override
  void initState() {
    print('start');
    super.initState();
    loadScreen();
    setState(() {});
    // WidgetsBinding.instance.addPostFrameCallback((_) => {
    //   DatabaseMethods().getUserChats(widget.ID).then((chats) {
    //     setState(() {
    //       chatRooms = chats;
    //       // print(chatRooms?.length);
    //       print("Get chats");
    //     });
    //   }),
    // });
    // super.initState();
  }

  // Future<TheUser> retrieveUserInFirestore(String userID) async {
  //   // You know that the new user doesn't exist, so you can  create a new one
  //   // check if user exists in users collection in database according to their ID
  //   final DocumentSnapshot doc = await usersRef.doc(userID).get();
  //   return TheUser.fromDocument(doc);
  //   // get username from create account, use it to make new user document in users collection
  // }
  loadScreen() async {
    print("Get chats");
    // Stream<QuerySnapshot> chats = DatabaseMethods().getUserChats(widget.ID);
    // int chatsNumber = await chats.length;
    // print(chats.isEmpty);
    // print(chatsNumber);
    // setState(() {
    //   chatRooms = chats;
    //   chatRoomNumbers = chatsNumber;
    // });

    chatRooms = DatabaseMethods().getUsersChats(widget.currentUserId);
    chatRooms?.forEach((QuerySnapshot conversation) { // each element of the Stream, i.e. each user
      conversation.docs.forEach((QueryDocumentSnapshot queryDocumentSnapshot) {
        ChatUser chatUser = ChatUser.fromDocument(queryDocumentSnapshot);
        ChatCard newConversation = ChatCard(userName: chatUser.username, chatRoomId: chatUser.chatRoomId);
        conversations.add(newConversation);
        print("New chat added");
        print(conversations);
      });
    });
    setState(() {});
    // setState(() {
    //   chatRoomNumbers = snapshot.docs.length;
    // });
  }

  @override
  Widget build(BuildContext context) {
    print("Main body running");
    print(conversations);
    return Column(
      children: [
        // Text("sdsadasdds"),
        Expanded(
          child: StreamBuilder(
            stream: chatRooms,
            builder: (context, snapshot) {
              return conversations.isEmpty ? Column() : ListView(children: conversations,);
              // ListView.builder(
              //   // itemCount: DatabaseMethods().getUserChats(widget.ID).docs.length,
              //   itemCount: 1,
              //   itemBuilder: (context, index) {
              //     return ChatCard(
              //       userName: (snapshot.data! as QuerySnapshot).docs[index].get('chatRoomId')
              //           .toString()
              //           .replaceAll("_","")
              //           .replaceAll(widget.ID,''),
              //       chatRoomId: (snapshot.data! as QuerySnapshot).docs[index].get('chatRoomId')
              //     );
              //   }
              // )
            }
          )
        )
      ],
    );
  }
}