import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:log_in/screens/chat/components/chat.dart';

class ChatCard extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  final String imagePath;
  final String lastMessage;
  final Timestamp timestamp;

  ChatCard({required this.userName,
    required this.chatRoomId,
    required this.imagePath,
    required this.lastMessage,
    required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Chat(chatRoomId: chatRoomId)
        ));
      },

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 2.0, color: Colors.grey)
          )
        ),

        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [

            CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: imagePath == ""
                  ? Image.asset('assets/images/default_profile.webp').image
                  : CachedNetworkImageProvider(imagePath),
            ),

            SizedBox(
              width: 12,
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),

                    SizedBox(height: 8),
                    Column(
                      children: [
                        Opacity(
                          opacity: 0.64,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              lastMessage,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizedBox(height: 5,),

                        Opacity(
                          opacity: 0.64,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              timestamp.toDate().toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
