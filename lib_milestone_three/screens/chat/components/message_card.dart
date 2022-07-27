import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageCard extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final Timestamp time;

  MessageCard({required this.message, required this.sendByMe, required this.time});

  @override
  Widget build(BuildContext context) {

    DateTime log =  DateTime.fromMicrosecondsSinceEpoch(time.microsecondsSinceEpoch);
    String formattedDate = DateFormat('MM-dd kk:mm').format(log);

    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8, left: sendByMe ? 0 : 10, right: sendByMe ? 10 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        children: <Widget> [
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
            decoration: BoxDecoration(
                borderRadius: sendByMe
                ? BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15))
                : BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
                bottomLeft: Radius.circular(15)),

                gradient: LinearGradient(
                    colors: sendByMe ? [Colors.redAccent, Colors.orange] : [Colors.blue, Colors.lightBlue]
                )
            ),
            child: Text(message, textAlign: TextAlign.start,
                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal))
          ),

          Text(
            formattedDate,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 10,
              fontWeight: FontWeight.bold
            ),
          )
        ]
      )
    );
  }
}