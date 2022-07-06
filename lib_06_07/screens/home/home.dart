import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:log_in/screens/activity_feed/activity_feed.dart';
import '../../services/auth.dart';
import '../chat/chats_screen.dart';
import '../profile/profile_screen.dart';
import '../search/search_screen.dart';


late String homeCurrentUserID;
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.theCurrentUserID}) : super(key: key);
  final String theCurrentUserID;

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
    if (pageIndex == 0)    return ChatScreen(profileUserID: widget.theCurrentUserID);
    if (pageIndex == 1)    return ActivityFeed(profileUserID: widget.theCurrentUserID);
    if (pageIndex == 2)    return Search();
    if (pageIndex == 3) {
      return ProfilePage(
        profileUserID: widget.theCurrentUserID,
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

  @override
  Widget build(BuildContext context) {
    // IMPORTANT!!
    homeCurrentUserID = widget.theCurrentUserID;
    return Scaffold(
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
    );
  }
}
