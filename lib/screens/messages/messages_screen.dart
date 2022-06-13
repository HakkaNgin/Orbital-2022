import 'package:flutter/material.dart';
import '../../constants.dart';
import 'body.dart';

class MessagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          BackButton(),
          CircleAvatar(
            backgroundImage: AssetImage("assets/images/1.png"),
          ),
          SizedBox(width: kDefaultPadding * 0.75),
          Text(
            "Ultraviolet",
            style: TextStyle(fontSize: 16),
          )
        ],
      )
    );
  }
}