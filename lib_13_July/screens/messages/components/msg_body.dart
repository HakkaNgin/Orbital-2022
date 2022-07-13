import 'package:flutter/material.dart';
import 'package:log_in/models/chat_message.dart';
import 'package:log_in/shared/constants.dart';
import 'chat_input_field.dart';
import 'message.dart';

class MessageBody extends StatelessWidget {
  @override
  Widget build (BuildContext context) {
    return Column(
      children:[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: ListView.builder(
              itemCount: demoChatMessges.length,
              itemBuilder: (context, index) =>
                  Message(message: demoChatMessges[index]),
            ),
          ),
        ),
        ChatInputField(),
      ],
    );
  }
}