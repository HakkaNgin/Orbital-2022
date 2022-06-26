import 'package:flutter/material.dart';
import '../../services/auth.dart';
import '../chat/Components/chat_body.dart';

class ChatPage extends StatefulWidget {

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: Colors.orange,
        child: Icon(
          Icons.person_add_alt_1,
          color: Colors.white,
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        'Chats',
        style: TextStyle(
            color: Colors.white,
            fontSize: 24
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
      ],
    );
  }
}
