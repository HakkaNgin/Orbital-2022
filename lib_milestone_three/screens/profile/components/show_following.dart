import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
class ShowFollowing extends StatefulWidget {

  final Widget following;
  ShowFollowing({required this.following});

  @override
  _ShowFollowingState createState() => _ShowFollowingState();
}

class _ShowFollowingState extends State<ShowFollowing> {
  Future<List<QuerySnapshot>>? searchResultsFuture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[700],
      appBar: AppBar(
        leading: BackButton(),
        title: Text("Following"),
      ),
      // body: followersFuture == null ? buildNoContent() : buildFollowers(),
      // body: buildFollowers(),
      body: widget.following,
    );
  }
}
