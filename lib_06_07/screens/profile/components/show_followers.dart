import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final followersRef = FirebaseFirestore.instance.collection('followers');
class ShowFollowers extends StatefulWidget {

  final Widget followers;
  ShowFollowers({required this.followers});

  @override
  _ShowFollowersState createState() => _ShowFollowersState();
}

class _ShowFollowersState extends State<ShowFollowers> {
  Future<QuerySnapshot>? followersFuture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[700],
      appBar: AppBar(
        leading: BackButton(),
        title: Text("Followers"),
      ),
      // body: followersFuture == null ? buildNoContent() : buildFollowers(),
      // body: buildFollowers(),
      body: widget.followers,
    );
  }
}
