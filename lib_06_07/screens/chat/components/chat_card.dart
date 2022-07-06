import 'package:flutter/material.dart';
import 'package:log_in/screens/chat/components/chat_room.dart';
import '../../../../shared/constants.dart';

class ChatCard extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatCard({required this.userName, required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ChatRoom(chatRoomId: chatRoomId)
        ));
      },

      child: Container(

        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Color(0xff007EF4),
                  borderRadius: BorderRadius.circular(30)),
              child: Text(
                  userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w300)),
            ),

            SizedBox(
              width: 12,
            ),

            Text(userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}