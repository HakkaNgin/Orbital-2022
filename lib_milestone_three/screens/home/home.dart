import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:log_in/models/user.dart';
import 'package:log_in/screens/activity_feed/activity_feed.dart';
import '../../services/auth.dart';
import '../chat/chats_screen.dart';
import '../profile/profile_screen.dart';
import '../search/search_screen.dart';

late TheUser homeCurrentUser;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.theCurrentUserId}) : super(key: key);
  final String theCurrentUserId;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();
  int index = 0;
  final usersRef = FirebaseFirestore.instance.collection('users');
  final followersRef = FirebaseFirestore.instance.collection('followers');
  final followingRef = FirebaseFirestore.instance.collection('following');
  List<dynamic> users = [];

  changePage(int pageIndex) {
    if (pageIndex == 0)    return ChatPage(ID: widget.theCurrentUserId);
    if (pageIndex == 1)    return ActivityFeed(profileUserID: widget.theCurrentUserId);
    if (pageIndex == 2)    return Search();
    if (pageIndex == 3) {
      return ProfilePage(
        profileUserID: widget.theCurrentUserId,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Profile",
          style: TextStyle(
            color:Colors.white,
            fontSize: 24),
          ),
        )
      );
    }
  }

  retrieveUserInFirestore(String homeUserID) async {
    // You know that the new user doesn't exist, so you can  create a new one
    // check if user exists in users collection in database according to their ID
    final DocumentSnapshot doc = await usersRef.doc(homeUserID).get();
    homeCurrentUser = TheUser.fromDocument(doc);
    // get username from create account, use it to make new user document in users collection
  }

  @override
  void initState() {
    super.initState();
    retrieveUserInFirestore(widget.theCurrentUserId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // IMPORTANT!!
    // homeCurrentUser = widget.theCurrentUser;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: changePage(index),
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: Colors.white,
            indicatorColor: Colors.blue.shade100,
            labelTextStyle: MaterialStateProperty.all(
              TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          child: NavigationBar(
            height: 60,
            backgroundColor: Color(0xFFf1f5fb),
            selectedIndex: index,
            onDestinationSelected: (int index) =>
              setState(() => this.index = index),

            destinations: [
              NavigationDestination(
                icon: Icon(Icons.chat_bubble),
                selectedIcon: Icon(Icons.chat_bubble),
                label: 'Message',
              ),
              NavigationDestination(
                icon: Icon(Icons.notifications),
                selectedIcon: Icon(Icons.notifications),
                label: 'Notifications',
              ),
              NavigationDestination(
                icon: Icon(Icons.search),
                selectedIcon: Icon(Icons.search),
                label: 'Search',
              ),
              NavigationDestination(
                icon: Icon(Icons.person),
                selectedIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
